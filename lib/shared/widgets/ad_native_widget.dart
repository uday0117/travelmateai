import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:travelmateai/core/services/admob_service.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';

/// Native ad card for feed-style lists (Explore, Trips).
class AdNativeWidget extends StatefulWidget {
  const AdNativeWidget({super.key, this.templateType = TemplateType.medium});

  final TemplateType templateType;

  @override
  State<AdNativeWidget> createState() => _AdNativeWidgetState();
}

class _AdNativeWidgetState extends State<AdNativeWidget> {
  NativeAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<AdMobService>()) return;
    _ad = Get.find<AdMobService>().createNativeAd(
      templateType: widget.templateType,
      onLoaded: (_) => setState(() => _loaded = true),
    );
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: widget.templateType == TemplateType.small ? 100 : 320,
        child: AdWidget(ad: _ad!),
      ),
    );
  }
}
