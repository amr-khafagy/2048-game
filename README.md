# 2048 Game

A Flutter implementation of the classic 2048 puzzle game, built with responsive controls, tile animations, and local game-state persistence.

## Highlights

- Swipe controls for mobile and keyboard controls for desktop.
- Animated tile movement and merge interactions.
- Score tracking during gameplay.
- Local persistence for the board state using Hive.
- Portrait-oriented mobile experience with a dedicated splash and menu flow.

## Tech Stack

- **Framework:** Flutter
- **State Management:** Riverpod
- **Local Storage:** Hive
- **Input:** `flutter_swipe_detector` and keyboard events
- **Animations:** Flutter animation controllers and curved animations
- **Code Generation:** `build_runner` and `json_serializable`

## Project Structure

```text
lib/
├── component/   # Board, tile, score, and reusable UI components
├── manager/     # Game-round, direction, and board state logic
├── models/      # Board and tile models with Hive serialization
├── game.dart    # Game screen and animations
├── menu_screen.dart
├── setting_screen.dart
└── splash_screen.dart
```

## Getting Started

```bash
flutter pub get
flutter run
```

## Author

Built by [Amr Khafagy](https://github.com/amr-khafagy), Flutter Developer and Mobile Application Engineer.
