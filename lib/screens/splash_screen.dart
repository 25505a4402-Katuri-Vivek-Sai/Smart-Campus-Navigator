import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _progressController;
  late Animation<double> _logoScale;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _logoScale = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeInOut));

    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(_progressController)..addListener(() { setState(() {}); });
    _progressController.forward().then((value) {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int percentage = (_progressAnimation.value * 100).toInt();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            ScaleTransition(
              scale: _logoScale,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F80ED).withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: const Color(0xFF2F80ED).withOpacity(0.2), blurRadius: 20, spreadRadius: 5)],
                ),
                child: const Icon(Icons.explore_rounded, size: 100, color: Color(0xFF2F80ED)),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Smart Campus Navigator', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF2F80ED), letterSpacing: 1.2)),
            const SizedBox(height: 12),
            const Text('Navigate Your Campus Smartly', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
            const Spacer(flex: 2),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(value: _progressAnimation.value, minHeight: 12, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2F80ED))),
                ),
                const SizedBox(height: 16),
                Text('$percentage%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2F80ED))),
                const Text('Loading campus data...', style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
              ],
            ),
            const Spacer(flex: 1),
            const Text('v1.2.0', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
