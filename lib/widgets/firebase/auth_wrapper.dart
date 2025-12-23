import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

/// Wrapper que maneja el estado de autenticación
/// 
/// Muestra diferentes widgets según el estado de autenticación:
/// - Usuario autenticado -> homeBuilder
/// - Usuario no autenticado -> authBuilder
/// - Cargando -> loadingBuilder
class AuthWrapper extends StatelessWidget {
  final Widget Function(BuildContext context, User user) homeBuilder;
  final Widget Function(BuildContext context) authBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final AuthService authService;

  const AuthWrapper({
    super.key,
    required this.homeBuilder,
    required this.authBuilder,
    required this.authService,
    this.loadingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Mostrar loading mientras se determina el estado
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingBuilder?.call(context) ??
              const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
        }

        // Si hay error, mostrar pantalla de autenticación
        if (snapshot.hasError) {
          debugPrint('Error en auth stream: ${snapshot.error}');
          return authBuilder(context);
        }

        // Si hay usuario, mostrar home
        if (snapshot.hasData && snapshot.data != null) {
          return homeBuilder(context, snapshot.data!);
        }

        // Si no hay usuario, mostrar auth
        return authBuilder(context);
      },
    );
  }
}

/// Widget más simple que solo verifica si hay usuario autenticado
class SimpleAuthWrapper extends StatelessWidget {
  final Widget home;
  final Widget auth;
  final AuthService authService;

  const SimpleAuthWrapper({
    super.key,
    required this.home,
    required this.auth,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      authService: authService,
      homeBuilder: (context, user) => home,
      authBuilder: (context) => auth,
    );
  }
}

/// Widget que requiere autenticación verificada
/// 
/// Muestra contenido solo si el usuario está autenticado y verificado
class RequireAuth extends StatelessWidget {
  final Widget child;
  final Widget Function(BuildContext context)? authBuilder;
  final bool requireEmailVerification;
  final AuthService authService;

  const RequireAuth({
    super.key,
    required this.child,
    required this.authService,
    this.authBuilder,
    this.requireEmailVerification = false,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;

        // Si no hay usuario, mostrar pantalla de auth o redirigir
        if (user == null) {
          return authBuilder?.call(context) ??
              Scaffold(
                appBar: AppBar(title: const Text('Autenticación requerida')),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Debes iniciar sesión para ver este contenido',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          // Navegar a pantalla de login
                          // Navigator.pushNamed(context, '/login');
                        },
                        child: const Text('Iniciar sesión'),
                      ),
                    ],
                  ),
                ),
              );
        }

        // Si se requiere verificación de email y no está verificado
        if (requireEmailVerification && !user.emailVerified) {
          return Scaffold(
            appBar: AppBar(title: const Text('Verificación requerida')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.mark_email_unread, size: 64, color: Colors.orange),
                    const SizedBox(height: 16),
                    const Text(
                      'Por favor verifica tu email',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hemos enviado un email de verificación a ${user.email}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await authService.sendEmailVerification();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email de verificación enviado'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.email),
                      label: const Text('Reenviar email'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () async {
                        await authService.reloadUser();
                      },
                      child: const Text('Ya verifiqué mi email'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Usuario autenticado y verificado, mostrar contenido
        return child;
      },
    );
  }
}

/// Widget que muestra información del usuario actual
class CurrentUserInfo extends StatelessWidget {
  final AuthService authService;

  const CurrentUserInfo({
    super.key,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (user == null) {
          return const Text('No autenticado');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              user.displayName ?? user.email ?? 'Usuario',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (user.email != null && user.displayName != null)
              Text(
                user.email!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            if (!user.emailVerified && user.email != null)
              const Row(
                children: [
                  Icon(Icons.warning, size: 12, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    'Email no verificado',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

/// Widget que oculta contenido si no hay autenticación
class AuthGuard extends StatelessWidget {
  final Widget child;
  final Widget? placeholder;
  final AuthService authService;

  const AuthGuard({
    super.key,
    required this.child,
    required this.authService,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return child;
        }

        return placeholder ?? const SizedBox.shrink();
      },
    );
  }
}
