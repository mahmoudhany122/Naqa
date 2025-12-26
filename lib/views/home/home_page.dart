import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../../models/progress_model.dart';
import '../../../viewmodels/home_viewmodel.dart';

class HomePage extends StatelessWidget {
  final String userId;

  const HomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(userId: userId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('رحلة التعافي'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // TODO: Notifications
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SafeArea(
              child: Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildTimerWidget(viewModel),
                        const SizedBox(height: 20),
                        _buildProgressChart(viewModel),
                        const SizedBox(height: 20),
                        _buildMotivationWidget(viewModel),
                        const SizedBox(height: 20),
                        _buildQuickActions(context),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerWidget(HomeViewModel viewModel) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 200,
      borderRadius: 20,
      blur: 20,
      border: 2,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'الوقت المنقضي',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time, size: 40, color: Colors.white),
              const SizedBox(width: 16),
              Text(
                viewModel.formattedTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CircularPercentIndicator(
            radius: 40,
            lineWidth: 8,
            percent: (viewModel.duration.inSeconds % 60) / 60,
            center: Text(
              "${viewModel.duration.inSeconds % 60}s",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            progressColor: Colors.greenAccent,
            backgroundColor: Colors.white38,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart(HomeViewModel viewModel) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 220,
      borderRadius: 20,
      blur: 20,
      border: 2,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.5)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'التقدم الأسبوعي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: charts.BarChart(
                [
                  charts.Series<ProgressModel, String>(
                    id: 'WeeklyProgress',
                    colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.white),
                    domainFn: (ProgressModel progress, _) => progress.day,
                    measureFn: (ProgressModel progress, _) => progress.progress,
                    data: viewModel.weeklyProgress,
                  )
                ],
                animate: true,
                primaryMeasureAxis: const charts.NumericAxisSpec(
                  renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.white,
                      fontSize: 10,
                    ),
                    lineStyle: charts.LineStyleSpec(
                      color: charts.MaterialPalette.white,
                    ),
                  ),
                ),
                domainAxis: const charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationWidget(HomeViewModel viewModel) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 100,
      borderRadius: 20,
      blur: 20,
      border: 2,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.5)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.format_quote, color: Colors.white70, size: 24),
            const SizedBox(height: 8),
            Text(
              viewModel.currentMotivationMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.book,
            title: 'اليوميات',
            color: Colors.teal,
            onTap: () {
              // Navigate to Journey
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.emoji_events,
            title: 'الإنجازات',
            color: Colors.amber,
            onTap: () {
              // Navigate to Achievements
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 120,
        borderRadius: 16,
        blur: 20,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.5),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}