class ReviewSummaryModel {
  final int totalReviews;
  final double averageRating;
  final RatingDistribution ratingDistribution;

  const ReviewSummaryModel({
    required this.totalReviews,
    required this.averageRating,
    required this.ratingDistribution,
  });

  /// Check if product has any reviews
  bool get hasReviews => totalReviews > 0;

  factory ReviewSummaryModel.fromMap(Map<String, dynamic> map) {
    final rawDistribution = map['rating_distribution'];

    return ReviewSummaryModel(
      totalReviews: (map['total_reviews'] as num?)?.toInt() ?? 0,
      averageRating: _parseDouble(map['average_rating']),
      ratingDistribution: (rawDistribution is Map<String, dynamic>)
          ? RatingDistribution.fromMap(rawDistribution)
          : const RatingDistribution(
              fiveStar: 0,
              fourStar: 0,
              threeStar: 0,
              twoStar: 0,
              oneStar: 0,
            ),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'total_reviews': totalReviews,
      'average_rating': averageRating,
      'rating_distribution': ratingDistribution.toMap(),
    };
  }

  @override
  String toString() {
    return 'ReviewSummaryModel(total: $totalReviews, average: $averageRating)';
  }
}

class RatingDistribution {
  final int fiveStar;
  final int fourStar;
  final int threeStar;
  final int twoStar;
  final int oneStar;

  const RatingDistribution({
    required this.fiveStar,
    required this.fourStar,
    required this.threeStar,
    required this.twoStar,
    required this.oneStar,
  });

  /// Calculate percentage for a specific star rating
  double getPercentage(int star, int total) {
    if (total == 0) return 0.0;
    final count = _getCount(star);
    return (count / total) * 100;
  }

  int _getCount(int star) {
    switch (star) {
      case 5:
        return fiveStar;
      case 4:
        return fourStar;
      case 3:
        return threeStar;
      case 2:
        return twoStar;
      case 1:
        return oneStar;
      default:
        return 0;
    }
  }

  factory RatingDistribution.fromMap(Map<String, dynamic> map) {
    return RatingDistribution(
      fiveStar: (map['5_star'] as num?)?.toInt() ?? 0,
      fourStar: (map['4_star'] as num?)?.toInt() ?? 0,
      threeStar: (map['3_star'] as num?)?.toInt() ?? 0,
      twoStar: (map['2_star'] as num?)?.toInt() ?? 0,
      oneStar: (map['1_star'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '5_star': fiveStar,
      '4_star': fourStar,
      '3_star': threeStar,
      '2_star': twoStar,
      '1_star': oneStar,
    };
  }

  @override
  String toString() {
    return 'RatingDistribution(5★: $fiveStar, 4★: $fourStar, 3★: $threeStar, 2★: $twoStar, 1★: $oneStar)';
  }
}
