import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/services/currency_service.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/shared/widgets/app_loading_view.dart';
import 'package:travelmateai/shared/widgets/demo_data_banner.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  final _amountCtrl = TextEditingController(text: '100');
  Map<String, double> _rates = {};
  String _from = 'USD';
  String _to = 'EUR';
  bool _loading = true;
  bool _isDemo = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final service = Get.find<CurrencyService>();
    final rates = await service.getRates();
    if (mounted) {
      setState(() {
        _rates = rates;
        _isDemo = service.lastResultWasDemo;
        _loading = false;
      });
    }
  }

  void _logConversion() {
    if (Get.isRegistered<AnalyticsService>()) {
      Get.find<AnalyticsService>().logCurrencyConverted(from: _from, to: _to);
    }
  }

  double _convertedAmount() {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    if (_from == _to) return amount;
    final fromRate = _rates[_from] ?? 1;
    final toRate = _rates[_to] ?? 1;
    return amount * (toRate / fromRate);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: AppLoadingView());

    final codes = _rates.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            if (_isDemo)
              const DemoDataBanner(
                message: 'Sample rates — add EXCHANGE_RATE_API_KEY to .env for live data.',
              ),
            if (_isDemo) const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _from,
                    decoration: const InputDecoration(labelText: 'From'),
                    items: codes
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {
                      setState(() => _from = v ?? _from);
                      _logConversion();
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.arrow_forward),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _to,
                    decoration: const InputDecoration(labelText: 'To'),
                    items: codes
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {
                      setState(() => _to = v ?? _to);
                      _logConversion();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Text(
                      '${_convertedAmount().toStringAsFixed(2)} $_to',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '1 $_from = ${(_rates[_to]! / (_rates[_from] ?? 1)).toStringAsFixed(4)} $_to',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }
}
