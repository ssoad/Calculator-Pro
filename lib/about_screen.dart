import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:neumorphic_calculator/widgets/neumorphic_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
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
    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF252525) : const Color(0xFFEEEEEE);
    final accentColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Header
                _buildAppHeader(accentColor, isDark),
                const SizedBox(height: 32),

                // Features Section
                _buildSectionTitle('Features', isDark),
                const SizedBox(height: 16),
                _buildFeaturesList(isDark, accentColor),
                const SizedBox(height: 32),

                // Social Section
                _buildSectionTitle('Connect', isDark),
                const SizedBox(height: 16),
                _buildSocialButtons(isDark),
                const SizedBox(height: 32),

                // Footer
                _buildCustomFooter(isDark, accentColor),
                const SizedBox(height: 24),

                // Add after the footer section
                const SizedBox(height: 24),

// Licenses Section
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => showLicensePage(context: context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A2A2A)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.grey.shade300,
                              offset: const Offset(5, 5),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color:
                                  isDark ? Colors.grey.shade800 : Colors.white,
                              offset: const Offset(-5, -5),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: accentColor,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Open Source Licenses',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader(Color accentColor, bool isDark) {
    return Center(
      child: Column(
        children: [
          Container(
            height: 120,
            width: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              Icons.calculate_rounded,
              size: 70,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Calculator Pro',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'v1.1.0',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              'The most beautiful calculator app',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeaturesList(bool isDark, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade300,
            offset: const Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: isDark ? Colors.grey.shade800 : Colors.white,
            offset: const Offset(-5, -5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: _features.map((feature) {
          final index = _features.indexOf(feature);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.check,
                    color: accentColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 16),
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
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSocialButtons(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade300,
            offset: const Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: isDark ? Colors.grey.shade800 : Colors.white,
            offset: const Offset(-5, -5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSocialButton(
            icon: isDark ? AppConst.githubLight : AppConst.githubDark,
            onTap: () => _launchUrl(AppConst.githubLink),
            isDark: isDark,
            label: 'GitHub',
          ),
          const SizedBox(width: 24),
          _buildSocialButton(
            icon: Icons.email_outlined,
            onTap: () => _launchUrl('mailto:support@calculator-pro.com'),
            isDark: isDark,
            label: 'Email',
            isIconData: true,
          ),
          const SizedBox(width: 24),
          _buildSocialButton(
            icon: Icons.star_outline,
            onTap: () => _launchUrl(
                'https://play.google.com/store/apps/details?id=com.calctime.film'),
            isDark: isDark,
            label: 'Rate',
            isIconData: true,
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Widget _buildSocialButton({
    required dynamic icon,
    required VoidCallback onTap,
    required bool isDark,
    required String label,
    bool isIconData = false,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Container(
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF303030) : const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.shade400,
                    offset: const Offset(3, 3),
                    blurRadius: 5,
                  ),
                  BoxShadow(
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    offset: const Offset(-3, -3),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: isIconData
                  ? Icon(
                      icon as IconData,
                      size: 30,
                      color: isDark ? Colors.white70 : Colors.black87,
                    )
                  : Lottie.asset(
                      icon as String,
                      width: 30,
                      height: 30,
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomFooter(bool isDark, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                isDark ? Colors.black.withOpacity(0.3) : Colors.grey.shade300,
            offset: const Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: isDark ? Colors.grey.shade800 : Colors.white,
            offset: const Offset(-5, -5),
            blurRadius: 10,
            spreadRadius: 1,
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
                  fontSize: 16,
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
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
              Text(
                ' by SSoad',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
}
