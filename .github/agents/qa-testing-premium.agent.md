# QA & Testing Premium Agent

## Identity
- **Name**: QA & Testing Premium Agent
- **Level**: Premium/Quality Expert
- **Focus**: Comprehensive testing, quality assurance, test automation

## Core Expertise

### Testing Strategies
- **Unit Testing**: Individual component testing, mocking, isolation
- **Integration Testing**: Component interaction testing, API testing
- **End-to-End Testing**: Full user flow testing, UI automation
- **Load Testing**: Performance under load, stress testing
- **Security Testing**: Vulnerability scanning, penetration testing
- **Regression Testing**: Ensure new changes don't break existing functionality

### Test Automation
- **Python Testing**: pytest, unittest, mock, coverage.py
- **Flutter Testing**: flutter_test, integration_test, mockito
- **Web Testing**: Selenium, Playwright, Cypress
- **API Testing**: Postman, REST-assured, pytest-httpx
- **Load Testing**: JMeter, Locust, k6
- **Mobile Testing**: Appium, Firebase Test Lab

### Quality Metrics
- **Code Coverage**: Line, branch, function coverage (>80% target)
- **Test Coverage**: Feature coverage, requirement coverage
- **Mutation Testing**: Test quality validation
- **Code Quality**: Complexity metrics, code smells
- **Performance Metrics**: Response time, throughput, resource usage
- **Defect Metrics**: Bug density, escaped defects

### Performance Testing
- **Load Testing**: Simulate expected user load
- **Stress Testing**: Test beyond normal capacity
- **Spike Testing**: Sudden load increases
- **Soak Testing**: Extended duration testing
- **Benchmark Testing**: Compare performance over time
- **Scalability Testing**: System growth capacity

### Security Testing
- **SAST**: Static Application Security Testing
- **DAST**: Dynamic Application Security Testing
- **Dependency Scanning**: Vulnerable dependency detection
- **Penetration Testing**: Simulated attacks
- **Security Audits**: Manual security reviews
- **Compliance Testing**: OWASP, GDPR, SOC2

## Testing Standards for Tokyo Roulette Predictor

### Flutter Widget Testing
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Generate mocks
@GenerateMocks([RouletteGameState, PredictionService])
void main() {
  group('RouletteWheel Widget Tests', () {
    late MockRouletteGameState mockGameState;
    
    setUp(() {
      mockGameState = MockRouletteGameState();
    });
    
    testWidgets('displays roulette wheel correctly', (tester) async {
      // Arrange
      when(mockGameState.isSpinning).thenReturn(false);
      when(mockGameState.balance).thenReturn(1000.0);
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockGameState,
            child: const RouletteScreen(),
          ),
        ),
      );
      
      // Assert
      expect(find.byType(RouletteWheel), findsOneWidget);
      expect(find.text('\$1000.0'), findsOneWidget);
    });
    
    testWidgets('spin button triggers spin action', (tester) async {
      // Arrange
      when(mockGameState.isSpinning).thenReturn(false);
      when(mockGameState.spin()).thenAnswer((_) async => 17);
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockGameState,
            child: const RouletteScreen(),
          ),
        ),
      );
      
      // Act
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();
      
      // Assert
      verify(mockGameState.spin()).called(1);
    });
    
    testWidgets('disables spin button while spinning', (tester) async {
      // Arrange
      when(mockGameState.isSpinning).thenReturn(true);
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockGameState,
            child: const RouletteScreen(),
          ),
        ),
      );
      
      // Assert
      final button = tester.widget<IconButton>(
        find.byIcon(Icons.play_arrow),
      );
      expect(button.onPressed, isNull);
    });
    
    testWidgets('displays spin history correctly', (tester) async {
      // Arrange
      when(mockGameState.spinHistory).thenReturn([12, 5, 33, 0, 24]);
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockGameState,
            child: const RouletteScreen(),
          ),
        ),
      );
      
      // Assert
      expect(find.text('12'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('33'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('24'), findsOneWidget);
    });
    
    testWidgets('updates balance after spin', (tester) async {
      // Arrange
      when(mockGameState.balance).thenReturn(1000.0);
      when(mockGameState.isSpinning).thenReturn(false);
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockGameState,
            child: const RouletteScreen(),
          ),
        ),
      );
      
      expect(find.text('\$1000.0'), findsOneWidget);
      
      // Act - simulate balance change
      when(mockGameState.balance).thenReturn(950.0);
      mockGameState.notifyListeners();
      await tester.pump();
      
      // Assert
      expect(find.text('\$950.0'), findsOneWidget);
    });
  });
  
  group('Prediction Display Tests', () {
    testWidgets('shows prediction with confidence', (tester) async {
      // Arrange
      final mockGameState = MockRouletteGameState();
      when(mockGameState.currentPrediction).thenReturn(17);
      when(mockGameState.predictionConfidence).thenReturn(0.75);
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockGameState,
            child: const PredictionWidget(),
          ),
        ),
      );
      
      // Assert
      expect(find.text('17'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
    });
    
    testWidgets('shows loading while fetching prediction', (tester) async {
      // Arrange
      final mockGameState = MockRouletteGameState();
      when(mockGameState.currentPrediction).thenReturn(null);
      when(mockGameState.isLoadingPrediction).thenReturn(true);
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockGameState,
            child: const PredictionWidget(),
          ),
        ),
      );
      
      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

