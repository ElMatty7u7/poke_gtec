import 'package:gtec/domain/entities/pokemon.dart';
import 'package:gtec/domain/repositories/pokemon_repository.dart';

class SearchPokemon {
  final PokemonRepository repository;

  SearchPokemon(this.repository);

  Future<Pokemon?> call({required String name}) {
    // PokeAPI requiere nombres en minúsculas para buscar o el ID
    return repository.searchPokemon(name.toLowerCase());
  }
}
