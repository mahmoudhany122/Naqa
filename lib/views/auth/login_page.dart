import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../main_layout/main_layout_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: Scaffold(
        body: Consumer<AuthViewModel>(
          builder: (context, viewModel, child) {
            // Listen to success
            if (viewModel.user != null && !viewModel.isLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MainLayoutPage(userId: viewModel.user!.uid),
                  ),
                );
              });
            }

            // Listen to error
            if (viewModel.error != null && !viewModel.isLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.error!),
                    backgroundColor: Colors.red,
                  ),
                );
                viewModel.clearError();
              });
            }

            return Padding(
              padding: const EdgeInsets.only(top: 100, right: 10, left: 10),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        "Login",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        labelText: 'Email',
                        hintText: 'Enter Your Email',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        controller: passwordController,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: "Login",
                        isLoading: viewModel.isLoading,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await viewModel.login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                          }
                        },
                        backgroundColor: Colors.blueAccent,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}