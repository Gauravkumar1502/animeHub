// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ani_pic.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AniPicAdapter extends TypeAdapter<AniPic> {
  @override
  final int typeId = 1;

  @override
  AniPic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AniPic(
      id: (fields[0] as num).toInt(),
      url: fields[1] as String,
      rating: fields[2] as Rating,
      tags: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AniPic obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AniPicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RatingAdapter extends TypeAdapter<Rating> {
  @override
  final int typeId = 0;

  @override
  Rating read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Rating.safe;
      case 1:
        return Rating.suggestive;
      case 2:
        return Rating.borderline;
      case 3:
        return Rating.explicit;
      default:
        return Rating.safe;
    }
  }

  @override
  void write(BinaryWriter writer, Rating obj) {
    switch (obj) {
      case Rating.safe:
        writer.writeByte(0);
      case Rating.suggestive:
        writer.writeByte(1);
      case Rating.borderline:
        writer.writeByte(2);
      case Rating.explicit:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
