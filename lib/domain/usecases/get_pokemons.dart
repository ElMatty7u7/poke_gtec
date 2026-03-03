import 'package:gtec/domain/entities/pokemon.dart';
import 'package:gtec/domain/repositories/pokemon_repository.dart';

class GetPokemons {
  final PokemonRepository repository;

  GetPokemons(this.repository);

  Future<List<Pokemon>> call({required int offset, required int limit}) {
    return repository.getPokemons(offset: offset, limit: limit);
  }
}
