# Seasonal Puzzle Switch Guide

This document describes how to swap between Nature and Merry puzzle availability for seasonal updates.

## Overview

The app shows different puzzle type buttons based on conditional logic in `GameViewNoDrawing2.swift` (lines 89-96). By swapping which puzzle is "always available" vs "only shown if already selected", we can make seasonal puzzles the default for new users while preserving existing users' selections.

## File Location

`inkwellpoetry/GameViewNoDrawing2.swift` - lines 89-96

---

## Holiday Season (Merry Available)

Use this configuration from approximately late November through early January.

**Behavior:**
- New users see: Classic, **Merry**, Swifty
- Existing Nature users still see their Nature button
- Once a Nature user switches away, they see Merry instead

```swift
if selectedPuzzleType == "nature 🌳" {
    PuzzleTypeButton(title: "Nature 🌳", type: "nature 🌳", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "nature 🌳") })
}

//the way to update puzzle types for new entries that should not show the old ones
if selectedPuzzleType != "spooky 👻" && selectedPuzzleType != "nature 🌳" {
    PuzzleTypeButton(title: "Merry ☃️", type: "merry ☃️", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "merry ☃️") })
}
```

---

## Rest of Year (Nature Available)

Use this configuration for the rest of the year (January through late November).

**Behavior:**
- New users see: Classic, **Nature**, Swifty
- Existing Merry users still see their Merry button
- Once a Merry user switches away, they see Nature instead

```swift
if selectedPuzzleType == "merry ☃️" {
    PuzzleTypeButton(title: "Merry ☃️", type: "merry ☃️", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "merry ☃️") })
}

//the way to update puzzle types for new entries that should not show the old ones
if selectedPuzzleType != "spooky 👻" && selectedPuzzleType != "merry ☃️" {
    PuzzleTypeButton(title: "Nature 🌳", type: "nature 🌳", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "nature 🌳") })
}
```

---

## How It Works

The conditional logic follows this pattern:

1. **Exact match condition** (`selectedPuzzleType == "puzzle"`) - Shows the button ONLY if user already has this puzzle selected. This preserves existing users' access.

2. **Exclusion condition** (`selectedPuzzleType != "spooky" && selectedPuzzleType != "other"`) - Shows the button for everyone EXCEPT those on seasonal puzzles. This is the "default available" puzzle.

By swapping which puzzle uses which condition, we control which is the seasonal default.

---

## Backwards Compatibility

- **User data is preserved** - No changes to data models or stored puzzle types
- **Archive entries unaffected** - Historical puzzles retain their original type
- **Graceful transition** - Existing users keep their current selection until they choose to change
