# ⚡ Performance Optimization Guide

Best practices and techniques for optimizing Tokyo Roulette Predicciones performance.

## 📋 Table of Contents

- [Build Optimization](#build-optimization)
- [Runtime Performance](#runtime-performance)
- [Memory Management](#memory-management)
- [Image and Asset Optimization](#image-and-asset-optimization)
- [Network Optimization](#network-optimization)
- [Caching Strategies](#caching-strategies)
- [Profiling Tools](#profiling-tools)

## 🔨 Build Optimization

### Release Build Configuration

**Enable optimizations:**
```bash
# Build with tree-shake-icons (removes unused icons)
flutter build apk --release --tree-shake-icons

# Obfuscate code (harder to reverse engineer)
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Shrink resources
flutter build apk --release --shrink
```

**Analyze app size:**
```bash
flutter build apk --analyze-size --target-platform android-arm64
```

### Reduce App Size

**1. Remove unused dependencies:**
```yaml
# pubspec.yaml - only include what you need
dependencies:
  flutter:
    sdk: flutter
  # Add only required packages
```

**2. Use split APKs:**
```bash
flutter build apk --split-per-abi
# Reduces size by ~30%
```

**3. Use App Bundle:**
```bash
flutter build appbundle
# Play Store generates optimized APKs per device
```

**4. Minimize asset sizes:**
```bash
# Optimize images before adding to project
# Use WebP format where possible
# Remove unused assets
```

## 🏃 Runtime Performance

### Widget Build Optimization

**Use const constructors:**
```dart
// ✅ Good - const widgets aren't rebuilt
const Text('Static text')
const SizedBox(height: 16)
const Icon(Icons.casino)

// ❌ Bad - rebuilt on every parent rebuild
Text('Static text')
SizedBox(height: 16)
Icon(Icons.casino)
```

**Extract widgets strategically:**
```dart
// ✅ Good - expensive widget only rebuilds when needed
class ExpensiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ComplexCalculation();
  }
}

// ❌ Bad - rebuilds with every setState
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      ComplexCalculation(),  // Rebuilt unnecessarily
    ],
  );
}
```

**Use ListView.builder for long lists:**
```dart
// ✅ Good - only builds visible items
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// ❌ Bad - builds all items upfront
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)
```

**Avoid expensive operations in build:**
```dart
// ✅ Good - calculation done once in initState
@override
void initState() {
  super.initState();
  _expensiveResult = calculateSomething();
}

// ❌ Bad - recalculated on every build
@override
Widget build(BuildContext context) {
  final result = calculateSomething();  // Expensive!
  return Text('$result');
}
```

### Animation Performance

**Use RepaintBoundary:**
```dart
// Isolate expensive repaints
RepaintBoundary(
  child: AnimatedWidget(),
)
```

**Optimize animations:**
```dart
// ✅ Use built-in animations
AnimatedOpacity(
  opacity: _visible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 300),
  child: MyWidget(),
)

// ✅ Use AnimatedBuilder for complex animations
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: child,
    );
  },
  child: ExpensiveWidget(),  // Only built once
)
```

### State Management Performance

**Minimize setState scope:**
```dart
// ✅ Good - only rebuilds necessary widgets
setState(() {
  _counter++;  // Only updates counter widget
});

// ❌ Bad - rebuilds entire screen
setState(() {
  _counter++;
  _entireAppState = newState;  // Too much!
});
```

**Use Provider/Riverpod for shared state:**
```dart
// Avoids prop drilling and unnecessary rebuilds
context.watch<GameState>().balance  // Only rebuilds when balance changes
```

## 💾 Memory Management

### Dispose Resources

**Always dispose controllers:**
```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _controller = TextEditingController();
  final _animController = AnimationController(vsync: this);
  
  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

**Cancel streams and subscriptions:**
```dart
StreamSubscription? _subscription;

@override
void initState() {
  super.initState();
  _subscription = someStream.listen((data) {
    // Handle data
  });
}

@override
void dispose() {
  _subscription?.cancel();
  super.dispose();
}
```

### Limit History Size

**Current implementation (good):**
```dart
void addToHistory(int number) {
  _history.add(number);
  if (_history.length > 20) {  // Limit to 20 items
    _history.removeAt(0);
  }
}
```

### Avoid Memory Leaks

**Check mounted before setState:**
```dart
Future<void> loadData() async {
  final data = await fetchData();
  
  if (mounted) {  // Check widget is still in tree
    setState(() {
      _data = data;
    });
  }
}
```

## 🖼️ Image and Asset Optimization

### Image Best Practices

**Use appropriate formats:**
- **PNG**: Transparency, simple graphics
- **JPEG**: Photos (no transparency)
- **WebP**: Best compression, supports transparency

**Optimize image sizes:**
```bash
# Compress images
# macOS: use ImageOptim
# Linux: optipng, jpegoptim
# Online: tinypng.com

# Convert to WebP
cwebp input.png -o output.webp -q 80
```

**Provide multiple resolutions:**
```
assets/
  images/
    logo.png      # 1x
    2.0x/
      logo.png    # 2x
    3.0x/
      logo.png    # 3x
```

### Asset Loading

**Use AssetImage for local images:**
```dart
// ✅ Efficient
Image.asset('assets/images/logo.png')

// Or with explicit AssetImage
Image(image: AssetImage('assets/images/logo.png'))
```

**Cache network images:**
```dart
// Use cached_network_image package
CachedNetworkImage(
  imageUrl: 'https://example.com/image.png',
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

## 🌐 Network Optimization

### Efficient API Calls

**Batch requests:**
```dart
// ✅ Good - single request
final results = await Future.wait([
  api.getUser(),
  api.getHistory(),
  api.getStats(),
]);

// ❌ Bad - sequential requests
final user = await api.getUser();
final history = await api.getHistory();
final stats = await api.getStats();
```

**Implement timeouts:**
```dart
try {
  final response = await http.get(url).timeout(
    Duration(seconds: 10),
    onTimeout: () => throw TimeoutException('Request timeout'),
  );
} catch (e) {
  // Handle error
}
```

**Cancel unnecessary requests:**
```dart
Dio dio = Dio();
CancelToken cancelToken = CancelToken();

// Make request
dio.get(url, cancelToken: cancelToken);

// Cancel if needed (e.g., user navigates away)
cancelToken.cancel('User cancelled');
```

### Firebase Optimization

**Use Firebase indexes:**
```javascript
// firestore.indexes.json
{
  "indexes": [
    {
      "collectionGroup": "users",
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "created_at", "order": "DESCENDING"}
      ]
    }
  ]
}
```

**Limit query results:**
```dart
// ✅ Good - only fetch what you need
firestore.collection('users')
  .limit(20)
  .orderBy('created_at', descending: true)
  .get();

// ❌ Bad - fetches everything
firestore.collection('users').get();
```

## 💿 Caching Strategies

### Local Data Caching

**Use SharedPreferences for simple data:**
```dart
import 'package:shared_preferences/shared_preferences.dart';

// Save
final prefs = await SharedPreferences.getInstance();
await prefs.setDouble('balance', balance);
await prefs.setStringList('history', history.map((e) => e.toString()).toList());

// Load
final balance = prefs.getDouble('balance') ?? 1000.0;
final history = prefs.getStringList('history')
    ?.map((e) => int.parse(e))
    .toList() ?? [];
```

**Use Hive for complex data:**
```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

```dart
// Initialize
await Hive.initFlutter();

// Store
final box = await Hive.openBox('gameData');
await box.put('balance', balance);
await box.put('history', history);

// Retrieve
final balance = box.get('balance', defaultValue: 1000.0);
final history = box.get('history', defaultValue: []);
```

### Cache Invalidation

**Time-based expiration:**
```dart
class CacheEntry<T> {
  final T data;
  final DateTime timestamp;
  final Duration ttl;
  
  CacheEntry(this.data, this.ttl) : timestamp = DateTime.now();
  
  bool get isExpired => DateTime.now().difference(timestamp) > ttl;
}

// Usage
final cache = <String, CacheEntry>{};

Future<User> getUser(String id) async {
  if (cache.containsKey(id) && !cache[id]!.isExpired) {
    return cache[id]!.data;
  }
  
  final user = await api.fetchUser(id);
  cache[id] = CacheEntry(user, Duration(minutes: 5));
  return user;
}
```

## 🔍 Profiling Tools

### Flutter DevTools

**Launch DevTools:**
```bash
# Start app in profile mode
flutter run --profile

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

**Key Features:**
- **Performance overlay**: Shows frame rate
- **Timeline**: Identifies jank
- **Memory view**: Detects memory leaks
- **Network profiler**: Monitors HTTP traffic

### Performance Overlay

**Enable in app:**
```dart
MaterialApp(
  showPerformanceOverlay: true,  // Show FPS overlay
  // ...
)

// Or toggle with debug key
// While running: press 'p' key
```

### Analyze Startup Time

```bash
# Profile app startup
flutter run --profile --trace-startup

# Generates timeline in build/start_up_info.json
```

### Benchmark Tests

```dart
// test/benchmarks/roulette_benchmark.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Roulette spin performance', () {
    final roulette = RouletteLogic();
    
    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 10000; i++) {
      roulette.generateSpin();
    }
    stopwatch.stop();
    
    final avgTime = stopwatch.elapsedMicroseconds / 10000;
    print('Average spin time: ${avgTime}μs');
    
    expect(avgTime, lessThan(10));  // Should be < 10 microseconds
  });
}
```

## 📊 Performance Targets

**Target Metrics:**
- Frame rate: 60 FPS (16.67ms per frame)
- App startup: <2 seconds
- Screen transition: <300ms
- API response handling: <100ms
- Memory usage: <200MB
- APK size: <30MB (uncompressed)

**Monitor with:**
- Flutter DevTools
- Firebase Performance Monitoring
- Google Analytics
- Custom metrics

## 🎯 Optimization Checklist

Before release:
- [ ] Profile mode testing
- [ ] No dropped frames in common flows
- [ ] Memory leaks checked
- [ ] Network calls optimized
- [ ] Images optimized
- [ ] Build size analyzed
- [ ] Startup time measured
- [ ] Animations smooth (60 FPS)
- [ ] No unnecessary rebuilds
- [ ] Resources properly disposed

## 📚 Additional Resources

- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Flutter Performance Profiling](https://docs.flutter.dev/perf/ui-performance)
- [Dart Performance Tips](https://dart.dev/guides/language/effective-dart/performance)

---

**Last Updated:** December 2024
