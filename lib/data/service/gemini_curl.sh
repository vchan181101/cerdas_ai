# Struktur Request Gemini API (Konsep cURL)
# File ini digunakan sebagai referensi untuk pengujian API secara manual via terminal atau Postman.

curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=API_KEY_ANDA" \
-H 'Content-Type: application/json' \
-X POST \
-d '{
  "contents": [{
    "parts":[{"text": "Jelaskan apa itu AI"}]
  }]
}'