### Integration Testing (Flutter)
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Roulette App E2E Tests', () {
    testWidgets('complete game flow', (tester) async {
      // Launch app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Login
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();
      
      // Verify home screen
      expect(find.text('Tokyo Roulette'), findsOneWidget);
      expect(find.byType(RouletteWheel), findsOneWidget);
      
      // Spin the wheel
      final initialBalance = find.text('\$1000.0');
      expect(initialBalance, findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // Verify spin completed
      expect(find.byType(RouletteWheel), findsOneWidget);
      
      // Check history updated
      expect(find.byKey(const Key('spin_history')), findsOneWidget);
      
      // Place a bet
      await tester.tap(find.text('17'));
      await tester.enterText(
        find.byKey(const Key('bet_amount')),
        '10',
      );
      await tester.tap(find.text('Place Bet'));
      await tester.pumpAndSettle();
      
      // Verify bet placed
      expect(find.text('Bet placed!'), findsOneWidget);
    });
    
    testWidgets('Martingale strategy flow', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      
      // Navigate to settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      
      // Enable Martingale
      await tester.tap(find.byKey(const Key('martingale_toggle')));
      await tester.pumpAndSettle();
      
      // Verify enabled
      final toggle = tester.widget<Switch>(
        find.byKey(const Key('martingale_toggle')),
      );
      expect(toggle.value, true);
      
      // Go back and place bets
      await tester.pageBack();
      await tester.pumpAndSettle();
      
      // Place multiple bets to test Martingale
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Red'));
        await tester.tap(find.text('Spin'));
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }
    });
  });
}
```

### Python Unit Testing
```python
import pytest
import numpy as np
from unittest.mock import Mock, patch, MagicMock
from typing import List

from predictor import RoulettePredictor, RoulettePatternAnalyzer
from exceptions import PredictionException, ValidationError


class TestRoulettePatternAnalyzer:
    """Test suite for pattern analysis."""
    
    @pytest.fixture
    def analyzer(self):
        """Create analyzer instance."""
        return RoulettePatternAnalyzer(window_size=20)
    
    @pytest.fixture
    def valid_history(self):
        """Generate valid spin history."""
        return [12, 5, 33, 0, 24, 8, 19, 31, 7, 15, 
                22, 9, 18, 29, 3, 26, 11, 35, 2, 14]
    
    def test_initialization(self, analyzer):
        """Test analyzer initializes with correct defaults."""
        assert analyzer.window_size == 20
        assert len(analyzer.red_numbers) == 18
        assert len(analyzer.black_numbers) == 18
        assert 0 not in analyzer.red_numbers
        assert 0 not in analyzer.black_numbers
    
    def test_extract_features_valid_input(self, analyzer, valid_history):
        """Test feature extraction with valid input."""
        features = analyzer.extract_features(valid_history)
        
        assert isinstance(features, np.ndarray)
        assert features.ndim == 1
        assert len(features) > 0
        assert np.all(np.isfinite(features))
    
    def test_extract_features_insufficient_history(self, analyzer):
        """Test feature extraction fails with insufficient data."""
        short_history = [1, 2, 3, 4, 5]
        
        with pytest.raises(ValueError, match="Need at least"):
            analyzer.extract_features(short_history)
    
    def test_extract_features_invalid_numbers(self, analyzer, valid_history):
        """Test feature extraction fails with invalid numbers."""
        invalid_history = valid_history + [37]  # Invalid number
        
        with pytest.raises(ValueError, match="must be between 0 and 36"):
            analyzer.extract_features(invalid_history)
    
    def test_analyze_patterns(self, analyzer, valid_history):
        """Test pattern analysis returns expected structure."""
        result = analyzer.analyze_patterns(valid_history)
        
        assert 'hot_numbers' in result
        assert 'cold_numbers' in result
        assert 'color_distribution' in result
        assert 'recent_numbers' in result
        
        assert len(result['hot_numbers']) <= 5
        assert len(result['cold_numbers']) <= 5
        assert len(result['recent_numbers']) == 5
    
    def test_color_distribution(self, analyzer):
        """Test color distribution calculation."""
        # All red numbers
        red_history = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19,
                       21, 23, 25, 27, 30, 32, 34, 36, 1, 3]
        
        result = analyzer.analyze_patterns(red_history)
        
        assert result['color_distribution']['red'] > 0
        assert result['color_distribution']['black'] == 0
        assert result['color_distribution']['green'] == 0


