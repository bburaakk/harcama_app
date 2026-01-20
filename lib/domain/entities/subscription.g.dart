// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionAdapter extends TypeAdapter<Subscription> {
  @override
  final int typeId = 9;

  @override
  Subscription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subscription(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      amount: fields[3] as double,
      frequency: fields[4] as SubscriptionFrequency,
      startDate: fields[5] as DateTime,
      nextBillingDate: fields[6] as DateTime,
      status: fields[7] as SubscriptionStatus,
      icon: fields[8] as String,
      color: fields[9] as String,
      category: fields[10] as String?,
      billingDay: fields[13] as int?,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Subscription obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.frequency)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.nextBillingDate)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.icon)
      ..writeByte(9)
      ..write(obj.color)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.billingDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubscriptionFrequencyAdapter extends TypeAdapter<SubscriptionFrequency> {
  @override
  final int typeId = 7;

  @override
  SubscriptionFrequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubscriptionFrequency.daily;
      case 1:
        return SubscriptionFrequency.weekly;
      case 2:
        return SubscriptionFrequency.monthly;
      case 3:
        return SubscriptionFrequency.yearly;
      default:
        return SubscriptionFrequency.daily;
    }
  }

  @override
  void write(BinaryWriter writer, SubscriptionFrequency obj) {
    switch (obj) {
      case SubscriptionFrequency.daily:
        writer.writeByte(0);
        break;
      case SubscriptionFrequency.weekly:
        writer.writeByte(1);
        break;
      case SubscriptionFrequency.monthly:
        writer.writeByte(2);
        break;
      case SubscriptionFrequency.yearly:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionFrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubscriptionStatusAdapter extends TypeAdapter<SubscriptionStatus> {
  @override
  final int typeId = 8;

  @override
  SubscriptionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubscriptionStatus.active;
      case 1:
        return SubscriptionStatus.paused;
      case 2:
        return SubscriptionStatus.cancelled;
      default:
        return SubscriptionStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, SubscriptionStatus obj) {
    switch (obj) {
      case SubscriptionStatus.active:
        writer.writeByte(0);
        break;
      case SubscriptionStatus.paused:
        writer.writeByte(1);
        break;
      case SubscriptionStatus.cancelled:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
