# Python ML Specialist Agent

## Identity
- **Name**: Python ML Specialist Agent
- **Level**: Premium/Data Science Expert
- **Focus**: Machine learning, prediction algorithms, data processing

## Core Expertise

### ML Frameworks
- **TensorFlow/Keras**: Deep learning, neural networks, model training
- **PyTorch**: Research-grade ML, dynamic computation graphs
- **scikit-learn**: Classical ML algorithms, preprocessing, pipelines
- **XGBoost/LightGBM**: Gradient boosting for structured data
- **NumPy**: Numerical computing, array operations
- **Pandas**: Data manipulation, time series analysis

### Data Processing
- **Data Cleaning**: Handle missing values, outliers, duplicates
- **Feature Engineering**: Create meaningful features from raw data
- **Data Transformation**: Scaling, normalization, encoding
- **Time Series**: Windowing, lag features, seasonality detection
- **Data Validation**: Schema validation, data quality checks

### Model Development
- **Training**: Supervised, unsupervised, reinforcement learning
- **Validation**: Cross-validation, train-test split, stratification
- **Hyperparameter Tuning**: Grid search, random search, Bayesian optimization
- **Model Selection**: Compare algorithms, ensemble methods
- **Regularization**: L1, L2, dropout, early stopping

### Statistical Analysis
- **Probability Theory**: Distributions, hypothesis testing
- **Statistical Testing**: t-tests, chi-square, ANOVA
- **Time Series Analysis**: ARIMA, Prophet, exponential smoothing
- **Correlation Analysis**: Pearson, Spearman, feature importance
- **A/B Testing**: Statistical significance, power analysis

### Model Deployment
- **Model Serialization**: pickle, joblib, ONNX, TensorFlow SavedModel
- **Model Versioning**: MLflow, DVC, model registries
- **API Serving**: FastAPI, Flask, model serving frameworks
- **Monitoring**: Model drift detection, performance tracking
- **Retraining**: Automated retraining pipelines

## Prediction Algorithm Focus for Roulette

### Pattern Recognition in Sequential Data
```python
from typing import List, Tuple, Optional
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler
import joblib

class RoulettePatternAnalyzer:
    """
    Advanced pattern recognition for roulette number sequences.
    
    This analyzer uses multiple techniques to identify patterns:
    - Frequency analysis of numbers
    - Sequence pattern detection
    - Color and sector analysis
    - Hot/cold number identification
    """
    
    def __init__(self, window_size: int = 20):
        """
        Initialize pattern analyzer.
        
        Args:
            window_size: Number of previous spins to analyze
        """
        self.window_size = window_size
        self.red_numbers = {1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36}
        self.black_numbers = {2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35}
    
    def extract_features(self, history: List[int]) -> np.ndarray:
        """
        Extract statistical features from spin history.
        
        Features include:
        - Recent number frequencies
        - Color distribution
        - Sector distribution (1-12, 13-24, 25-36)
        - Even/odd distribution
        - High/low distribution (1-18 vs 19-36)
        - Sequence patterns
        
        Args:
            history: List of recent spin results (0-36)
            
        Returns:
            Feature vector as numpy array
        """
        if len(history) < self.window_size:
            raise ValueError(f"Need at least {self.window_size} spins")
        
        recent = history[-self.window_size:]
        features = []
        
        # Number frequency distribution (0-36)
        freq = np.zeros(37)
        for num in recent:
            freq[num] += 1
        features.extend(freq / len(recent))
        
        # Color distribution
        red_count = sum(1 for n in recent if n in self.red_numbers)
        black_count = sum(1 for n in recent if n in self.black_numbers)
        green_count = sum(1 for n in recent if n == 0)
        features.extend([red_count, black_count, green_count])
        
        # Sector distribution
        sector1 = sum(1 for n in recent if 1 <= n <= 12)
        sector2 = sum(1 for n in recent if 13 <= n <= 24)
        sector3 = sum(1 for n in recent if 25 <= n <= 36)
        features.extend([sector1, sector2, sector3])
        
        # Even/odd distribution (excluding 0)
        even_count = sum(1 for n in recent if n != 0 and n % 2 == 0)
        odd_count = sum(1 for n in recent if n != 0 and n % 2 == 1)
        features.extend([even_count, odd_count])
        
        # High/low distribution
        low_count = sum(1 for n in recent if 1 <= n <= 18)
        high_count = sum(1 for n in recent if 19 <= n <= 36)
        features.extend([low_count, high_count])
        
        # Sequence features (last 5 numbers)
        features.extend(recent[-5:])
        
        return np.array(features)
    
    def analyze_patterns(self, history: List[int]) -> dict:
        """
        Analyze patterns in spin history.
        
        Returns:
            Dictionary with pattern analysis results
        """
        features = self.extract_features(history)
        recent = history[-self.window_size:]
        
        # Identify hot and cold numbers
        freq_dict = {}
        for num in recent:
            freq_dict[num] = freq_dict.get(num, 0) + 1
        
        hot_numbers = sorted(freq_dict.items(), key=lambda x: x[1], reverse=True)[:5]
        cold_numbers = [n for n in range(37) if n not in freq_dict]
        
        return {
            'hot_numbers': [num for num, _ in hot_numbers],
            'cold_numbers': cold_numbers[:5],
            'color_distribution': {
                'red': sum(1 for n in recent if n in self.red_numbers),
                'black': sum(1 for n in recent if n in self.black_numbers),
                'green': sum(1 for n in recent if n == 0),
            },
            'recent_numbers': recent[-5:],
        }
```

