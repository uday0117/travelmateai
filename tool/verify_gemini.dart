import 'dart:io';

import 'package:dio/dio.dart';
import 'package:travelmateai/config/env_config.dart';

Future<void> main() async {
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    stderr.writeln('FAIL: .env not found');
    exit(1);
  }

  for (final line in envFile.readAsLinesSync()) {
    if (line.startsWith('GEMINI_API_KEY=')) {
      EnvConfig.load(
        gemini: line.substring('GEMINI_API_KEY='.length).trim(),
        openWeather: '',
        exchangeRate: '',
        googleMaps: '',
      );
      break;
    }
  }

  if (EnvConfig.geminiApiKey.isEmpty) {
    stderr.writeln('FAIL: GEMINI_API_KEY is empty in .env');
    exit(1);
  }

  final model = Platform.environment['GEMINI_MODEL'] ?? 'gemini-2.5-flash';

  try {
    final dio = Dio();
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=${EnvConfig.geminiApiKey}';
    final response = await dio.post<Map<String, dynamic>>(
      url,
      data: {
        'contents': [
          {
            'parts': [
              {'text': 'Reply with exactly: TravelMate AI OK'},
            ],
          },
        ],
        'generationConfig': {'maxOutputTokens': 20, 'temperature': 0},
      },
    );
    final candidates = response.data?['candidates'] as List<dynamic>?;
    final parts = (candidates?.first['content'] as Map?)?['parts'] as List?;
    final text = parts?.first['text'] as String? ?? '';
    stdout.writeln('OK: ${text.trim()}');
    stdout.writeln('Model: $model');
  } on DioException catch (e) {
    stderr.writeln('FAIL: HTTP ${e.response?.statusCode}');
    stderr.writeln(e.response?.data ?? e.message);
    exit(1);
  } catch (e) {
    stderr.writeln('FAIL: $e');
    exit(1);
  }
}
