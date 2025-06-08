//
//  DogAPIService.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import Foundation

// All dogs breed (and sub-breeds)
// https://dog.ceo/api/breeds/list/all

// All images from a given breed
// https://dog.ceo/api/breed/hound/images

// A given number of images from a given breed
// https://dog.ceo/api/breed/hound/images/random/3

// A radom imagem from a given breed
// https://dog.ceo/api/breed/\(akita)/images/random

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkingError(Error)
}

protocol NetworkServiceProtocol {
    func fetchData(from url: URL) async throws -> Data
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchData(from url: URL) async throws -> Data {
        do {
            let (data, _) = try await session.data(from: url)
            return data
        } catch {
            throw APIError.invalidURL
        }
    }
}

protocol DogAPIServiceProtocol {
    func fetchAllBreeds() async throws -> [Breed]
    func fetchRandomImage(from breed: String) async throws -> URL
}

struct DogAPIURLBuilder {
    private let baseURL = "https://dog.ceo/api/"

    func allBreedsURL() -> URL? {
        URL(string: "\(baseURL)breeds/list/all")
    }

    func randomImageURL(from breed: String) -> URL? {
        URL(string: "\(baseURL)breed/\(breed)/images/random")
    }
}

final class DogAPIService: ObservableObject {
    private let networkService: NetworkServiceProtocol
    private let decode: JSONDecoder
    private let urlBuilder: DogAPIURLBuilder

    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        urlBuilder: DogAPIURLBuilder = DogAPIURLBuilder(),
        decode: JSONDecoder = JSONDecoder()
    ) {
        self.networkService = networkService
        self.decode = decode
        self.urlBuilder = urlBuilder
    }
}

extension DogAPIService: DogAPIServiceProtocol {
    func fetchAllBreeds() async throws -> [Breed] {
        guard let url = urlBuilder.allBreedsURL() else {
            throw APIError.invalidURL
        }

        let data = try await networkService.fetchData(from: url)

        do {
            let response = try decode.decode(BreedResponse.self, from: data)
            return response.message.map { Breed(name: $0.key, urlImage: nil) }
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    func fetchRandomImage(from breed: String) async throws -> URL {
        guard let url = urlBuilder.randomImageURL(from: breed) else {
            throw APIError.invalidURL
        }

        let data = try await networkService.fetchData(from: url)

        do {
            let response = try decode.decode(RadomBreedImageResponse.self, from: data)
            guard let url = URL(string: response.message) else {
                throw APIError.invalidResponse
            }
            return url
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
