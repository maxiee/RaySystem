# AppFlowyEditor Styling Guide

This document outlines the available styling options for the AppFlowyEditor component used in RaySystem. The editor supports different style configurations for desktop and mobile environments, allowing you to customize the appearance and behavior of the rich text editor.

## Overview

The `EditorStyle` class is the main configuration point for styling the AppFlowyEditor. It provides two factory constructors:
- `EditorStyle.desktop()` - Optimized for desktop environments
- `EditorStyle.mobile()` - Optimized for mobile environments

You can apply the style by passing it to the editor:

```dart
AppFlowyEditor(
  editorState: _editorState!,
  // ... other properties ...
  editorStyle: const EditorStyle.desktop(
    padding: EdgeInsets.zero,
    // Add other customizations here
  ),
)
```

## Available Style Properties

### Common Properties

These properties are available for both desktop and mobile environments:

| Property | Type | Description | Default (Desktop) | Default (Mobile) |
|----------|------|-------------|------------------|------------------|
| `padding` | `EdgeInsets` | Padding around the editor content | `EdgeInsets.symmetric(horizontal: 100)` | `EdgeInsets.symmetric(horizontal: 20)` |
| `cursorColor` | `Color` | Color of the text cursor | `Color(0xFF00BCF0)` | `Color(0xFF00BCF0)` |
| `selectionColor` | `Color` | Background color of selected text | `Color.fromARGB(53, 111, 201, 231)` | `Color.fromARGB(53, 111, 201, 231)` |
| `textStyleConfiguration` | `TextStyleConfiguration` | Default text style for the editor | See below | See below |
| `textSpanDecorator` | `TextSpanDecoratorForAttribute` | Customization for text spans | `defaultTextSpanDecoratorForAttribute` | `mobileTextSpanDecoratorForAttribute` |
| `defaultTextDirection` | `String?` | Text direction (ltr, rtl) | `null` | `null` |
| `cursorWidth` | `double` | Width of the text cursor | `2.0` | `2.0` |
| `textScaleFactor` | `double` | Text scaling factor | `1.0` | `1.0` |
| `maxWidth` | `double?` | Maximum width of the editor | `null` | `null` |

### Desktop-Specific Properties

Desktop environments have minimal mobile-specific properties with default values that essentially disable these features:

| Property | Default Value |
|----------|---------------|
| `magnifierSize` | `Size.zero` |
| `mobileDragHandleBallSize` | `Size.zero` |
| `mobileDragHandleWidth` | `0.0` |
| `enableHapticFeedbackOnAndroid` | `false` |
| `dragHandleColor` | `Colors.transparent` |
| `autoDismissCollapsedHandleDuration` | `Duration(seconds: 0)` |

### Mobile-Specific Properties

Mobile environments have additional properties to customize the touch interaction:

| Property | Type | Description | Default Value |
|----------|------|-------------|--------------|
| `dragHandleColor` | `Color` | Color of the text selection handles | `Color(0xFF00BCF0)` |
| `magnifierSize` | `Size` | Size of the text magnifier | `Size(72, 48)` |
| `mobileDragHandleBallSize` | `Size` | Size of the selection handle's ball | `Size(8, 8)` |
| `mobileDragHandleWidth` | `double` | Width of the selection handle | `2.0` |
| `enableHapticFeedbackOnAndroid` | `bool` | Enable haptic feedback when dragging handles on Android | `true` |
| `mobileDragHandleTopExtend` | `double?` | Extend hit test area from the top | `null` |
| `mobileDragHandleLeftExtend` | `double?` | Extend hit test area from the left | `null` |
| `mobileDragHandleWidthExtend` | `double?` | Extend hit test area width | `null` |
| `mobileDragHandleHeightExtend` | `double?` | Extend hit test area height | `null` |
| `autoDismissCollapsedHandleDuration` | `Duration` | Auto-dismiss time for collapsed selection handle | `Duration(seconds: 3)` |

## Text Style Configuration

The `TextStyleConfiguration` allows you to customize the default text style used in the editor:

```dart
const TextStyleConfiguration(
  text: TextStyle(fontSize: 16, color: Colors.black),
  // Other text styles can be added here
);
```

This configuration is applied to all text-based components, but can be overridden by specific block component configurations.

## Usage Examples

### Basic Desktop Configuration
```dart
EditorStyle.desktop(
  padding: EdgeInsets.symmetric(horizontal: 60),
  cursorColor: Colors.blue,
  selectionColor: Colors.blue.withOpacity(0.2),
)
```

### Custom Mobile Configuration
```dart
EditorStyle.mobile(
  padding: EdgeInsets.symmetric(horizontal: 16),
  cursorColor: Theme.of(context).primaryColor,
  dragHandleColor: Theme.of(context).primaryColor,
  magnifierSize: const Size(80, 50),
  mobileDragHandleBallSize: const Size(10, 10),
)
```

### Custom Text Style
```dart
EditorStyle.desktop(
  textStyleConfiguration: TextStyleConfiguration(
    text: TextStyle(
      fontSize: 16,
      color: Colors.black87,
      height: 1.5,
      fontWeight: FontWeight.normal,
    ),
  ),
)
```

## Modifying Styles Programmatically

You can use the `copyWith` method to create a new instance with modified properties:

```dart
final darkEditorStyle = editorStyle.copyWith(
  cursorColor: Colors.white,
  selectionColor: Colors.white.withOpacity(0.3),
  textStyleConfiguration: TextStyleConfiguration(
    text: TextStyle(fontSize: 16, color: Colors.white),
  ),
);
```

## Notes

- The drag handle color will be ignored on Android as it uses the native selection handles.
- For best performance, consider using constants for styles that don't change at runtime.
- Mobile-specific styling is particularly important for ensuring good touch interactions on small screens.