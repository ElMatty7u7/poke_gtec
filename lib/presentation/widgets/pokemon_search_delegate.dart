import 'package:flutter/material.dart';
import 'package:gtec/domain/entities/pokemon.dart';
import 'package:gtec/presentation/providers/pokemon_provider.dart';
import 'package:gtec/presentation/pages/pokemon_detail_page.dart';

class PokemonSearchDelegate extends SearchDelegate<Pokemon?> {
  final PokemonProvider provider;

  PokemonSearchDelegate(this.provider);

  @override
  String get searchFieldLabel => 'Search name or ID';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Type a pokemon name or ID.'));
    }

    return FutureBuilder<Pokemon?>(
      future: provider.searchByName(query.trim().toLowerCase()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Pokemon not found.'));
        }

        final pokemon = snapshot.data!;

        return ListView(
          children: [
            Padding(
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
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailPage(
                          pokemon: pokemon,
                          provider: provider,
                        ),
                      ),
                    );
                  },
                  leading: Hero(
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
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Search by name or ID'));
  }
}
