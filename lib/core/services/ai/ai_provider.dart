/// AI chat/completion request.
class AiRequest {
  const AiRequest({
    required this.prompt,
    this.systemInstruction,
    this.temperature = 0.7,
    this.maxTokens = 2048,
  });

  final String prompt;
  final String? systemInstruction;
  final double temperature;
  final int maxTokens;
}

/// AI provider response.
class AiResponse {
  const AiResponse({
    required this.text,
    this.model,
    this.tokensUsed,
  });

  final String text;
  final String? model;
  final int? tokensUsed;
}

/// Abstract AI provider — swap Gemini for OpenAI, Claude, etc.
abstract class AiProvider {
  String get providerName;

  Future<AiResponse> complete(AiRequest request);

  Stream<String> streamComplete(AiRequest request);
}
