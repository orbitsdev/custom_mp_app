class ReviewAttachmentModel {
  final int id;
  final String url;
  final String mimeType;
  final int size;
  final String name;

  const ReviewAttachmentModel({
    required this.id,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.name,
  });

  /// Check if attachment is an image
  bool get isImage => mimeType.startsWith('image/');

  /// Check if attachment is a video
  bool get isVideo => mimeType.startsWith('video/');

  factory ReviewAttachmentModel.fromMap(Map<String, dynamic> map) {
    return ReviewAttachmentModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      url: map['url']?.toString() ?? '',
      mimeType: map['mime_type']?.toString() ?? '',
      size: (map['size'] as num?)?.toInt() ?? 0,
      name: map['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'mime_type': mimeType,
      'size': size,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'ReviewAttachmentModel(id: $id, name: $name, mimeType: $mimeType, size: $size)';
  }
}
