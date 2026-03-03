import 'package:gtec/domain/entities/pokemon.dart';

abstract class PokemonRepository {
  Future<List<Pokemon>> getPokemons({required int offset, required int limit});
  Future<Pokemon?> searchPokemon(String name);
}
