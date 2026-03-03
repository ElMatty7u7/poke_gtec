import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gtec/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<List<PokemonModel>> getPokemons({
    required int offset,
    required int limit,
  });
  Future<PokemonModel?> searchPokemon(String name);
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://pokeapi.co/api/v2';

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PokemonModel>> getPokemons({
    required int offset,
    required int limit,
  }) async {
    final response = await client
        .get(Uri.parse('$baseUrl/pokemon?offset=$offset&limit=$limit'))
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () =>
              throw Exception('Connection timeout. Please try again.'),
        );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      final List results = decodedJson['results'];

      return results
          .map(
            (json) => PokemonModel.fromJsonList(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception('Failed to load pokemons');
    }
  }

  @override
  Future<PokemonModel?> searchPokemon(String name) async {
    final response = await client
        .get(Uri.parse('$baseUrl/pokemon/$name'))
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () =>
              throw Exception('Connection timeout. Please try again.'),
        );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      return PokemonModel.fromJsonDetail(decodedJson);
    } else if (response.statusCode == 404) {
      return null; // Not found
    } else {
      throw Exception('Failed to search pokemon');
    }
  }
}
