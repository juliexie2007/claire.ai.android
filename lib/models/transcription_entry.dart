import 'package:hive/hive.dart';

part 'transcription_entry.g.dart';

@HiveType(typeId: 0)
class TranscriptionEntry extends HiveObject {
  @HiveField(0)
  String fileName;

  @HiveField(1)
  String transcription;

  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  double duration;

  TranscriptionEntry({
    required this.fileName,
    required this.transcription,
    required this.timestamp,
    required this.duration,
  });
}
