import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../widgets/quote_card.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Quote> favorites;
  final Function(Quote) onToggleFavorite;

  const FavoriteScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  bool _isFavorite(Quote quote) {
    return favorites.any(
            (fav) => fav.text == quote.text && fav.author == quote.author);
  }

  @override
  Widget build(BuildContext context) {
    return favorites.isEmpty
        ? const Center(child: Text("No favorites yet"))
        : ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final quote = favorites[index];
        return QuoteCard(
          quote: quote,
          isFavorited: _isFavorite(quote),
          onFavoriteToggle: () => onToggleFavorite(quote),
        );
      },
    );
  }
}
