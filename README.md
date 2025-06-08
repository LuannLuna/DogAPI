# Dog Breed Explorer

A SwiftUI app that allows users to explore dog breeds, view random images, and manage their favorite breeds.

## Features

- Browse list of dog breeds
- View random images for each breed
- Add/remove breeds from favorites
- Persistent storage of favorite breeds using SwiftData
- Smooth animations and transitions
- Error handling and loading states
- Image caching for better performance
- Tab-based navigation with favorites section

## Architecture

The app follows the MV (Model-View) architecture pattern with the following components:

This implementation is based on the MV pattern approach as described in:
- [Building Large-Scale Apps with SwiftUI: A Guide to Modular Architecture](https://azamsharp.com/2023/02/28/building-large-scale-apps-swiftui.html)
- [SwiftUI Architecture - A Complete Guide to MV Pattern Approach](https://azamsharp.com/2022/10/06/practical-mv-pattern-crud.html)

> **Note on Architecture Choice**: While MVVM is a popular pattern in iOS development, this project intentionally uses the MV pattern. The decision was made because SwiftUI already provides built-in state management and data binding capabilities, making an additional ViewModel layer potentially redundant. The articles above provide detailed explanations of why MV can be more appropriate for SwiftUI applications, especially when leveraging the framework's native features.

### Models
- `Breed`: Represents a dog breed with its name and images
- `FavoriteBreed`: SwiftData model for managing persistence of favorite breeds
- `AppRoute`: Navigation routes for the app

### Views
- `BreedListScreen`: Main screen showing the grid of breeds
- `BreedDetailScreen`: Shows breed details and random images
- `FavoritesScreen`: Displays user's favorite breeds
- `FavoriteRow`: Reusable view for displaying breed information
- `BreedGridItem`: Grid item view for the breed list
- `ErrorView`: Reusable error view with retry functionality

### Services
- `DogAPIService`: Handles API communication with dog.ceo
- `ImageCache`: Manages image caching for better performance
- `Router`: Handles navigation and routing throughout the app

### Utils
- `CachedAsyncImage`: Custom view for handling cached image loading
- `Optional+Extensions`: Utility extensions for optional handling

## Technical Details

### Data Persistence
- Uses SwiftData for managing favorite breeds
- In-memory caching for images
- Efficient state management using SwiftUI's state management

### Navigation
- Tab-based navigation with favorites section
- Smooth transitions between screens
- Type-safe routing using enums

### Image Handling
- Efficient image caching system
- Lazy loading of images
- Error handling for failed image loads
- Placeholder support during loading

### Testing
- Unit tests for favorites functionality
- SwiftData integration tests
- Async/await support in tests
- In-memory testing environment

## Setup Instructions

1. Clone the repository
2. Open `DogAPI.xcodeproj` in Xcode
3. Build and run the project (iOS 15.0+ required)

## Dependencies

- SwiftUI
- SwiftData
- Async/Await

## Testing

The project includes:
- Unit tests for favorite breeds management
- SwiftUI previews for reusable components
- In-memory testing environment for SwiftData

## Assumptions & Trade-offs

- Uses SwiftData for persistence (modern, efficient, and integrated with SwiftUI)
- Implements comprehensive error handling with user-friendly messages
- Focuses on iOS platform with SwiftUI
- Uses modern Swift features like async/await and actors
