import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:travelmateai/core/constants/ad_constants.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/services/remote_config_service.dart';

/// Google AdMob — app open, banner, interstitial, native, rewarded.
class AdMobService extends GetxService {
  final RxBool isInitialized = false.obs;
  final RxBool adsEnabled = true.obs;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  AppOpenAd? _appOpenAd;
  DateTime? _appOpenAdLoadTime;
  NativeAd? _nativeAd;

  bool _isShowingAppOpenAd = false;
  bool _splashComplete = false;
  DateTime? _lastAppOpenAdShownAt;
  DateTime? _backgroundedAt;

  static const _appOpenAdMaxAge = Duration(hours: 4);
  static const _appOpenAdCooldown = Duration(minutes: 4);
  static const _minBackgroundDuration = Duration(seconds: 5);

  DateTime? _lastInterstitialShown;
  Duration _interstitialCooldown =
      const Duration(minutes: AdConstants.defaultInterstitialCooldownMinutes);

  static const appOpenAdUnitId = AdConstants.appOpenAdUnitId;
  static const bannerAdUnitId = AdConstants.bannerAdUnitId;
  static const interstitialAdUnitId = AdConstants.interstitialAdUnitId;
  static const rewardedAdUnitId = AdConstants.rewardedAdUnitId;
  static const nativeAdUnitId = AdConstants.nativeAdUnitId;

  Future<AdMobService> init() async {
    try {
      await MobileAds.instance.initialize();
      isInitialized.value = true;
      applyRemoteConfig();
      _loadInterstitial();
      _loadRewarded();
      _loadAppOpenAd();
    } catch (e, st) {
      AppLogger.warning('AdMob init failed', e, st);
    }
    return this;
  }

  /// Sync ad flags and cooldown from Firebase Remote Config.
  void applyRemoteConfig() {
    if (!Get.isRegistered<RemoteConfigService>()) return;
    final config = Get.find<RemoteConfigService>();
    adsEnabled.value = config.enableAds;
    _interstitialCooldown = Duration(minutes: config.interstitialCooldownMinutes);
  }

  void _logAdClick(String adType) {
    if (Get.isRegistered<AnalyticsService>()) {
      Get.find<AnalyticsService>().logAdClicked(adType: adType);
    }
  }

  BannerAd? createBanner() {
    if (!adsEnabled.value || !isInitialized.value) return null;
    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdClicked: (_) => _logAdClick('banner'),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
    return _bannerAd;
  }

  void _loadAppOpenAd() {
    if (!adsEnabled.value) return;
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAdLoadTime = DateTime.now();
        },
        onAdFailedToLoad: (_) {
          _appOpenAd = null;
          _appOpenAdLoadTime = null;
        },
      ),
    );
  }

  /// Called when splash finishes so app-open ads do not block cold start.
  void markSplashComplete() {
    _splashComplete = true;
  }

  /// Track when the app truly leaves the foreground (not ad overlay transitions).
  void onAppBackgrounded() {
    if (!_isShowingAppOpenAd) {
      _backgroundedAt = DateTime.now();
    }
  }

  bool get _isAppOpenAdAvailable {
    final ad = _appOpenAd;
    final loadedAt = _appOpenAdLoadTime;
    if (ad == null || loadedAt == null) return false;
    return DateTime.now().difference(loadedAt) < _appOpenAdMaxAge;
  }

  void showAppOpenAdIfAvailable() {
    if (!adsEnabled.value || !isInitialized.value) return;
    if (!_splashComplete || _isShowingAppOpenAd || !_isAppOpenAdAvailable) {
      return;
    }

    final backgroundedAt = _backgroundedAt;
    if (backgroundedAt == null) return;
    if (DateTime.now().difference(backgroundedAt) < _minBackgroundDuration) {
      return;
    }

    final lastShown = _lastAppOpenAdShownAt;
    if (lastShown != null &&
        DateTime.now().difference(lastShown) < _appOpenAdCooldown) {
      return;
    }

    final ad = _appOpenAd!;
    _isShowingAppOpenAd = true;
    _backgroundedAt = null;
    _appOpenAd = null;
    _appOpenAdLoadTime = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdClicked: (_) => _logAdClick('app_open'),
      onAdDismissedFullScreenContent: (dismissedAd) {
        dismissedAd.dispose();
        _isShowingAppOpenAd = false;
        _lastAppOpenAdShownAt = DateTime.now();
        _loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (failedAd, _) {
        failedAd.dispose();
        _isShowingAppOpenAd = false;
        _loadAppOpenAd();
      },
    );
    ad.show();
  }

  void _loadInterstitial() {
    if (!adsEnabled.value) return;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (_) => _interstitialAd = null,
      ),
    );
  }

  /// Shows interstitial only outside critical flows and with cooldown.
  void showInterstitial({bool force = false}) {
    if (!adsEnabled.value) return;
    if (!force) {
      final last = _lastInterstitialShown;
      if (last != null &&
          DateTime.now().difference(last) < _interstitialCooldown) {
        return;
      }
    }
    _interstitialAd?.show();
    _lastInterstitialShown = DateTime.now();
    _interstitialAd = null;
    _loadInterstitial();
  }

  void _loadRewarded() {
    if (!adsEnabled.value) return;
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (_) => _rewardedAd = null,
      ),
    );
  }

  /// Rewarded ad for optional boosts (e.g. AI itinerary) — never blocks core flows.
  Future<bool> showRewarded({VoidCallback? onReward}) async {
    if (!adsEnabled.value || _rewardedAd == null) return false;
    var rewarded = false;
    await _rewardedAd!.show(
      onUserEarnedReward: (_, reward) {
        rewarded = true;
        onReward?.call();
      },
    );
    _rewardedAd = null;
    _loadRewarded();
    return rewarded;
  }

  NativeAd? createNativeAd({
    required TemplateType templateType,
    void Function(NativeAd ad)? onLoaded,
  }) {
    if (!adsEnabled.value || !isInitialized.value) return null;
    _nativeAd?.dispose();
    _nativeAd = NativeAd(
      adUnitId: nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) => onLoaded?.call(ad as NativeAd),
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          _nativeAd = null;
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: templateType,
        mainBackgroundColor: Colors.transparent,
        cornerRadius: 12,
      ),
    )..load();
    return _nativeAd;
  }

  @override
  void onClose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _appOpenAd?.dispose();
    _nativeAd?.dispose();
    super.onClose();
  }
}
