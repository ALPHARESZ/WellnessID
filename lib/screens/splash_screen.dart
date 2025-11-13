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
      end: const Offset(0, -0.4),
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
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isTablet = size.width > 600;

    // Sesuaikan ukuran berdasarkan orientasi
    final logoSize = isLandscape
        ? (isTablet ? 160.0 : 120.0)
        : (isTablet ? 220.0 : 180.0);

    final textFontSize = isLandscape
        ? (isTablet ? 28.0 : 24.0)
        : (isTablet ? 34.0 : 28.0);

    final buttonHeight = isLandscape
        ? (isTablet ? 52.0 : 44.0)
        : (isTablet ? 56.0 : 48.0);

    final horizontalPadding = isLandscape
        ? (isTablet ? 120.0 : 80.0)
        : (isTablet ? 80.0 : 40.0);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: isLandscape ? 8 : 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SlideTransition(
                        position: _moveLogo,
                        child: FadeTransition(
                          opacity: _fadeLogo,
                          child: Image.asset(
                            'assets/images/Logo.jpg',
                            width: logoSize,
                            height: logoSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: isLandscape ? 16 : 24),
                      FadeTransition(
                        opacity: _fadeText,
                        child: Column(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: textFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Wellness',
                                    style: TextStyle(color: Color(0xFF003B88)),
                                  ),
                                  TextSpan(
                                    text: 'ID',
                                    style: TextStyle(color: Color(0xFF006FFF)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Ayo Cek Kondisi Kamu',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isLandscape ? 14 : 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isLandscape ? 24 : 40),
                      FadeTransition(
                        opacity: _fadeButton,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF22B3E4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                'Mulai Aplikasi',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: isLandscape ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                ),
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
          },
        ),
      ),
    );
  }
}
