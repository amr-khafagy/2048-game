// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map json) => Board(
      (json['score'] as num).toInt(),
      (json['highScore'] as num).toInt(),
      (json['tiles'] as List<dynamic>)
          .map((e) => Tile.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      isGameOver: json['isGameOver'] as bool? ?? false,
      isGameWon: json['isGameWon'] as bool? ?? false,
      undo: json['undo'] == null
          ? null
          : Board.fromJson(Map<String, dynamic>.from(json['undo'] as Map)),
    );

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'score': instance.score,
      'highScore': instance.highScore,
      'tiles': instance.tiles.map((e) => e.toJson()).toList(),
      'isGameOver': instance.isGameOver,
      'isGameWon': instance.isGameWon,
      'undo': instance.undo?.toJson(),
    };
