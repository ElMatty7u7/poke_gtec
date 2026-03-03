import 'package:gtec/data/datasources/pokemon_remote_data_source.dart';
import 'package:gtec/domain/entities/pokemon.dart';
import 'package:gtec/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;

  PokemonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Pokemon>> getPokemons({
    required int offset,
    required int limit,
  }) async {
    return await remoteDataSource.getPokemons(offset: offset, limit: limit);
  }

  @override
  Future<Pokemon?> searchPokemon(String name) async {
    return await remoteDataSource.searchPokemon(name);
  }
}
