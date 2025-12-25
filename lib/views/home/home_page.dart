import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../models/progress_model.dart';
import '../../viewmodels/home_viewmodel.dart';

class HomePage extends StatelessWidget {
  final String userId;

  HomePage({super.key, required this.userId,});

  final TextEditingController journeyController = TextEditingController();

  final List<ProgressModel> weeklyProgress = [
    ProgressModel('Mon', 80),
    ProgressModel('Tue', 50),
    ProgressModel('Wed', 70),
    ProgressModel('Thu', 60),
    ProgressModel('Fri', 90),
    ProgressModel('Sat', 40),
    ProgressModel('Sun', 100),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Scaffold(
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
                        _buildProgressChart(),
                        const SizedBox(height: 20),
                        _buildMotivationWidget(viewModel),
                        const SizedBox(height: 20),
                        _buildJourneyLog(viewModel),
                        const SizedBox(height: 20),
                        _buildAppLockWidget(viewModel),
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
      height: 120,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time, size: 50, color: Colors.white),
              Text(
                viewModel.formattedTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          CircularPercentIndicator(
            radius: 50,
            lineWidth: 10,
            percent: (viewModel.duration.inSeconds % 60) / 60,
            center: Text(
              "${viewModel.duration.inSeconds % 60} sec",
              style: const TextStyle(color: Colors.white),
            ),
            progressColor: Colors.white,
            backgroundColor: Colors.white38,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 180,
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
        padding: const EdgeInsets.all(12.0),
        child: charts.BarChart(
          [
            charts.Series<ProgressModel, String>(
              id: 'WeeklyProgress',
              colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.white),
              domainFn: (ProgressModel progress, _) => progress.day,
              measureFn: (ProgressModel progress, _) => progress.progress,
              data: weeklyProgress,
            )
          ],
          animate: true,
          primaryMeasureAxis: const charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white),
              lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.white),
            ),
          ),
          domainAxis: const charts.OrdinalAxisSpec(
            renderSpec: charts.SmallTickRendererSpec(
              labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMotivationWidget(HomeViewModel viewModel) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 80,
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
      child: Center(
        child: Text(
          viewModel.currentMotivationMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildJourneyLog(HomeViewModel viewModel) {
    return StreamBuilder(
      stream: viewModel.getJourneyLog(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final entries = snapshot.data!;
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
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        entries[index].text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: journeyController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Add new entry',
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (journeyController.text.isNotEmpty) {
                          viewModel.addJourneyEntry(userId, journeyController.text);
                          journeyController.clear();
                        }
                      },
                      icon: const Icon(Icons.send, color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppLockWidget(HomeViewModel viewModel) {
    return StreamBuilder<bool>(
      stream: viewModel.getAppLockStatus(userId),
      builder: (context, snapshot) {
        final isLocked = snapshot.data ?? false;
        return GlassmorphicContainer(
          width: double.infinity,
          height: 80,
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
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    viewModel.toggleAppLock(userId, !isLocked);
                  },
                  icon: Icon(isLocked ? Icons.lock : Icons.lock_open),
                  label: Text(isLocked ? "Locked" : "Unlock"),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.timer),
                  label: const Text("Focus Timer"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}