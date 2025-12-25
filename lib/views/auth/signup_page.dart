import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account created successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
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
              padding: const EdgeInsets.only(top: 100.0, right: 10, left: 10),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        "Create Account",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        labelText: 'First name',
                        hintText: 'Enter Your first name',
                        controller: firstnameController,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.drive_file_rename_outline,
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        labelText: 'Last name',
                        hintText: 'Enter Your last name',
                        controller: lastnameController,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.drive_file_rename_outline,
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        labelText: 'Phone number',
                        hintText: 'Enter Your Phone number',
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone,
                        validator: Validators.validatePhone,
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
                      const SizedBox(height: 14),
                      CustomTextField(
                        labelText: 'Confirm Password',
                        hintText: 'Re-enter password',
                        controller: confirmPasswordController,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                        validator: (value) => Validators.validateConfirmPassword(
                          value,
                          passwordController.text,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: "Sign Up",
                        isLoading: viewModel.isLoading,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await viewModel.signUp(
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
