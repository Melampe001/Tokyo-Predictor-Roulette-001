# 🔒 Security Checklist for Pull Requests

## Pre-Commit Checklist

Before committing code, ensure:

- [ ] No API keys, secrets, or credentials hardcoded
- [ ] No sensitive data (emails, passwords, tokens) in logs
- [ ] Input validation on all user inputs
- [ ] No `shell=True` in subprocess calls (Python)
- [ ] No SQL/NoSQL injection vulnerabilities
- [ ] Cryptographically secure RNG used (Random.secure() in Dart)

## Pull Request Checklist

When submitting a PR, verify:

### 1. Code Security
- [ ] No hardcoded secrets (check with: `git grep -i "api.*key\|secret\|password"`)
- [ ] Dependencies scanned for vulnerabilities
- [ ] No sensitive data in error messages or logs
- [ ] Proper input validation and sanitization
- [ ] No eval(), exec(), or dynamic code execution
- [ ] File paths validated to prevent traversal

### 2. Authentication & Authorization
- [ ] Firebase Auth properly configured (if applicable)
- [ ] No authentication bypass vulnerabilities
- [ ] Session management secure
- [ ] Rate limiting implemented for sensitive operations

### 3. Data Protection
- [ ] HTTPS enforced for all network communication
- [ ] No cleartext traffic allowed
- [ ] Sensitive data encrypted at rest
- [ ] PII handled according to GDPR/CCPA

### 4. Mobile Security (Android/iOS)
- [ ] Minimal permissions requested
- [ ] Permissions justified in code comments
- [ ] ProGuard/R8 enabled for release builds
- [ ] Release APK signed with production keystore (not debug)
- [ ] Certificate pinning for critical APIs (if applicable)

### 5. Educational App Compliance
- [ ] Educational disclaimers visible and clear
- [ ] Age verification (18+) implemented
- [ ] No real money gambling functionality
- [ ] Gambling addiction resources provided
- [ ] Clear statement: "For educational purposes only"

### 6. Firebase Security (if applicable)
- [ ] Firestore security rules validated
- [ ] Storage security rules configured
- [ ] Authentication rules prevent unauthorized access
- [ ] No overly permissive rules (avoid `allow read, write: if true`)

### 7. Dependency Management
- [ ] All dependencies up to date
- [ ] No dependencies with known vulnerabilities
- [ ] Dependencies from trusted sources only
- [ ] Unused dependencies removed

### 8. Testing
- [ ] Security test cases included
- [ ] Input fuzzing for critical functions
- [ ] Authentication/authorization tests
- [ ] No test credentials in production code

## Code Review Security Focus

Reviewers should specifically check:

1. **Authentication flows**: Proper validation, no bypass
2. **API calls**: Proper error handling, no data leakage
3. **User inputs**: Validated and sanitized
4. **File operations**: Path traversal prevention
5. **Cryptography**: Strong algorithms, secure keys
6. **Logging**: No sensitive data logged
7. **Third-party integrations**: Secure configuration

## Automated Security Checks

These should run automatically in CI/CD:

- [ ] CodeQL security scanning
- [ ] Dependency vulnerability scanning (GitHub Advisory)
- [ ] Secret scanning (prevent accidental commits)
- [ ] Linting with security rules
- [ ] SAST (Static Application Security Testing)

## Release Checklist

Before releasing to production:

- [ ] All security issues from CodeQL resolved
- [ ] Dependency vulnerabilities addressed
- [ ] Production keystore configured (not debug)
- [ ] Firebase security rules reviewed and tested
- [ ] Security audit completed
- [ ] Penetration testing performed (if applicable)
- [ ] Privacy policy updated
- [ ] Terms of service reviewed

## Incident Response

If a security vulnerability is discovered:

1. Create a private security advisory in GitHub
2. Do NOT discuss publicly until fixed
3. Assess severity: CRITICAL, HIGH, MEDIUM, LOW
4. Develop and test fix
5. Deploy fix to production
6. Notify affected users (if applicable)
7. Document in security changelog

## Security Resources

- **OWASP Mobile Top 10**: https://owasp.org/www-project-mobile-top-10/
- **Flutter Security**: https://docs.flutter.dev/security
- **Android Security**: https://developer.android.com/topic/security
- **Dart Secure Coding**: https://dart.dev/guides/libraries/secure-coding
- **Firebase Security**: https://firebase.google.com/docs/rules

## Contact

For security concerns or to report vulnerabilities:
- Create a private security advisory in GitHub
- Email: security@tokyoapps.com (if configured)
- Do NOT open public issues for security vulnerabilities

---

**Last Updated**: 2025-12-15  
**Version**: 1.0
