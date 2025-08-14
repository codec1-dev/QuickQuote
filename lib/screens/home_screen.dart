import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/quote_service.dart';
import '../widgets/quote_card.dart';

class HomeScreen extends StatefulWidget {
  final List<Quote> favorites;
  final Function(Quote) onToggleFavorite;

  const HomeScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AiQuoteService _aiService = AiQuoteService();
  Quote? _quote;
  bool _loading = false;

  bool _isFavorite(Quote? quote) {
    if (quote == null) return false;
    return widget.favorites.any(
          (favQuote) =>
      favQuote.text == quote.text && favQuote.author == quote.author,
    );
  }

  @override
  void initState() {
    super.initState();
    _getQuote();
  }

  Future<void> _getQuote() async {
    setState(() => _loading = true);
    try {
      final quote = await _aiService.generateQuote();
      setState(() => _quote = quote);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed to get quote")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _loading
          ? const CircularProgressIndicator()
          : _quote != null
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QuoteCard(
            quote: _quote!,
            isFavorited: _isFavorite(_quote),
            onFavoriteToggle: () =>
                widget.onToggleFavorite(_quote!),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _getQuote,
            icon: const Icon(Icons.refresh),
            label: const Text("New Quote"),
          ),
        ],
      )
          : const Text("No quote yet"),
    );
  }
}
