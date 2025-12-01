import 'review_attachment_model.dart';
import 'review_user_model.dart';
import 'review_product_model.dart';

class ReviewModel {
  final int id;
  final int rating;
  final String? comment;
  final Map<String, dynamic>? variantSnapshot;
  final int? cartItemId;
  final String createdAt;
  final String updatedAt;
  final ReviewUserModel user;
  final ReviewProductModel? product;
  final List<ReviewAttachmentModel> attachments;

  const ReviewModel({
    required this.id,
    required this.rating,
    this.comment,
    this.variantSnapshot,
    this.cartItemId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.product,
    required this.attachments,
  });

  /// Check if review has images
  bool get hasImages => attachments.any((a) => a.isImage);

  /// Check if review has videos
  bool get hasVideos => attachments.any((a) => a.isVideo);

  /// Check if review has any attachments
  bool get hasAttachments => attachments.isNotEmpty;

  /// Check if review has comment text
  bool get hasComment => comment != null && comment!.isNotEmpty;

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    final rawUser = map['user'];
    final rawProduct = map['product'];
    final rawAttachments = map['attachments'];

    return ReviewModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      rating: _parseRating(map['rating']),
      comment: map['comment']?.toString(),
      variantSnapshot: map['variant_snapshot'] as Map<String, dynamic>?,
      cartItemId: map['cart_item_id'] != null
          ? _parseInt(map['cart_item_id'])
          : null,
      createdAt: map['created_at']?.toString() ?? '',
      updatedAt: map['updated_at']?.toString() ?? '',
      user: (rawUser is Map<String, dynamic>)
          ? ReviewUserModel.fromMap(rawUser)
          : ReviewUserModel(id: 0, name: 'Anonymous'),
      product: (rawProduct is Map<String, dynamic>)
          ? ReviewProductModel.fromMap(rawProduct)
          : null,
      attachments: (rawAttachments is List)
          ? rawAttachments
              .map((e) => ReviewAttachmentModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'variant_snapshot': variantSnapshot,
      'cart_item_id': cartItemId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user.toMap(),
      'product': product?.toMap(),
      'attachments': attachments.map((e) => e.toMap()).toList(),
    };
  }

  /// Parse rating - handles both String and num from API
  static int _parseRating(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }

  /// Parse int - handles both String and num from API
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is num) return value.toInt();
    return null;
  }

  @override
  String toString() {
    return 'ReviewModel(id: $id, rating: $rating, user: ${user.name}, attachments: ${attachments.length})';
  }
}
