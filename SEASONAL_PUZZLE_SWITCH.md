# Seasonal Puzzle Switch Guide

This document describes how to swap puzzle availability for seasonal updates (Spooky, Merry, and Nature).

## Overview

The app shows different puzzle type buttons based on conditional logic in `GameViewNoDrawing2.swift` (lines 89-96). By swapping which puzzle is "always available" vs "only shown if already selected", we can make seasonal puzzles the default for new users while preserving existing users' selections.

## File Location

`inkwellpoetry/GameViewNoDrawing2.swift` - lines 89-96

---

## Spooky Season (October)

Use this configuration for Halloween/fall season (approximately October).

**Behavior:**
- New users see: Classic, **Spooky**, Swifty
- Existing Nature/Merry users still see their button
- Once they switch away, they see Spooky instead

```swift
if selectedPuzzleType == "nature 🌳" {
    PuzzleTypeButton(title: "Nature 🌳", type: "nature 🌳", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "nature 🌳") })
}

if selectedPuzzleType == "merry ☃️" {
    PuzzleTypeButton(title: "Merry ☃️", type: "merry ☃️", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "merry ☃️") })
}

//the way to update puzzle types for new entries that should not show the old ones
if selectedPuzzleType != "nature 🌳" && selectedPuzzleType != "merry ☃️" {
    PuzzleTypeButton(title: "Spooky 👻", type: "spooky 👻", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "spooky 👻") })
}
```

---

## Holiday Season (Late November - Early January)

Use this configuration for the winter holiday season (approximately late November through early January).

**Behavior:**
- New users see: Classic, **Merry**, Swifty
- Existing Nature/Spooky users still see their button
- Once they switch away, they see Merry instead

```swift
if selectedPuzzleType == "nature 🌳" {
    PuzzleTypeButton(title: "Nature 🌳", type: "nature 🌳", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "nature 🌳") })
}

if selectedPuzzleType == "spooky 👻" {
    PuzzleTypeButton(title: "Spooky 👻", type: "spooky 👻", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "spooky 👻") })
}

//the way to update puzzle types for new entries that should not show the old ones
if selectedPuzzleType != "nature 🌳" && selectedPuzzleType != "spooky 👻" {
    PuzzleTypeButton(title: "Merry ☃️", type: "merry ☃️", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "merry ☃️") })
}
```

---

## Rest of Year (January - Late September)

Use this configuration for the rest of the year.

**Behavior:**
- New users see: Classic, **Nature**, Swifty
- Existing Merry/Spooky users still see their button
- Once they switch away, they see Nature instead

```swift
if selectedPuzzleType == "merry ☃️" {
    PuzzleTypeButton(title: "Merry ☃️", type: "merry ☃️", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "merry ☃️") })
}

if selectedPuzzleType == "spooky 👻" {
    PuzzleTypeButton(title: "Spooky 👻", type: "spooky 👻", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "spooky 👻") })
}

//the way to update puzzle types for new entries that should not show the old ones
if selectedPuzzleType != "merry ☃️" && selectedPuzzleType != "spooky 👻" {
    PuzzleTypeButton(title: "Nature 🌳", type: "nature 🌳", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "nature 🌳") })
}
```

---

## How It Works

The conditional logic follows this pattern:

1. **Exact match condition** (`selectedPuzzleType == "puzzle"`) - Shows the button ONLY if user already has this puzzle selected. This preserves existing users' access.

2. **Exclusion condition** (`selectedPuzzleType != "other1" && selectedPuzzleType != "other2"`) - Shows the button for everyone EXCEPT those on the other seasonal puzzles. This is the "default available" puzzle.

By swapping which puzzle uses which condition, we control which is the seasonal default.

---

## Annual Cycle

| Season | Dates | Default Puzzle |
|--------|-------|----------------|
| Spooky | October | Spooky 👻 |
| Holiday | Late Nov - Early Jan | Merry ☃️ |
| Rest of Year | Jan - Late Sept | Nature 🌳 |

---

## Backwards Compatibility

- **User data is preserved** - No changes to data models or stored puzzle types
- **Archive entries unaffected** - Historical puzzles retain their original type
- **Graceful transition** - Existing users keep their current selection until they choose to change
