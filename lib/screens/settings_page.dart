import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    // Wrap the content in a SingleChildScrollView
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Appearance section
            _buildSectionTitle(context, 'Appearance'),
            _buildSettingCard(
              context,
              'Dark Mode',
              'Switch between light and dark mode',
              Icons.dark_mode,
              trailing: Switch.adaptive(
                value: themeProvider.isDarkMode,
                activeColor: theme.primaryColor,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),

            // Account section
            _buildSectionTitle(context, 'Account'),



            // Privacy section
            _buildSectionTitle(context, 'Privacy'),
            _buildSettingCard(
              context,
              'Privacy Policy',
              'Read our privacy policy',
              Icons.privacy_tip_outlined,
              onTap: () {
                // Show privacy policy
              },
            ),
            _buildSettingCard(
              context,
              'Terms of Service',
              'Read our terms of service',
              Icons.description_outlined,
              onTap: () {
                // Show terms of service
              },
            ),

            // About section
            _buildSectionTitle(context, 'About'),
            _buildSettingCard(
              context,
              'App Version',
              '1.0.0',
              Icons.info_outline,
            ),

            // Add extra bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon, {
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.brightness == Brightness.dark
              ? Colors.grey[800]!
              : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: theme.primaryColor,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
      ),
    );
  }
}