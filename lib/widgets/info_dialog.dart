import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoDialog extends StatefulWidget {
  const InfoDialog({super.key});

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> with TickerProviderStateMixin {
  late AnimationController _swipeRightController;
  late AnimationController _swipeLeftController;
  late AnimationController _swipeUpController;
  late AnimationController _heartController;
  void _initAnimations() {
    _swipeRightController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _swipeLeftController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _swipeUpController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _heartController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _swipeLeftController.forward();
    _swipeLeftController.addListener(
      () {
        if (_swipeLeftController.isCompleted) {
          _swipeRightController.reset();
          _swipeRightController.forward();
        }
      },
    );

    _swipeRightController.addListener(
      () {
        if (_swipeRightController.isCompleted) {
          _swipeUpController.reset();
          _swipeUpController.forward();
        }
      },
    );

    _swipeUpController.addListener(
      () {
        if (_swipeUpController.isCompleted) {
          _heartController.reset();
          _heartController.forward();
        }
      },
    );

    _heartController.addListener(
      () {
        if (_heartController.isCompleted) {
          _swipeLeftController.reset();
          _swipeLeftController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _swipeRightController.dispose();
    _swipeLeftController.dispose();
    _swipeUpController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);
    final shadowColor = isDark ? Colors.black38 : Colors.grey.shade400;
    final lightColor = isDark
        ? Colors.grey.shade800.withOpacity(0.5)
        : Colors.white.withOpacity(0.8);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(3, 3),
              blurRadius: 10,
              spreadRadius: 0.5,
            ),
            BoxShadow(
              color: lightColor,
              offset: const Offset(-3, -3),
              blurRadius: 10,
              spreadRadius: 0.5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calculator Pro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                    shadows: [
                      BoxShadow(
                        color: shadowColor,
                        offset: const Offset(2, 2),
                        blurRadius: 3,
                      ),
                      BoxShadow(
                        color: lightColor,
                        offset: const Offset(-2, -2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                _buildNeumorphicIcon(
                    githubIconPath:
                        isDark ? AppConst.githubLight : AppConst.githubDark),
              ],
            ),
            const SizedBox(height: 20),
            _buildFeatureItem(
              animation: _swipeLeftController,
              asset: AppConst.swipeLeftGesture,
              text: 'Access History',
              isDark: isDark,
            ),
            _buildFeatureItem(
              animation: _swipeRightController,
              asset: AppConst.swipeRightGesture,
              text: 'Quick Settings',
              isDark: isDark,
            ),
            _buildFeatureItem(
              animation: _swipeUpController,
              asset: AppConst.swipeUpGesture,
              text: 'Smart Features',
              isDark: isDark,
            ),
            _buildFeatureItem(
              animation: _heartController,
              asset: AppConst.heart,
              text: 'Crafted with passion by Calculator Pro Team',
              isDark: isDark,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildNeumorphicButton('Licenses',
                    () => showLicensePage(context: context), isDark),
                const SizedBox(width: 10),
                _buildNeumorphicButton(
                    'Close', () => Navigator.of(context).pop(), isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeumorphicIcon({required String githubIconPath}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        try {
          await launchUrl(Uri.parse(AppConst.githubLink));
        } catch (_) {}
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black12 : Colors.grey.shade300,
              offset: const Offset(2, 2),
              blurRadius: 5,
            ),
            BoxShadow(
              color:
                  isDark ? Colors.grey.shade800.withOpacity(0.5) : Colors.white,
              offset: const Offset(-2, -2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Lottie.asset(githubIconPath, width: 35, height: 35),
      ),
    );
  }

  Widget _buildFeatureItem({
    required AnimationController animation,
    required String asset,
    required String text,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black12 : Colors.grey.shade300,
            offset: const Offset(2, 2),
            blurRadius: 5,
          ),
          BoxShadow(
            color:
                isDark ? Colors.grey.shade800.withOpacity(0.5) : Colors.white,
            offset: const Offset(-2, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.withOpacity(0.1),
            ),
            child: Lottie.asset(asset,
                controller: animation, width: 40, height: 40),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeumorphicButton(
      String text, VoidCallback onPressed, bool isDark) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black12 : Colors.grey.shade300,
              offset: const Offset(2, 2),
              blurRadius: 5,
            ),
            BoxShadow(
              color:
                  isDark ? Colors.grey.shade800.withOpacity(0.5) : Colors.white,
              offset: const Offset(-2, -2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
