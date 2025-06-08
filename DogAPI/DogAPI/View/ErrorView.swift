//
//  ErrorView.swift
//  DogAPI
//
//  Created by Luann Luna on 07/06/25.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)

            Text("Something went wrong")
                .font(.headline)

            Text(error.localizedDescription)
                .font(.caption)

            Button(action: retryAction) {
                Text("Try again")
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    ErrorView(
        error: NSError(domain: "Test", code: 1),
        retryAction: {}
    )
}
