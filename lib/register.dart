import 'package:bmicalculator_1/login.dart';
import 'package:bmicalculator_1/share.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    String? tempNameError;
    String? tempEmailError;
    String? tempPasswordError;
    String? tempConfirmPasswordError;

    // Validate Name
    if (name.isEmpty) {
      tempNameError = 'Full name is required';
    } else if (name.length < 2) {
      tempNameError = 'Name must be at least 2 characters';
    }

    // Validate Email
    if (email.isEmpty) {
      tempEmailError = 'Email address is required';
    } else if (!_isValidEmail(email)) {
      tempEmailError = 'Enter a valid email (e.g. name@example.com)';
    }

    // Validate Password
    if (password.isEmpty) {
      tempPasswordError = 'Password is required';
    } else if (password.length < 6) {
      tempPasswordError = 'Password must be at least 6 characters';
    }

    // Validate Confirm Password
    if (confirmPassword.isEmpty) {
      tempConfirmPasswordError = 'Please confirm your password';
    } else if (password != confirmPassword) {
      tempConfirmPasswordError = 'Passwords do not match';
    }

    setState(() {
      nameError = tempNameError;
      emailError = tempEmailError;
      passwordError = tempPasswordError;
      confirmPasswordError = tempConfirmPasswordError;
    });

    if (tempNameError != null ||
        tempEmailError != null ||
        tempPasswordError != null ||
        tempConfirmPasswordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form')),
      );
      return;
    }

    // Save profile details and credentials
    await PreferencesService.saveName(name);
    await PreferencesService.saveEmail(email);
    await PreferencesService.savePassword(password);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully. Please log in.'),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPages()),
    );
  }

  Widget inputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onSuffixPressed,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6D7478),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: errorText != null
                  ? Colors.redAccent
                  : const Color(0xFF7B8588),
            ),
            const SizedBox(width: 20),

            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                onChanged: onChanged,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.black45,
                  ),
                  border: InputBorder.none,
                  suffixIcon: onSuffixPressed != null
                      ? IconButton(
                          onPressed: onSuffixPressed,
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: const TextStyle(color: Colors.red, fontSize: 13),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD5F8F3), Color(0xFFF5F7FB)],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 25),
            child: Column(
              children: [
                // Logo
                Container(
                  height: 105,
                  width: 105,
                  decoration: BoxDecoration(
                    color: const Color(0xFF087C8C),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.monitor_heart_outlined,
                    size: 58,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                // App name
                const Text(
                  'BMI',
                  style: TextStyle(
                    fontSize: 43,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 18),

                // Subtitle
                const Text(
                  'Start your mindful journey to wellness.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Color(0xFF555B5E)),
                ),

                const SizedBox(height: 55),

                // White Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(40, 42, 40, 35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      // Create Account title
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 45),

                      // Full Name
                      inputField(
                        label: 'FULL NAME',
                        hint: 'Enter Name',
                        icon: Icons.person_outline,
                        controller: nameController,
                        errorText: nameError,
                        onChanged: (_) {
                          if (nameError != null) {
                            setState(() => nameError = null);
                          }
                        },
                      ),

                      const SizedBox(height: 30),

                      // Email
                      inputField(
                        label: 'EMAIL ADDRESS',
                        hint: 'Enter Email',
                        icon: Icons.email_outlined,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        errorText: emailError,
                        onChanged: (_) {
                          if (emailError != null) {
                            setState(() => emailError = null);
                          }
                        },
                      ),

                      const SizedBox(height: 30),

                      // Password
                      inputField(
                        label: 'PASSWORD',
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        controller: passwordController,
                        obscureText: hidePassword,
                        errorText: passwordError,
                        onChanged: (_) {
                          if (passwordError != null) {
                            setState(() => passwordError = null);
                          }
                        },
                        onSuffixPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),

                      const SizedBox(height: 30),

                      // Confirm Password
                      inputField(
                        label: 'CONFIRM PASSWORD',
                        hint: '••••••••',
                        icon: Icons.verified_user_outlined,
                        controller: confirmPasswordController,
                        obscureText: hideConfirmPassword,
                        errorText: confirmPasswordError,
                        onChanged: (_) {
                          if (confirmPasswordError != null) {
                            setState(() => confirmPasswordError = null);
                          }
                        },
                        onSuffixPressed: () {
                          setState(() {
                            hideConfirmPassword = !hideConfirmPassword;
                          });
                        },
                      ),

                      const SizedBox(height: 45),

                      // Terms
                      const Text(
                        'By creating an account, you agree to our',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFB7BDC0),
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Terms of Service.',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF087C8C),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: createAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF087C8C),
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 15),
                              Icon(Icons.arrow_forward, size: 30),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 55),

                      // Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF666D70),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to Login screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPages(),
                                ),
                              );
                            },
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF087C8C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
