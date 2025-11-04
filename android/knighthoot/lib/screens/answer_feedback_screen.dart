import 'package:flutter/material.dart';
import 'dart:async';

class AnswerFeedbackScreen extends StatefulWidget {
  final bool isCorrect;
  final String correctAnswer;
  final String studentAnswer;

  const AnswerFeedbackScreen({
    Key? key,
    required this.isCorrect,
    required this.correctAnswer,
    required this.studentAnswer,
  }) : super(key: key);

  @override
  State<AnswerFeedbackScreen> createState() => _AnswerFeedbackScreenState();
}

class _AnswerFeedbackScreenState extends State<AnswerFeedbackScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isCorrect
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1),
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.isCorrect ? Icons.check_circle : Icons.cancel,
                  size: 120,
                  color: widget.isCorrect ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 32),

                Text(
                  widget.isCorrect ? 'CORRECT!' : 'INCORRECT',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: widget.isCorrect ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.isCorrect ? Colors.green : Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      if (!widget.isCorrect) ...[
                        Text(
                          'Your answer: ${widget.studentAnswer}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(
                        'Correct answer: ${widget.correctAnswer}',
                        style: TextStyle(
                          fontSize: 18,
                          color: widget.isCorrect ? Colors.green : const Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                const CircularProgressIndicator(
                  color: Color(0xFFFFD700),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Loading next question...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}