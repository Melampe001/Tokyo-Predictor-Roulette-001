# Copilot Instructions for Tokyo Roulette Predictor

## Project Overview
This is a Flutter/Dart educational roulette simulator with predictions, RNG (Random Number Generator), Martingale strategy implementation, and a freemium model. The app includes integrations with Stripe for payments and Firebase for remote configurations.

**Important**: This is an educational simulator only - it does not promote real gambling.

## Technology Stack
- **Framework**: Flutter (SDK >=3.0.0 <4.0.0)
- **Language**: Dart
- **Key Dependencies**:
  - `flutter_stripe`: Payment processing
  - `firebase_core`, `firebase_remote_config`, `cloud_firestore`, `firebase_auth`, `firebase_messaging`: Firebase integrations
  - `in_app_purchase`: In-app purchase support
  - `charts_flutter`: Data visualization
  - `shared_preferences`: Local storage
  - `intl`: Internationalization
  - `device_info_plus`: Device information
  - `url_launcher`: External URL handling

## Project Structure
- `lib/`: Main application code
  - `main.dart`: Application entry point
  - `roulette_logic.dart`: Core roulette logic and predictions
- `test/`: Unit and widget tests
- `android/`: Android-specific configuration
- `docs/`: Documentation files
- `assets/images/`: Image assets

## Development Workflow

### Setup
1. Clone the repository: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. Install dependencies: `flutter pub get`
3. Run the app: `flutter run`

### Building
- **Development**: `flutter run`
- **Release APK**: `flutter build apk --release`
- **Testing**: `flutter test`

### Testing
- Unit tests are located in the `test/` directory
- Run all tests with: `flutter test`
- Integration tests use the `integration_test` package

## Code Style and Conventions
- Follow Dart's official style guide
- Use meaningful variable and function names (Spanish comments are acceptable as the project is in Spanish)
- Keep functions focused and single-purpose
- Document complex algorithms, especially in `roulette_logic.dart`

## Firebase Configuration
The app uses Firebase for:
- **Remote Config**: Dynamic updates every 4 months
- **Firestore**: Email storage
- **Authentication**: User authentication for email handling
- **Messaging**: Push notifications for invitations

Ensure Firebase configuration files are properly set up before running.

## Stripe Integration
- Payment processing is handled through `flutter_stripe`
- Test mode should be used for development
- Never commit API keys or secrets to the repository

## Security Considerations
- **API Keys**: Never commit Firebase or Stripe API keys. Use environment variables or secure configuration management
- **Sensitive Data**: Handle user emails and payment information according to GDPR and privacy best practices
- **Authentication**: Use Firebase Auth for secure user authentication
- **Input Validation**: Validate all user inputs, especially in payment and betting logic

## Common Tasks

### Adding a New Feature
1. Create a new branch from `main`
2. Implement the feature in the appropriate file(s)
3. Add tests for the new functionality
4. Run tests: `flutter test`
5. Build and verify: `flutter run`
6. Submit a pull request

### Updating Dependencies
1. Update `pubspec.yaml`
2. Run `flutter pub get`
3. Test thoroughly to ensure compatibility
4. Check for security vulnerabilities in new dependencies

### Modifying Roulette Logic
- The core logic is in `lib/roulette_logic.dart`
- Ensure RNG remains truly random
- Document any changes to prediction algorithms
- Maintain the educational nature of the simulator

## Language and Localization
- The project supports internationalization via the `intl` package
- Primary language is Spanish
- Comments and documentation can be in Spanish or English
- UI text should be localized where appropriate

## Best Practices for AI Assistance
- When making changes, always consider the educational purpose of the app
- Maintain clear separation between free and premium features
- Ensure Firebase and Stripe integrations remain secure
- Test payment flows thoroughly in test mode before production
- Keep the disclaimer visible that this is a simulator, not real gambling
