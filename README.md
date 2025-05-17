# Blinko

The project is organized in different folders:

- **Models/**: Data models that will be used in the app.
- **Services/**:
  - **Camera/**: Logic for handling camera input and image/frame processing.
  - **CoreML/**: Includes trained `.mlmodel` files for object detection.
  - **TextToSpeech/**: Manages the text-to-speech conversion.
- **ViewModels/**: Manages the logic and state used by views. Currently includes only the MLViewModel.
- **Views/**:
  - **Levels/**: Views related to the level selection and minigame-selection.
  - **Minigames/**: Folder with other folders with the views of the minigames.
  - **Shared/**: Components that are used along more than one view. (Like CardView).
- **BlinkoApp.swift**: The app entry point.
- **ContentView.swift**: Root view of the app.
