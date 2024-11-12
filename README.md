# Square Animation App

This Flutter app demonstrates an animated square that moves left, right, scales, rotates, and changes color upon user interaction. The app includes animations for movement, scaling, and rotation, along with visual feedback on its current position.

## Live Demo

You can view the app live here: [Square Animation App on GitHub Pages](https://altved.github.io/)

## Features

- **Move Square**: Buttons to move the square left and right.
- **Center Reset**: Reset the square back to the center position.
- **Visual Feedback**: Dynamic status text updates to show the square's position (e.g., "Moving Right", "Reached Left").
- **Animations**:
  - Color transition from red to blue.
  - Smooth scaling effect on square movement.
  - Light rotation effect.

## How to Use

1. **Move Left**: Moves the square left with animation. Button is disabled when the square is at the left edge.
2. **Move Right**: Moves the square right with animation. Button is disabled when the square is at the right edge.
3. **Reset Position**: Reset the square back to the center by tapping the refresh button in the top-right corner.

## Installation

1. Clone this repository.
2. Ensure Flutter is installed on your system.
3. Run the following commands:

   ```bash
   flutter pub get
   flutter run
   ```

## Code Explanation

### `SquareAnimation` Widget

- **State Management**:  
  This widget is `Stateful` to manage the square’s position, color, scale, and rotation animations.

- **Animation Controller**:  
  The `AnimationController` controls the timing of all animations, ensuring smooth transitions and proper synchronization of animations.

- **Position, Color, Scale, and Rotation Animations**:  
  Each movement and visual effect (position, color change, scaling, and rotation) is managed by an individual animation. This separation ensures that the animations can be fine-tuned and provide smooth transitions for each property.

- **Gradient Background**:  
  A visually pleasing background gradient is applied, transitioning from top-left to bottom-right, creating a soothing backdrop for the animated square.

### Main Components

- **Gradient Background**:  
  The background features a gradient that transitions from the top-left to the bottom-right of the screen, creating a smooth and colorful visual effect.

- **Control Buttons**:  
  There are three control buttons:
  - **Move Left**: Moves the square to the left.
  - **Move Right**: Moves the square to the right.
  - **Reset**: Resets the square back to the center.

- **Status Text**:  
  A dynamic status text displays the square’s current state, such as whether it is "Moving Right," "Moving Left," or "Centered." This provides users with clear visual feedback on the square’s position and animation status.
