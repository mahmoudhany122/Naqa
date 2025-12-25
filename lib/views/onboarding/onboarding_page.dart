import 'package:flutter/material.dart';
import '../../models/boarding_model.dart';
import '../auth/signup_or_login_page.dart';
import 'widgets/boarding_item_widget.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<BoardingModel> boardingModel = [
    BoardingModel(
      image: "assets/images/onb1.webp",
      title: "Welcome",
      title1: "Petanque App",
      body: "Discover events and players easily",
    ),
    BoardingModel(
      image: "assets/images/ChatGPT Image Dec 22, 2025, 01_36_53 AM.png",
      title: "Play",
      title1: "With Friends",
      body: "Join matches and tournaments",
    ),
    BoardingModel(
      image: "assets/images/bird (1).png",
      title: "Enjoy",
      title1: "The Game",
      body: "Track progress and improve",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: boardingModel.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) => buildBoardingItem(boardingModel[index]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              boardingModel.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(4),
                width: currentIndex == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentIndex == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          currentIndex == boardingModel.length - 1 ? Icons.check : Icons.arrow_forward,
        ),
        onPressed: () {
          if (currentIndex == boardingModel.length - 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignUpOrLoginPage()),
            );
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
    );
  }
}
