import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Custom button widget with Material Design 3 styling
/// Provides consistent button appearance with animations
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final padding = _getPadding();
    final textStyle = _getTextStyle(theme);

    Widget buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.primary
                    ? colorScheme.onPrimary
                    : colorScheme.primary,
              ),
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: _getIconSize()),
                  const SizedBox(width: 8),
                  Text(text, style: textStyle),
                ],
              )
            : Text(text, style: textStyle);

    Widget button;
    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            minimumSize: fullWidth ? const Size(double.infinity, 0) : null,
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            minimumSize: fullWidth ? const Size(double.infinity, 0) : null,
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: padding,
            minimumSize: fullWidth ? const Size(double.infinity, 0) : null,
          ),
          child: buttonChild,
        );
        break;
    }

    return button.animate(target: isLoading ? 1 : 0).scale(
          duration: const Duration(milliseconds: 150),
          begin: const Offset(1, 1),
          end: const Offset(0.95, 0.95),
        );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  TextStyle _getTextStyle(ThemeData theme) {
    switch (size) {
      case ButtonSize.small:
        return theme.textTheme.labelMedium!;
      case ButtonSize.medium:
        return theme.textTheme.labelLarge!;
      case ButtonSize.large:
        return theme.textTheme.titleMedium!;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 18;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }
}

enum ButtonType {
  primary,
  secondary,
  text,
}

enum ButtonSize {
  small,
  medium,
  large,
}

/// Icon button with ripple effect
class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double size;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon, size: size),
      onPressed: onPressed,
      color: color,
      tooltip: tooltip,
      constraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),
    );

    return tooltip != null
        ? Semantics(
            label: tooltip,
            button: true,
            child: button,
          )
        : button;
  }
}

/// Floating action button with custom styling
class CustomFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool extended;
  final String? label;

  const CustomFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.extended = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (extended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label!),
        tooltip: tooltip,
      ).animate().scale(
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
          );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(icon),
    ).animate().scale(
          duration: const Duration(milliseconds: 300),
          curve: Curves.elasticOut,
        );
  }
}
