import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khet_buddy/constants/colors.dart';
import 'package:provider/provider.dart';
import '../../app_routes.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.offwhite,
      body: Column(
        children: [
          // 🔹 Top Section
          Container(
            height: screenHeight * 0.37,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 56, 132, 60),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.85,
                      child: Image.asset(
                        'assets/logo2.png',
                        height: 250,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Smart Farming, Simplified',
                    style: GoogleFonts.merriweather(
                      color: Colors.white,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Bottom Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),

                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Sign in to manage your farms',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Color.fromARGB(150, 56, 132, 60),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // EMAIL
                  Text(
                    'EMAIL',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color.fromARGB(150, 56, 132, 60)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Your Email',
                      hintStyle: GoogleFonts.poppins(
                          color: Color.fromARGB(150, 56, 132, 60)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // PASSWORD
                  Text(
                    'PASSWORD',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color.fromARGB(150, 56, 132, 60)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                      hintText: 'Your password',
                      hintStyle: GoogleFonts.poppins(
                        color: Color.fromARGB(150, 56, 132, 60),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF2E7D32),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Consumer<AuthController>(
                      builder: (context, authController, _) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color.fromARGB(255, 56, 132, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: authController.isLoading
                              ? null
                              : () async {
                            final username =
                            _emailController.text.trim();
                            final password =
                            _passwordController.text.trim();

                            if (username.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text("Please fill all fields")),
                              );
                              return;
                            }

                            final success = await authController.login(
                                username, password);

                            if (success) {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.createProfile);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(authController
                                        .errorMessage ??
                                        "Login failed")),
                              );
                            }
                          },
                          child: authController.isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Spacer(),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: GoogleFonts.poppins(color: Colors.black54),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.signup,
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF2E7D32),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}