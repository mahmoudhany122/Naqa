import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../onboarding/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _opacity = 1.0;
  double _scale = 1.8;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _opacity = 0.7;
          _scale = 1.4;
        });
      }
    });

    Timer(const Duration(seconds: 9), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardingPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 7),
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(seconds: 7),
                curve: Curves.easeOutBack,
                child: Image.asset(
                  AppConstants.logoImage,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 6),
              child: Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