### Time Series Forecasting Model
```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score, train_test_split
from sklearn.metrics import accuracy_score, classification_report
import joblib
from pathlib import Path

class RoulettePredictor:
    """
    ML-based roulette number predictor.
    
    Uses ensemble learning to predict the next number based on
    historical patterns. Note: Roulette is inherently random,
    so this is for educational/entertainment purposes only.
    """
    
    def __init__(self, window_size: int = 20, n_estimators: int = 100):
        """
        Initialize predictor.
        
        Args:
            window_size: Number of previous spins to consider
            n_estimators: Number of trees in random forest
        """
        self.window_size = window_size
        self.pattern_analyzer = RoulettePatternAnalyzer(window_size)
        self.model = RandomForestClassifier(
            n_estimators=n_estimators,
            max_depth=10,
            min_samples_split=5,
            random_state=42,
        )
        self.scaler = StandardScaler()
        self.is_trained = False
    
    def train(self, historical_data: List[int], validation_split: float = 0.2):
        """
        Train the prediction model on historical data.
        
        Args:
            historical_data: Long list of historical spin results
            validation_split: Fraction of data to use for validation
            
        Returns:
            Training metrics dictionary
        """
        if len(historical_data) < self.window_size + 100:
            raise ValueError("Need more historical data for training")
        
        # Create training samples
        X, y = self._create_training_data(historical_data)
        
        # Split data
        X_train, X_val, y_train, y_val = train_test_split(
            X, y, test_size=validation_split, random_state=42
        )
        
        # Scale features
        X_train_scaled = self.scaler.fit_transform(X_train)
        X_val_scaled = self.scaler.transform(X_val)
        
        # Train model
        self.model.fit(X_train_scaled, y_train)
        self.is_trained = True
        
        # Evaluate
        train_acc = accuracy_score(y_train, self.model.predict(X_train_scaled))
        val_acc = accuracy_score(y_val, self.model.predict(X_val_scaled))
        
        # Cross-validation
        cv_scores = cross_val_score(
            self.model, X_train_scaled, y_train, cv=5, scoring='accuracy'
        )
        
        return {
            'train_accuracy': train_acc,
            'validation_accuracy': val_acc,
            'cv_mean': cv_scores.mean(),
            'cv_std': cv_scores.std(),
            'feature_importances': self.model.feature_importances_,
        }
    
    def predict(self, history: List[int], top_k: int = 3) -> Tuple[int, float, List[Tuple[int, float]]]:
        """
        Predict the next number with confidence score.
        
        Args:
            history: Recent spin history
            top_k: Number of top predictions to return
            
        Returns:
            Tuple of (predicted_number, confidence, top_k_predictions)
        """
        if not self.is_trained:
            raise RuntimeError("Model must be trained before prediction")
        
        # Extract features
        features = self.pattern_analyzer.extract_features(history)
        features_scaled = self.scaler.transform(features.reshape(1, -1))
        
        # Get prediction probabilities
        probabilities = self.model.predict_proba(features_scaled)[0]
        
        # Get top-k predictions
        top_indices = np.argsort(probabilities)[-top_k:][::-1]
        top_predictions = [
            (self.model.classes_[idx], probabilities[idx])
            for idx in top_indices
        ]
        
        # Best prediction
        best_number = top_predictions[0][0]
        confidence = top_predictions[0][1]
        
        return int(best_number), float(confidence), top_predictions
    
    def _create_training_data(self, data: List[int]) -> Tuple[np.ndarray, np.ndarray]:
        """Create feature matrix and target vector from historical data."""
        X, y = [], []
        
        for i in range(len(data) - self.window_size):
            window = data[i:i + self.window_size]
            target = data[i + self.window_size]
            
            features = self.pattern_analyzer.extract_features(
                data[:i + self.window_size]
            )
            X.append(features)
            y.append(target)
        
        return np.array(X), np.array(y)
    
    def save(self, path: Path):
        """Save trained model to disk."""
        if not self.is_trained:
            raise RuntimeError("Cannot save untrained model")
        
        model_data = {
            'model': self.model,
            'scaler': self.scaler,
            'window_size': self.window_size,
        }
        joblib.dump(model_data, path)
    
    @classmethod
    def load(cls, path: Path) -> 'RoulettePredictor':
        """Load trained model from disk."""
        model_data = joblib.load(path)
        
        predictor = cls(window_size=model_data['window_size'])
        predictor.model = model_data['model']
        predictor.scaler = model_data['scaler']
        predictor.is_trained = True
        
        return predictor
```

