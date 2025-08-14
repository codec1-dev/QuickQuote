import 'package:shared_preferences/shared_preferences.dart';

class SaveQuoteService {
  static const _savedKey = 'saved_quotes';

  Future<void> saveQuote(String quoteText) async {
    final prefs = await SharedPreferences.getInstance();
    final savedQuotes = prefs.getStringList(_savedKey) ?? [];
    savedQuotes.add(quoteText);
    await prefs.setStringList(_savedKey, savedQuotes);
  }

  Future<List<String>> getSavedQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_savedKey) ?? [];
  }

  Future<void> clearQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedKey);
  }
}
