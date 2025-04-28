import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  // Flag to prevent showing too many ads
  DateTime? _lastInterstitialShown;
  int _calculationsCounter = 0;
  final int _calculationsThreshold = 8; // Show ad after this many calculations

  // Banner ad instances
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  bool _isAdManagerInitialized = false;
  bool _isBannerAdLoaded = false;
  bool get isBannerAdLoaded => _isBannerAdLoaded;

  // Test ad units - Replace with your real ones for production
  // Banner Ads
  final String _androidBannerAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/6300978111' // Test ad unit
      : 'ca-app-pub-6977171798368884/2291246096';

  final String _iosBannerAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/2934735716' // Test ad unit
      : 'ca-app-pub-YOUR_REAL_BANNER_ID_HERE';

  // Interstitial Ads
  final String _androidInterstitialAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/1033173712' // Test ad unit
      : 'ca-app-pub-6977171798368884/6697394969';

  final String _iosInterstitialAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/4411468910' // Test ad unit
      : 'ca-app-pub-YOUR_REAL_INTERSTITIAL_ID_HERE';

  // Rewarded Interstitial Ads
  final String _androidRewardedInterstitialAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/5354046379' // Test ad unit
      : 'ca-app-pub-6977171798368884/7080522434';

  final String _iosRewardedInterstitialAdUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/6978759866' // Test ad unit
      : 'ca-app-pub-YOUR_REAL_REWARDED_INTERSTITIAL_ID_HERE';

  String get bannerAdUnitId {
    return Platform.isAndroid ? _androidBannerAdUnitId : _iosBannerAdUnitId;
  }

  String get interstitialAdUnitId {
    return Platform.isAndroid
        ? _androidInterstitialAdUnitId
        : _iosInterstitialAdUnitId;
  }

  String get rewardedInterstitialAdUnitId {
    return Platform.isAndroid
        ? _androidRewardedInterstitialAdUnitId
        : _iosRewardedInterstitialAdUnitId;
  }

  /// Initialize the AdMob SDK and request ATT permission on iOS
  Future<void> initialize() async {
    if (_isAdManagerInitialized) return;

    // Initialize the Google Mobile Ads SDK
    await MobileAds.instance.initialize();

    // Request App Tracking Transparency authorization on iOS (required for iOS 14+)
    if (Platform.isIOS) {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(seconds: 1));
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    }

    _isAdManagerInitialized = true;

    // Preload ads
    loadBannerAd();
    loadInterstitialAd();
    loadRewardedInterstitialAd();
  }

  /// Load a banner ad
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isBannerAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerAdLoaded = false;
          ad.dispose();
          // Retry after a delay
          Future.delayed(const Duration(minutes: 1), () => loadBannerAd());
        },
      ),
    );

    _bannerAd?.load();
  }

  /// Get the banner ad widget for display
  Widget getBannerAdWidget() {
    if (_bannerAd == null || !_isBannerAdLoaded) {
      return const SizedBox(height: 50); // Placeholder height
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  /// Load an interstitial ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;

          // Add full screen listener to reload after ad is shown
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd(); // Preload next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd(); // Retry loading
            },
          );
        },
        onAdFailedToLoad: (error) {
          // Retry after a delay
          Future.delayed(
              const Duration(minutes: 1), () => loadInterstitialAd());
        },
      ),
    );
  }

  /// Show interstitial ad if conditions are met
  Future<bool> showInterstitialAd() async {
    // Check if ad is available
    if (_interstitialAd == null) {
      loadInterstitialAd();
      return false;
    }

    // Check if enough time has passed since last ad (at least 1 minute)
    if (_lastInterstitialShown != null) {
      final difference = DateTime.now().difference(_lastInterstitialShown!);
      if (difference.inMinutes < 3) {
        return false;
      }
    }

    // Show the ad
    await _interstitialAd!.show();
    _lastInterstitialShown = DateTime.now();
    return true;
  }

  /// Load a rewarded interstitial ad
  void loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: rewardedInterstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialAd = ad;

          // Add full screen listener to reload after ad is shown
          _rewardedInterstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedInterstitialAd = null;
              loadRewardedInterstitialAd(); // Preload next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedInterstitialAd = null;
              loadRewardedInterstitialAd(); // Retry loading
            },
          );
        },
        onAdFailedToLoad: (error) {
          // Retry after a delay
          Future.delayed(
              const Duration(minutes: 1), () => loadRewardedInterstitialAd());
        },
      ),
    );
  }

  /// Show rewarded interstitial ad
  Future<bool> showRewardedInterstitialAd({
    required Function(RewardItem reward) onRewarded,
  }) async {
    // Check if ad is available
    if (_rewardedInterstitialAd == null) {
      loadRewardedInterstitialAd();
      return false;
    }

    // Show the ad
    await _rewardedInterstitialAd!.show(
      onUserEarnedReward: (_, reward) {
        onRewarded(reward);
      },
    );
    return true;
  }

  /// Increment calculation counter and check if we should show an ad
  Future<void> trackCalculation() async {
    _calculationsCounter++;

    // Show interstitial after certain number of calculations
    if (_calculationsCounter >= _calculationsThreshold) {
      _calculationsCounter = 0; // Reset counter
      await showInterstitialAd();
    }
  }

  /// Clean up resources
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedInterstitialAd?.dispose();
  }
}
