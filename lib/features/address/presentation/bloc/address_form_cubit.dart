import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/address_entity.dart';

class AddressFormState extends Equatable {
  const AddressFormState({required this.type, required this.location});

  final AddressType type;
  final AddressEntity location;

  AddressFormState copyWith({AddressType? type, AddressEntity? location}) {
    return AddressFormState(
      type: type ?? this.type,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [type, location];
}

/// Holds the add/edit address form. Created per route with the address being
/// edited, so the first frame already shows the right values.
class AddressFormCubit extends Cubit<AddressFormState> {
  AddressFormCubit(AddressEntity initial)
    : super(
        AddressFormState(
          type: initial.type == AddressType.unknown
              ? AddressType.home
              : initial.type,
          location: initial,
        ),
      );

  void setType(AddressType type) => emit(state.copyWith(type: type));

  void setLocation(AddressEntity location) =>
      emit(state.copyWith(location: location));
}
