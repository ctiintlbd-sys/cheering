import 'dart:typed_data';
import 'package:hive/hive.dart';

class CacheEntry {
  final Uint8List bytes;
  final DateTime expiresAt;

  const CacheEntry({required this.bytes, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class CacheEntryAdapter extends TypeAdapter<CacheEntry> {
  @override
  final int typeId = 0;

  @override
  CacheEntry read(BinaryReader reader) => CacheEntry(
    bytes: reader.readByteList(),
    expiresAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
  );

  @override
  void write(BinaryWriter writer, CacheEntry obj) {
    writer.writeByteList(obj.bytes);
    writer.writeInt(obj.expiresAt.millisecondsSinceEpoch);
  }
}
