import 'package:flutter/material.dart';
import 'favorite_detail_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recycling_helper/providers/favorites_provider.dart';
import 'package:recycling_helper/models/favorite_chat.dart';
import 'package:recycling_helper/services/api_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<FavoriteChat>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = ApiService.fetchFavoriteChats();
  }

  void _refreshFavorites() {
    setState(() {
      _favoritesFuture = ApiService.fetchFavoriteChats();
    });
  }

  String formatDate(String isoString) {
    final date = DateTime.tryParse(isoString);
    if (date == null) return isoString;
    return '${date.year}년 ${date.month.toString().padLeft(2, '0')}월 ${date.day.toString().padLeft(2, '0')}일';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/main');
          },
        ),
        title: const Text('즐겨찾기', style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder<List<FavoriteChat>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('즐겨찾기한 항목이 없습니다.'));
          }

          final favorites = snapshot.data!;
          print('✅ 받아온 즐겨찾기 개수: ${favorites.length}');
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final item = favorites[index];
              return _FavoriteItem(
                title: item.label ?? item.title, // ✅ label 우선 사용
                dateTime: formatDate(item.dateTime), // ✅ 날짜 변환
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FavoriteDetailPage(favoriteId: item.id),
                    ),
                  );

                  if (result == true) {
                    _refreshFavorites(); // ✅ 삭제 후 새로고침
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}


class _FavoriteItem extends StatelessWidget {
  final String title;
  final String dateTime;
  final VoidCallback onTap;

  const _FavoriteItem({
    required this.title,
    required this.dateTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.star, color: Color(0xFF5B8B4B)),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      subtitle: Text(dateTime, style: const TextStyle(color: Colors.black54)),
      onTap: onTap,
    );
  }
}
