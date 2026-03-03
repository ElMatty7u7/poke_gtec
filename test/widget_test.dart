// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:gtec/main.dart';
import 'package:gtec/data/datasources/pokemon_remote_data_source.dart';
import 'package:gtec/data/repositories/pokemon_repository_impl.dart';
import 'package:gtec/domain/usecases/get_pokemons.dart';
import 'package:gtec/domain/usecases/search_pokemon.dart';
import 'package:gtec/presentation/providers/pokemon_provider.dart';

void main() {
  testWidgets('PokeApi GTec app smoke test', (WidgetTester tester) async {
    final httpClient = http.Client();
    final remoteDataSource = PokemonRemoteDataSourceImpl(client: httpClient);
    final repository = PokemonRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    final getPokemonsUseCase = GetPokemons(repository);
    final searchPokemonUseCase = SearchPokemon(repository);

    final pokemonProvider = PokemonProvider(
      getPokemonsUseCase: getPokemonsUseCase,
      searchPokemonUseCase: searchPokemonUseCase,
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(provider: pokemonProvider));
    await tester.pump();

    // Verify that our app bar title exists
    expect(find.text('Pokedex GTec'), findsOneWidget);
  });
}
