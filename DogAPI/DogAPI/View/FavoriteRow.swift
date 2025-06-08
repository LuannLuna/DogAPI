//
//  FavoriteRow.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import SwiftUI
import SwiftData

struct FavoriteRow: View {
    @Query(sort: \FavoriteBreed.dateAdded, order: .reverse) private var favorites: [FavoriteBreed]
    @Environment(\.modelContext) private var modelContext
    let breed: Breed

    var body: some View {
        HStack {
            Text(breed.name)
            Spacer()
            if favorites.contains(where: { $0.name == breed.name }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}

#Preview {
    FavoriteRow( breed: .init(name: "Pug"))
        .padding()
}
