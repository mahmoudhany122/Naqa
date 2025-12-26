import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../models/progress_model.dart';
import '../../viewmodels/statistics_viewmodel.dart';

class StatisticsPage extends StatelessWidget {
  final String userId;

  const StatisticsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StatisticsViewModel()..loadStatistics(userId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإحصائيات'),
          centerTitle: true,
        ),
        body: Consumer<StatisticsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsCards(context, viewModel),
                  const SizedBox(height: 24),
                  _buildWeeklyChart(context, viewModel),
                  const SizedBox(height: 24),
                  _buildAchievements(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, StatisticsViewModel viewModel) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          title: 'الأيام الحالية',
          value: '${viewModel.currentStreak}',
          icon: Icons.local_fire_department,
          color: Colors.orange,
        ),
        _buildStatCard(
          context,
          title: 'أطول فترة',
          value: '${viewModel.longestStreak}',
          icon: Icons.emoji_events,
          color: Colors.amber,
        ),
        _buildStatCard(
          context,
          title: 'إجمالي الأيام',
          value: '${viewModel.totalDays}',
          icon: Icons.calendar_today,
          color: Colors.blue,
        ),
        _buildStatCard(
          context,
          title: 'معدل النجاح',
          value: '${(viewModel.successRate * 100).toInt()}%',
          icon: Icons.trending_up,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      BuildContext context, {
        required String title,
        required String value,
        required IconData icon,
        required Color color,
      }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context, StatisticsViewModel viewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التقدم الأسبوعي',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: charts.BarChart(
                [
                  charts.Series<ProgressModel, String>(
                    id: 'Progress',
                    colorFn: (_, __) =>
                        charts.ColorUtil.fromDartColor(Colors.blue),
                    domainFn: (ProgressModel progress, _) => progress.day,
                    measureFn: (ProgressModel progress, _) => progress.progress,
                    data: viewModel.weeklyProgress,
                  )
                ],
                animate: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإنجازات',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildAchievementItem(
              context,
              title: 'أول يوم',
              description: 'أكملت أول يوم بنجاح',
              isUnlocked: true,
            ),
            _buildAchievementItem(
              context,
              title: 'أسبوع كامل',
              description: 'أكملت 7 أيام متتالية',
              isUnlocked: true,
            ),
            _buildAchievementItem(
              context,
              title: 'شهر كامل',
              description: 'أكمل 30 يوم متتالية',
              isUnlocked: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(
      BuildContext context, {
        required String title,
        required String description,
        required bool isUnlocked,
      }) {
    return ListTile(
      leading: Icon(
        isUnlocked ? Icons.emoji_events : Icons.lock_outline,
        color: isUnlocked ? Colors.amber : Colors.grey,
        size: 32,
      ),
      title: Text(title),
      subtitle: Text(description),
      trailing: isUnlocked
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
    );
  }
}