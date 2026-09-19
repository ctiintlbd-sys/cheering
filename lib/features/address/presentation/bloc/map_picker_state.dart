import 'package:equatable/equatable.dart';

import '../../domain/entities/map_location_entities.dart';

class MapPickerState extends Equatable {
  const MapPickerState({
    this.isPinMoving = false,
    this.address = MapLocationDefaults.locatingLabel,
    this.area = '',
    this.searchResults = const [],
    this.isSearchLoading = false,
    this.showSearchResults = false,
  });

  final bool isPinMoving;
  final String address;
  final String area;
  final List<MapSearchResult> searchResults;
  final bool isSearchLoading;
  final bool showSearchResults;

  bool get isConfirmable => MapLocationDefaults.isConfirmableAddress(address);

  MapPickerState copyWith({
    bool? isPinMoving,
    String? address,
    String? area,
    List<MapSearchResult>? searchResults,
    bool? isSearchLoading,
    bool? showSearchResults,
  }) {
    return MapPickerState(
      isPinMoving: isPinMoving ?? this.isPinMoving,
      address: address ?? this.address,
      area: area ?? this.area,
      searchResults: searchResults ?? this.searchResults,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      showSearchResults: showSearchResults ?? this.showSearchResults,
    );
  }

  @override
  List<Object?> get props => [
    isPinMoving,
    address,
    area,
    searchResults,
    isSearchLoading,
    showSearchResults,
  ];
}
