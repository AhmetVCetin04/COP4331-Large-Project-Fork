import 'package:flutter/material.dart';
import 'dart:async';
import '../models/user.dart';
import '../services/quiz_session.dart';
import '../services/quiz_services.dart';
import 'quiz_question_screen.dart';

class WaitingRoomScreen extends StatefulWidget {
  final User user;
  final QuizSession session;

  const WaitingRoomScreen({
    Key? key,
    required this.user,
    required this.session,
  }) : super(key: key);

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  Timer? _pollTimer;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (_isChecking) return;

      setState(() => _isChecking = true);

      try {
        final updatedSession = await QuizService.getQuizStatus(
          widget.session.testID,
          widget.user.token ?? '',
        );
        
        if (updatedSession.isLive && updatedSession.currentQuestion >= 0) {
          _pollTimer?.cancel();
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => QuizQuestionScreen(
                  user: widget.user,
                  session: updatedSession,
                ),
              ),
            );
          }
        }
      } catch (e) {
        print('Error polling: $e');
      } finally {
        if (mounted) setState(() => _isChecking = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF272727),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFC904)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Knighthoot',
          style: TextStyle(
            color: Color(0xFFFFC904),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background decorative squares
          Positioned(
            top: 50,
            right: 30,
            child: _buildHollowSquare(200, 2),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: _buildHollowSquare(200, 2),
          ),
          Positioned(
            bottom: 200,
            right: 50,
            child: _buildHollowSquare(80, 2),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            child: _buildHollowSquare(50, 2),
          ),
          Positioned(
            top: 300,
            right: 70,
            child: _buildHollowSquare(35, 2),
          ),
          Positioned(
            top: 400,
            left: 60,
            child: _buildHollowSquare(45, 2),
          ),
          Positioned(
            bottom: 200,
            left: 80,
            child: _buildHollowSquare(150, 2),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated hourglass icon
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 2),
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: 0.8 + (value * 0.2),
                          child: Icon(
                            Icons.hourglass_empty,
                            size: 100,
                            color: Color(0xFFFFC904).withOpacity(value),
                          ),
                        );
                      },
                      onEnd: () {
                        if (mounted) setState(() {});
                      },
                    ),
                    const SizedBox(height: 32),

                    // Test name
                    Text(
                      widget.session.testName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFC904),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Waiting message
                    const Text(
                      'Waiting for teacher to start...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Info container
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF272727),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF333333),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Student name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.person,
                                color: Color(0xFFFFC904),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.user.firstName} ${widget.user.lastName}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Divider
                          Container(
                            height: 1,
                            color: const Color(0xFF333333),
                          ),
                          const SizedBox(height: 16),

                          // Quiz code
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.pin,
                                color: Color(0xFFFFC904),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Quiz Code: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                widget.session.testID,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFC904),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Loading indicator
                    const CircularProgressIndicator(
                      color: Color(0xFFFFC904),
                    ),
                    const SizedBox(height: 16),

                    // Status text
                    const Text(
                      'Checking for updates...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHollowSquare(double size, double borderWidth) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF272727),
          width: borderWidth,
        ),
      ),
    );
  }
}