import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/map_location_entities.dart';
import 'map_picker_state.dart';

/// Drives a single map-picker screen. Scoped to that route, so panning the map
/// never wakes up the saved-address list or the home header.
class MapPickerCubit extends Cubit<MapPickerState> {
  MapPickerCubit() : super(const MapPickerState());

  void setPinMoving(bool isMoving) {
    if (state.isPinMoving == isMoving) return;
    emit(state.copyWith(isPinMoving: isMoving));
  }

  void setAddress(String address, String area) {
    emit(state.copyWith(address: address, area: area));
  }

  void setUnknownAddress() {
    emit(state.copyWith(address: MapLocationDefaults.unknownLabel, area: ''));
  }

  void showSearchLoading() {
    emit(state.copyWith(isSearchLoading: true, showSearchResults: true));
  }

  void setSearchResults(List<MapSearchResult> results, {required bool show}) {
    emit(
      state.copyWith(
        isSearchLoading: false,
        searchResults: results,
        showSearchResults: show,
      ),
    );
  }

  void clearSearchResults() {
    emit(
      state.copyWith(
        searchResults: const [],
        isSearchLoading: false,
        showSearchResults: false,
      ),
    );
  }

  void setSearchResultsVisible(bool show) {
    emit(state.copyWith(showSearchResults: show));
  }
}
