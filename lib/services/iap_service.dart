import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../domain/repositories/app_settings_repository.dart';

/// Product ID — must match the ID registered in App Store Connect / Google
/// Play Console before publishing.
const String kRemoveAdsProductId = 'remove_ads';

class IapService {
  IapService(this._repository);

  final AppSettingsRepository _repository;
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _storeAvailable = false;
  bool get storeAvailable => _storeAvailable;

  Future<void> initialize() async {
    _storeAvailable = await _iap.isAvailable();
    if (!_storeAvailable) return;

    _subscription = _iap.purchaseStream.listen(
      _handlePurchases,
      onDone: () => _subscription?.cancel(),
      onError: (_) {},
    );

    // Restore any previously completed purchases on startup.
    await _iap.restorePurchases();
  }

  void _handlePurchases(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID != kRemoveAdsProductId) continue;

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _iap.completePurchase(purchase);
        _repository.updateAdsRemoved(true);
      }
    }
  }

  /// Initiates the Remove Ads purchase flow.
  /// Returns [true] if the purchase was successfully initiated.
  Future<bool> purchaseRemoveAds() async {
    if (!_storeAvailable) return false;

    final response = await _iap.queryProductDetails({kRemoveAdsProductId});
    if (response.productDetails.isEmpty) return false;

    final param = PurchaseParam(
      productDetails: response.productDetails.first,
    );
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  /// Asks the store to restore previously completed purchases.
  Future<void> restorePurchases() async {
    if (!_storeAvailable) return;
    await _iap.restorePurchases();
  }

  void dispose() {
    _subscription?.cancel();
  }
}
