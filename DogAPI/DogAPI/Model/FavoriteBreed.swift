//
//  FavoriteBreed.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import Foundation
import SwiftData

@Model
final class FavoriteBreed {
    var name: String
    var dateAdded: Date

    init(name: String, dateAdded: Date = Date()) {
        self.name = name
        self.dateAdded = dateAdded
    }
}