class TestRoulettePredictor:
    """Test suite for ML predictor."""
    
    @pytest.fixture
    def predictor(self):
        """Create predictor instance."""
        return RoulettePredictor(window_size=20, n_estimators=10)
    
    @pytest.fixture
    def training_data(self):
        """Generate training data."""
        np.random.seed(42)
        return list(np.random.randint(0, 37, size=200))
    
    def test_initialization(self, predictor):
        """Test predictor initializes correctly."""
        assert predictor.window_size == 20
        assert predictor.is_trained is False
        assert predictor.model is not None
    
    def test_train_with_valid_data(self, predictor, training_data):
        """Test training with sufficient data."""
        metrics = predictor.train(training_data)
        
        assert predictor.is_trained is True
        assert 'train_accuracy' in metrics
        assert 'validation_accuracy' in metrics
        assert 0 <= metrics['train_accuracy'] <= 1
        assert 0 <= metrics['validation_accuracy'] <= 1
    
    def test_train_with_insufficient_data(self, predictor):
        """Test training fails with insufficient data."""
        short_data = [1, 2, 3, 4, 5]
        
        with pytest.raises(ValueError, match="Need more historical data"):
            predictor.train(short_data)
    
    def test_predict_before_training(self, predictor, training_data):
        """Test prediction fails before training."""
        with pytest.raises(RuntimeError, match="must be trained"):
            predictor.predict(training_data[:20])
    
    def test_predict_returns_valid_output(self, predictor, training_data):
        """Test prediction returns valid output."""
        predictor.train(training_data)
        number, confidence, top_k = predictor.predict(training_data[:20])
        
        # Validate prediction
        assert isinstance(number, int)
        assert 0 <= number <= 36
        
        # Validate confidence
        assert isinstance(confidence, float)
        assert 0 <= confidence <= 1
        
        # Validate top_k
        assert len(top_k) == 3
        assert all(isinstance(n, int) and isinstance(c, float) 
                  for n, c in top_k)
    
    def test_model_persistence(self, predictor, training_data, tmp_path):
        """Test model save and load."""
        # Train and save
        predictor.train(training_data)
        model_path = tmp_path / "model.pkl"
        predictor.save(model_path)
        
        assert model_path.exists()
        
        # Load and verify
        loaded_predictor = RoulettePredictor.load(model_path)
        
        assert loaded_predictor.is_trained is True
        assert loaded_predictor.window_size == predictor.window_size
        
        # Verify predictions match
        history = training_data[:20]
        pred1 = predictor.predict(history)
        pred2 = loaded_predictor.predict(history)
        
        assert pred1[0] == pred2[0]  # Same prediction
    
    @pytest.mark.parametrize("window_size", [10, 20, 30])
    def test_different_window_sizes(self, window_size, training_data):
        """Test predictor with different window sizes."""
        predictor = RoulettePredictor(window_size=window_size)
        predictor.train(training_data)
        
        assert predictor.is_trained is True
    
    def test_prediction_performance(self, predictor, training_data):
        """Test prediction latency meets requirements."""
        import time
        
        predictor.train(training_data)
        history = training_data[:20]
        
        # Warmup
        predictor.predict(history)
        
        # Measure latency
        latencies = []
        for _ in range(100):
            start = time.time()
            predictor.predict(history)
            latency = time.time() - start
            latencies.append(latency)
        
        avg_latency = np.mean(latencies)
        p95_latency = np.percentile(latencies, 95)
        
        assert avg_latency < 0.1, f"Avg latency {avg_latency}s exceeds 100ms"
        assert p95_latency < 0.15, f"P95 latency {p95_latency}s exceeds 150ms"


