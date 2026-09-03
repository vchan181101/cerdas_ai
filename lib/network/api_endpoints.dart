class ApiEndpoints {
  // Base URL - Ganti dengan URL Production Anda
  static const String baseUrl = "https://api.aicerdas.com/v1";
  
  // Auth Endpoints
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String refreshToken = "/auth/refresh";

  // AI & Processing Endpoints
  static const String chat = "/ai/chat";
  static const String analyzeDocument = "/ai/analyze-doc";
  static const String voiceToText = "/ai/voice-to-text";

  // User Endpoints
  static const String profile = "/user/profile";
  static const String updateProfile = "/user/update";
}
