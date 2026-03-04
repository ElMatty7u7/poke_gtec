import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:gtec/domain/entities/pokemon.dart';
import 'package:gtec/presentation/providers/pokemon_provider.dart';
import 'package:gtec/presentation/pages/pokemon_detail_page.dart';

class PokemonListView extends StatefulWidget {
  final PokemonProvider provider;

  const PokemonListView({super.key, required this.provider});

  @override
  State<PokemonListView> createState() => _PokemonListViewState();
}

class _PokemonListViewState extends State<PokemonListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.provider.loadInitialPokemons();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Dummy list for Skeletonizer
  List<Pokemon> get _dummyData => List.generate(
    10,
    (index) => Pokemon(id: index, name: 'Loading...', imageUrl: ''),
  );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.provider,
      builder: (context, child) {
        if (widget.provider.errorMessage.isNotEmpty &&
            widget.provider.pokemons.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${widget.provider.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.provider.loadInitialPokemons();
                  },
                  child: const Text('Intentar de nuevo'),
                ),
              ],
            ),
          );
        }

        final isInitialLoading =
            widget.provider.isLoading && widget.provider.pokemons.isEmpty;
        final items = isInitialLoading ? _dummyData : widget.provider.pokemons;

        return Skeletonizer(
          enabled: isInitialLoading,
          child: ListView.builder(
            controller: _scrollController,
            itemCount:
                items.length +
                (isInitialLoading || widget.provider.hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                if (widget.provider.isFetchingMore) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.provider.loadMorePokemons();
                      },
                      child: const Text('Cargar más pokemones'),
                    ),
                  );
                }
              }

              final pokemon = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    onTap: isInitialLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PokemonDetailPage(
                                  pokemon: pokemon,
                                  provider: widget.provider,
                                ),
                              ),
                            );
                          },
                    leading: isInitialLoading
                        ? Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                        : Hero(
                            tag: 'pokemon_image_${pokemon.id}',
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.network(
                                pokemon.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                    title: Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '#${pokemon.id.toString().padLeft(3, '0')}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
