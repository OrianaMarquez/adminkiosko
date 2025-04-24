// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClienteAdapter extends TypeAdapter<Cliente> {
  @override
  final int typeId = 0;

  @override
  Cliente read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cliente(
      id: fields[0] as String,
      nombre: fields[1] as String,
      correo: fields[2] as String,
      telefono: fields[3] as String,
      fechaNacimiento: fields[4] as DateTime,
      facturas: (fields[5] as List).cast<Factura>(),
    );
  }

  @override
  void write(BinaryWriter writer, Cliente obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.correo)
      ..writeByte(3)
      ..write(obj.telefono)
      ..writeByte(4)
      ..write(obj.fechaNacimiento)
      ..writeByte(5)
      ..write(obj.facturas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClienteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
