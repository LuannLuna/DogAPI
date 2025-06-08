//
//  FavoritesScreen.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import SwiftUI
import SwiftData

struct FavoritesScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Router.self) private var router: Router
    @Query(sort: \FavoriteBreed.dateAdded, order: .reverse) var favorites: [FavoriteBreed]

    var body: some View {
        NavigationView {
            VStack {
                if favorites.isEmpty {
                    ContentUnavailableView(
                        "No Favorites Yet",
                        systemImage: "heart.slash",
                        description: Text(
                            "Add some breeds to your favorites to see them here."
                        )
                    )
                } else {
                    List {
                        ForEach(favorites, id: \.name) { breed in
                            Button {
                                router.navigation(to: .breedDetail(.init(name: breed.name)))
                            } label: {
                                FavoriteRow(breed: .init(name: breed.name))
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                removeFavorite(favorites[index])
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }

    func removeFavorite(_ breed: FavoriteBreed) {
        if let existingFavorite = favorites.first(where: { $0.name == breed.name }) {
            modelContext.delete(existingFavorite)
        }
    }
}

#Preview {
    FavoritesScreen()
        .environment(Router())
}
