import 'package:flutter/material.dart';
import 'package:gtec/config/app_theme.dart';
import 'package:http/http.dart' as http;

import 'package:gtec/data/datasources/pokemon_remote_data_source.dart';
import 'package:gtec/data/repositories/pokemon_repository_impl.dart';
import 'package:gtec/domain/usecases/get_pokemons.dart';
import 'package:gtec/domain/usecases/search_pokemon.dart';
import 'package:gtec/presentation/pages/pokemon_home_page.dart';
import 'package:gtec/presentation/providers/pokemon_provider.dart';

void main() {
  final httpClient = http.Client();
  final remoteDataSource = PokemonRemoteDataSourceImpl(client: httpClient);
  final repository = PokemonRepositoryImpl(remoteDataSource: remoteDataSource);

  final getPokemonsUseCase = GetPokemons(repository);
  final searchPokemonUseCase = SearchPokemon(repository);

  final pokemonProvider = PokemonProvider(
    getPokemonsUseCase: getPokemonsUseCase,
    searchPokemonUseCase: searchPokemonUseCase,
  );

  runApp(MyApp(provider: pokemonProvider));
}

class MyApp extends StatelessWidget {
  final PokemonProvider provider;

  const MyApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex GTec',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: PokemonHomePage(provider: provider),
    );
  }
}
