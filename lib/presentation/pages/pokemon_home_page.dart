import 'package:flutter/material.dart';
import 'package:gtec/presentation/providers/pokemon_provider.dart';
import 'package:gtec/presentation/widgets/pokemon_list_view.dart';
import 'package:gtec/presentation/widgets/pokemon_search_delegate.dart';

class PokemonHomePage extends StatelessWidget {
  final PokemonProvider provider;

  const PokemonHomePage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex GTec'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: PokemonSearchDelegate(provider),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(child: PokemonListView(provider: provider)),
    );
  }
}
