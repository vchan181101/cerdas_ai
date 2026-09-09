enum GeminiTier {
  free(
    id: "gemini-1.5-flash",
    name: "Gemini Free (Flash)",
    desc: "Cepat, gratis, cocok untuk dokumen harian",
    badgeColor: 0xFF4CAF50, // Hijau
  ),
  plus(
    id: "gemini-1.5-flash-8b",
    name: "Google AI Plus (Speed)",
    desc: "Sangat responsif untuk ekstraksi data singkat",
    badgeColor: 0xFF00BCD4, // Cyan
  ),
  pro(
    id: "gemini-1.5-pro",
    name: "Google AI Pro",
    desc: "Penalaran tinggi untuk analisis dokumen kompleks",
    badgeColor: 0xFF3F51B5, // Indigo
  ),
  ultra(
    id: "gemini-1.5-pro",
    name: "Google AI Ultra",
    desc: "Kapasitas analisis mendalam & akurasi tertinggi",
    badgeColor: 0xFF9C27B0, // Ungu
  );

  final String id;
  final String name;
  final String desc;
  final int badgeColor;

  const GeminiTier({
    required this.id,
    required this.name,
    required this.desc,
    required this.badgeColor,
  });
}