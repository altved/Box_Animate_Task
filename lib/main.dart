import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SquareAnimation(),
        ),
      ),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() => SquareAnimationState();
}

class SquareAnimationState extends State<SquareAnimation>
    with SingleTickerProviderStateMixin {
  static const double _squareSize = 50.0;
  late final AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  double _position = 0.0;
  String _statusText = "Centered";

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  // Initialize the animations
  void _initAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.blue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {
        _position = _positionAnimation.value;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _updateStatusText();
      }
    });
  }

  // Update the status text based on the position
  void _updateStatusText() {
    setState(() {
      _statusText = _position == 0
          ? "Centered"
          : _position > 0
              ? "Reached Right"
              : "Reached Left";
    });
  }

  // Handle the "Move Right" action
  void _moveRight(double screenWidth) {
    final double maxPosition = (screenWidth - _squareSize) / 2;
    _statusText = "Moving Right";

    _positionAnimation = Tween<double>(begin: _position, end: maxPosition)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward(from: 0);
  }

  // Handle the "Move Left" action
  void _moveLeft(double screenWidth) {
    final double minPosition = -(screenWidth - _squareSize) / 2;
    _statusText = "Moving Left";

    _positionAnimation = Tween<double>(begin: _position, end: minPosition)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward(from: 0);
  }

  // Reset the square to the center position
  void _resetPosition() {
    _statusText = "Centered";
    _positionAnimation = Tween<double>(begin: _position, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxPosition = (screenWidth - _squareSize) / 2;
    final isAtRightEdge = _position >= maxPosition;
    final isAtLeftEdge = _position <= -maxPosition;

    return Stack(
      children: [
        _buildGradientBackground(),
        _buildResetButton(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusText(),
            _buildAnimatedSquare(),
            const SizedBox(height: 32),
            _buildControlButtons(screenWidth, isAtLeftEdge, isAtRightEdge),
          ],
        ),
      ],
    );
  }

  // Background
  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  // Reset Button
  Widget _buildResetButton() {
    return Positioned(
      top: 40,
      right: 20,
      child: IconButton(
        icon: Icon(Icons.refresh, color: Colors.grey.shade700),
        onPressed: _controller.isAnimating ? null : _resetPosition,
      ),
    );
  }

  // Build the status text widget
  Widget _buildStatusText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        _statusText,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Animation Square
  Widget _buildAnimatedSquare() {
    return Transform.translate(
      offset: Offset(_position, 0),
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: Transform.rotate(
          angle: _rotationAnimation.value,
          child: Container(
            width: _squareSize,
            height: _squareSize,
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(5, 5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Control Buttons
  Widget _buildControlButtons(
      double screenWidth, bool isAtLeftEdge, bool isAtRightEdge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: isAtLeftEdge || _controller.isAnimating
              ? null
              : () => _moveLeft(screenWidth),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Move Left'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: isAtRightEdge || _controller.isAnimating
              ? null
              : () => _moveRight(screenWidth),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Move Right'),
        ),
      ],
    );
  }
}
