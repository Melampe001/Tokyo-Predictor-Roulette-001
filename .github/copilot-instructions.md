# GitHub Copilot Instructions for Tokyo Roulette Predicciones

## Project Overview

This is a Flutter-based educational roulette simulator application with prediction features, RNG (Random Number Generator), Martingale strategy implementation, and a freemium business model. The app is designed as a learning tool and explicitly does not promote real gambling.

**Disclaimer**: This is a simulation tool for educational purposes only.

## Technology Stack

- **Framework**: Flutter (SDK >= 3.0.0 < 4.0.0)
- **Language**: Dart
- **Backend Services**:
  - Firebase Core
  - Firebase Remote Config (for dynamic updates every 4 months)
  - Cloud Firestore (email storage)
  - Firebase Auth (authentication)
  - Firebase Messaging (push notifications for invitations)
- **Payment Integration**:
  - Flutter Stripe (Stripe payments)
  - In-App Purchase (in-app purchases)
- **Additional Dependencies**:
  - intl (internationalization)
  - device_info_plus (device/platform info)
  - url_launcher (email feedback)
  - shared_preferences (local storage)
  - charts_flutter (visualizations)

## Project Structure

```
lib/
  ├── main.dart              # App entry point, Firebase & Stripe initialization
  └── roulette_logic.dart    # Core roulette logic and Martingale strategy

test/
  └── widget_test.dart       # Widget tests

android/                      # Android-specific configuration
```

## Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git
   cd Tokyo-Predictor-Roulette-001
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**:
   - Ensure `firebase_options.dart` is generated using:
     ```bash
     flutterfire configure
     ```
   - Replace Stripe publishable key in `lib/main.dart`

4. **Run the app**:
   ```bash
   flutter run
   ```

5. **Build APK**:
   ```bash
   flutter build apk --release
   ```

## Development Guidelines

### Code Style
- Follow Dart style guidelines and conventions
- Use meaningful variable and function names (Spanish comments are acceptable given the project context)
- Maintain consistent formatting with `dart format`
- Add comments for complex logic, especially in prediction algorithms

### Architecture Patterns
- **RouletteLogic**: Handles core game mechanics
  - `generateSpin()`: Generates random roulette spins using secure RNG
  - `predictNext()`: Implements prediction logic based on history
  
- **MartingaleAdvisor**: Implements betting strategy
  - `getNextBet()`: Calculates next bet based on win/loss
  - `reset()`: Resets betting state

### Code Organization
- Keep business logic separate from UI code
- Place reusable logic in dedicated classes/files
- Use StatefulWidget for interactive components
- Use StatelessWidget for static components

### Testing
- Write widget tests for UI components in `test/widget_test.dart`
- Add unit tests for core logic in `roulette_logic.dart`
- Use `flutter test` to run tests
- Maintain test coverage for critical functionality like:
  - RNG spin generation
  - Prediction algorithms
  - Martingale bet calculations

### Security Considerations
- **Never commit API keys or secrets** to the repository
- Use environment variables or Firebase Remote Config for sensitive data
- Stripe keys should be stored securely and not hardcoded
- Validate all user inputs, especially in payment flows
- Use Firebase Auth best practices for authentication
- Implement proper error handling for payment transactions

### Firebase Integration
- Use Firebase Remote Config to enable/disable features dynamically
- Store user emails securely in Cloud Firestore
- Implement proper Firebase Auth flows
- Use Firebase Messaging for push notifications

### Payment Integration
- Test Stripe integration in test mode before production
- Handle payment failures gracefully
- Implement proper error messages for users
- Follow Stripe's best practices for mobile integration
- Test in-app purchases on both platforms (iOS/Android)

## Common Tasks

### Adding a New Feature
1. Create new logic files in `lib/` if needed
2. Update UI components in `lib/main.dart` or create new screen files
3. Add tests in `test/` directory
4. Update dependencies in `pubspec.yaml` if new packages are needed
5. Run tests before committing

### Updating Dependencies
1. Modify `pubspec.yaml`
2. Run `flutter pub get`
3. Test thoroughly, especially Firebase and payment integrations
4. Check for breaking changes in package changelogs

### Adding Tests
- Place widget tests in `test/` directory
- Use descriptive test names
- Test both success and failure scenarios
- Mock external dependencies (Firebase, Stripe)

## Build and Deploy

### Android Build
```bash
flutter build apk --release
```

### iOS Build (requires macOS)
```bash
flutter build ios --release
```

## Debugging Tips
- Use `flutter doctor` to check environment setup
- Enable verbose logging for Firebase and Stripe in development
- Use Flutter DevTools for performance profiling
- Test RNG behavior with deterministic seeds in tests

## Important Notes

- This is an **educational simulator** - avoid implementing features that encourage real gambling
- Maintain the disclaimer in all user-facing materials
- Focus on teaching probability, statistics, and responsible decision-making
- Follow app store guidelines for gambling-adjacent apps
- Ensure compliance with local regulations regarding simulated gambling

## Contributing

When making changes:
1. Create feature branches from the main branch
2. Write clear commit messages
3. Add tests for new functionality
4. Update documentation if needed
5. Ensure all tests pass before creating pull requests
6. Run `flutter analyze` to catch potential issues

## Language Considerations

- The app is primarily targeted at Spanish-speaking users
- Comments and documentation may be in Spanish
- UI text should support internationalization using the `intl` package
- Maintain consistency in language usage throughout the codebase
