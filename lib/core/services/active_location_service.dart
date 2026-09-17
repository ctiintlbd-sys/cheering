import 'package:flutter/foundation.dart';
import '../../features/address/domain/entities/address_entity.dart';

class ActiveLocationService extends ChangeNotifier {
  AddressEntity? _activeAddress;

  AddressEntity? get activeAddress => _activeAddress;

  void setActiveAddress(AddressEntity address) {
    _activeAddress = address;
    notifyListeners();
  }
}
