//
//  Router.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import SwiftUI

enum AppRouter: Hashable {
    case breedList
    case breedDetail(Breed)
    case favorite
}

enum NavigationType {
    case tabBar, push
}

@Observable
final class Router {
    var currentTab: AppRouter = .breedList
    var breedListNavigationPath = NavigationPath()
    var favoriteNavigationPath = NavigationPath()

    func navigation(to router: AppRouter, using navigationType: NavigationType = .push) {
        switch navigationType {
            case .tabBar:
                if [.breedList, .favorite].contains(router) {
                    currentTab = router
                }
            case .push:
                switch currentTab {
                    case .breedList:
                        breedListNavigationPath.append(router)

                    case .favorite:
                        favoriteNavigationPath.append(router)

                    default: break
                }
        }
    }
}
