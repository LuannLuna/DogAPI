//
//  CacheAsyncImage.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import SwiftUI

struct CacheAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    enum AsyncPhase {
        case empty
        case success(Image)
        case failure(Error)
    }

    @State private var phase: AsyncPhase = .empty

    init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
    }
    var body: some View {
        Group {
            switch phase {
                case .empty:
                    placeholder()

                case .success(let image):
                    content(image)

                case .failure(let error):
                    placeholder()
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }

    private func loadImage() async {
        guard let url else { return }
        do {
            guard let image = try await ImageCache.shared.image(for: url) else {
                phase = .failure(NSError(domain: "Image Loading Error", code: 400))
                return
            }
            phase = .success(image)
        } catch {
            phase = .failure(error)
        }
    }
}

extension CacheAsyncImage where Placeholder == ProgressView<EmptyView, EmptyView> {
    init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content
    ) {
        self.init(
            url: url,
            scale: scale,
            transaction: transaction,
            content: content,
            placeholder: { ProgressView() }
        )
    }
}

#Preview {
    CacheAsyncImage(
        url: URL(string: "https://example.com/image.jpg")) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
        }
}
