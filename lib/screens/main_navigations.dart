import 'package:flutter/material.dart';
import 'package:qoute_app/models/quote.dart';
import 'package:qoute_app/screens/favorite_screen.dart';
import 'package:qoute_app/screens/home_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Quote> _favorites = [];

  void _toggleFavorite(Quote quote) {
    setState(() {
      final exists = _favorites.any(
            (q) => q.text == quote.text && q.author == quote.author,
      );
      if (exists) {
        _favorites.removeWhere(
              (q) => q.text == quote.text && q.author == quote.author,
        );
      } else {
        _favorites.add(quote);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(favorites: _favorites, onToggleFavorite: _toggleFavorite),
      FavoriteScreen(favorites: _favorites, onToggleFavorite: _toggleFavorite),
      ProfileScreen(),
    ];

    final List<String> _titles = ['Quick Quote', 'Favorites', ''];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(_titles[_currentIndex])),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 15,
          selectedFontSize: 18,
          unselectedFontSize: 14,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          selectedIconTheme: const IconThemeData(size: 28),
          unselectedIconTheme: const IconThemeData(size: 24),
          currentIndex: _currentIndex,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
