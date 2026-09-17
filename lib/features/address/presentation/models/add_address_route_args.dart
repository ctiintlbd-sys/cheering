import '../../domain/entities/address_entity.dart';

class AddAddressRouteArgs {
  const AddAddressRouteArgs({
    required this.latitude,
    required this.longitude,
    required this.primaryLine,
    required this.secondaryLine,
    this.editAddress,
  });

  final double latitude;
  final double longitude;
  final String primaryLine;
  final String secondaryLine;
  final AddressEntity? editAddress;

  factory AddAddressRouteArgs.fromMapResult(
    Map<String, dynamic> result, {
    AddressEntity? editAddress,
  }) {
    return AddAddressRouteArgs(
      latitude: (result['latitude'] as num).toDouble(),
      longitude: (result['longitude'] as num).toDouble(),
      primaryLine: result['address']?.toString() ?? '',
      secondaryLine: result['area']?.toString() ?? '',
      editAddress: editAddress,
    );
  }
}
