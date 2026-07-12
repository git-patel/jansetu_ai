class AIRequest {
  final String prompt;
  final List<Map<String, dynamic>>? history;
  final Map<String, dynamic>? options;

  const AIRequest({
    required this.prompt,
    this.history,
    this.options,
  });
}

class AIResponse {
  final String text;
  final bool isMock;
  final String? error;

  const AIResponse({
    required this.text,
    this.isMock = false,
    this.error,
  });
}

abstract class AIService {
  Future<AIResponse> generate(AIRequest request);
}
