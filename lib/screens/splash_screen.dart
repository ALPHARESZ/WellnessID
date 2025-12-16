import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

    _logoController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _textController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _buttonController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _fadeLogo = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.6)),
    );

    _moveLogo = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.4),
    ).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.4, 1.0)),
    );

    _fadeText = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

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
    final media = MediaQuery.of(context);
    final size = media.size;
    final isLandscape = media.orientation == Orientation.landscape;
    final isTablet = size.width >= 600;

    final logoSize = isLandscape
        ? (isTablet ? 140.0 : 110.0)
        : (isTablet ? 220.0 : 180.0);

    final textFontSize = isLandscape
        ? (isTablet ? 26.0 : 22.0)
        : (isTablet ? 34.0 : 28.0);

    final buttonHeight = isLandscape ? 44.0 : 48.0;
    final horizontalPadding =
        isTablet ? size.width * 0.25 : size.width * 0.15;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: isLandscape ? 12 : 32,
                  ),
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
                          ),
                        ),
                      ),

                      SizedBox(height: isLandscape ? 12 : 24),

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
                                    style:
                                        TextStyle(color: Color(0xFF003B88)),
                                  ),
                                  TextSpan(
                                    text: 'ID',
                                    style:
                                        TextStyle(color: Color(0xFF006FFF)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Ayo Cek Kondisi Kamu',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isLandscape ? 14 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isLandscape ? 20 : 40),

                      FadeTransition(
                        opacity: _fadeButton,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding),
                          child: SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: () => context.goNamed('login'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF22B3E4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
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
