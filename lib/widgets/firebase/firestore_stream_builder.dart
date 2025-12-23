import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Builder genérico para streams de Firestore
/// 
/// Facilita la construcción de widgets que escuchan cambios en tiempo real
class FirestoreStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  const FirestoreStreamBuilder({
    super.key,
    required this.stream,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        // Mostrar loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingBuilder?.call(context) ??
              const Center(child: CircularProgressIndicator());
        }

        // Mostrar error
        if (snapshot.hasError) {
          return errorBuilder?.call(context, snapshot.error!) ??
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
        }

        // Verificar si hay datos
        if (!snapshot.hasData) {
          return emptyBuilder?.call(context) ??
              const Center(child: Text('No hay datos'));
        }

        // Construir con datos
        return builder(context, snapshot.data as T);
      },
    );
  }
}

/// Builder específico para lista de documentos de Firestore
class FirestoreListBuilder<T> extends StatelessWidget {
  final Stream<List<T>> stream;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final Widget? separator;

  const FirestoreListBuilder({
    super.key,
    required this.stream,
    required this.itemBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    return FirestoreStreamBuilder<List<T>>(
      stream: stream,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      emptyBuilder: emptyBuilder,
      builder: (context, items) {
        if (items.isEmpty) {
          return emptyBuilder?.call(context) ??
              const Center(
                child: Text('No hay elementos'),
              );
        }

        if (separator != null) {
          return ListView.separated(
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            itemCount: items.length,
            separatorBuilder: (context, index) => separator!,
            itemBuilder: (context, index) {
              return itemBuilder(context, items[index], index);
            },
          );
        }

        return ListView.builder(
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return itemBuilder(context, items[index], index);
          },
        );
      },
    );
  }
}

/// Builder específico para grid de documentos de Firestore
class FirestoreGridBuilder<T> extends StatelessWidget {
  final Stream<List<T>> stream;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  const FirestoreGridBuilder({
    super.key,
    required this.stream,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return FirestoreStreamBuilder<List<T>>(
      stream: stream,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      emptyBuilder: emptyBuilder,
      builder: (context, items) {
        if (items.isEmpty) {
          return emptyBuilder?.call(context) ??
              const Center(
                child: Text('No hay elementos'),
              );
        }

        return GridView.builder(
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return itemBuilder(context, items[index], index);
          },
        );
      },
    );
  }
}

/// Builder para documento único de Firestore
class FirestoreDocumentBuilder<T> extends StatelessWidget {
  final Stream<T?> stream;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final Widget Function(BuildContext context)? notFoundBuilder;

  const FirestoreDocumentBuilder({
    super.key,
    required this.stream,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.notFoundBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FirestoreStreamBuilder<T?>(
      stream: stream,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      emptyBuilder: notFoundBuilder,
      builder: (context, data) {
        if (data == null) {
          return notFoundBuilder?.call(context) ??
              const Center(
                child: Text('Documento no encontrado'),
              );
        }

        return builder(context, data);
      },
    );
  }
}

/// Widget auxiliar para mostrar estado de carga
class FirestoreLoadingWidget extends StatelessWidget {
  final String? message;

  const FirestoreLoadingWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!),
          ],
        ],
      ),
    );
  }
}

/// Widget auxiliar para mostrar estado vacío
class FirestoreEmptyWidget extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final VoidCallback? onRetry;

  const FirestoreEmptyWidget({
    super.key,
    this.message,
    this.icon,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'No hay datos',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget auxiliar para mostrar errores
class FirestoreErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const FirestoreErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Ocurrió un error',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Utilidad para convertir QuerySnapshot a lista tipada
extension QuerySnapshotExtension on QuerySnapshot {
  List<Map<String, dynamic>> toMapList() {
    return docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }
}
