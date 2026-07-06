import 'package:dio/dio.dart';
import 'package:travelmateai/config/env_config.dart';
import 'package:travelmateai/core/constants/api_constants.dart';
import 'package:travelmateai/core/errors/exceptions.dart';
import 'package:travelmateai/core/services/ai/ai_provider.dart';

/// Google Gemini implementation of [AiProvider].
class GeminiAiProvider implements AiProvider {
  GeminiAiProvider({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const _model = 'gemini-2.5-flash';

  @override
  String get providerName => 'gemini';

  @override
  Future<AiResponse> complete(AiRequest request) async {
    _ensureApiKey();

    final url =
        '${ApiConstants.geminiBaseUrl}/models/$_model:generateContent?key=${EnvConfig.geminiApiKey}';

    final body = _buildBody(request);

    try {
      final response = await _dio.post<Map<String, dynamic>>(url, data: body);
      final text = _extractText(response.data);
      return AiResponse(text: text, model: _model);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?.toString() ?? e.message ?? 'Gemini request failed',
      );
    }
  }

  @override
  Stream<String> streamComplete(AiRequest request) async* {
    final response = await complete(request);
    yield response.text;
  }

  Map<String, dynamic> _buildBody(AiRequest request) {
    return {
      'contents': [
        {
          'parts': [
            {'text': request.prompt},
          ],
        },
      ],
      if (request.systemInstruction != null)
        'systemInstruction': {
          'parts': [
            {'text': request.systemInstruction},
          ],
        },
      'generationConfig': {
        'temperature': request.temperature,
        'maxOutputTokens': request.maxTokens,
      },
    };
  }

  String _extractText(Map<String, dynamic>? data) {
    final candidates = data?['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw const ServerException('Empty AI response');
    }

    final content = candidates.first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    if (parts == null || parts.isEmpty) {
      throw const ServerException('Invalid AI response format');
    }

    return parts.first['text'] as String? ?? '';
  }

  void _ensureApiKey() {
    if (EnvConfig.geminiApiKey.isEmpty) {
      throw const ServerException(
        'Gemini API key not configured. Add GEMINI_API_KEY to .env',
      );
    }
  }
}
