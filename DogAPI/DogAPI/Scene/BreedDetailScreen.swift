//
//  BreedDetailScreen.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import SwiftUI
import SwiftData

struct BreedDetailScreen: View {
    enum ViewState {
        case loading
        case loaded
        case error(Error)
    }

    @EnvironmentObject private var apiService: DogAPIService
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteBreed.dateAdded) private var favorites: [FavoriteBreed]

    @State var breed: Breed
    @State private var isFavorite: Bool = false
    @State private var viewState: ViewState = .loaded

    init(breed: Breed) {
        self._breed = State(initialValue: breed)
    }

    var body: some View {
        ScrollView {
            switch viewState {
                case .loading:
                    ProgressView()
                        .frame(height: 300)

                case .loaded:
                    VStack(spacing: 20) {
                        CacheAsyncImage(url: breed.urlImage) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 300)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                        .onTapGesture(perform: loadImage)

                        Button {
                            toggleFavorite()
                        } label: {
                            Label(
                                isFavorite ? "Remove from favorites" : "Add to Favorites",
                                systemImage: isFavorite ? "heart.fill" : "heart"
                            )
                            .foregroundColor(.red)
                        }
                        .buttonStyle(.bordered)

                    }
                case .error(let error):
                    ErrorView(error: error, retryAction: loadImage)
            }
        }
        .navigationTitle(breed.name.capitalized)
        .padding()
        .onAppear(perform: loadImage)
        .onAppear {
            isFavorite = favorites.contains(where: { $0.name == breed.name })
        }
    }

    private
    func loadImage() {
        viewState = .loading
        Task {
            do {
                let imageUrl = try await apiService.fetchRandomImage(from: breed.name)
                breed.urlImage = imageUrl
                viewState = .loaded
            } catch {
                viewState = .error(error)
            }
        }
    }

    private
    func toggleFavorite() {
        if let existingFavorite = favorites.first(where: { $0.name == breed.name }) {
            modelContext.delete(existingFavorite)
            isFavorite = false
        } else {
            modelContext.insert(FavoriteBreed(name: breed.name))
            isFavorite = true
        }
        try? modelContext.save()
    }
}

#Preview {
    BreedDetailScreen(breed: .init(name: "husky"))
        .environmentObject(DogAPIService())
}
