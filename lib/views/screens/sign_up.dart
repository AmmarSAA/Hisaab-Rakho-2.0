/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: sign_up.dart                                                           |*/
/*| Path: lib/views/screens/sign_up.dart                                         |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Sign Up Screen                                                      |*/
/*| Output: Implement Sign Up Screen                                             |*/
/*| Description: Sign up the user to the application                             |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hisaab_rakho/models/users.dart';
import 'package:hisaab_rakho/services/user_services.dart';
import 'package:hisaab_rakho/utils/id_gen.dart';
import 'package:hisaab_rakho/utils/responsive.dart';
import 'package:hisaab_rakho/utils/session_manager.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
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

              // Name, Email, and Password Fields
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  children: [
                    // Name Field
                    TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        labelText: 'Name',
                        hintStyle: TextStyle(fontSize: 16),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: TextStyle(fontSize: responsive.sp(18)),
                    ),
                    const SizedBox(height: 16),

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
                    // Sign In Link
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/sign-in');
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "Already Signed Up? Sign In Now!",
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

              // Sign Up Button
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(10), // 10% horizontal padding
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        final newUser = AppUser(
                          createdAt: DateTime.now(),
                          id: id,
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        // Call the UserService's addUser method
                        Object addedSuccessfully =
                            await UserService.addUser(newUser);

                        if (addedSuccessfully is Map<String, dynamic>) {
                          bool isSuccess =
                              addedSuccessfully['success'] ?? false;
                          String message = addedSuccessfully['message'] ??
                              'Please connect to the internet.';
                          String title = isSuccess ? 'Woohoo!' : 'Oops!';

                          if (!isSuccess) {
                            debugPrint('Unknown error occurred');
                          }

                          if (isSuccess) {
                            nameController.clear();
                            emailController.clear();
                            passwordController.clear();
                            await SessionManager().set('email', newUser.email);
                            await SessionManager().set('session', true);
                            Get.snackbar("Woohoo!", message);
                            await Future.delayed(const Duration(seconds: 2));
                            Navigator.pushNamed(context, '/dashboard');

                            Get.snackbar(
                              title,
                              message,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } else {
                            Get.snackbar(title, message,
                                backgroundColor: Colors.red);
                          }
                        } else {
                          Get.snackbar(
                              'Alert!', 'Please connect to the internet.',
                              backgroundColor: Colors.yellow);
                        }
                      } else {
                        Get.snackbar('Hey!', 'Fill all the fields.');
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
                      'Sign Up',
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
