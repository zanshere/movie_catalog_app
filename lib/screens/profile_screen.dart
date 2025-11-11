import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _autoPlayEnabled = false;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red.shade300),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout from your account?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.purple.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white24,
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alex Johnson',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'alex.johnson@email.com',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Premium Member',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    Widget item(String count, String label, IconData icon) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue.shade300),
          ),
          const SizedBox(height: 8),
          Text(count, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 12)),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          item('128', 'Movies Watched', Icons.movie_rounded),
          item('47', 'Favorites', Icons.favorite_rounded),
          item('12', 'Watchlist', Icons.bookmark_rounded),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    Widget tile({
      required IconData icon,
      required String title,
      required String subtitle,
      bool? value,
      ValueChanged<bool>? onChanged,
    }) {
      return ListTile(
        leading: Icon(icon, color: Colors.blue.shade300),
        title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        subtitle: Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 12)),
        trailing: onChanged != null
            ? Switch.adaptive(
                value: value!,
                onChanged: onChanged,
                activeTrackColor: Colors.blue,
              )
            : const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
      );
    }

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          tile(
            icon: Icons.notifications_rounded,
            title: 'Push Notifications',
            subtitle: 'Receive updates about new movies',
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),
          tile(
            icon: Icons.play_arrow_rounded,
            title: 'Auto-play Trailers',
            subtitle: 'Automatically play movie trailers',
            value: _autoPlayEnabled,
            onChanged: (v) => setState(() => _autoPlayEnabled = v),
          ),
          ListTile(
            leading: Icon(Icons.dark_mode_rounded, color: Colors.blue.shade300),
            title: Text('Dark Mode', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text('Use dark theme across the app', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 12)),
            trailing: IconButton(
              icon: Icon(
                widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: widget.onThemeToggle,
            ),
          ),
          // ✅ Privacy popup
          ListTile(
            leading: Icon(Icons.security_rounded, color: Colors.blue.shade300),
            title: Text('Privacy & Security', style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
            subtitle: Text('Manage your privacy settings', style: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7), fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).dialogBackgroundColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: const Text('Privacy & Security'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SwitchListTile(
                        title: const Text('Allow Data Collection'),
                        subtitle: const Text('Enable anonymous usage statistics'),
                        value: true,
                        onChanged: (_) {},
                      ),
                      SwitchListTile(
                        title: const Text('Two-Factor Authentication'),
                        subtitle: const Text('Add extra security to your account'),
                        value: false,
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          // ✅ Help popup
          ListTile(
            leading: Icon(Icons.help_rounded, color: Colors.blue.shade300),
            title: Text('Help & Support', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text('Get help and contact support', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).dialogBackgroundColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: const Text('Help & Support'),
                  content: const Text(
                    'If you have any issues, contact us at:\n\nsupport@movieapp.com\n\nWe’ll respond within 24 hours.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withValues(alpha: 0.2),
          foregroundColor: Colors.red.shade300,
          side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        onPressed: _showLogoutDialog,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Profile',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.settings_rounded, color: Theme.of(context).colorScheme.onSurface),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              _buildProfileHeader(),
              _buildStatsSection(),
              _buildSettingsSection(),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
