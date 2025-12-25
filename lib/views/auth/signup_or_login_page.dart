import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_logo_button.dart';
import 'login_page.dart';
import 'signup_page.dart';

class SignUpOrLoginPage extends StatelessWidget {
  const SignUpOrLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppConstants.logoImage,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15.0),
                CustomButton(
                  text: 'Sign Up',
                  backgroundColor: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                ),
                const SizedBox(height: 15.0),
                CustomButton(
                  text: "Login",
                  backgroundColor: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                ),
                const SizedBox(height: 15.0),
                Text(
                  "تابعنا على وسائل التواصل الاجتماعى",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CustomLogoButton(image: "icons8-twitter-96.png"),
                    CustomLogoButton(image: "icons8-whatsapp-96.png"),
                    CustomLogoButton(image: "icons8-instagram-96.png"),
                    CustomLogoButton(image: "icon.jpg"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
