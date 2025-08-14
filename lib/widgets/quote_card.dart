import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote.dart';

class QuoteCard extends StatefulWidget {
  final Quote quote;
  final bool isFavorited;
  final VoidCallback onFavoriteToggle;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.isFavorited,
    required this.onFavoriteToggle,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  final List<Color> cardColors = [
    Colors.teal.shade100,
    Colors.pink.shade100,
    Colors.blue.shade100,
    Colors.orange.shade100,
    Colors.green.shade100,
    Colors.purple.shade100,
    Colors.amber.shade100,
  ];

  late Color bgColor;
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    bgColor = cardColors[Random().nextInt(cardColors.length)];
  }

  void _shareQuote() {
    final textToShare = '"${widget.quote.text}"\n\n— ${widget.quote.author}';
    Share.share(textToShare);
  }

  void _copyQuote() {
    final quoteText = '"${widget.quote.text}"\n\n— ${widget.quote.author}';
    Clipboard.setData(ClipboardData(text: quoteText));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Quote copied to clipboard!")));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxCardHeight = screenHeight * 0.6;
    final textColor = Colors.black;

    return Container(
      constraints: BoxConstraints(maxHeight: maxCardHeight),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.format_quote, size: 36, color: textColor.withOpacity(0.6)),
          const SizedBox(height: 12),

          // Scroll only if needed
          Flexible(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '"${widget.quote.text}"',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '— ${widget.quote.author}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isFavorited = !isFavorited;
                    widget.onFavoriteToggle();
                  });
                },
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : Colors.black54,
                ),
                tooltip: isFavorited ? 'Unfavorite' : 'Favorite',
              ),
              IconButton(
                onPressed: _copyQuote,
                icon: const Icon(Icons.copy, color: Colors.black87),
                tooltip: 'Copy Quote',
              ),
              IconButton(
                onPressed: _shareQuote,
                icon: const Icon(Icons.share_outlined, color: Colors.black87),
                tooltip: 'Share Quote',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
