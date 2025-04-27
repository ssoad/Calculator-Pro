// Rename this file to about_dialog.dart since it no longer contains MadeBy

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:url_launcher/url_launcher.dart';

class CalculatorAboutDialog extends StatefulWidget {
  const CalculatorAboutDialog({Key? key}) : super(key: key);

  @override
  State<CalculatorAboutDialog> createState() => _CalculatorAboutDialogState();
}

class _CalculatorAboutDialogState extends State<CalculatorAboutDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _heartAnimationController;
  final List<String> _features = [
    'Modern neumorphic design',
    'Dark & light themes',
    'Multiple color schemes',
    'Custom fonts',
    'History view',
    'Customizable buttons',
    'Splash animations'
  ];

  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _heartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF252525) : const Color(0xFFEEEEEE);
    final accentColor = Theme.of(context).colorScheme.primary;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _animationController.value,
            child: Opacity(
              opacity: _animationController.value,
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.5)
                    : Colors.grey.shade400,
                offset: const Offset(8, 8),
                blurRadius: 20,
              ),
              BoxShadow(
                color: isDark ? Colors.grey.shade800 : Colors.white,
                offset: const Offset(-8, -8),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accentColor,
                        accentColor.withOpacity(0.7),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: _buildAppLogo(isDark),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Calculator Pro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'v1.1.0',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Features',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeaturesList(isDark, accentColor),
                    const SizedBox(height: 24),
                    _buildSocialButtons(isDark),
                    const SizedBox(height: 24),
                    _buildCustomFooter(isDark, accentColor),
                  ],
                ),
              ),

              // Actions
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildButton(
                      'Licenses',
                      onPressed: () {
                        Navigator.pop(context);
                        showLicensePage(context: context);
                      },
                      isDark: isDark,
                      isPrimary: false,
                    ),
                    const SizedBox(width: 12),
                    _buildButton(
                      'Close',
                      onPressed: () => Navigator.pop(context),
                      isDark: isDark,
                      isPrimary: true,
                      accentColor: accentColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomFooter(bool isDark, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF303030) : const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade300,
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: isDark ? Colors.grey.shade800 : Colors.white,
            offset: const Offset(-3, -3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Made with ',
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              AnimatedBuilder(
                animation: _heartAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_heartAnimationController.value * 0.3),
                    child: Transform.rotate(
                      angle: _heartAnimationController.value * 0.1,
                      child: const Text(
                        '❤️',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
              Text(
                ' in Flutter',
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
              ),
              children: [
                const TextSpan(text: '© 2024 '),
                TextSpan(
                  text: 'Calculator Pro',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                const TextSpan(text: '. All rights reserved.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppLogo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      // child: Lottie.asset(
      //   AppConst.calculatorAnimation,
      //   fit: BoxFit.contain,
      // ),
    );
  }

  Widget _buildFeaturesList(bool isDark, Color accentColor) {
    return Column(
      children: _features.map((feature) {
        final index = _features.indexOf(feature);
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 100)),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(20 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.check,
                    color: accentColor,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    feature,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSocialButtons(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: isDark ? AppConst.githubLight : AppConst.githubDark,
          onTap: () => launchUrl(Uri.parse(AppConst.githubLink)),
          isDark: isDark,
        ),
        const SizedBox(width: 16),
        // _buildSocialButton(
        //   icon: AppConst.twitterIcon,
        //   onTap: () => launchUrl(Uri.parse('https://twitter.com/your_twitter')),
        //   isDark: isDark,
        // ),
        // const SizedBox(width: 16),
        // _buildSocialButton(
        //   icon: AppConst.linkedinIcon,
        //   onTap: () => launchUrl(Uri.parse('https://linkedin.com/in/your_linkedin')),
        //   isDark: isDark,
        // ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF303030) : const Color(0xFFE6E6E6),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.shade400,
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
              BoxShadow(
                color: isDark ? Colors.grey.shade800 : Colors.white,
                offset: const Offset(-2, -2),
                blurRadius: 4,
              ),
            ],
          ),
          child: SizedBox(
            height: 24,
            width: 24,
            child: Lottie.asset(icon),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    String text, {
    required VoidCallback onPressed,
    required bool isDark,
    bool isPrimary = false,
    Color? accentColor,
  }) {
    final backgroundColor = isPrimary
        ? accentColor ?? Colors.blue
        : isDark
            ? const Color(0xFF303030)
            : const Color(0xFFE6E6E6);
    final textColor =
        isPrimary ? Colors.white : (isDark ? Colors.white70 : Colors.black87);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.shade300,
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
              BoxShadow(
                color: isDark ? Colors.grey.shade800 : Colors.white,
                offset: const Offset(-2, -2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
