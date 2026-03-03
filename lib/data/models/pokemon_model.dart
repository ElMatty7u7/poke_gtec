import 'package:gtec/domain/entities/pokemon.dart';

class PokemonModel extends Pokemon {
  const PokemonModel({
    required super.id,
    required super.name,
    required super.imageUrl,
  });

  // Used for list response from /pokemon?offset=X&limit=X
  factory PokemonModel.fromJsonList(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final url = json['url'] as String;

    final idStr = url.split('/').where((part) => part.isNotEmpty).last;
    final id = int.parse(idStr);

    return PokemonModel(id: id, name: name, imageUrl: _getImageUrl(id));
  }

  factory PokemonModel.fromJsonDetail(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final name = json['name'] as String;

    return PokemonModel(id: id, name: name, imageUrl: _getImageUrl(id));
  }

  static String _getImageUrl(int id) {
    //Obtenemos la imagen desde github content para no hacer una peticion extra por cada pokemon
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }
}
