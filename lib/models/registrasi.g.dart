// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registrasi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegistrasiAdapter extends TypeAdapter<Registrasi> {
  @override
  final int typeId = 0;

  @override
  Registrasi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Registrasi()
      ..name = fields[0] as String?
      ..birth = fields[1] as String?
      ..address = fields[2] as String?
      ..telephone = fields[3] as String?
      ..email = fields[4] as String?
      ..courseName = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, Registrasi obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.birth)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.telephone)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.courseName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegistrasiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
