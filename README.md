# Blinko

The project is organized in different folders:

- **Models/**: Holds data models used throughout the app.
- **Preview Content/**: Contains SwiftUI preview data and image assets used only for previews.
- **Services/**:
  - **Camera/**: Logic for handling camera input and image/frame processing.
  - **CoreML/**: Includes trained `.mlmodel` files for object detection.
  - **TextToSpeech/**: Manages text-to-speech conversion for language learning.
- **ViewModels/**: Manages the logic and state used by views. Currently includes MLViewModel.
- **Views/**:
  - **Levels/**: Holds definitions for vocabulary objects per game level.
  - **Minigames/TreasureHunt/**: UI for the Treasure Hunt mini-game.
  - **Shared/**: Contains reusable components such as `CardView`.
- **Assets/**: App-wide assets such as images and colors.
- **BlinkoApp.swift**: The app entry point.
- **ContentView.swift**: Root view of the app.
