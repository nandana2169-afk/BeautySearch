class ProductModel {
  final List<BeautyCategory> products;
  final int total;

  ProductModel({required this.products, required this.total});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      products: List<BeautyCategory>.from(
        json['products'].map((x) => BeautyCategory.fromJson(x)),
      ),
      total: json['total'],
    );
  }
}

class BeautyCategory {
  final int id;
  final String title;
  final String description;
  final String category;
  final dynamic price;
  final dynamic rating;
  final String thumbnail;
  final String brand;
  final List<Review> reviews;

  BeautyCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.brand,
    required this.reviews,
  });

  factory BeautyCategory.fromJson(Map<String, dynamic> json) {
    return BeautyCategory(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? "",
      category: json['category'] ?? "",
      price: json['price'],
      rating: json['rating'],
      thumbnail: json['thumbnail'],
      brand: json['brand'] ?? "Generic",
      reviews: List<Review>.from(
        (json['reviews'] as List).map((x) => Review.fromJson(x)),
      ),
    );
  }
}

class Review {
  final int rating;
  final String comment;
  final String reviewerName;

  Review({
    required this.rating,
    required this.comment,
    required this.reviewerName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? "",
      reviewerName: json['reviewerName'] ?? "Anonymous",
    );
  }
}
