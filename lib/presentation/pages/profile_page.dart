import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/presentation/notifiers/theme_notifier.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),

          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.person, size: 55, color: Colors.white),
                ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: () {},
                  child: const Text("Oturum Aç"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 35),

          _sectionTitle(context, "Hesap"),

          _modernCard(
            context,
            children: [
              _tile(context, Icons.settings, "Hesap Ayarları"),
              _divider(context),
              _tile(context, Icons.notifications, "Bildirimler"),
              _divider(context),
              _tile(context, Icons.lock, "Gizlilik ve Güvenlik"),
              _divider(context),

              // 🔥 Tema Toggle Eklenen Tile
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text("Tema"),
                subtitle: Text(
                  theme.isDark ? "Karanlık Mod" : "Aydınlık Mod",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
                trailing: Switch(
                  value: theme.isDark,
                  onChanged: (_) => theme.toggleTheme(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          _sectionTitle(context, "Diğer"),

          _modernCard(
            context,
            children: [
              _tile(
                context,
                Icons.workspace_premium,
                "Premium Satın Al",
                iconColor: Colors.amber,
                isBold: true,
              ),
              _divider(context),
              _tile(context, Icons.help_outline, "Yardım ve Destek"),
              _divider(context),
              _tile(
                context,
                Icons.logout,
                "Çıkış Yap",
                iconColor: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- UI Helpers ---

  Widget _sectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }

  Widget _modernCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: 1,
            color: Theme.of(context).shadowColor.withOpacity(0.08),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String title, {
    Color? iconColor,
    bool isBold = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Theme.of(context).iconTheme.color),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      height: 1,
      color: Theme.of(context).dividerColor.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
