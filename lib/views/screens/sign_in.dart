/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: sign_in.dart                                                           |*/
/*| Path: lib/views/screens/sign_in.dart                                         |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Sign In Screen                                                      |*/
/*| Output: Implement Sign In Screen                                             |*/
/*| Description: Implement the sign in screen for the application                |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisaab_rakho/services/user_services.dart';
import 'package:hisaab_rakho/utils/responsive.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _busy = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal:
                responsive.wp(8), // 8% of screen width for horizontal padding
            vertical:
                responsive.hp(5), // 5% of screen height for vertical padding
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/light/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image Container
              Image.asset(
                'assets/light/splash.png',
                height: responsive.hp(40), // 40% of screen height
                width: responsive.wp(100), // 100% of screen width
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
              const SizedBox(height: 20),

              // Email and Password Fields
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  children: [
                    // Email Field
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        labelText: 'Email',
                        hintStyle: TextStyle(fontSize: 16),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: TextStyle(fontSize: responsive.sp(18)),
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: '********',
                        labelText: 'Password',
                        hintStyle: TextStyle(fontSize: 16),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: TextStyle(fontSize: responsive.sp(18)),
                    ),
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () async {
                              setState(() => _busy = true);
                              try {
                                if (emailController.text.trim().isEmpty) {
                                  Get.snackbar(
                                      'Recovery', 'Enter your email first.');
                                  return;
                                }
                                final message =
                                    await UserService.requestRecovery(
                                        emailController.text);
                                if (context.mounted) {
                                  Get.snackbar('Recovery', message,
                                      duration: const Duration(seconds: 8));
                                }
                              } catch (_) {
                                if (context.mounted) {
                                  Get.snackbar('Recovery',
                                      'Unable to request recovery. Please try again.');
                                }
                              } finally {
                                if (mounted) setState(() => _busy = false);
                              }
                            },
                      child: const Text('Recover account / forgot password'),
                    ),
                    // Sign Up Link
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/sign-up');
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "New User? Sign Up Now!",
                          style: TextStyle(
                            fontSize: responsive.sp(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Sign In Button
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(10)), // 10% horizontal padding
                  child: ElevatedButton(
                    onPressed: _busy
                        ? null
                        : () async {
                            setState(() => _busy = true);
                            try {
                              String email = emailController.text.trim();
                              String password = passwordController.text;

                              if (email.isNotEmpty && password.isNotEmpty) {
                                var user = await UserService.verifyUser(
                                    email, password);

                                if (user != null) {
                                  // Navigate to dashboard on successful sign-in
                                  if (context.mounted) {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/dashboard', (_) => false);
                                  }
                                } else {
                                  // Invalid credentials
                                  Get.snackbar('Oops!', 'Invalid credentials.',
                                      backgroundColor: Colors.red);
                                }
                              } else {
                                // Show alert for empty fields
                                Get.snackbar(
                                  'Hey!',
                                  'Fill all the fields.',
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _busy = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: Size(responsive.wp(60), responsive.hp(7)),
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: responsive.sp(18),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
