import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../viewmodels/home_viewmodel.dart';

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