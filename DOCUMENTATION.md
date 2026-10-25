# Smart Campus Navigator - Complete Project Documentation
*Developed by Katuri Vivek Sai*

---

## 1. Project Overview & Objective
The **Smart Campus Navigator** is a premium, interactive, cross-platform application (available on Mobile and Web) designed to revolutionize indoor and outdoor campus navigation. 

**Objective:** To provide an intuitive, GPS-like navigation experience for complex college campuses, ensuring students, staff, parents, and guests can easily locate specific rooms, labs, and offices across multiple buildings and floors without getting lost.

---

## 2. Core Features & Modules

### 2.1 Role-Based Authentication
Provides customized access based on the user's role.
- **Students & Staff:** Require a secure Roll Number/ID and Password to log in. Their profile data is fetched and maintained throughout the session.
- **Parents & Guests:** One-tap bypass login. They are taken straight to the maps/guest features to instantly find their way around the campus without the friction of creating an account.

### 2.2 Advanced Interactive Map Engine
The crown jewel of the application is a custom-built, multi-floor 2D interactive map rendering engine.
- **Floor-Aware Routing:** The map supports 4 distinct floors (Ground, F1, F2, F3). It automatically knows exactly which floor a room is located on.
- **Step-by-Step Navigation:** Instead of drawing a static line, the app integrates a "Step/Walk" mechanic. The user taps a walk button to progress along the nodes.
- **Sequential Floor Transitions:** If the user is on the Ground floor and needs to go to Floor 3, the pointer physically walks to the *Stairs*, increments the floor level sequentially (G -> 1 -> 2 -> 3), and changes the visual floor plan dynamically.
- **Tap-To-Select:** Users can tap directly on building icons on the map to instantly set them as a destination.

### 2.3 Global State Management (Real-time Profile Updates)
- The app utilizes Flutter's `ChangeNotifier` and `Provider`-like singleton patterns (`UserSession`) to ensure data consistency.
- If a user edits their Name, Email, or Department in the Profile Edit Modal, the changes immediately trigger a `notifyListeners()` call. This instantly updates the Profile Screen UI and the Help/Feedback screens without requiring a page refresh.

### 2.4 Smart Search & Discovery
- A dedicated search page featuring a dynamic list of campus locations (e.g., *Physics Lab, Chemistry Lab, Form/Drawing Lab, Exam Cell, Auditorium*).
- Filtering logic instantly narrows down the list as the user types, and clicking a result passes the destination string directly into the Map engine.

### 2.5 Help & Feedback Center
- An interactive form allowing users to report bugs, request map updates, or ask general questions.
- Dynamically updates the text field hint based on the category the user selects (e.g., selecting "Map Issue" changes the hint to "Describe the map issue (e.g., wrong room...)").

---

## 3. Project Architecture

The app is built using **Flutter (Dart)**, utilizing a modular, feature-first folder structure.

```text
smart_campus_flutter/
├── lib/
│   ├── main.dart                 # App Entry Point & Route Definitions
│   ├── services/
│   │   ├── auth_service.dart     # Handles Login Validation & Roles
│   │   └── user_session.dart     # Global State (ChangeNotifier) for Profile Data
│   └── screens/
│       ├── splash_screen.dart    # Initial Loader with Animation
│       ├── login_screen.dart     # Authentication UI
│       ├── home_screen.dart      # Dashboard with Quick Links
│       ├── map_screen.dart       # The Core Map Engine & CustomPainter
│       ├── search_screen.dart    # Location discovery logic
│       ├── profile_screen.dart   # Profile viewing and editing logic
│       └── help_screen.dart      # Feedback and Support forms
├── web/                          # Web deployment configuration
├── pubspec.yaml                  # Project Dependencies
└── README.md                     # Brief project intro
```

---

## 4. Deep Dive: Map Navigation Logic

The `map_screen.dart` utilizes a highly sophisticated `CustomPainter` class named `BuildingMapPainter`. Here's how the math and logic work:

1. **Coordinate System:** Every location (like *Computer Lab 3*) is assigned an `(X, Y)` coordinate as a percentage of the screen width and height (e.g., `x: 0.72, y: 0.22`), along with a `floor` integer.
2. **Corridor Routing:** The map hardcodes a main "Corridor" at `Y = 0.43`. When moving between rooms, the user's X/Y coordinates do not snap directly diagonally through walls. The math forces the user to move vertically to the corridor, then horizontally along the corridor, then vertically to the destination room.
3. **Staircase Logic:** The stairs are located at `x: 0.5, y: 0.43`. If the `userFloor != destinationFloor`, the algorithm forces the user to walk exactly to `(0.5, 0.43)`. Once overlapping the stairs, tapping the "Walk" button increments/decrements `userFloor` until it matches `destinationFloor`.

---

## 5. Step-by-Step Developer Setup

To run this project locally, follow these steps:

### Prerequisites:
1. **Install Flutter SDK:** Ensure you have the latest stable version of Flutter installed.
2. **Install an IDE:** VS Code (with the Flutter extension) or Android Studio.

### Setup Instructions:
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/KaturiVivekSai/Vivek-Sai.git
   cd Vivek-Sai/smart_campus_flutter
   ```
2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the Application Locally (Chrome/Web):**
   ```bash
   flutter run -d chrome
   ```
4. **Run the Application Locally (Android Emulator):**
   ```bash
   flutter run -d emulator-name
   ```

---

## 6. Depolyment to GitHub Pages (Web)

This application is designed to be hosted directly on the web using GitHub Pages.

### Step-by-Step Deployment:
1. **Build the Web Release:**
   Run the following command to compile the Dart code into optimized HTML/JS/WASM. Ensure the `base-href` exactly matches your GitHub repository name (surrounded by slashes).
   ```bash
   flutter build web --release --base-href "/Vivek-Sai/"
   ```
2. **Commit the Build to GitHub:**
   Because we are deploying via GitHub Pages from the root repository, copy the contents of `build/web/` to your repository root (or push the entire project if you have a GitHub Action set up).
   ```bash
   git add .
   git commit -m "chore: deploy latest web build"
   git push origin main
   ```
3. **Configure GitHub Pages:**
   - Go to your repository on GitHub.
   - Click on **Settings** -> **Pages**.
   - Set the source to deploy from your branch (e.g., `main`), and hit Save.
   - Your site will live at: `https://KaturiVivekSai.github.io/Vivek-Sai/`

---

## 7. Future Roadmap
While the application is fully functional, future scaling could include:
1. **A* Pathfinding Algorithm:** Replacing the hardcoded corridor math with a dynamic node-graph algorithm (like Dijkstra's or A*) if the map expands to dozens of interconnected buildings.
2. **Firebase Backend:** Connecting `auth_service.dart` and `user_session.dart` to Google Firebase to persist user accounts, profile pictures, and feedback forms to an active cloud database.
3. **Native Voice & Hardware Hooks:** Implementing `flutter_tts` for actual Text-to-Speech voice guidance when the user presses the Voice button during navigation.