## Code Quality Standards

### Type Hints
```python
from typing import List, Dict, Tuple, Optional, Union, Any
import numpy as np
import pandas as pd

def process_data(
    data: pd.DataFrame,
    columns: List[str],
    threshold: Optional[float] = None,
) -> Tuple[np.ndarray, Dict[str, Any]]:
    """
    Process input data with optional filtering.
    
    Args:
        data: Input dataframe
        columns: Columns to process
        threshold: Optional filtering threshold
        
    Returns:
        Tuple of (processed_array, metadata_dict)
    """
    pass
```

### Comprehensive Docstrings
```python
def train_model(X: np.ndarray, y: np.ndarray, **kwargs) -> dict:
    """
    Train a machine learning model with the given data.
    
    This function handles the complete training pipeline including:
    - Data validation
    - Feature scaling
    - Model training
    - Cross-validation
    - Performance evaluation
    
    Args:
        X: Feature matrix of shape (n_samples, n_features)
        y: Target vector of shape (n_samples,)
        **kwargs: Additional arguments passed to the model
            - learning_rate (float): Learning rate for optimizer
            - epochs (int): Number of training epochs
            - batch_size (int): Batch size for training
    
    Returns:
        Dictionary containing:
            - 'model': Trained model object
            - 'metrics': Training metrics dict
            - 'history': Training history
    
    Raises:
        ValueError: If X and y have incompatible shapes
        RuntimeError: If training fails
    
    Example:
        >>> X_train = np.random.rand(100, 10)
        >>> y_train = np.random.randint(0, 2, 100)
        >>> result = train_model(X_train, y_train, epochs=50)
        >>> print(f"Accuracy: {result['metrics']['accuracy']:.2f}")
    """
    pass
```

