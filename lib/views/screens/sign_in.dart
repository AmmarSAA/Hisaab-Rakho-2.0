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
import 'package:hisaab_rakho/utils/session_manager.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

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
                      style: TextStyle(
                          fontSize: responsive.sp(18)),
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
                      style: TextStyle(
                          fontSize: responsive.sp(18)),
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
                    onPressed: () async {
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();

                      if (email.isNotEmpty && password.isNotEmpty) {
                        var user =
                            await UserService.verifyUser(email, password);

                        if (user != null) {
                          await SessionManager().set('session', true);
                          await SessionManager().set('email', email.toString());
                          debugPrint("sign-in email: $email");

                          // Navigate to dashboard on successful sign-in
                          Navigator.pushNamed(context, '/dashboard');
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: Size(responsive.wp(60),
                          responsive.hp(7)),
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
