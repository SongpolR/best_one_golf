import 'dart:async';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // Test ad unit IDs — replace with real IDs before publishing.
  static String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1860869647825336~6107390768';
    }
    return 'ca-app-pub-1860869647825336~9882879042';
  }

  InterstitialAd? _ad;
  bool _isLoading = false;

  void preload() {
    if (_isLoading || _ad != null) return;
    _isLoading = true;
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (_) {
          _ad = null;
          _isLoading = false;
        },
      ),
    );
  }

  bool get isReady => _ad != null;

  /// Shows the interstitial ad. Returns [true] if the ad was shown
  /// successfully, [false] if no ad was available.
  Future<bool> show() async {
    if (_ad == null) return false;

    final completer = Completer<bool>();
    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        preload();
        if (!completer.isCompleted) completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _ad = null;
        preload();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    await _ad!.show();
    return completer.future;
  }

  void dispose() {
    _ad?.dispose();
    _ad = null;
  }
}
