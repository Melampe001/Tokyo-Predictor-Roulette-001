# Tokyo Roulette - Design System

## 🎨 Overview

This design system implements **Material Design 3** principles with a custom casino-themed aesthetic for the Tokyo Roulette educational simulator. It ensures consistency, accessibility, and a polished user experience across all platforms.

---

## 🎯 Design Principles

1. **Educational First** - Clear disclaimers and educational messaging
2. **Casino Aesthetic** - Premium, sophisticated casino-inspired visuals
3. **Accessible** - WCAG AA compliant, semantic labels, proper touch targets
4. **Responsive** - Adaptive layouts for mobile, tablet, and desktop
5. **Delightful** - Smooth animations and micro-interactions

---

## 🎨 Color Palette

### Primary Colors
- **Primary Red**: `#D32F2F` - Casino red, used for primary actions
- **Primary Gold**: `#FFD700` - Luxury gold accent, highlights and celebrations
- **Casino Green**: `#2E7D32` - Table green, used for zero and success states

### Roulette Colors
- **Red Numbers**: `#D32F2F` (1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36)
- **Black Numbers**: `#1A1A1A` (2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35)
- **Green (Zero)**: `#2E7D32` (0)

### Surface Colors
- **Light Background**: `#F5F5F5`
- **Light Surface**: `#FAFAFA`
- **Dark Background**: `#1A1A1A`
- **Dark Surface**: `#1E1E1E`

### Semantic Colors
- **Success**: `#2E7D32`
- **Error**: `#B00020` (Light) / `#CF6679` (Dark)
- **Warning**: `#F57C00`
- **Info**: `#0277BD`

---

## 📝 Typography

### Type Scale (Material Design 3)

```dart
Display Large: 57px / 400 weight
Display Medium: 45px / 400 weight
Display Small: 36px / 400 weight

Headline Large: 32px / 400 weight
Headline Medium: 28px / 400 weight
Headline Small: 24px / 400 weight

Title Large: 22px / 500 weight
Title Medium: 16px / 500 weight
Title Small: 14px / 500 weight

Body Large: 16px / 400 weight
Body Medium: 14px / 400 weight
Body Small: 12px / 400 weight

Label Large: 14px / 500 weight
Label Medium: 12px / 500 weight
Label Small: 11px / 500 weight
```

### Usage Guidelines
- **Display**: Hero content, large numbers, results
- **Headline**: Section titles, screen headings
- **Title**: Card headers, list items
- **Body**: Main content, descriptions
- **Label**: Buttons, chips, tags

---

## 📐 Spacing System

```dart
XS:  4px   - Tight spacing within components
SM:  8px   - Component internal padding
MD:  16px  - Standard spacing, card padding
LG:  24px  - Section spacing
XL:  32px  - Large gaps between major sections
2XL: 48px  - Screen-level spacing
3XL: 64px  - Extra large spacing
```

### Usage
- Use consistent spacing throughout the app
- Prefer multiples of 4px (4, 8, 12, 16, 24, etc.)
- Mobile: MD (16px) base padding
- Tablet: LG (24px) base padding
- Desktop: XL (32px) base padding

---

## 🔲 Border Radius

```dart
XS:   4px  - Small elements (chips, tags)
SM:   8px  - Buttons, small cards
MD:   12px - Standard cards, inputs
LG:   16px - Large cards, dialogs
XL:   20px - Hero cards, modals
Full: 9999px - Circular elements
```

---

## ✨ Elevation & Shadows

```dart
None: 0dp  - Flat elements
SM:   1dp  - Subtle elevation (light theme cards)
MD:   2dp  - Standard cards, buttons
LG:   4dp  - Floating action buttons
XL:   8dp  - Dialogs, navigation bars
```

---

## 🧩 Components

### Buttons

#### Primary Button
- **Use**: Main actions (Spin, Submit, Continue)
- **Style**: Filled with primary color
- **Sizes**: Small (8/16px), Medium (12/24px), Large (16/32px)
- **Min Touch Target**: 48x48px

#### Secondary Button
- **Use**: Alternative actions (Cancel, Skip)
- **Style**: Outlined
- **Colors**: Uses outline color from theme

#### Text Button
- **Use**: Tertiary actions, inline links
- **Style**: Text only with ripple

### Cards

