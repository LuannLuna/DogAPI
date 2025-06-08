//
//  Breed.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import Foundation

struct Breed: Hashable {
    let name: String
    var urlImage: URL?
}

struct BreedResponse: Decodable {
    let status: String
    let message: [String: [String]]
}

struct RadomBreedImageResponse: Decodable {
    let status: String
    let message: String
}
