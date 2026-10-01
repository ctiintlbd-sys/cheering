import 'package:flutter_test/flutter_test.dart';
import 'package:cheering/features/food/domain/entities/reel_entity.dart';
import 'package:cheering/features/food/domain/entities/reel_query_params.dart';
import 'package:cheering/features/food/domain/entities/restaurant_entity.dart';
import 'package:cheering/features/food/domain/repositories/i_food_repository.dart';
import 'package:cheering/features/food/domain/usecases/get_reels_usecase.dart';
import 'package:cheering/features/food/presentation/blocs/reels/reels_bloc.dart';
import 'package:cheering/features/food/presentation/blocs/reels/reels_event.dart';
import 'package:cheering/features/food/presentation/blocs/reels/reels_state.dart';
import 'package:cheering/core/services/active_location_service.dart';

class FakeFoodRepository implements IFoodRepository {
  final List<ReelsResponseEntity> responses;

  FakeFoodRepository(this.responses);

  @override
  Stream<ReelsResponseEntity> getReels(ReelQueryParams params) {
    return Stream.fromIterable(responses);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeActiveLocationService implements ActiveLocationService {
  @override
  Null get activeAddress => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const dummyRestaurant = RestaurantEntity(
    id: '1',
    name: 'Test Rest',
    slug: 'test-rest',
    cuisineTypes: ['Burger'],
    ratingAvg: 4.5,
    ratingCount: 10,
    avgPrepTimeMins: 20,
    deliveryFee: 15,
    minOrderAmount: 50,
    isOpen: true,
    isFavorite: false,
  );

  final dummyReel = ReelEntity(
    id: 'r1',
    videoUrl: 'https://example.com/video.mp4',
    durationSeconds: 15,
    restaurant: dummyRestaurant,
    createdAt: DateTime.now(),
  );

  const dummyMeta = ReelsPaginationMetaEntity(
    total: 1,
    limit: 20,
    offset: 0,
    page: 1,
    hasMore: false,
  );

  test('ReelsBloc loads reels and updates state to success', () async {
    final fakeRepo = FakeFoodRepository([
      ReelsResponseEntity(reels: [dummyReel], meta: dummyMeta),
    ]);
    final useCase = GetReelsUseCase(fakeRepo, FakeActiveLocationService());
    final bloc = ReelsBloc(useCase);

    expect(bloc.state.status, ReelsStatus.initial);

    bloc.add(const LoadReels());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<ReelsState>((s) => s.status == ReelsStatus.loading),
        predicate<ReelsState>(
          (s) => s.status == ReelsStatus.success && s.reels.length == 1,
        ),
      ]),
    );

    await bloc.close();
  });
}
