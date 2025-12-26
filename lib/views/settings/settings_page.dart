import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/settings_viewmodel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات'),
          centerTitle: true,
        ),
        body: Consumer<SettingsViewModel>(
          builder: (context, viewModel, child) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection(
                  context,
                  title: 'الإشعارات',
                  children: [
                    SwitchListTile(
                      title: const Text('تفعيل الإشعارات'),
                      subtitle: const Text('استقبال تنبيهات التطبيق'),
                      value: viewModel.notificationsEnabled,
                      onChanged: viewModel.toggleNotifications,
                    ),
                    SwitchListTile(
                      title: const Text('الأصوات'),
                      subtitle: const Text('تشغيل الأصوات للإشعارات'),
                      value: viewModel.soundEnabled,
                      onChanged: viewModel.toggleSound,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'المظهر',
                  children: [
                    SwitchListTile(
                      title: const Text('الوضع الليلي'),
                      subtitle: const Text('تفعيل المظهر الداكن'),
                      value: viewModel.darkModeEnabled,
                      onChanged: viewModel.toggleDarkMode,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'اللغة',
                  children: [
                    RadioListTile<String>(
                      title: const Text('العربية'),
                      value: 'ar',
                      groupValue: viewModel.language,
                      onChanged: (value) {
                        if (value != null) {
                          viewModel.changeLanguage(value);
                        }
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('English'),
                      value: 'en',
                      groupValue: viewModel.language,
                      onChanged: (value) {
                        if (value != null) {
                          viewModel.changeLanguage(value);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'عن التطبيق',
                  children: [
                    ListTile(
                      title: const Text('الإصدار'),
                      trailing: const Text('1.0.0'),
                    ),
                    ListTile(
                      title: const Text('الدعم الفني'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to support
                      },
                    ),
                    ListTile(
                      title: const Text('سياسة الخصوصية'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to privacy policy
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required List<Widget> children,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }
}
