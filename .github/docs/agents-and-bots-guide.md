# Premium Agents & Bots Guide

Welcome to the comprehensive guide for Tokyo Roulette Predictor's premium suite of custom Copilot agents and GitHub Actions bots!

## 📋 Table of Contents

1. [Overview](#overview)
2. [Custom Copilot Agents](#custom-copilot-agents)
3. [GitHub Actions Bots](#github-actions-bots)
4. [Configuration Files](#configuration-files)
5. [Usage Examples](#usage-examples)
6. [Troubleshooting](#troubleshooting)
7. [Best Practices](#best-practices)

---

## Overview

This project includes a premium suite of 5 custom Copilot agents and 5 automated GitHub Actions bots designed to streamline development, improve code quality, and enhance the contributor experience.

### Custom Copilot Agents (5)
1. **Tokyo Roulette Premium Master Agent** - Full-stack orchestration
2. **Flutter Mobile Expert Agent** - Mobile UI/UX specialist
3. **Python ML Specialist Agent** - Machine learning expert
4. **DevOps & Deployment Agent** - CI/CD and infrastructure
5. **QA & Testing Premium Agent** - Quality assurance

### GitHub Actions Bots (5)
1. **Auto-Labeler Premium Bot** - Automatic PR/issue labeling
2. **PR Reviewer Premium Bot** - Automated code review
3. **Code Quality & Performance Bot** - Quality analysis
4. **Auto-Deploy Premium Bot** - Automated deployments
5. **Welcome & Onboarding Bot** - Contributor welcome

---

## Custom Copilot Agents

### How to Use Copilot Agents

Custom Copilot agents are available in GitHub Copilot when you're working in this repository. To use them:

1. **Open a file** in VS Code or your IDE with GitHub Copilot
2. **Mention the agent** in a Copilot chat with `@agent-name`
3. **Ask your question** or describe what you need help with
4. **Review the response** and apply suggestions

### 1. Tokyo Roulette Premium Master Agent

**Location**: `.github/agents/tokyo-roulette-premium.agent.md`

**When to Use**:
- Full-stack architecture decisions
- Cross-platform integration (Flutter + Python)
- ML prediction system design
- Performance optimization
- System-wide refactoring

**Example Usage**:
```
@tokyo-roulette-premium How should I integrate the ML prediction API with the Flutter mobile app?
```

**Expertise**:
- AI/ML prediction systems
- Multi-platform development
- Data science and analytics
- Clean architecture patterns
- Real-time data pipelines

### 2. Flutter Mobile Expert Agent

**Location**: `.github/agents/flutter-mobile-expert.agent.md`

**When to Use**:
- Flutter widget development
- State management (Provider, Riverpod, Bloc)
- Mobile UI/UX design
- Performance optimization
- Platform integration (Android/iOS)

**Example Usage**:
```
@flutter-mobile-expert How do I optimize this widget to prevent unnecessary rebuilds?
```

**Expertise**:
- Advanced Flutter/Dart
- Custom animations and gestures
- Responsive design
- Widget testing
- Performance profiling

### 3. Python ML Specialist Agent

**Location**: `.github/agents/python-ml-specialist.agent.md`

**When to Use**:
- ML model development
- Prediction algorithms
- Data preprocessing
- Model training and evaluation
- Statistical analysis

**Example Usage**:
```
@python-ml-specialist How can I improve the accuracy of my roulette prediction model?
```

**Expertise**:
- TensorFlow, PyTorch, scikit-learn
- Feature engineering
- Time series analysis
- Model deployment
- Performance optimization

### 4. DevOps & Deployment Agent

**Location**: `.github/agents/devops-deployment.agent.md`

**When to Use**:
- CI/CD pipeline setup
- Docker containerization
- Kubernetes deployment
- Infrastructure as Code
- Monitoring and logging

**Example Usage**:
```
@devops-deployment How do I set up automated deployments to staging and production?
```

**Expertise**:
- GitHub Actions workflows
- Container orchestration
- Cloud platforms (AWS, GCP, Azure)
- Security best practices
- Performance monitoring

### 5. QA & Testing Premium Agent

**Location**: `.github/agents/qa-testing-premium.agent.md`

**When to Use**:
- Writing unit tests
- Integration testing
- End-to-end testing
- Performance testing
- Test automation

**Example Usage**:
```
@qa-testing-premium What tests should I write for this new prediction feature?
```

**Expertise**:
- pytest and Flutter test
- Test-driven development
- Code coverage analysis
- Load testing
- Security testing

---

## GitHub Actions Bots

### 1. Auto-Labeler Premium Bot

**Workflow**: `.github/workflows/auto-labeler-premium.yml`

**Triggers**:
- Pull requests opened/edited/synchronized
- Issues opened/edited

**Features**:
- Automatically labels PRs based on file changes
- Labels issues based on keywords
- Adds priority labels (high/medium/low)
- Adds size labels (XS/S/M/L/XL)
- Posts helpful welcome comments
- Auto-assigns reviewers (configurable)

**Labels Created**:
```
Component Labels:
- backend, frontend, mobile, ml-model, api
- tests, documentation, configuration, ci-cd

Type Labels:
- bug, enhancement, refactor, security, performance

Priority Labels:
- priority: high, priority: medium, priority: low

Size Labels:
- size: XS, size: S, size: M, size: L, size: XL

Status Labels:
- needs-review, needs-testing, ready-to-merge
- first-time-contributor, good first issue
```

**Configuration**:
No additional configuration needed. The bot works automatically on all PRs and issues.

### 2. PR Reviewer Premium Bot

**Workflow**: `.github/workflows/pr-reviewer-premium.yml`

**Triggers**:
- Pull requests opened/synchronized/reopened

**Features**:
- Runs Flutter analyzer and formatter checks
- Runs Python linting (pylint, black, isort)
- Runs security scans (Bandit)
- Executes test suites with coverage
- Checks documentation updates
- Validates commit messages
- Posts comprehensive review comments

**What It Checks**:
```
Flutter/Dart:
✓ flutter analyze
✓ dart format
✓ flutter test

Python:
✓ pylint (code quality)
✓ black (formatting)
✓ isort (import sorting)
✓ bandit (security)
✓ pytest (tests)

General:
✓ Documentation updates
✓ Commit message format
```

**How to Read Results**:
The bot posts a comment on your PR with sections:
- ✅ **Passed** - No issues found
- ⚠️ **Warning** - Minor issues to address
- ❌ **Failed** - Critical issues blocking merge

### 3. Code Quality & Performance Bot

**Workflow**: `.github/workflows/code-quality-premium.yml`

**Triggers**:
- Push to main/develop
- Pull requests
- Weekly schedule (Mondays)
- Manual dispatch

**Features**:
- Comprehensive code quality analysis
- Code coverage reporting (Codecov)
- Dependency vulnerability scanning (Trivy)
- Performance benchmarking
- APK size monitoring
- Code complexity analysis

**Reports Generated**:
```
Flutter:
- Analysis report
- Test coverage
- Build size metrics

Python:
- Pylint quality score
- Code complexity (Radon)
- Security scan (Bandit)
- Test coverage

Security:
- Trivy vulnerability scan
- Safety dependency check
```

**Artifacts**:
Quality reports are uploaded as workflow artifacts and retained for 30 days.

### 4. Auto-Deploy Premium Bot

**Workflow**: `.github/workflows/auto-deploy-premium.yml`

**Triggers**:
- Push to `develop` (→ staging)
- Push to `main` or `master` (→ production)
- Manual workflow dispatch

**Deployment Flow**:
```
develop branch → Staging Environment
main/master → Production Environment

Steps:
1. Run pre-deployment tests
2. Build APK and App Bundle
3. Deploy to environment
4. Run smoke tests
5. Create GitHub release (production)
6. Send notifications
```

**Environments**:
```
Staging:
- URL: https://staging.tokyo-roulette.app
- Auto-deploy on develop branch
- Suitable for testing

Production:
- URL: https://tokyo-roulette.app
- Auto-deploy on main/master
- Creates GitHub releases
- Requires approval (configurable)
```

**Manual Deployment**:
1. Go to Actions tab
2. Select "Auto-Deploy Premium Bot"
3. Click "Run workflow"
4. Choose environment and options
5. Click "Run workflow"

**Rollback**:
If deployment fails, the bot creates an issue with rollback instructions.

### 5. Welcome & Onboarding Bot

**Workflow**: `.github/workflows/welcome-premium.yml`

**Triggers**:
- Issues opened
- Pull requests opened/closed
- Discussions created

**Features**:
- Welcomes first-time contributors
- Provides contextual resources
- Thanks contributors on PR merge
- Celebrates milestones (5, 10, 25, 50, 100 PRs)
- Suggests good first issues
- Adds first-time contributor labels

**Welcome Messages**:
```
First Issue:
- Welcome message
- Getting started guide
- Helpful resources
- Contribution guidelines

First PR:
- Encouragement
- Review process explanation
- Tips for success
- Available support

PR Merged:
- Thank you message
- Next steps
- Milestone celebration (if applicable)
```

---

## Configuration Files

### Dependabot (`/.github/dependabot.yml`)

**Purpose**: Automated dependency updates

**Configured For**:
- Python pip packages (weekly)
- Dart pub packages (weekly)
- GitHub Actions (weekly)
- Docker base images (weekly)

**Features**:
- Automatic security updates
- Scheduled version updates
- Auto-assigns reviewers
- Adds appropriate labels
- Conventional commit messages

**Customization**:
Edit `.github/dependabot.yml` to:
- Change update schedule
- Modify reviewers/assignees
- Add package-specific rules
- Ignore specific dependencies

### CODEOWNERS (`/.github/CODEOWNERS`)

**Purpose**: Automatic code review assignments

**Current Configuration**:
- Owner reviews all changes: `@Melampe001`
- Can be extended for team members

**How It Works**:
When a PR changes files, GitHub automatically requests review from the designated owners.

**Customization**:
```
# Add team members
/lib/*.dart @flutter-team
/scripts/*.py @ml-team
/.github/workflows/ @devops-team
```

---

## Usage Examples

### Example 1: Contributing a New Feature

1. **Create feature branch**:
   ```bash
   git checkout -b feat/add-statistics-page
   ```

2. **Ask Copilot agent for guidance**:
   ```
   @tokyo-roulette-premium I'm adding a statistics page to show betting history. 
   What's the best architecture approach?
   ```

3. **Develop the feature** following agent guidance

4. **Write tests** with QA agent help:
   ```
   @qa-testing-premium What tests should I write for the statistics page?
   ```

5. **Open PR** - Auto-labeler will:
   - Label as `mobile`, `frontend`, `enhancement`
   - Add size label based on changes
   - Post welcome comment

6. **Review bot feedback**:
   - Fix any linting issues
   - Address test failures
   - Update documentation if flagged

7. **Merge** - Welcome bot will thank you!

### Example 2: Improving ML Model

1. **Open issue** using ML template:
   - Auto-labeled as `ml-model`, `enhancement`
   - Resources automatically suggested

2. **Ask ML specialist agent**:
   ```
   @python-ml-specialist How can I add LSTM layers to improve sequence prediction?
   ```

3. **Implement changes** following guidance

4. **Run quality checks**:
   ```bash
   pytest --cov=.
   pylint *.py
   ```

5. **Open PR** - Bots will:
   - Run comprehensive tests
   - Check code quality
   - Verify documentation

6. **Deploy to staging** automatically on merge to develop

7. **Test in staging**, then merge to main for production

### Example 3: Fixing a Bug

1. **Report bug** using bug template
   - Auto-labeled appropriately
   - Priority assigned based on keywords

2. **Investigate** with relevant agent help

3. **Fix and test**:
   ```
   @qa-testing-premium What edge cases should I test for this fix?
   ```

4. **Open PR** with fix

5. **Bots verify**:
   - Tests pass
   - No regressions
   - Code quality maintained

6. **Fast-track to production** after review

---

## Troubleshooting

### Workflow Failures

**Problem**: Workflow fails with permissions error

**Solution**: 
- Check workflow permissions in repository settings
- Ensure `GITHUB_TOKEN` has required permissions
- For external services, verify secrets are configured

**Problem**: Tests fail in CI but pass locally

**Solution**:
- Check Flutter/Python versions match
- Review environment differences
- Examine artifact logs for details

**Problem**: Bot not commenting on PR

**Solution**:
- Verify workflow triggered (check Actions tab)
- Check workflow permissions for PR comments
- Review workflow logs for errors

### Agent Issues

**Problem**: Agent not responding in Copilot

**Solution**:
- Ensure agent files are in `.github/agents/`
- Check file syntax is correct Markdown
- Try refreshing IDE/Copilot
- Verify repository is synced

**Problem**: Agent gives generic responses

**Solution**:
- Be more specific in your question
- Provide code context
- Mention specific technologies/patterns
- Reference files or functions

### Labeling Issues

**Problem**: Wrong labels applied

**Solution**:
- Manually adjust labels as needed
- Update labeling logic in workflow if pattern is consistent
- Labels are suggestions, not requirements

**Problem**: No labels applied

**Solution**:
- Check workflow ran successfully
- Verify trigger conditions met
- Review workflow logs

### Deployment Issues

**Problem**: Deployment to staging failed

**Solution**:
- Check pre-deployment tests passed
- Review build logs for errors
- Verify environment secrets configured
- Check smoke tests results

**Problem**: Can't manually trigger deployment

**Solution**:
- Ensure you have write permissions
- Check workflow has `workflow_dispatch` trigger
- Verify branch protection rules

---

## Best Practices

### Working with Agents

✅ **Do**:
- Be specific in your questions
- Provide code context
- Ask follow-up questions
- Apply suggestions thoughtfully
- Verify generated code

❌ **Don't**:
- Blindly copy-paste without understanding
- Ignore security warnings
- Skip testing suggested code
- Forget to review for project standards

### Working with Bots

✅ **Do**:
- Read bot feedback carefully
- Address all warnings and errors
- Update documentation when flagged
- Keep PRs focused and small
- Respond to review comments promptly

❌ **Don't**:
- Ignore bot feedback
- Merge with failing checks
- Bypass required reviews
- Create overly large PRs
- Leave issues unaddressed

### Contributing

✅ **Do**:
- Follow conventional commit format
- Write descriptive PR descriptions
- Add tests for new features
- Update documentation
- Run tests locally first
- Ask for help when needed

❌ **Don't**:
- Commit secrets or credentials
- Make unrelated changes in one PR
- Skip code review
- Merge without approval
- Forget to sync with main branch

### Code Quality

✅ **Do**:
- Maintain >80% code coverage
- Follow style guidelines
- Write clear comments
- Keep functions small and focused
- Profile performance changes
- Address security warnings

❌ **Don't**:
- Skip tests
- Ignore linter warnings
- Leave debug code
- Create complex functions
- Introduce performance regressions
- Ignore security issues

---

## Additional Resources

### Documentation
- [README](../../README.md) - Project overview
- [Contributing Guide](../../CONTRIBUTING.md) - Contribution guidelines
- [Architecture](../../docs/ARCHITECTURE.md) - Technical architecture
- [Changelog](../../CHANGELOG.md) - Version history

### Workflows
- [Build APK](../workflows/build-apk.yml) - APK build workflow
- [Project Health Check](../workflows/project-health-check.yml) - Health monitoring

### Issue Templates
- [Bug Report](../ISSUE_TEMPLATE/bug_report.md)
- [Feature Request](../ISSUE_TEMPLATE/feature_request.md)
- [ML Model Improvement](../ISSUE_TEMPLATE/ml_model_improvement.md)
- [Performance Issue](../ISSUE_TEMPLATE/performance_issue.md)
- [Documentation](../ISSUE_TEMPLATE/documentation.md)

---

## Support

Need help?
- 📖 Check this guide first
- 🔍 Search existing issues
- 💬 Ask in discussions
- 🐛 Report bugs with template
- 💡 Suggest features with template
- 📧 Contact: [Open an issue](../../issues/new)

---

## Changelog

### Version 1.0.0 (Current)
- Initial premium agent suite
- 5 custom Copilot agents
- 5 GitHub Actions bots
- Comprehensive documentation
- Issue templates
- Dependabot configuration
- CODEOWNERS setup

---

**Last Updated**: December 2024
**Maintained by**: Tokyo Roulette Predictor Team
**License**: MIT