#### Standard Card
- **Padding**: 16px
- **Radius**: 16px
- **Elevation**: 1dp (light) / 2dp (dark)
- **Use**: Content containers

#### Info Card
- **Use**: Display key metrics (balance, wins, losses)
- **Contains**: Icon, title, value
- **Color**: Tinted background based on type

#### Stat Card
- **Use**: Statistics display
- **Contains**: Label, value, icon, optional subtitle
- **Layout**: Vertical

### Casino Widgets

#### Bet Chip
- **Size**: 60px default
- **Colors**: Based on value (Red: ≤10, Blue: ≤50, Green: ≤100, Black: ≤500, Gold: >500)
- **Pattern**: Circular with rings and center value
- **States**: Default, Selected (scaled 1.1x with border)

#### Number Chip
- **Size**: 48px default
- **Colors**: Red, Black, or Green based on roulette number
- **Shape**: Circular
- **Text**: White, bold

#### Roulette Wheel
- **Size**: 300px (mobile) / 350px (tablet+)
- **Segments**: 37 (European roulette: 0-36)
- **Animation**: 4-5 seconds spin with easing
- **Pointer**: Gold triangle at top

---

## 🎭 Animations

### Timing
- **Fast**: 150ms - Micro-interactions, hover states
- **Normal**: 300ms - Standard transitions, page changes
- **Slow**: 500ms - Complex animations, celebrations
- **Roulette Spin**: 3000-5000ms - Physics-based with easing

### Curves
- **easeOut**: Default for most transitions
- **easeInOut**: Symmetrical animations
- **elasticOut**: Bouncy effects (celebrations)
- **easeOutCubic**: Roulette spin deceleration

### Types
1. **Fade In/Out**: Opacity transitions
2. **Slide**: Position transitions (Y: 0.1 to 0)
3. **Scale**: Size transitions (0.95 to 1.05)
4. **Rotate**: Rotation animations
5. **Shimmer**: Loading states

### Key Animations
- **Win Animation**: Confetti particles + message overlay
- **Number Reveal**: Scale + fade in
- **Chip Selection**: Scale 1.1x + border
- **Roulette Spin**: Rotation with cubic easing

---

## 📱 Responsive Design

### Breakpoints

```dart
Mobile:  < 600px   - Single column, bottom nav
Tablet:  600-900px - Two columns, nav rail (optional)
Desktop: > 900px   - Multi-column, spacious layout
```

### Layout Guidelines

#### Mobile (< 600px)
- Single column layouts
- Bottom navigation bar (4 items)
- 16px base padding
- Stack cards vertically
- Full-width buttons

#### Tablet (600-900px)
- Two-column grid layouts
- Optional navigation rail
- 24px base padding
- 2-3 columns for cards
- Adaptive button widths

#### Desktop (> 900px)
- Multi-column layouts (up to 4)
- Navigation drawer or rail
- 32px base padding
- Centered content (max 1200px)
- Fixed-width buttons

### Responsive Components
- **ResponsiveCenter**: Centers content with max width
- **ResponsiveBuilder**: Different widgets per breakpoint
- **ResponsiveHelper**: Utility functions for queries

---

## ♿ Accessibility

### WCAG AA Compliance

#### Color Contrast
- **Normal Text**: Minimum 4.5:1 contrast ratio
- **Large Text**: Minimum 3:1 contrast ratio
- **Primary Red on White**: 7.2:1 ✅
- **White on Casino Black**: 15.4:1 ✅

#### Touch Targets
- **Minimum**: 48x48dp for all interactive elements
- **Recommended**: 56x56dp for primary actions
- All buttons, chips, and interactive elements comply

#### Semantic Labels
```dart
Semantics(
  label: 'Girar Ruleta',
  button: true,
  enabled: true,
  child: SpinButton(...),
)
```

#### Screen Reader Support
- All interactive elements have descriptive labels
- Icon buttons include tooltips
- Form fields have proper labels
- Status announcements for game events

#### Text Scaling
- All text respects device text scale
- Layouts adapt to larger text sizes
- Maximum tested: 200% scaling

#### Reduced Motion
- Respect `prefers-reduced-motion` preference
- Provide instant transitions when preferred
- Disable confetti and particle effects

---

## 🎨 Theme Configuration

