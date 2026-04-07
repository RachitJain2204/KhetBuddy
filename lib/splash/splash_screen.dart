import 'dart:async';
import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../constants/colors.dart';
import '../services/api_service.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _circleController;
  late AnimationController _circleBounceController;
  late AnimationController _logoFadeController;
  late AnimationController _expandController;
  late AnimationController _transitionController;

  late Animation<double> _circleScale;
  late Animation<double> _circleBounceScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoMoveX;
  late Animation<double> _logoMoveY;
  late Animation<double> _logoScale;
  late Animation<double> _circleExpandScale;
  late Animation<double> _splashOpacity;

  late Animation<double> _greenFadeOut;
  late Animation<double> _splashMoveY;
  late Animation<double> _splashFadeOut;

  @override
  void initState() {
    super.initState();

    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _circleScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _circleController, curve: Curves.easeOut),
    );

    _circleBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _circleBounceScale = Tween<double>(begin: 0.5, end: 1.1).animate(
      CurvedAnimation(
        parent: _circleBounceController,
        curve: Curves.easeOutBack,
      ),
    );

    _logoFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoFadeController, curve: Curves.easeIn),
    );

    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _circleExpandScale = Tween<double>(begin: 1.35, end: 25.0).animate(
      CurvedAnimation(
        parent: _expandController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _splashOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _expandController,
        curve: const Interval(0.35, 0.8, curve: Curves.easeIn),
      ),
    );

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoMoveX = Tween<double>(begin: 0.0, end: 150.0).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeInOut),
    );

    _logoMoveY = Tween<double>(begin: 0.0, end: 150.0).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeInOut),
    );

    _logoScale = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeInOut),
    );

    _greenFadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _splashMoveY = Tween<double>(begin: 0.0, end: 0.87).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOutCubic),
      ),
    );

    _splashFadeOut = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(_transitionController);

    _startAnimation();
  }

  void _startAnimation() async {
    await _circleController.forward();

    await Future.delayed(const Duration(milliseconds: 200));

    _circleBounceController.forward();
    _logoFadeController.forward();

    await _circleBounceController.forward();

    await Future.delayed(const Duration(milliseconds: 250));

    _logoFadeController.reverse();

    await Future.delayed(const Duration(milliseconds: 300));

    await Future.delayed(const Duration(milliseconds: 250));

    await _expandController.forward();
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    await _transitionController.forward();

    await _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    if (!mounted) return;

    // Check if user is already logged in
    final apiService = ApiService();
    final token = await apiService.getToken();

    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    if (token != null &&
        token.isNotEmpty ) {
      await apiService.loadToken();
      Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
    }
  }

  @override
  void dispose() {
    _circleController.dispose();
    _circleBounceController.dispose();
    _logoFadeController.dispose();
    _expandController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final splashWidth = size.width * 0.32;

    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    // Use a percentage-based approach that respects safe areas
    final availableHeight = size.height - safeAreaTop - safeAreaBottom;
    final targetTopPosition = safeAreaTop + (availableHeight * 0.15);

    final centerY = size.height / 2;
    final targetY = targetTopPosition - centerY;

    return Scaffold(
      backgroundColor: AppColors.offwhite,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _circleController,
            _circleBounceController,
            _logoFadeController,
            _expandController,
            _transitionController,
          ]),
          builder: (context, child) {
            final circleFullyExpanded = _expandController.value > 0.6;
            final isTransitioning = _transitionController.value > 0.0;

            return Stack(
              children: [
                if (circleFullyExpanded || isTransitioning)
                  Opacity(
                    opacity: _greenFadeOut.value,
                    child: Container(color: AppColors.mainGreen),
                  ),

                if (!circleFullyExpanded && !isTransitioning)
                  Center(
                    child: Transform.scale(
                      scale:
                      _circleScale.value *
                          _circleBounceScale.value *
                          _circleExpandScale.value,
                      child: Container(
                        width: size.width * 0.3,
                        height: size.width * 0.3,
                        decoration: const BoxDecoration(
                          color: AppColors.mainGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                if (_splashOpacity.value > 0)
                  Opacity(
                    opacity: _splashOpacity.value * _splashFadeOut.value,
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(0, targetY * _splashMoveY.value),
                        child: Image.asset(
                          'assets/splash.png',
                          fit: BoxFit.contain,
                          width: splashWidth,
                        ),
                      ),
                    ),
                  ),

                if (_logoOpacity.value > 0)
                  Opacity(
                    opacity: _logoOpacity.value,
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(_logoMoveX.value, _logoMoveY.value),
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Image.asset(
                            'assets/logo2.png',
                            width: size.width * 0.18,
                            height: size.width * 0.18,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
