import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: (1)),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Lottie.network(
        'https://assets4.lottiefiles.com/packages/lf20_j1adxtyb.json',
        controller: _controller,
        height: MediaQuery.of(context).size.height * 1,
        animate: true,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward().whenComplete(() => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NavigationBarWidget()),
                ));
        },
      ),
    );
  }
}