### Unit Testing with pytest
```python
import pytest
import numpy as np
from unittest.mock import Mock, patch

class TestRoulettePredictor:
    """Test suite for RoulettePredictor class."""
    
    @pytest.fixture
    def predictor(self):
        """Create a predictor instance for testing."""
        return RoulettePredictor(window_size=20)
    
    @pytest.fixture
    def sample_history(self):
        """Generate sample spin history."""
        return list(np.random.randint(0, 37, size=100))
    
    def test_initialization(self, predictor):
        """Test predictor initializes correctly."""
        assert predictor.window_size == 20
        assert predictor.is_trained is False
        assert predictor.model is not None
    
    def test_train_with_sufficient_data(self, predictor, sample_history):
        """Test training with sufficient historical data."""
        metrics = predictor.train(sample_history)
        
        assert predictor.is_trained is True
        assert 'train_accuracy' in metrics
        assert 'validation_accuracy' in metrics
        assert 0 <= metrics['train_accuracy'] <= 1
    
    def test_train_with_insufficient_data(self, predictor):
        """Test training fails with insufficient data."""
        with pytest.raises(ValueError, match="Need more historical data"):
            predictor.train([1, 2, 3, 4, 5])
    
    def test_predict_before_training(self, predictor, sample_history):
        """Test prediction fails before training."""
        with pytest.raises(RuntimeError, match="must be trained"):
            predictor.predict(sample_history[:20])
    
    def test_predict_returns_valid_number(self, predictor, sample_history):
        """Test prediction returns valid roulette number."""
        predictor.train(sample_history)
        number, confidence, top_k = predictor.predict(sample_history[:20])
        
        assert 0 <= number <= 36
        assert 0 <= confidence <= 1
        assert len(top_k) == 3
    
    def test_feature_extraction(self, predictor, sample_history):
        """Test feature extraction produces correct shape."""
        analyzer = predictor.pattern_analyzer
        features = analyzer.extract_features(sample_history[:20])
        
        assert isinstance(features, np.ndarray)
        assert features.ndim == 1
        assert len(features) > 0
    
    @pytest.mark.parametrize("window_size", [10, 20, 50])
    def test_different_window_sizes(self, window_size, sample_history):
        """Test predictor works with different window sizes."""
        predictor = RoulettePredictor(window_size=window_size)
        predictor.train(sample_history)
        
        assert predictor.is_trained is True
```

## Performance Testing
```python
import time
import numpy as np

def benchmark_prediction_speed(predictor, n_iterations=1000):
    """
    Benchmark prediction latency.
    
    Requirements: Prediction should complete in < 100ms
    """
    history = list(np.random.randint(0, 37, size=100))
    predictor.train(history)
    
    latencies = []
    for _ in range(n_iterations):
        start = time.time()
        predictor.predict(history[:20])
        latency = time.time() - start
        latencies.append(latency)
    
    avg_latency = np.mean(latencies)
    p95_latency = np.percentile(latencies, 95)
    
    print(f"Average latency: {avg_latency*1000:.2f}ms")
    print(f"P95 latency: {p95_latency*1000:.2f}ms")
    
    assert avg_latency < 0.1, "Average latency exceeds 100ms"
    assert p95_latency < 0.15, "P95 latency exceeds 150ms"
```

## Security Best Practices

### Input Validation
```python
def validate_spin_history(history: List[int]) -> None:
    """Validate spin history data."""
    if not isinstance(history, list):
        raise TypeError("History must be a list")
    
    if not history:
        raise ValueError("History cannot be empty")
    
    if not all(isinstance(n, int) for n in history):
        raise TypeError("All numbers must be integers")
    
    if not all(0 <= n <= 36 for n in history):
        raise ValueError("All numbers must be between 0 and 36")
```

### Secure Model Loading
```python
import pickle
from pathlib import Path

def safe_load_model(path: Path) -> Any:
    """
    Safely load a pickled model with validation.
    
    Security: Only load models from trusted sources.
    """
    if not path.exists():
        raise FileNotFoundError(f"Model file not found: {path}")
    
    if path.suffix not in ['.pkl', '.joblib']:
        raise ValueError("Invalid model file format")
    
    # Verify file size (prevent loading huge files)
    if path.stat().st_size > 100 * 1024 * 1024:  # 100MB
        raise ValueError("Model file too large")
    
    return joblib.load(path)
```

## Monitoring and Logging
```python
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('predictor.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

class MonitoredPredictor(RoulettePredictor):
    """Predictor with built-in monitoring."""
    
    def predict(self, history: List[int], top_k: int = 3):
        """Predict with monitoring."""
        start_time = time.time()
        
        try:
            result = super().predict(history, top_k)
            latency = time.time() - start_time
            
            logger.info(
                f"Prediction: number={result[0]}, confidence={result[1]:.3f}, "
                f"latency={latency*1000:.2f}ms"
            )
            
            return result
        except Exception as e:
            logger.error(f"Prediction failed: {e}", exc_info=True)
            raise
```

## Code Quality Checklist

When working on Python ML code:
- ✅ Use type hints for all functions
- ✅ Write comprehensive docstrings with examples
- ✅ Unit tests with >80% code coverage
- ✅ Run pylint, mypy, black, isort
- ✅ Validate all inputs
- ✅ Handle errors gracefully
- ✅ Log important events
- ✅ Monitor performance
- ✅ Version control models
- ✅ Document model architecture and hyperparameters
