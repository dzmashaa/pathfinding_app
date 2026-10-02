# Pathfinding Flutter App

A Flutter application developed as a technical assessment. It fetches pathfinding tasks from a REST API, calculates the shortest path on a 2D grid avoiding obstacles, and submits the results.

## Features

* **Algorithm:** Implements Breadth-First Search (BFS) to find the shortest path in an unweighted grid.
* **API Integration:** Uses the `http` package with robust error handling for network drops and invalid data.
* **Responsive UI:** Adaptive layouts that safely handle screen rotation and keyboard appearance using `CustomScrollView` and `SafeArea`.
* **Grid Visualization:** Custom scrollable grid view (horizontal & vertical) that dynamically calculates cell size to display large maps without UI overflow.

## Tech Stack

* **Framework:** Flutter
* **Language:** Dart
* **Packages:** `http`

## Getting Started

1. Clone the repository:
```bash
   git clone https://github.com/dzmashaa/pathfinding_app
 ```
2.Navigate to the project directory:
```bash
cd pathfinding_app
```
3.Install dependencies:
```bash
flutter pub get
```
3.Run the app:
```bash
flutter run
```
