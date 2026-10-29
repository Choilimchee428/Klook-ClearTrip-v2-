import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

// HTTP GET only. Separate server started by run_app.sh on port 3100.
const String serverBaseUrl = 'http://localhost:3100';

Future<List<TravelProduct>> fetchProducts() async {
  final response = await http.get(Uri.parse('$serverBaseUrl/items'))
      .timeout(const Duration(seconds: 7));
  if (response.statusCode != 200) {
    throw Exception('GET /items: HTTP ${response.statusCode}');
  }
  final data = jsonDecode(utf8.decode(response.bodyBytes));
  if (data is! List) throw const FormatException('상품 데이터는 배열이어야 합니다.');
  // The v1 json-server may return string IDs: models accepts either kind.
  return data.map(TravelProduct.fromJson).whereType<TravelProduct>().toList();
}

Future<String> fetchPolicyDetails(String productId) async {
  final response = await http.get(Uri.parse('$serverBaseUrl/policies'))
      .timeout(const Duration(seconds: 7));
  if (response.statusCode != 200) {
    throw Exception('GET /policies: HTTP ${response.statusCode}');
  }
  final data = jsonDecode(utf8.decode(response.bodyBytes));
  if (data is! List) throw const FormatException('정책 데이터 형식이 잘못되었습니다.');
  for (final row in data) {
    if (row is Map && row['productId']?.toString() == productId &&
        row['description'] is String) {
      return row['description'] as String;
    }
  }
  return '해당 상품에 대한 추가 안내가 없습니다.';
}
