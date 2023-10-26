import 'package:flutter/material.dart';

class TestAnimationPage extends StatefulWidget {
  const TestAnimationPage({super.key});

  @override
  _TestAnimationPageState createState() => _TestAnimationPageState();
}

class _TestAnimationPageState extends State<TestAnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _sizeAnimation = Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.75, curve: Curves.elasticOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomAnimatedWidget(
              opacityAnimation: _opacityAnimation,
              sizeAnimation: _sizeAnimation,
              rotationAnimation: _rotationAnimation,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _startAnimation,
              child: const Text('开始动画'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAnimatedWidget extends StatelessWidget {
  final Animation<double> opacityAnimation;
  final Animation<double> sizeAnimation;
  final Animation<double> rotationAnimation;

  const CustomAnimatedWidget({super.key, 
    required this.opacityAnimation,
    required this.sizeAnimation,
    required this.rotationAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacityAnimation.value,
      child: RotationTransition(
        turns: rotationAnimation,
        child: AnimatedContainer(
          duration: const Duration(seconds: 3),
          width: sizeAnimation.value,
          height: sizeAnimation.value,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: sizeAnimation.value > 50
                ? const Text(
                    '签到成功',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: TestAnimationPage(),
  ));
}
