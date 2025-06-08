//
//  BreedListScreen.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import SwiftUI

struct BreedListScreen: View {
    enum ViewState {
        case loaded
        case loading
        case error(Error)
    }

    @Environment(Router.self) private var router
    @EnvironmentObject private var apiService: DogAPIService
    @State private var breeds: [Breed] = []
    @State private var viewState: ViewState = .loading

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        NavigationView {
            switch viewState {
                case .loaded:
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns) {
                            ForEach($breeds, id: \.self) { breed in
                                BreedGridItem(breed: breed)
                                    .frame(minHeight: 150)
                                    .onTapGesture {
                                        router.navigation(to: .breedDetail(breed.wrappedValue))
                                    }
                            }
                        }
                    }
                    .navigationTitle("Breeds")
                case .loading:
                    ProgressView()
                case .error(let error):
                    ErrorView(
                        error: error,
                        retryAction: fetchAllBreeds
                    )
            }
        }
        .onAppear(perform: fetchAllBreeds)
    }

    private func fetchAllBreeds() {
        guard breeds.isEmpty else { return }
        viewState = .loading
        Task {
            do {
                breeds = try await apiService.fetchAllBreeds()
                viewState = .loaded
            } catch {
                viewState = .error(error)
            }
        }
    }
}

#Preview {
    BreedListScreen()
        .environmentObject(DogAPIService())
        .environment(Router())
}
