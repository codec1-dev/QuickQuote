import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class AiQuoteService {
  Future<Quote> generateQuote() async {
    final response = await http.get(Uri.parse('https://thequoteshub.com/api/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return Quote(
        text: data['text'] ?? "No quote found",
        author: data['author'] ?? "Unknown",
      );
    } else {
      throw Exception("Failed to fetch quote");
    }
  }
}
