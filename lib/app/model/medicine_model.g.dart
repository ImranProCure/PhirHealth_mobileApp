// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineModelAdapter extends TypeAdapter<MedicineModel> {
  @override
  final int typeId = 0;

  @override
  MedicineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineModel(
      name: fields[0] as String,
      type: fields[1] as String,
      strength: fields[2] as String,
      unit: fields[3] as String,
      doses: (fields[4] as List).cast<DoseModel>(),
      scheduleType: fields[5] as String,
      specificDays: (fields[6] as List).cast<int>(),
      intervalDays: fields[7] as int,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.strength)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.doses)
      ..writeByte(5)
      ..write(obj.scheduleType)
      ..writeByte(6)
      ..write(obj.specificDays)
      ..writeByte(7)
      ..write(obj.intervalDays)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DoseModelAdapter extends TypeAdapter<DoseModel> {
  @override
  final int typeId = 1;

  @override
  DoseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoseModel(
      label: fields[0] as String,
      hour: fields[1] as int,
      minute: fields[2] as int,
      foodInstruction: fields[3] as String,
      notificationId: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DoseModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.hour)
      ..writeByte(2)
      ..write(obj.minute)
      ..writeByte(3)
      ..write(obj.foodInstruction)
      ..writeByte(4)
      ..write(obj.notificationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdherenceModelAdapter extends TypeAdapter<AdherenceModel> {
  @override
  final int typeId = 2;

  @override
  AdherenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdherenceModel(
      medicineKey: fields[0] as String,
      doseIndex: fields[1] as int,
      scheduledTime: fields[2] as DateTime,
      status: fields[3] as String,
      takenAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AdherenceModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.medicineKey)
      ..writeByte(1)
      ..write(obj.doseIndex)
      ..writeByte(2)
      ..write(obj.scheduledTime)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.takenAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdherenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
