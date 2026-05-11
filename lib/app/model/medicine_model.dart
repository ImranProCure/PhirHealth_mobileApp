import 'package:hive/hive.dart';

part 'medicine_model.g.dart';

@HiveType(typeId: 0)
class MedicineModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String type; // Tablet, Capsule, Syrup, Injection

  @HiveField(2)
  String strength;

  @HiveField(3)
  String unit;

  @HiveField(4)
  List<DoseModel> doses;

  @HiveField(5)
  String scheduleType; // every_day, specific_days, interval

  @HiveField(6)
  List<int> specificDays; // 1=Mon ... 7=Sun (for specific_days)

  @HiveField(7)
  int intervalDays; // e.g. every 2 days

  @HiveField(8)
  DateTime createdAt;

  MedicineModel({
    required this.name,
    required this.type,
    required this.strength,
    required this.unit,
    required this.doses,
    this.scheduleType = 'every_day',
    this.specificDays = const [],
    this.intervalDays = 1,
    required this.createdAt,
  });
}

@HiveType(typeId: 1)
class DoseModel extends HiveObject {
  @HiveField(0)
  String label; // Morning, Afternoon, Night, Custom

  @HiveField(1)
  int hour;

  @HiveField(2)
  int minute;

  @HiveField(3)
  String foodInstruction; // Before Food, After Food, With Food, etc.

  @HiveField(4)
  int notificationId;

  DoseModel({
    required this.label,
    required this.hour,
    required this.minute,
    required this.foodInstruction,
    required this.notificationId,
  });

  String get timeString {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final m = minute.toString().padLeft(2, '0');
    final period = hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }
}

@HiveType(typeId: 2)
class AdherenceModel extends HiveObject {
  @HiveField(0)
  String medicineKey; // Hive key of MedicineModel

  @HiveField(1)
  int doseIndex;

  @HiveField(2)
  DateTime scheduledTime;

  @HiveField(3)
  String status; // 'taken', 'missed', 'upcoming', 'snoozed'

  @HiveField(4)
  DateTime? takenAt;

  AdherenceModel({
    required this.medicineKey,
    required this.doseIndex,
    required this.scheduledTime,
    required this.status,
    this.takenAt,
  });
}