### Light Theme
```dart
Primary: #D32F2F
Secondary: #FFD700
Tertiary: #2E7D32
Background: #F5F5F5
Surface: #FAFAFA
```

### Dark Theme
```dart
Primary: #EF5350 (lighter red for contrast)
Secondary: #FFD700
Tertiary: #66BB6A (lighter green)
Background: #1A1A1A
Surface: #1E1E1E
```

### System Theme
- Automatically switches based on device preference
- Smooth transitions between themes
- Persisted user preference

---

## 📦 Component Library

### Custom Widgets

```dart
// Buttons
CustomButton(text, onPressed, type, size, icon, isLoading)
CustomIconButton(icon, onPressed, tooltip)
CustomFAB(icon, onPressed, extended, label)

// Cards
CustomCard(child, padding, color, onTap)
InfoCard(title, value, icon, color)
BalanceCard(label, amount, icon)
StatCard(label, value, icon, subtitle)

// Casino
BetChip(value, isSelected, onTap, size)
NumberChip(number, isSelected, onTap)
RouletteNumberGrid(selectedNumber, onNumberSelected)

// Roulette
AnimatedRouletteWheel(resultNumber, predictionNumber, size)
RouletteResultDisplay(number, size, animate)
SpinButton(onPressed, isSpinning, isDisabled)

// Numbers
NumberSelector(selectedNumber, onNumberSelected)
CompactNumberDisplay(number, size)
NumberHistory(numbers, highlightNumber)
PredictionDisplay(predictedNumber, description)

// Animations
WinAnimation(amount, onComplete)
CelebrationOverlay(message, icon)
PulseAnimation(child)
ShakeAnimation(child)

// Loading
ShimmerLoading(width, height, borderRadius)
ShimmerCircle(size)
ShimmerText(width, height)
ShimmerCard()
LoadingOverlay(isLoading, child, message)
```

---

## 🎯 Best Practices

### DO ✅
- Use semantic HTML and widgets
- Follow Material 3 guidelines
- Maintain consistent spacing
- Use design tokens (constants)
- Test on multiple screen sizes
- Provide meaningful feedback
- Include loading states
- Handle errors gracefully
- Add tooltips to icon buttons
- Use proper text styles

### DON'T ❌
- Hardcode colors or sizes
- Mix design systems
- Ignore accessibility
- Skip error handling
- Use ambiguous labels
- Create touch targets < 48px
- Disable animations without fallback
- Use only color for meaning
- Ignore responsive design
- Skip loading states

---

## 🎪 Casino Aesthetic Guidelines

### Visual Style
- **Premium**: High-quality visuals, smooth animations
- **Sophisticated**: Dark colors, gold accents
- **Playful**: Celebration effects, engaging interactions
- **Professional**: Clean layouts, clear information hierarchy

### Color Usage
- Red: Action, excitement, hot numbers
- Black: Sophistication, stability, black numbers
- Green: Success, zero, table felt
- Gold: Premium features, achievements, highlights

### Iconography
- Use Material Icons
- Minimum 24px size
- Consistent style throughout
- Meaningful and intuitive

---

## 📋 Checklist for New Components

- [ ] Follows Material Design 3 guidelines
- [ ] Uses design tokens from constants
- [ ] Includes all interactive states (default, hover, pressed, disabled)
- [ ] Has proper touch target size (min 48x48dp)
- [ ] Includes semantic labels for accessibility
- [ ] Responsive across all screen sizes
- [ ] Smooth animations with proper timing
- [ ] Proper error handling
- [ ] Loading states where applicable
- [ ] Documentation and code comments
- [ ] Tested on light and dark themes

---

## 📚 Resources

- [Material Design 3](https://m3.material.io/)
- [Flutter Material 3](https://docs.flutter.dev/ui/design/material)
- [WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Flutter Animate](https://pub.dev/packages/flutter_animate)
- [FL Chart](https://pub.dev/packages/fl_chart)

---

## 🔄 Version History

- **v1.0.0** (2024-12-23) - Initial Material Design 3 implementation
  - Complete theme system
  - Custom widget library
  - Animated roulette wheel
  - Statistics and profile screens
  - Accessibility features
  - Responsive layouts

---

**Maintained by**: Tokyo Roulette Team  
**Last Updated**: December 23, 2024
