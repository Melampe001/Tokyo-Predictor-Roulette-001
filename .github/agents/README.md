# Custom GitHub Copilot Agents

This directory contains specialized agents for the Tokyo Roulette Predictor project. Each agent is an expert in specific aspects of the application.

## Available Agents

### 1. Flutter Mobile Development Agent
**Path**: `.github/agents/flutter-mobile-agent/`

Expert in Flutter/Dart mobile development with Firebase and Stripe integrations.

**Use for**:
- Creating new screens and UI components
- Implementing Flutter features
- State management
- Navigation and routing
- Mobile-specific implementations
- UI/UX improvements

**Example prompts**:
- "Create a new settings screen with theme toggle"
- "Implement a custom roulette wheel widget"
- "Add pull-to-refresh functionality"

---

### 2. Roulette Logic & Algorithm Agent
**Path**: `.github/agents/roulette-logic-agent/`

Specialist in roulette simulation, RNG, prediction algorithms, and betting strategies.

**Use for**:
- Implementing game logic
- Developing prediction algorithms
- RNG improvements
- Martingale strategy optimization
- Statistical analysis features
- Mathematical calculations

**Example prompts**:
- "Improve the prediction algorithm accuracy"
- "Implement a new betting strategy"
- "Optimize RNG for better distribution"
- "Add statistical analysis for last 100 spins"

---

### 3. Firebase Integration Agent
**Path**: `.github/agents/firebase-integration-agent/`

Expert in all Firebase services including Auth, Firestore, Remote Config, and Cloud Messaging.

**Use for**:
- Firebase authentication flows
- Firestore database operations
- Remote Config updates
- Push notifications
- Firebase security rules
- Offline data handling

**Example prompts**:
- "Set up user authentication with email"
- "Create Firestore collection for user statistics"
- "Implement push notifications for special events"
- "Update Remote Config with new parameters"

---

### 4. Payment & Monetization Agent
**Path**: `.github/agents/payment-agent/`

Specialist in Stripe integration, in-app purchases, and freemium model implementation.

**Use for**:
- Payment processing
- In-app purchase flows
- Premium feature access
- Subscription management
- Payment error handling
- Monetization optimization

**Example prompts**:
- "Implement one-time payment for premium features"
- "Add subscription management screen"
- "Handle payment failures gracefully"
- "Set up Stripe webhook handlers"

---

### 5. Testing & Quality Assurance Agent
**Path**: `.github/agents/testing-qa-agent/`

Expert in Flutter testing, code quality, and CI/CD workflows.

**Use for**:
- Writing unit tests
- Creating widget tests
- Integration testing
- CI/CD improvements
- Code quality checks
- Performance optimization

**Example prompts**:
- "Write unit tests for roulette logic"
- "Create widget tests for the main screen"
- "Improve test coverage for payment flows"
- "Set up integration tests for Firebase"

---

### 6. Localization & Spanish Content Agent
**Path**: `.github/agents/localization-agent/`

Specialist in internationalization and Spanish language content.

**Use for**:
- Spanish translations
- Internationalization setup
- Cultural adaptation
- Educational content in Spanish
- Multi-language support
- Regional compliance

**Example prompts**:
- "Translate new features to Spanish"
- "Adapt content for Mexican Spanish"
- "Add responsible gaming message in Spanish"
- "Implement currency formatting for Latin America"

---

## How to Use Custom Agents

### In GitHub Copilot Chat

1. **Reference an agent in your prompt**:
   ```
   @flutter-mobile-agent create a new statistics dashboard screen
   ```

2. **Ask agent-specific questions**:
   ```
   @roulette-logic-agent how can I improve the prediction algorithm?
   ```

3. **Request code reviews**:
   ```
   @testing-qa-agent review this test suite for completeness
   ```

### In Pull Requests

Reference agents in PR descriptions to get specialized reviews:
```markdown
@payment-agent please review the Stripe integration changes
@firebase-integration-agent verify the Firestore security rules
```

### Best Practices

1. **Use the right agent for the task**: Each agent specializes in specific areas
2. **Be specific in prompts**: Provide context and clear requirements
3. **Combine agents when needed**: Some tasks may require multiple agents
4. **Follow agent guidelines**: Each agent has specific coding standards
5. **Security first**: Agents will remind you about security best practices

---

## Agent Selection Guide

| Task Type | Recommended Agent |
|-----------|------------------|
| UI Components | Flutter Mobile Development Agent |
| Game Logic | Roulette Logic & Algorithm Agent |
| Database Operations | Firebase Integration Agent |
| Payments | Payment & Monetization Agent |
| Writing Tests | Testing & QA Agent |
| Translations | Localization & Spanish Content Agent |
| Authentication | Firebase Integration Agent |
| Performance Optimization | Testing & QA Agent |
| RNG Improvements | Roulette Logic & Algorithm Agent |
| Spanish Content | Localization & Spanish Content Agent |

---

## Contributing

When adding new agents:

1. Create a new directory under `.github/agents/`
2. Add an `agent.yml` configuration file
3. Update this README with agent details
4. Document the agent's expertise and use cases
5. Provide example prompts

---

## Project Context

**Repository**: Tokyo-Predictor-Roulette-001  
**Type**: Educational roulette simulator (Flutter/Dart)  
**Purpose**: Entertainment and education only - not real gambling  
**Primary Language**: Spanish  
**Target Markets**: Spain, Mexico, Latin America

---

## Quick Reference

### Common Multi-Agent Workflows

**Adding a new premium feature**:
1. @flutter-mobile-agent: Build the UI
2. @roulette-logic-agent: Implement the logic
3. @payment-agent: Gate the feature behind premium
4. @localization-agent: Translate to Spanish
5. @testing-qa-agent: Write comprehensive tests

**Firebase feature with payment**:
1. @firebase-integration-agent: Set up Firestore structure
2. @payment-agent: Implement payment flow
3. @flutter-mobile-agent: Create the UI
4. @testing-qa-agent: Test the integration

**Algorithm improvement**:
1. @roulette-logic-agent: Optimize the algorithm
2. @testing-qa-agent: Benchmark and test
3. @localization-agent: Update educational content
4. @flutter-mobile-agent: Update UI if needed

---

## Support

For questions about agents or to request new specialized agents, please open an issue with the label `agent-request`.
