import 'package:bmicalculator_1/home.dart';
import 'package:bmicalculator_1/register.dart';
import 'package:bmicalculator_1/share.dart';
import 'package:flutter/material.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPages> {
  bool iseyeButtonClicked = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Icon
                  Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF006B80),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.monitor_heart_outlined,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title & Subtitle
                  const Text(
                    'BMI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006B80),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Your mindful health companion',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 28),

                  // Email Label
                  const Text(
                    'EMAIL OR USERNAME',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email TextField
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) {
                      if (emailError != null) {
                        setState(() => emailError = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email or Name',
                      errorText: emailError,
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password Label Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PASSWORD',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                          letterSpacing: 0.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF006B80),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Password TextField
                  TextField(
                    controller: passwordController,
                    obscureText: !iseyeButtonClicked,
                    onChanged: (_) {
                      if (passwordError != null) {
                        setState(() => passwordError = null);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      errorText: passwordError,
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          iseyeButtonClicked
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            iseyeButtonClicked = !iseyeButtonClicked;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Log In Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006B80),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      final inputUserOrEmail = emailController.text.trim();
                      final inputPassword = passwordController.text;

                      String? tempEmailError;
                      String? tempPasswordError;

                      // Validate username / email
                      if (inputUserOrEmail.isEmpty) {
                        tempEmailError = 'Email or username is required';
                      } else if (inputUserOrEmail.contains('@') &&
                          !_isValidEmail(inputUserOrEmail)) {
                        tempEmailError =
                            'Enter a valid email format (e.g. name@domain.com)';
                      }

                      // Validate password
                      if (inputPassword.isEmpty) {
                        tempPasswordError = 'Password is required';
                      } else if (inputPassword.length < 6) {
                        tempPasswordError =
                            'Password must be at least 6 characters';
                      }

                      setState(() {
                        emailError = tempEmailError;
                        passwordError = tempPasswordError;
                      });

                      if (tempEmailError != null || tempPasswordError != null) {
                        return;
                      }

                      // Retrieve saved credentials
                      final savedEmail = await PreferencesService.getEmail();
                      final savedName = await PreferencesService.getName();
                      final savedPassword =
                          await PreferencesService.getPassword();

                      if (savedEmail == null && savedName == null) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No registered account found. Please sign up first.',
                            ),
                          ),
                        );
                        return;
                      }

                      // Validate login (allow login via registered email or name)
                      final isUserMatch =
                          (savedEmail != null &&
                              inputUserOrEmail.toLowerCase() ==
                                  savedEmail.toLowerCase()) ||
                          (savedName != null &&
                              inputUserOrEmail.toLowerCase() ==
                                  savedName.toLowerCase());
                      final isPasswordMatch = inputPassword == savedPassword;

                      if (isUserMatch && isPasswordMatch) {
                        await PreferencesService.saveLoginStatus(true);

                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BmiHomePage(),
                          ),
                        );
                      } else {
                        if (!context.mounted) return;
                        setState(() {
                          passwordError = 'Invalid email/username or password';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter valid email and password',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Divider(thickness: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 20),

                  // Bottom Sign Up Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateAccountScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFF006B80),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
