import os

def add_toJson(file_path, to_json_code):
    with open(file_path, 'r') as f:
        content = f.read()
    
    if "toJson" not in content:
        content = content.replace("}\n", "\n" + to_json_code + "\n}\n", 1)
        with open(file_path, 'w') as f:
            f.write(content)

cuisine_code = """  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'restaurant_count': restaurantCount,
      'image_url': imageUrl,
    };
  }"""
add_toJson("lib/features/food/data/models/cuisine_model.dart", cuisine_code)

category_code = """  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image_url': imageUrl,
      'restaurant_count': restaurantCount,
    };
  }"""
add_toJson("lib/features/food/data/models/category_model.dart", category_code)

promotion_code = """  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_order_amount': minOrderAmount,
      'max_discount': maxDiscount,
      'valid_until': validUntil.toIso8601String(),
    };
  }"""
add_toJson("lib/features/food/data/models/promotion_model.dart", promotion_code)

with open("lib/features/food/data/models/restaurant_model.dart", 'r') as f:
    content = f.read()

business_hours_code = """  Map<String, dynamic> toJson() {
    return {
      'is_open': isOpen,
      'opens_at': opensAt,
      'closes_at': closesAt,
    };
  }"""
restaurant_code = """  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'cuisine_types': cuisineTypes,
      'logo_url': logoUrl,
      'cover_image_url': coverImageUrl,
      'rating_avg': ratingAvg,
      'rating_count': ratingCount,
      'avg_prep_time_mins': avgPrepTimeMins,
      'delivery_fee': deliveryFee,
      'min_order_amount': minOrderAmount,
      'is_open': isOpen,
      'distance_km': distanceKm,
      'is_favorite': isFavorite,
      'description': description,
      'phone': phone,
      'address_line': addressLine,
      'latitude': latitude,
      'longitude': longitude,
      'business_hours': businessHours?.map((k, v) => MapEntry(k, (v as BusinessHoursModel).toJson())),
      'promotions': promotions?.map((e) => (e as PromotionModel).toJson()).toList(),
    };
  }"""
if "toJson" not in content:
    # We have two classes in restaurant_model.dart: BusinessHoursModel and RestaurantModel.
    # The first '}\n' corresponds to BusinessHoursModel (wait, actually, BusinessHoursModel ends with '  }\n}\n')
    # Let's just do targeted replacement.
    content = content.replace("    );\n  }\n}", "    );\n  }\n\n" + business_hours_code + "\n}")
    content = content.replace("          .toList(),\n    );\n  }\n}", "          .toList(),\n    );\n  }\n\n" + restaurant_code + "\n}")
    with open("lib/features/food/data/models/restaurant_model.dart", 'w') as f:
        f.write(content)

home_feed_code = """  Map<String, dynamic> toJson() {
    return {
      'cuisines': cuisines.map((e) => (e as CuisineModel).toJson()).toList(),
      'categories': categories.map((e) => (e as CategoryModel).toJson()).toList(),
      'promoted': promoted.map((e) => (e as RestaurantModel).toJson()).toList(),
      'nearby': nearby.map((e) => (e as RestaurantModel).toJson()).toList(),
      'top_rated': topRated.map((e) => (e as RestaurantModel).toJson()).toList(),
    };
  }"""
add_toJson("lib/features/food/data/models/home_feed_model.dart", home_feed_code)
