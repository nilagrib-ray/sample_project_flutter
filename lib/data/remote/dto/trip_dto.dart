class TripsResponse {
  final List<TripDto>? upcomingTrips;
  final List<TripDto>? previousTrips;

  const TripsResponse({this.upcomingTrips, this.previousTrips});

  factory TripsResponse.fromJson(Map<String, dynamic> json) {
    return TripsResponse(
      upcomingTrips: (json['upcoming_trips'] as List<dynamic>?)
          ?.map((e) => TripDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      previousTrips: (json['previous_trips'] as List<dynamic>?)
          ?.map((e) => TripDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TripDto {
  final int? packageId;
  final String? packageTitle;
  final int? bookingId;
  final String? bookingTitle;
  final bool? ownerBooking;
  final String? type;
  final String? description;
  final String? arrivalDate;
  final String? arrivalTime;
  final String? departureDate;
  final String? departureTime;
  final String? hotel;
  final int? productId;
  final String? orderId;
  final String? featuredImage;
  final String? image;
  final String? squareImage;
  final String? travellers;
  final String? discountTotal;
  final String? bookingTotal;
  final String? bookingBalance;
  final String? currencySymbol;
  final List<DestinationDto>? destination;

  const TripDto({
    this.packageId,
    this.packageTitle,
    this.bookingId,
    this.bookingTitle,
    this.ownerBooking,
    this.type,
    this.description,
    this.arrivalDate,
    this.arrivalTime,
    this.departureDate,
    this.departureTime,
    this.hotel,
    this.productId,
    this.orderId,
    this.featuredImage,
    this.image,
    this.squareImage,
    this.travellers,
    this.discountTotal,
    this.bookingTotal,
    this.bookingBalance,
    this.currencySymbol,
    this.destination,
  });

  factory TripDto.fromJson(Map<String, dynamic> json) {
    return TripDto(
      packageId: json['package_id'] as int?,
      packageTitle: json['package_title'] as String?,
      bookingId: json['booking_id'] as int?,
      bookingTitle: json['booking_title'] as String?,
      ownerBooking: json['owner_booking'] as bool?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      arrivalDate: json['arrival_date'] as String?,
      arrivalTime: json['arrival_time'] as String?,
      departureDate: json['departure_date'] as String?,
      departureTime: json['departure_time'] as String?,
      hotel: json['hotel'] as String?,
      productId: json['product_id'] as int?,
      orderId: json['order_id']?.toString(),
      featuredImage: json['featured_image'] as String?,
      image: json['image'] as String?,
      squareImage: json['square_image'] as String?,
      travellers: json['travellers']?.toString(),
      discountTotal: json['discount_total'] as String?,
      bookingTotal: json['booking_total'] as String?,
      bookingBalance: json['booking_balance'] as String?,
      currencySymbol: json['currency_symbol'] as String?,
      destination: (json['destination'] as List<dynamic>?)
          ?.map((e) => DestinationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DestinationDto {
  final int? id;
  final String? name;
  final String? slug;
  final String? descriptionFeaturedImageUrl;

  const DestinationDto({
    this.id,
    this.name,
    this.slug,
    this.descriptionFeaturedImageUrl,
  });

  factory DestinationDto.fromJson(Map<String, dynamic> json) {
    return DestinationDto(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      descriptionFeaturedImageUrl:
          json['description_featured_image_url'] as String?,
    );
  }
}

class CategoryDto {
  final int? categoryId;
  final String? categoryName;
  final String? destUrl;
  final List<PostDto>? posts;
  final String? descriptionFeaturedImageUrl;

  const CategoryDto({
    this.categoryId,
    this.categoryName,
    this.destUrl,
    this.posts,
    this.descriptionFeaturedImageUrl,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      categoryId: json['category_id'] as int?,
      categoryName: json['category_name'] as String?,
      destUrl: json['dest_url'] as String?,
      posts: (json['posts'] as List<dynamic>?)
          ?.map((e) => PostDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      descriptionFeaturedImageUrl:
          json['description_featured_image_url'] as String?,
    );
  }
}

class PostDto {
  final int? id;
  final String? title;
  final String? startDate;
  final String? endDate;
  final String? permalink;
  final String? image;
  final String? squareImage;

  const PostDto({
    this.id,
    this.title,
    this.startDate,
    this.endDate,
    this.permalink,
    this.image,
    this.squareImage,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) {
    return PostDto(
      id: json['id'] as int?,
      title: json['title'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      permalink: json['permalink'] as String?,
      image: json['image'] as String?,
      squareImage: json['square_image'] as String?,
    );
  }
}
