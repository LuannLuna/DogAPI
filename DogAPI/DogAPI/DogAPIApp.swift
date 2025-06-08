//
//  DogAPIApp.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import SwiftUI
import SwiftData

@main
struct DogAPIApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ FavoriteBreed.self ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var router = Router()

    var body: some Scene {
        WindowGroup {
            TabView(selection: $router.currentTab) {
                NavigationStack(path: $router.breedListNavigationPath) {
                    BreedListScreen()
                        .navigationDestination(for: AppRouter.self) {
                            destinationView(for: $0)
                        }
                }
                .tabItem {
                    Label("Breeds", systemImage: "list.bullet")
                }
                .tag(AppRouter.breedList)

                NavigationStack(path: $router.favoriteNavigationPath) {
                    FavoritesScreen()
                        .navigationDestination(for: AppRouter.self) {
                            destinationView(for: $0)
                        }
                }
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(AppRouter.favorite)
            }
        }
        .environmentObject(DogAPIService())
        .environment(router)
        .modelContainer(sharedModelContainer)
    }

    @ViewBuilder
    func destinationView(for router: AppRouter) -> some View {
        navigationContent(for: router)
            .transition(
                .asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                )
            )
    }

    @ViewBuilder
    func navigationContent(for router: AppRouter) -> some View {
        switch router {
            case .breedList:
                BreedListScreen()

            case .breedDetail(let breed):
                BreedDetailScreen(breed: breed)

            case .favorite:
                FavoritesScreen()
        }
    }
}
