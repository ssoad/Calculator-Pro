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

    // Chain animations
    _swipeLeftController.addListener(() {
      if (_swipeLeftController.isCompleted) {
        _swipeRightController.reset();
        _swipeRightController.forward();
      }
    });

    _swipeRightController.addListener(() {
      if (_swipeRightController.isCompleted) {
        _swipeUpController.reset();
        _swipeUpController.forward();
      }
    });

    _swipeUpController.addListener(() {
      if (_swipeUpController.isCompleted) {
        _heartController.reset();
        _heartController.forward();
      }
    });

    _heartController.addListener(() {
      if (_heartController.isCompleted) {
        _swipeLeftController.reset();
        _swipeLeftController.forward();
      }
    });
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
        isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE6E6E6);
    final shadowDark =
        isDark ? Colors.black.withOpacity(0.5) : Colors.grey.shade400;
    final shadowLight = isDark ? Colors.grey.shade700 : Colors.white;
    final accentColor =
        isDark ? const Color(0xFF6E88F7) : const Color(0xFF4367F2);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: shadowDark,
              offset: const Offset(5, 5),
              blurRadius: 7,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: shadowLight,
              offset: const Offset(-5, -5),
              blurRadius: 7,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with logo and title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildNeumorphicIcon(
                      child: Icon(
                        Icons.calculate_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      color: accentColor,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Calculator Pro',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                _buildGithubButton(
                  isDark: isDark,
                  githubIconPath:
                      isDark ? AppConst.githubLight : AppConst.githubDark,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Features section
            _buildFeatureItem(
              animation: _swipeLeftController,
              asset: AppConst.swipeLeftGesture,
              text: 'Access History',
              icon: Icons.history,
              isDark: isDark,
              accentColor: accentColor,
            ),
            _buildFeatureItem(
              animation: _swipeRightController,
              asset: AppConst.swipeRightGesture,
              text: 'Quick Settings',
              icon: Icons.settings,
              isDark: isDark,
              accentColor: accentColor,
            ),
            _buildFeatureItem(
              animation: _swipeUpController,
              asset: AppConst.swipeUpGesture,
              text: 'Smart Features',
              icon: Icons.smart_toy,
              isDark: isDark,
              accentColor: accentColor,
            ),
            _buildFeatureItem(
              animation: _heartController,
              asset: AppConst.heart,
              text: 'Crafted with passion',
              icon: Icons.favorite,
              isDark: isDark,
              accentColor: accentColor,
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildNeumorphicTextButton('Licenses',
                    () => showLicensePage(context: context), isDark),
                const SizedBox(width: 16),
                _buildNeumorphicPrimaryButton('Close',
                    () => Navigator.of(context).pop(), accentColor, isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeumorphicIcon({
    required Widget child,
    required Color color,
    required bool isDark,
    double size = 36,
  }) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color:
                isDark ? Colors.black.withOpacity(0.5) : Colors.grey.shade400,
            offset: const Offset(2, 2),
            blurRadius: 5,
          ),
          BoxShadow(
            color: isDark ? Colors.grey.shade800 : Colors.white,
            offset: const Offset(-2, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGithubButton({
    required String githubIconPath,
    required bool isDark,
  }) {
    final shadowDark =
        isDark ? Colors.black.withOpacity(0.5) : Colors.grey.shade400;
    final shadowLight = isDark ? Colors.grey.shade800 : Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () async {
          try {
            await launchUrl(Uri.parse(AppConst.githubLink));
          } catch (_) {}
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF252525) : const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: shadowDark,
                offset: const Offset(2, 2),
                blurRadius: 5,
              ),
              BoxShadow(
                color: shadowLight,
                offset: const Offset(-2, -2),
                blurRadius: 5,
              ),
            ],
          ),
          child: Lottie.asset(githubIconPath, width: 30, height: 30),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required AnimationController animation,
    required String asset,
    required String text,
    required IconData icon,
    required bool isDark,
    required Color accentColor,
  }) {
    final shadowDark =
        isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade300;
    final shadowLight = isDark ? Colors.grey.shade800 : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: shadowDark,
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: shadowLight,
                  offset: const Offset(-2, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Lottie.asset(
              asset,
              controller: animation,
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeumorphicTextButton(
      String text, VoidCallback onPressed, bool isDark) {
    final backgroundColor =
        isDark ? const Color(0xFF252525) : const Color(0xFFEBEBEB);
    final textColor = isDark ? Colors.white70 : Colors.black54;
    final shadowDark =
        isDark ? Colors.black.withOpacity(0.5) : Colors.grey.shade400;
    final shadowLight = isDark ? Colors.grey.shade800 : Colors.white;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: shadowDark,
              offset: const Offset(2, 2),
              blurRadius: 5,
            ),
            BoxShadow(
              color: shadowLight,
              offset: const Offset(-2, -2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphicPrimaryButton(
      String text, VoidCallback onPressed, Color accentColor, bool isDark) {
    final shadowDark =
        isDark ? Colors.black.withOpacity(0.5) : accentColor.withOpacity(0.5);
    final shadowLight =
        isDark ? accentColor.withOpacity(0.2) : Colors.white.withOpacity(0.5);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: shadowDark,
              offset: const Offset(2, 2),
              blurRadius: 5,
            ),
            BoxShadow(
              color: shadowLight,
              offset: const Offset(-2, -2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
