import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required String userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GlassmorphicContainer(
                    width: double.infinity,
                    height: 150,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(width: 20),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
                        ),
                        SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mahmoud Elzeiny",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Level: Beginner",
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircularPercentIndicator(
                        radius: 60,
                        lineWidth: 10,
                        percent: 0.7,
                        center: const Text("70%"),
                        progressColor: Colors.greenAccent,
                      ),
                      CircularPercentIndicator(
                        radius: 60,
                        lineWidth: 10,
                        percent: 0.5,
                        center: const Text("50%"),
                        progressColor: Colors.orangeAccent,
                      ),
                      CircularPercentIndicator(
                        radius: 60,
                        lineWidth: 10,
                        percent: 0.9,
                        center: const Text("90%"),
                        progressColor: Colors.purpleAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GlassmorphicContainer(
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
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Achievements",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "- Completed 3 streaks\n- Logged 7 days in a row",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