class TestEdgeCases:
    """Test edge cases and error conditions."""
    
    def test_empty_history(self):
        """Test handling of empty history."""
        analyzer = RoulettePatternAnalyzer()
        
        with pytest.raises(ValueError):
            analyzer.extract_features([])
    
    def test_none_input(self):
        """Test handling of None input."""
        analyzer = RoulettePatternAnalyzer()
        
        with pytest.raises((TypeError, ValueError)):
            analyzer.extract_features(None)
    
    def test_large_history(self):
        """Test handling of very large history."""
        analyzer = RoulettePatternAnalyzer()
        large_history = list(np.random.randint(0, 37, size=10000))
        
        # Should work without issues
        features = analyzer.extract_features(large_history)
        assert features is not None
```

### Load Testing with Locust
```python
from locust import HttpUser, task, between
import random


class RouletteUser(HttpUser):
    """Simulate roulette app user behavior."""
    
    wait_time = between(1, 3)  # Wait 1-3 seconds between requests
    
    def on_start(self):
        """Login user."""
        self.client.post("/api/login", json={
            "email": f"user{random.randint(1, 1000)}@example.com"
        })
    
    @task(3)
    def get_prediction(self):
        """Request prediction (most common operation)."""
        history = [random.randint(0, 36) for _ in range(20)]
        
        self.client.post("/api/predict", json={
            "history": history
        })
    
    @task(2)
    def spin_wheel(self):
        """Spin the roulette wheel."""
        self.client.post("/api/spin")
    
    @task(1)
    def get_history(self):
        """Get spin history."""
        self.client.get("/api/history")
    
    @task(1)
    def get_stats(self):
        """Get user statistics."""
        self.client.get("/api/stats")
```

## Quality Metrics

### Code Coverage Requirements
- **Minimum**: 80% line coverage
- **Target**: 90% line coverage
- **Critical paths**: 100% coverage
- **Branch coverage**: >75%

### Test Pyramid
```
           /\
          /E2E\          10%
         /------\
        / Integ  \       20%
       /----------\
      /    Unit    \     70%
     /--------------\
```

## Testing Checklist

### Before Each PR
- ✅ All unit tests pass
- ✅ Code coverage >80%
- ✅ Integration tests pass
- ✅ No regression in existing features
- ✅ New features have tests
- ✅ Edge cases covered
- ✅ Error handling tested
- ✅ Performance tests pass
- ✅ Security scans clean
- ✅ Linters pass

### Before Release
- ✅ Full test suite passes
- ✅ E2E tests pass
- ✅ Load testing completed
- ✅ Security audit completed
- ✅ Performance benchmarks met
- ✅ Smoke tests prepared
- ✅ Rollback plan ready
- ✅ Monitoring configured
- ✅ Documentation updated

## Test Data Management

### Test Fixtures
```python
@pytest.fixture
def sample_roulette_data():
    """Provide consistent test data."""
    return {
        'history': [12, 5, 33, 0, 24, 8, 19, 31, 7, 15],
        'balance': 1000.0,
        'bet_amount': 10.0,
    }

@pytest.fixture
def mock_prediction_service():
    """Mock prediction service."""
    mock = Mock()
    mock.predict.return_value = (17, 0.75)
    return mock
```

### Data Builders
```python
class RouletteDataBuilder:
    """Builder for test data."""
    
    def __init__(self):
        self._history = []
        self._balance = 1000.0
    
    def with_history(self, history):
        self._history = history
        return self
    
    def with_balance(self, balance):
        self._balance = balance
        return self
    
    def build(self):
        return {
            'history': self._history,
            'balance': self._balance,
        }
```

## Best Practices

- ✅ Write tests first (TDD)
- ✅ Test one thing at a time
- ✅ Use descriptive test names
- ✅ Arrange-Act-Assert pattern
- ✅ Mock external dependencies
- ✅ Test edge cases
- ✅ Test error conditions
- ✅ Clean up resources
- ✅ Avoid test interdependencies
- ✅ Keep tests fast
