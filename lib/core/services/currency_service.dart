import 'package:get_storage/get_storage.dart';
import 'package:travelmateai/config/env_config.dart';
import 'package:travelmateai/core/constants/api_constants.dart';
import 'package:travelmateai/core/network/api_client.dart';

class CurrencyRate {
  const CurrencyRate({required this.code, required this.rate, required this.updatedAt});
  final String code;
  final double rate;
  final DateTime updatedAt;
}

class CurrencyService {
  CurrencyService(this._apiClient, this._storage);

  final ApiClient _apiClient;
  final GetStorage _storage;
  static const _cacheKey = 'currency_rates';
  static const _cacheTimeKey = 'currency_rates_time';

  static const defaultFavorites = ['USD', 'EUR', 'GBP', 'INR', 'JPY'];

  bool lastResultWasDemo = false;

  Future<Map<String, double>> getRates({String base = 'USD'}) async {
    final cached = _readCache(base);
    if (cached != null) {
      lastResultWasDemo = false;
      return cached;
    }

    final key = EnvConfig.exchangeRateApiKey;
    if (key.isEmpty) {
      lastResultWasDemo = true;
      return _demoRates(base);
    }

    try {
      final res = await _apiClient.dio.get<Map<String, dynamic>>(
        '${ApiConstants.exchangeRateBaseUrl}/$key/latest/$base',
      );
      final rates = (res.data!['conversion_rates'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble()));
      lastResultWasDemo = false;
      _writeCache(base, rates);
      return rates;
    } catch (_) {
      lastResultWasDemo = true;
      return _demoRates(base);
    }
  }

  double convert({required double amount, required double rate}) => amount * rate;

  List<String> getFavorites() {
    final list = _storage.read<List<dynamic>>('currency_favorites');
    return list?.cast<String>() ?? defaultFavorites;
  }

  Future<void> toggleFavorite(String code) async {
    final favs = getFavorites().toList();
    if (favs.contains(code)) {
      favs.remove(code);
    } else {
      favs.add(code);
    }
    await _storage.write('currency_favorites', favs);
  }

  Map<String, double>? _readCache(String base) {
    final time = _storage.read<int>(_cacheTimeKey);
    if (time == null) return null;
    if (DateTime.now().millisecondsSinceEpoch - time > 3600000) return null;
    final data = _storage.read<Map<String, dynamic>>('${_cacheKey}_$base');
    return data?.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }

  void _writeCache(String base, Map<String, double> rates) {
    _storage.write('${_cacheKey}_$base', rates);
    _storage.write(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  Map<String, double> _demoRates(String base) => {
        'USD': 1,
        'EUR': 0.92,
        'GBP': 0.79,
        'INR': 83.12,
        'JPY': 149.5,
        'AUD': 1.53,
        'CAD': 1.36,
        'CHF': 0.88,
        'CNY': 7.24,
        'AED': 3.67,
      };
}
