import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/favorite_chat.dart';

class FavoritesNotifier extends StateNotifier<List<FavoriteChat>> {
  FavoritesNotifier() : super([]);

  void add(FavoriteChat chat) {
    state = [...state, chat];
  }

  void remove(FavoriteChat chat) {
    state = state.where((c) => c != chat).toList();
  }
}

final favoriteProvider = StateNotifierProvider<FavoritesNotifier, List<FavoriteChat>>(
      (ref) => FavoritesNotifier(),
);
