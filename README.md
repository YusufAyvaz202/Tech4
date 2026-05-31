# 🎮 Offline Mini Games Hub

A Flutter application featuring a collection of classic offline mini-games, each powered by its own AI engine. Built with a consistent dark UI theme and smooth animations for an enjoyable cross-platform experience.

---

## 📸 Screenshots

### Main Menu

<p align="left">
  <img width="260" alt="Main Menu" src="https://github.com/user-attachments/assets/d0f4b24b-683c-47e1-948e-2916c0d0f6ab" />
</p>

---

## 🕹️ Games

### 1. Tic-Tac-Toe

A classic 3×3 strategy game with a fully-featured Minimax AI opponent and three selectable difficulty levels.

| Selection Screen | Gameplay |
|:---:|:---:|
| <img width="230" alt="Tic-Tac-Toe Selection" src="https://github.com/user-attachments/assets/2bf4b11c-7804-4c51-8241-fbd7c5ff6a75" /> | <img width="230" alt="Tic-Tac-Toe Gameplay" src="https://github.com/user-attachments/assets/0b3b6b58-ed1f-475b-ba27-f59344c0cff7" /> |

**Features:**
- 3 difficulty levels: **Easy** (60% random), **Hard** (30% random), **Impossible** (perfect play)
- Live score tracking per session
- Winning line highlight animation
- Piece placement bounce animation

**AI:** Minimax with configurable error rate

---

### 2. Connect Four

A 7×6 grid strategy game with a deep-thinking AI and a built-in hint system.

| Color Selection | Gameplay |
|:---:|:---:|
| <img width="230" alt="Connect Four Color Selection" src="https://github.com/user-attachments/assets/fe7b15f8-dec7-4d6b-8ad8-845d3907dd48" /> | <img width="230" alt="Connect Four Gameplay" src="https://github.com/user-attachments/assets/7b1a6ccb-ede6-4470-8b54-814ca71c7a63" /> |

**Features:**
- Choose your color (Coral or Teal) before starting
- Animated piece drop with per-row bounce timing
- Winning pieces highlighted with a white glow
- 💡 Hint button highlights the top 2 recommended columns

**AI:** Minimax with Alpha-Beta Pruning (depth 3), center-weighted position scoring

---

### 3. Maze Escape

Navigate through 10 handcrafted mazes and escape to the exit. An A\* pathfinder runs silently in the background to benchmark your performance.

<p align="left">
  <img width="260" alt="Maze Escape Gameplay" src="https://github.com/user-attachments/assets/ab11e603-707f-4b19-8628-47e5f50140a5" />
</p>

**Features:**
- 10 levels: 4 Easy → 3 Medium → 3 Hard
- Step counter compared against the A\* optimal solution on win
- 💡 Animated hint path (up to 6 steps) revealed one cell at a time
- D-Pad touch controls

**AI:** A\* Pathfinder with Manhattan Distance heuristic

---

### 4. Sudoku

A full 9×9 Sudoku experience with a backtracking solver AI providing hints and auto-solve.

<p align="left">
  <img width="260" alt="Sudoku Gameplay" src="https://github.com/user-attachments/assets/3b2db428-b3aa-426c-b740-e9ba7f8136d1" />
</p>

**Features:**
- Puzzle loaded from a bundled JSON asset (`assets/puzzles.json`)
- Elapsed time tracker
- 3-mistake limit system
- 💡 AI Hint: fills the selected cell with the correct answer
- ✨ Auto-Solve: fills the entire board instantly
- Bold 3×3 sub-grid borders for visual clarity

**AI:** Backtracking solver (recursive constraint satisfaction)

---

## 🏗️ Architecture & Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | `Provider` / `ChangeNotifier` |
| Navigation | `Navigator` with `MaterialPageRoute` |
| Assets | JSON puzzle files, custom image assets |

### AI Algorithms Summary

| Game | Algorithm | Key Details |
|---|---|---|
| Tic-Tac-Toe | **Minimax** | Depth-limited, configurable error rate |
| Connect Four | **Minimax + Alpha-Beta Pruning** | Depth 3, positional scoring, top-2 hint |
| Maze Escape | **A\* Pathfinder** | Manhattan distance heuristic, animated hint |
| Sudoku | **Backtracking (CSP Solver)** | Recursive, solution cached at puzzle load |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/YusufAyvaz202/Tech4.git

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

---

## 🎨 Design System

All games share a unified dark color palette:

| Name | Hex | Usage |
|---|---|---|
| Deep Slate | `#121826` | App background |
| Muted Charcoal | `#1E2640` | Cards, boards, dialogs |
| Cool Grey | `#3A4454` | Borders, grid lines |
| Neon Coral | `#FF6B6B` | Player 1, errors, accents |
| Electric Teal | `#00F5D4` | Player 2, AI, highlights |
| Off-White | `#F8FAFC` | Primary text |
| Slate Grey | `#94A3B8` | Secondary text, hints |
