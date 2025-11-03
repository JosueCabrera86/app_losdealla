import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacityLogo1 = 0.0;
  double opacityLogo2 = 0.0;
  double opacityAuspiciantes = 0.0;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 300), () {
      setState(() => opacityLogo1 = 1.0);
    });

    Timer(const Duration(seconds: 3), () {
      setState(() {
        opacityLogo1 = 0.0;
        opacityLogo2 = 1.0;
      });
    });

    Timer(const Duration(seconds: 5), () {
      setState(() {
        opacityLogo2 = 0.0;
        opacityAuspiciantes = 1.0;
      });
    });

    Timer(const Duration(seconds: 8), () {
      Navigator.pushReplacementNamed(context, '/info');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDCBF6),
      body: Stack(
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: opacityLogo1,
              duration: const Duration(seconds: 1),
              child: Image.asset('assets/images/logo_losdeallac.png', width: 200),
            ),
          ),
          Center(
            child: AnimatedOpacity(
              opacity: opacityLogo2,
              duration: const Duration(seconds: 1),
              child: Image.asset('assets/images/logo_manoentonadaa.png', width: 200),
            ),
          ),
          Center(
            child: AnimatedOpacity(
              opacity: opacityAuspiciantes,
              duration: const Duration(seconds: 1),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                      offset: const Offset(-15,0),
                      child: Image.asset('assets/images/escudoqroo.png', width: 140),
                  ),
                  Transform.translate(
                    offset: const Offset(-30, 0),
                    child: Image.asset('assets/images/logo_sebien.png', width: 140),
                  ),
                  const SizedBox(width:2),

                  Image.asset('assets/images/logo_faron.png', width: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
