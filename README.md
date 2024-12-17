# feature_walkthrough

Feature discovery package

## Getting Started

# Walkthrough Widget for Flutter

A flexible and customizable Flutter widget designed to display overlay walk_throughs or tutorials. This widget allows you to highlight specific areas of the app, guiding users through important features with informative step-by-step tutorials. The widget automatically adjusts its position and appearance based on the screen layout, ensuring a smooth and intuitive onboarding experience.

---

## Features

- **Overlay Walkthroughs**: Display a tutorial or feature walkthrough over any widget in your app.
- **Customizable UI**: Easily customize the title, description, and content of each walkthrough step.
- **Dynamic Positioning**: Automatically adjusts to the position of the target widget on the screen.
- **Quadrant-based Positioning**: Uses screen quadrants to determine optimal placement for the overlay (top, bottom, left, right).
- **Navigation Between Steps**: Allows navigation between different tutorial steps by defining `id` and `nextId`.
- **Responsive Design**: Works well on different screen sizes and adapts to screen space.

---

## Installation

Add the following to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
    
  feature_walkthrough:
    git:
      url: https://github.com/xxxxxx # repo url](https://github.com/Molterous/feature_walkthrough.git
      ref: master # branch name
```

---

## Usage

### Step 1: Add `WalkthroughWidget` to Your Widget Tree

To create a walkthrough, use the `WalkthroughWidget` by passing in the required parameters:

```dart
WalkthroughWidget(
  id: 'step1',              // Unique ID for this step, prefer creating an enum
  title: 'Welcome to the App!',  // Title of the walkthrough
  desc: 'This is where you can find the main features.',  // Description of the step
  childWidget: YourWidgetHere(),  // The widget you want to highlight
  displayWidget: null, // if you wanted to show specific widget in walkthrough
  nextId: 'step2',  // ID of the next step to navigate to
)
```

### Step 2: Handle Walkthrough Navigation

Once the walkthrough is displayed, users can tap on the overlay to move to the next step. The widget will automatically navigate to the next step defined by `nextId`.

---

## Example

Here is a simple example of how to use the `WalkthroughWidget`:

```dart
WalkThroughNotifier.instance.setId('Home');
```

refer `test_widget.dart` for demo and implementation.

---

### Handling Multiple Steps

You can chain multiple steps by defining each step's `id` and `nextId`. Each step will only display once and automatically transition to the next.

---

## How It Works

1. **Widget Positioning**: The `WalkthroughWidget` uses a `GlobalKey` to determine the position of the widget it highlights. Based on the position, it calculates which quadrant (top-left, top-right, bottom-left, bottom-right) of the screen the widget is located in, and dynamically adjusts the positioning of the overlay.

2. **Responsive Walkthrough**: The overlay adjusts to the screen size, ensuring that the walkthrough content is always placed in a visible area of the screen.

3. **Notification System**: The `WalkThroughNotifier` manages the walkthrough steps, making sure that each step is only shown once and moves to the next step when the user interacts with the overlay.

---

## Customization

You can customize the `WalkthroughWidget` in several ways:

- **Highlighting Widget**: Pass a custom widget to `highlightedWidget` to highlight a specific area instead of using the `childWidget`.
- **Text Styling**: Modify the `title` and `desc` styles to match your app's theme.

---

## Contributing

Contributions are welcome! If you find bugs or want to improve the widget, feel free to fork the repository, create a branch, and submit a pull request. Please follow the coding standards and write tests for new features.

---

This README file provides a comprehensive guide to using your widget, including installation, usage examples, and how the widget works.
