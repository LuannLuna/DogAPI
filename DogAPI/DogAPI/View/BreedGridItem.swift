//
//  BreedGridItem.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import SwiftUI

struct BreedGridItem: View {
    @EnvironmentObject private var apiService: DogAPIService
    @Binding var breed: Breed
    var body: some View {
        VStack {
            CacheAsyncImage(url: breed.urlImage) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 120)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            Text(breed.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        guard breed.urlImage.isNil else { return }
        Task {
            do {
                let imageUrl = try await apiService.fetchRandomImage(from: breed.name)
                breed.urlImage = imageUrl
            } catch {
                print("Failed to loadImage: \(error.localizedDescription)")
            }
        }
    }
}

#if DEBUG
struct BreedGridItemWrapper: View {
    @State private var breed: Breed
    init(breed: Breed) {
        self._breed = State(initialValue: breed)
    }

    var body: some View {
        BreedGridItem(breed: $breed)
    }
}

#Preview {
    VStack(spacing: 50) {
        BreedGridItemWrapper(
            breed: .init(
                name: "husky",
                urlImage: URL(
                    string: "https://images.dog.ceo/breeds/husky/n02110185_6746.jpg"
                )
            )
        )

        BreedGridItemWrapper(
            breed: .init(
                name: "bluetick",
                urlImage: nil
            )
        )
    }
    .environmentObject(DogAPIService())
}
#endif
