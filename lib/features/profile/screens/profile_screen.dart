import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        authProvider.userModel?.firstName.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authProvider.userModel?.fullName ?? 'User',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            authProvider.userModel?.email ?? '',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Navigate to edit profile
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Menu items
            _buildMenuItem(
              context,
              icon: Icons.settings,
              title: l10n.settings,
              onTap: () {
                // TODO: Navigate to settings
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: l10n.support,
              onTap: () {
                // TODO: Navigate to support
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: l10n.about,
              onTap: () {
                // TODO: Show about dialog
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.logout,
              title: l10n.logout,
              isDestructive: true,
              onTap: () {
                _showLogoutDialog(context, l10n, authProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : null,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : null,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              authProvider.signOut();
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}
