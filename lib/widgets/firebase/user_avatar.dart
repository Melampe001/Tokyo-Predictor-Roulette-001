import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

/// Widget para mostrar avatar de usuario
/// 
/// Muestra la foto de perfil del usuario o sus iniciales
class UserAvatar extends StatelessWidget {
  final User? user;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.user,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBackgroundColor = backgroundColor ?? theme.primaryColor;
    final defaultTextColor = textColor ?? Colors.white;

    // Si no hay usuario, mostrar avatar por defecto
    if (user == null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.person,
          size: radius,
          color: Colors.white,
        ),
      );
    }

    final widget = CircleAvatar(
      radius: radius,
      backgroundColor: defaultBackgroundColor,
      backgroundImage: user!.photoURL != null && user!.photoURL!.isNotEmpty
          ? NetworkImage(user!.photoURL!)
          : null,
      child: user!.photoURL == null || user!.photoURL!.isEmpty
          ? Text(
              _getInitials(user!),
              style: TextStyle(
                color: defaultTextColor,
                fontSize: radius * 0.6,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: widget,
      );
    }

    return widget;
  }

  String _getInitials(User user) {
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      final parts = user.displayName!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return user.displayName![0].toUpperCase();
    }

    if (user.email != null && user.email!.isNotEmpty) {
      return user.email![0].toUpperCase();
    }

    return '?';
  }
}

/// Widget para mostrar avatar con información adicional
class UserAvatarWithInfo extends StatelessWidget {
  final User? user;
  final double avatarRadius;
  final bool showEmail;
  final bool showVerificationStatus;
  final VoidCallback? onTap;
  final AuthService authService;

  const UserAvatarWithInfo({
    super.key,
    this.user,
    this.avatarRadius = 24,
    this.showEmail = true,
    this.showVerificationStatus = true,
    this.onTap,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        final currentUser = user ?? snapshot.data;

        if (currentUser == null) {
          return ListTile(
            leading: UserAvatar(
              user: null,
              radius: avatarRadius,
            ),
            title: const Text('No autenticado'),
            onTap: onTap,
          );
        }

        return ListTile(
          leading: UserAvatar(
            user: currentUser,
            radius: avatarRadius,
          ),
          title: Text(
            currentUser.displayName ?? currentUser.email ?? 'Usuario',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showEmail && currentUser.email != null && currentUser.displayName != null)
                Text(
                  currentUser.email!,
                  style: const TextStyle(fontSize: 12),
                ),
              if (showVerificationStatus && !currentUser.emailVerified && currentUser.email != null)
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
          ),
          onTap: onTap,
        );
      },
    );
  }
}

/// Widget de perfil de usuario compacto
class UserProfileCard extends StatelessWidget {
  final User? user;
  final VoidCallback? onEditProfile;
  final VoidCallback? onLogout;
  final AuthService authService;

  const UserProfileCard({
    super.key,
    this.user,
    this.onEditProfile,
    this.onLogout,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        final currentUser = user ?? snapshot.data;

        if (currentUser == null) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No autenticado'),
            ),
          );
        }

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                UserAvatar(
                  user: currentUser,
                  radius: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  currentUser.displayName ?? 'Usuario',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (currentUser.email != null)
                  Text(
                    currentUser.email!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                if (!currentUser.emailVerified && currentUser.email != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning, size: 14, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          'Email no verificado',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (onEditProfile != null)
                      TextButton.icon(
                        onPressed: onEditProfile,
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar'),
                      ),
                    if (onLogout != null)
                      TextButton.icon(
                        onPressed: onLogout,
                        icon: const Icon(Icons.logout),
                        label: const Text('Salir'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Widget de avatar que se actualiza automáticamente
class LiveUserAvatar extends StatelessWidget {
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final AuthService authService;

  const LiveUserAvatar({
    super.key,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        return UserAvatar(
          user: snapshot.data,
          radius: radius,
          backgroundColor: backgroundColor,
          textColor: textColor,
          onTap: onTap,
        );
      },
    );
  }
}

/// Widget para seleccionar/cambiar avatar
class AvatarPicker extends StatelessWidget {
  final User? user;
  final VoidCallback? onPickImage;
  final VoidCallback? onRemoveImage;
  final double radius;

  const AvatarPicker({
    super.key,
    this.user,
    this.onPickImage,
    this.onRemoveImage,
    this.radius = 60,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = user?.photoURL != null && user!.photoURL!.isNotEmpty;

    return Stack(
      children: [
        UserAvatar(
          user: user,
          radius: radius,
        ),
        if (onPickImage != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, size: 16),
                color: Colors.white,
                padding: EdgeInsets.zero,
                onPressed: onPickImage,
              ),
            ),
          ),
        if (hasPhoto && onRemoveImage != null)
          Positioned(
            top: 0,
            right: 0,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.red,
              child: IconButton(
                icon: const Icon(Icons.close, size: 12),
                color: Colors.white,
                padding: EdgeInsets.zero,
                onPressed: onRemoveImage,
              ),
            ),
          ),
      ],
    );
  }
}

/// Lista de avatares de múltiples usuarios
class UserAvatarList extends StatelessWidget {
  final List<User> users;
  final int maxDisplayed;
  final double avatarRadius;
  final double overlap;

  const UserAvatarList({
    super.key,
    required this.users,
    this.maxDisplayed = 3,
    this.avatarRadius = 16,
    this.overlap = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    final displayUsers = users.take(maxDisplayed).toList();
    final remaining = users.length - maxDisplayed;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...displayUsers.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;
          
          return Transform.translate(
            offset: Offset(-avatarRadius * overlap * index, 0),
            child: UserAvatar(
              user: user,
              radius: avatarRadius,
            ),
          );
        }),
        if (remaining > 0)
          Transform.translate(
            offset: Offset(-avatarRadius * overlap * maxDisplayed, 0),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: Colors.grey,
              child: Text(
                '+$remaining',
                style: TextStyle(
                  fontSize: avatarRadius * 0.6,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
