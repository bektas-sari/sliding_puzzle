# 🧩 Sliding Puzzle (Flutter APP)

A modern and interactive **image-based sliding puzzle game** built with Flutter.
Reconstruct the original image by sliding tiles into the empty slot.

---

## 📱 Features

* 🎯 Classic sliding puzzle logic
* 📸 Uses a single full image sliced into tiles
* 🧠 Tap or swipe to move tiles
* ✅ Win detection and restart option
* 📈 Move counter
* 💡 Help popup with instructions
* 🎨 Smooth animations and adaptive UI

---

## 🛠️ How It Works

* The full image is split into a 3x3 grid (can be changed to 4x4 or 5x5).
* One tile is removed (empty slot).
* Player rearranges the tiles into correct positions using:

    * **Tap**
    * **Swipe gestures**
* Puzzle is solved when all tiles are in order and image is complete.

---

## 📂 Project Structure

```
lib/
 └── main.dart        # Game logic and UI
assets/
 └── image.jpg        # Main puzzle image
 └── screenshot.png   # Demo screenshot (optional)
```

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK (>=3.x)
* Android Studio / VS Code

### Install

```bash
git clone https://github.com/bektas-sari/sliding_puzzle.git
cd sliding_puzzle
flutter pub get
flutter run
```

---

## 🖼️ Customize Image

Replace the image inside `assets/image.jpg` with your own square image.
Update the `pubspec.yaml` if necessary:

```yaml
flutter:
  assets:
    - assets/image.jpg
```

---

## 🔧 Configuration

You can change the grid size by modifying:

```dart
final int gridSize = 3; // Try 4 or 5
```

---

## 👤 Developer

**Bektas Sari**
Email: [bektas.sari@gmail.com](mailto:bektas.sari@gmail.com)<br>
GitHub: [bektas-sari](https://github.com/bektas-sari)<br>
LinkedIn: [linkedin.com/in/bektas-sari](https://www.linkedin.com/in/bektas-sari)<br>
ResearchGate: [Bektas Sari](https://www.researchgate.net/profile/Bektas-Sari-3)<br>
Academia: [Independent Profile](https://independent.academia.edu/bektassari)<br>

---

## 📃 License

This project is licensed under the

---

## 🙌 Contributions

Pull requests are welcome!
If you have feature ideas or want to improve the UI/UX, feel free to contribute.
