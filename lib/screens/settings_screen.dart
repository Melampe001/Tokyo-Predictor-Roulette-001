import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_card.dart';
import '../utils/responsive_helper.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _soundEffects = true;
  bool _notifications = true;
  String _language = 'es';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final themeModeString = prefs.getString(AppConstants.keyThemeMode) ?? 'system';
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == 'ThemeMode.$themeModeString',
        orElse: () => ThemeMode.system,
      );
      _soundEffects = prefs.getBool(AppConstants.keySoundEffects) ?? true;
      _notifications = prefs.getBool(AppConstants.keyNotifications) ?? true;
      _language = prefs.getString(AppConstants.keyLanguage) ?? 'es';
    });
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final modeString = mode.toString().split('.').last;
    await prefs.setString(AppConstants.keyThemeMode, modeString);
    setState(() {
      _themeMode = mode;
    });
    // Note: In a real app, you'd need to notify the app to rebuild with new theme
  }

  Future<void> _saveSoundEffects(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keySoundEffects, value);
    setState(() {
      _soundEffects = value;
    });
  }

  Future<void> _saveNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyNotifications, value);
    setState(() {
      _notifications = value;
    });
  }

  Future<void> _saveLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyLanguage, value);
    setState(() {
      _language = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ResponsiveCenter(
        child: ListView(
          padding: ResponsiveHelper.responsivePadding(context),
          children: [
            // Appearance Section
            _SectionHeader(
              icon: Icons.palette_outlined,
              title: 'Apariencia',
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.light_mode),
                    title: const Text('Tema'),
                    subtitle: Text(_getThemeModeLabel(_themeMode)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showThemeDialog(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sound & Notifications Section
            _SectionHeader(
              icon: Icons.volume_up_outlined,
              title: 'Sonido y Notificaciones',
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.music_note),
                    title: const Text('Efectos de sonido'),
                    subtitle: const Text('Reproducir sonidos durante el juego'),
                    value: _soundEffects,
                    onChanged: _saveSoundEffects,
                  ),
                  const Divider(),
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications),
                    title: const Text('Notificaciones'),
                    subtitle: const Text('Recibir notificaciones de la app'),
                    value: _notifications,
                    onChanged: _saveNotifications,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Language Section
            _SectionHeader(
              icon: Icons.language,
              title: 'Idioma',
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: ListTile(
                leading: const Icon(Icons.translate),
                title: const Text('Idioma de la aplicación'),
                subtitle: Text(_getLanguageLabel(_language)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(),
              ),
            ),
            const SizedBox(height: 24),

            // About Section
            _SectionHeader(
              icon: Icons.info_outline,
              title: 'Acerca de',
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.article),
                    title: const Text('Términos de Servicio'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () {
                      // TODO: Open terms of service URL
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Política de Privacidad'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () {
                      // TODO: Open privacy policy URL
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.code),
                    title: const Text('Versión'),
                    subtitle: Text(AppConstants.appVersion),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Disclaimer
            CustomCard(
              color: theme.colorScheme.error.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  AppConstants.disclaimer,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Claro'),
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  _saveThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Oscuro'),
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  _saveThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Sistema'),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  _saveThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Español'),
              value: 'es',
              groupValue: _language,
              onChanged: (value) {
                if (value != null) {
                  _saveLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: _language,
              onChanged: (value) {
                if (value != null) {
                  _saveLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  }

  String _getLanguageLabel(String lang) {
    switch (lang) {
      case 'es':
        return 'Español';
      case 'en':
        return 'English';
      default:
        return 'Español';
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
