import 'package:flutter_test/flutter_test.dart';
import 'package:cheering/features/food/data/models/reel_model.dart';
import 'package:cheering/features/food/domain/entities/reel_query_params.dart';

void main() {
  final sampleJson = {
    "success": true,
    "data": [
      {
        "id": "f1c6fd8a-e12f-49b4-b180-dbd4fec1b9bc",
        "video_url": "https://pub-db14d358a7a44399acfb0ece862b89f4.r2.dev/uploads/db048ebd-b954-461f-8762-b2c029058ba1/2026/09/30/6d70fa50c01f4902b7ac97b6609379ce.mp4",
        "thumbnail_url": null,
        "caption": null,
        "duration_seconds": 10,
        "restaurant": {
          "id": "896095f4-f4cd-44a5-9bdb-7c6b07977958",
          "name": "চাপ ঘর",
          "slug": "restaurant-4",
          "cuisine_types": ["Bangladeshi"],
          "logo_url": "https://pub-db14d358a7a44399acfb0ece862b89f4.r2.dev/uploads/019eff7e-93e8-473d-a2cf-c77240e4c7ce/2026/09/30/b8c8beb3342f4f7aaefbe8b314de1a6a.jpg",
          "cover_image_url": null,
          "rating_avg": 0,
          "rating_count": 0,
          "avg_prep_time_mins": 20,
          "delivery_fee": 10,
          "min_order_amount": 0,
          "is_open": false,
          "distance_km": null,
          "is_favorite": false
        },
        "menu_item": null,
        "created_at": "2026-09-30T16:30:31.387350+00:00"
      },
      {
        "id": "913f9527-a3db-470e-96af-c2e915d5c38a",
        "video_url": "https://pub-db14d358a7a44399acfb0ece862b89f4.r2.dev/uploads/db048ebd-b954-461f-8762-b2c029058ba1/2026/09/30/9f3c13954b244564aa9077cf1868d8e1.mp4",
        "thumbnail_url": null,
        "caption": null,
        "duration_seconds": 10,
        "restaurant": {
          "id": "438aea31-b49d-4c37-9dca-b8c41540ac5b",
          "name": "Pizza Paradise BD",
          "slug": "pizza-paradise-bd",
          "cuisine_types": ["Fast Food"],
          "logo_url": "https://pub-db14d358a7a44399acfb0ece862b89f4.r2.dev/uploads/0c486e29-5abe-44ed-abd1-6723c769abe7/2026/09/30/05552b73681a43349f38aea2762f617b.jpg",
          "cover_image_url": null,
          "rating_avg": 0,
          "rating_count": 0,
          "avg_prep_time_mins": 30,
          "delivery_fee": 10,
          "min_order_amount": 0,
          "is_open": false,
          "distance_km": null,
          "is_favorite": false
        },
        "menu_item": null,
        "created_at": "2026-09-30T16:26:41.822073+00:00"
      }
    ],
    "meta": {
      "total": 2,
      "limit": 20,
      "offset": 0,
      "page": 1,
      "has_more": false
    }
  };

  test('ReelsResponseModel parses API JSON correctly', () {
    final response = ReelsResponseModel.fromJson(sampleJson);

    expect(response.reels.length, 2);
    expect(response.meta.total, 2);
    expect(response.meta.hasMore, false);

    final first = response.reels.first;
    expect(first.id, 'f1c6fd8a-e12f-49b4-b180-dbd4fec1b9bc');
    expect(first.videoUrl, contains('.mp4'));
    expect(first.durationSeconds, 10);
    expect(first.restaurant.name, 'চাপ ঘর');
    expect(first.restaurant.avgPrepTimeMins, 20);
    expect(first.restaurant.deliveryFee, 10.0);
    expect(first.restaurant.distanceKm, 0.0);
    expect(first.menuItem, isNull);
  });

  test('ReelQueryParams converts to query map correctly', () {
    const params = ReelQueryParams(
      lat: 23.8103,
      lng: 90.4125,
      limit: 10,
      offset: 0,
      sort: '-created_at',
    );

    final map = params.toMap();
    expect(map['lat'], 23.8103);
    expect(map['lng'], 90.4125);
    expect(map['limit'], 10);
    expect(map['offset'], 0);
    expect(map['sort'], '-created_at');
  });

  test('ReelsResponseModel cache toJson and fromJson roundtrip works', () {
    final response = ReelsResponseModel.fromJson(sampleJson);
    final cachedJson = response.toJson();
    final restored = ReelsResponseModel.fromJson(cachedJson);

    expect(restored.reels.length, response.reels.length);
    expect(restored.meta.total, response.meta.total);
    expect(restored.reels.first.id, response.reels.first.id);
    expect(restored.reels.first.restaurant.name, response.reels.first.restaurant.name);
  });
}
