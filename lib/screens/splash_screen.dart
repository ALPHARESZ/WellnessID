import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _buttonController;

  late Animation<double> _fadeLogo;
  late Animation<Offset> _moveLogo;
  late Animation<double> _fadeText;
  late Animation<double> _fadeButton;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeLogo = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.6)),
    );

    _moveLogo = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.5),
    ).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.4, 1.0)),
    );

    _fadeText = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _fadeButton = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeIn),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await _logoController.forward();
    await _textController.forward();
    await _buttonController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _moveLogo,
                child: FadeTransition(
                  opacity: _fadeLogo,
                  child: Image.asset(
                    'assets/images/Logo.jpg',
                    width: 180,
                    height: 180,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeText,
                child: Column(
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: 'Wellness',
                            style: TextStyle(color: Color(0xFF003B88))),
                          TextSpan(
                            text: 'ID',
                            style: TextStyle(color: Color(0xFF006FFF))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ayo Cek Kondisi Kamu',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _fadeButton,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22B3E4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Mulai Aplikasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
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
