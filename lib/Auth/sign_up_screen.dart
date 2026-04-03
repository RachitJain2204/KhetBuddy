import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 220, 220),
      body: Column(
        children: [
          // 🔹 Top Green Section
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
                    'Create Account',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Join KhetBuddy to manage your farms',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Color.fromARGB(150, 56, 132, 60),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Email Field
                  Text(
                    'EMAIL',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color.fromARGB(150, 56, 132, 60)
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Your Email',
                      hintStyle: GoogleFonts.poppins(
                          color: Color.fromARGB(150, 56, 132, 60)
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 🔹 Password Field
                  Text(
                    'PASSWORD',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color.fromARGB(150, 56, 132, 60)
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                      hintText: 'Create a Password',
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

                  const SizedBox(
                    height: 18,
                  ),

                  Text(
                    'CONFIRM PASSWORD',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color.fromARGB(150, 56, 132, 60)
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                      hintText: 'Repeat Your Password',
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

                  const SizedBox(height: 30),

                  // 🔹 Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 56, 132, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // 🔹 Bottom Text
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.poppins(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
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