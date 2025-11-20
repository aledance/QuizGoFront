import 'package:flutter/material.dart';

import '../theme/theme_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _music = true;
  bool _soundEffects = true;
  String _language = 'Español';
  String _userType = 'Social';
  late bool _isDark;
  late VoidCallback _themeListener;

  final List<String> _languages = const ['Español', 'Inglés', 'Francés'];
  final List<String> _userTypes = const ['Social', 'Profesor', 'Empresa'];

  @override
  void initState() {
    super.initState();
    _isDark = themeController.isDark;
    _themeListener = () => setState(() => _isDark = themeController.isDark);
    themeController.addListener(_themeListener);
  }

  @override
  void dispose() {
    themeController.removeListener(_themeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Perfil',
            children: [
              _ActionTile(label: 'Restaurar compras', onTap: () {}),
            ],
          ),
          _SectionCard(
            title: 'General',
            children: [
              ListTile(
                title: const Text('Idioma'),
                subtitle: Text(_language),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguagePicker(context),
              ),
              SwitchListTile.adaptive(
                value: _isDark,
                onChanged: (v) {
                  setState(() => _isDark = v);
                  themeController.setMode(v ? ThemeMode.dark : ThemeMode.light);
                },
                title: const Text('Modo oscuro'),
              ),
            ],
          ),
          _SectionCard(
            title: 'Música',
            children: [
              SwitchListTile.adaptive(
                value: _music,
                title: const Text('Música'),
                onChanged: (v) => setState(() => _music = v),
              ),
              SwitchListTile.adaptive(
                value: _soundEffects,
                title: const Text('Efectos de sonido'),
                onChanged: (v) => setState(() => _soundEffects = v),
              ),
            ],
          ),
          _SectionCard(
            title: 'Social',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _socialOptions
                      .map(
                        (opt) => CircleAvatar(
                          backgroundColor: opt.color,
                          child: Icon(opt.icon, color: Colors.white),
                        ),
                      )
                      .toList(),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Pasa la voz'),
              ),
            ],
          ),
          _SectionCard(
            title: 'Ayuda',
            children: const [
              _InfoTile(label: 'Desarrollo Equipo Morado v0.0.1'),
              _InfoTile(label: 'Preguntas frecuentes'),
            ],
          ),
          _SectionCard(
            title: 'Información legal',
            children: const [
              _InfoTile(label: 'Términos y condiciones'),
              _InfoTile(label: 'Política de privacidad'),
              _InfoTile(label: 'Agradecimientos'),
            ],
          ),
          _SectionCard(
            title: 'Tipo de usuario',
            children: [
              DropdownButtonFormField<String>(
                key: ValueKey('user-type-$_userType'),
                initialValue: _userType,
                items: _userTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _userType = value);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: scheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => ListView(
        children: _languages
            .map((lang) => ListTile(
                  title: Text(lang),
                  trailing: lang == _language ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.of(ctx).pop(lang),
                ))
            .toList(),
      ),
    );
    if (selected != null) {
      setState(() => _language = selected);
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ActionTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      onTap: onTap,
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  const _InfoTile({required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      onTap: () {},
    );
  }
}

class _SocialOption {
  final IconData icon;
  final Color color;
  const _SocialOption(this.icon, this.color);
}

const _socialOptions = [
  _SocialOption(Icons.alternate_email, Color(0xFF1DA1F2)),
  _SocialOption(Icons.music_note, Color(0xFF010101)),
  _SocialOption(Icons.facebook, Color(0xFF1777F2)),
  _SocialOption(Icons.business_center, Color(0xFF0A66C2)),
  _SocialOption(Icons.camera_alt, Color(0xFFE4405F)),
  _SocialOption(Icons.chat_bubble_outline, Color(0xFFFFFC00)),
];