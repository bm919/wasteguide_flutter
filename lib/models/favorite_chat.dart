class Message {
  final String sender; // 'user' 또는 'system'
  final String text;

  Message({required this.sender, required this.text});
}

class FavoriteChat {
  final int id;
  final String title;
  final String summary;
  final String imagePath;
  final String dateTime;// 저장한 시간 문자열
  final List<Message> messages;
  final int imageId;       // 이미지 ID (선택)
  final int chatId;
  final String? label;

  FavoriteChat({
    required this.id,
    required this.title,
    required this.summary,
    required this.imagePath,
    required this.dateTime,
    required this.messages,
    required this.imageId,
    required this.chatId,
    this.label,
  });
  // factory FavoriteChat.fromJson(Map<String, dynamic> json) {
  //   return FavoriteChat(
  //     id: json['id'] ?? -1,
  //     title: json['title'] ?? '제목 없음',
  //     summary: json['summary'] ?? '',
  //     imagePath: json['image_path'] ?? '',
  //     dateTime: json['created_at'] ?? '',
  //     imageId: json['image'] ?? -1,
  //     chatId: json['chat_id'] ?? -1,
  //     messages: (json['messages'] as List<dynamic>?)
  //         ?.map((m) => Message(sender: m['sender'], text: m['text']))
  //         .toList()
  //         ?? [],
  //   );
  // }
  factory FavoriteChat.fromJson(Map<String, dynamic> json) {
    return FavoriteChat(
      id: json['id'] ?? -1,
      title: '제목 없음', // 서버 응답에 없음 → 기본값
      summary: json['response_text']?.split('\n').first ?? '',
      imagePath: 'http://158.179.174.13:8000${json['image_url'] ?? ''}',
      dateTime: json['created_at'] ?? '',
      imageId: json['id'] ?? -1, // 일단 동일하게 사용
      chatId: json['id'] ?? -1,
      messages: [
        Message(sender: 'system', text: json['response_text'] ?? '')
      ],
      label: json['label'] as String?,
    );
  }


}