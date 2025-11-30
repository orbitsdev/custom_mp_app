# Review Models API Mapping

This document shows how our Flutter models map to the Review API responses.

## ✅ API Response Structure vs Our Models

### 1. Review Attachment (API → ReviewAttachmentModel)

**API Response (line 99-105 in REVIEW_API_DOCUMENTATION.md):**
```json
{
  "id": 16,
  "url": "https://dev.avantefoods.com/storage/16/example2.mp4",
  "mime_type": "video/mp4",
  "size": 2746869,
  "name": "example2.mp4"
}
```

**Our Model:** `ReviewAttachmentModel`
```dart
class ReviewAttachmentModel {
  final int id;              // ✅ maps to: id
  final String url;          // ✅ maps to: url
  final String mimeType;     // ✅ maps to: mime_type
  final int size;            // ✅ maps to: size
  final String name;         // ✅ maps to: name

  // Helper methods
  bool get isImage => mimeType.startsWith('image/');
  bool get isVideo => mimeType.startsWith('video/');
}
```

---

### 2. Review User (API → ReviewUserModel)

**API Response (line 87-91):**
```json
{
  "id": 2,
  "name": "brianon",
  "avatar_url": "https://dev.avantefoods.com/storage/12/avatar.jpg"
}
```

**Our Model:** `ReviewUserModel`
```dart
class ReviewUserModel {
  final int id;              // ✅ maps to: id
  final String name;         // ✅ maps to: name
  final String? avatarUrl;   // ✅ maps to: avatar_url
}
```

---

### 3. Review Product (API → ReviewProductModel)

**API Response (line 92-97):**
```json
{
  "id": 2,
  "name": "Apple",
  "slug": "apple",
  "thumbnail": "https://dev.avantefoods.com/storage/11/thumbnail.png"
}
```

**Our Model:** `ReviewProductModel`
```dart
class ReviewProductModel {
  final int id;              // ✅ maps to: id
  final String name;         // ✅ maps to: name
  final String slug;         // ✅ maps to: slug
  final String thumbnail;    // ✅ maps to: thumbnail
}
```

**Note:** This is a minimal product model specifically for review responses. It's different from the full `ProductModel` used elsewhere in the app.

---

### 4. Review (API → ReviewModel)

**API Response (line 80-107):**
```json
{
  "id": 3,
  "rating": "5",
  "comment": "This is an amazing product! Highly recommend.",
  "variant_snapshot": null,
  "created_at": "2025-11-30 13:17:54",
  "updated_at": "2025-11-30 13:17:54",
  "user": { ... },
  "product": { ... },
  "attachments": [ ... ]
}
```

**Our Model:** `ReviewModel`
```dart
class ReviewModel {
  final int id;                              // ✅ maps to: id
  final int rating;                          // ✅ maps to: rating (parsed from string)
  final String? comment;                     // ✅ maps to: comment
  final Map<String, dynamic>? variantSnapshot; // ✅ maps to: variant_snapshot
  final String createdAt;                    // ✅ maps to: created_at
  final String updatedAt;                    // ✅ maps to: updated_at
  final ReviewUserModel user;                // ✅ maps to: user object
  final ReviewProductModel? product;         // ✅ maps to: product object
  final List<ReviewAttachmentModel> attachments; // ✅ maps to: attachments array

  // Helper methods
  bool get hasImages => attachments.any((a) => a.isImage);
  bool get hasVideos => attachments.any((a) => a.isVideo);
  bool get hasAttachments => attachments.isNotEmpty;
  bool get hasComment => comment != null && comment!.isNotEmpty;
}
```

---

### 5. Review Summary (API → ReviewSummaryModel)

**API Response (line 626-636 in REVIEW_API_DOCUMENTATION.md):**
```json
{
  "total_reviews": 15,
  "average_rating": 4.5,
  "rating_distribution": {
    "5_star": 8,
    "4_star": 5,
    "3_star": 1,
    "2_star": 1,
    "1_star": 0
  }
}
```

**Our Model:** `ReviewSummaryModel`
```dart
class ReviewSummaryModel {
  final int totalReviews;              // ✅ maps to: total_reviews
  final double averageRating;          // ✅ maps to: average_rating
  final RatingDistribution ratingDistribution; // ✅ maps to: rating_distribution

  bool get hasReviews => totalReviews > 0;
}

class RatingDistribution {
  final int fiveStar;    // ✅ maps to: 5_star
  final int fourStar;    // ✅ maps to: 4_star
  final int threeStar;   // ✅ maps to: 3_star
  final int twoStar;     // ✅ maps to: 2_star
  final int oneStar;     // ✅ maps to: 1_star

  double getPercentage(int star, int total) { ... }
}
```

---

## 🗂️ Model Files Structure

```
lib/app/data/models/reviews/
├── review_attachment_model.dart   // Media attachments (images/videos)
├── review_user_model.dart         // User info in reviews
├── review_product_model.dart      // Minimal product reference
├── review_model.dart              // Main review model
└── review_summary_model.dart      // Rating statistics
```

---

## 📝 Usage Examples

### Parsing API Response

```dart
// From product details API response
final productData = response.data['data'];
final product = ProductModel.fromMap(productData);

// Access reviews
if (product.reviewSummary != null) {
  print('Average: ${product.reviewSummary!.averageRating}');
  print('Total: ${product.reviewSummary!.totalReviews}');
}

// Access individual reviews
for (final review in product.reviews) {
  print('${review.user.name}: ${review.rating}★');
  if (review.hasComment) {
    print(review.comment);
  }
  if (review.hasAttachments) {
    print('${review.attachments.length} attachments');
  }
}
```

### Filtering Reviews

```dart
// Get reviews with images
final reviewsWithImages = product.reviews.where((r) => r.hasImages).toList();

// Get 5-star reviews
final fiveStarReviews = product.reviews.where((r) => r.rating == 5).toList();

// Get reviews with comments
final reviewsWithComments = product.reviews.where((r) => r.hasComment).toList();
```

---

## ❌ Removed Legacy Code

### What was removed:
- ❌ `ReviewFile` class (doesn't exist in API)
- ❌ `lib/app/modules/reviews/views/video/file_viewer.dart` (broken imports)
- ❌ All old video player widgets with hardcoded colors

### What to use instead:
- ✅ `ReviewAttachmentModel` (properly matches API)
- ✅ `MediaViewerWidget` in `lib/app/global/widgets/video/`
- ✅ `NetworkVideoPlayerWidget` with AppColors

---

## ✅ Verification

All models have been verified against the API documentation and include:
- Proper `fromMap` factory constructors
- Type-safe parsing with null safety
- Helper methods for common operations
- Clean toString implementations
- Proper field mapping from snake_case API to camelCase Dart

**Status:** Ready for production use! 🎉
