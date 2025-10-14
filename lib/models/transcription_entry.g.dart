// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranscriptionEntryAdapter extends TypeAdapter<TranscriptionEntry> {
  @override
  final int typeId = 0;

  @override
  TranscriptionEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranscriptionEntry(
      fileName: fields[0] as String,
      transcription: fields[1] as String,
      timestamp: fields[2] as DateTime,
      duration: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TranscriptionEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.fileName)
      ..writeByte(1)
      ..write(obj.transcription)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranscriptionEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
