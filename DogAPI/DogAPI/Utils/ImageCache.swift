//
//  ImageCache.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import SwiftUI

actor ImageCache {
    static let shared = ImageCache()

    private var cache: [URL: Image] = [:]
    private var loadingTasks: [URL: Task<Image?, Error>] = [:]

    private init() {}

    func image(for url: URL) async throws -> Image? {
        if let cacheImage = cache[url] {
            return cacheImage
        }
        
        if let existingTask = loadingTasks[url] {
            return try await existingTask.value
        }

        let task = Task<Image?, Error> {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let uiImage = UIImage(data: data) else { return nil }
                let image = Image(uiImage: uiImage)
                cache[url] = image
                loadingTasks[url] = nil
                return image
            } catch {
                loadingTasks[url] = nil
                throw error
            }
        }

        loadingTasks[url] = task
        return try await task.value
    }

    func clearCache() {
        cache.removeAll()
        loadingTasks.values.forEach { $0.cancel() }
        loadingTasks.removeAll()
    }
}
