import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:gtec/domain/entities/pokemon.dart';
import 'package:gtec/presentation/providers/pokemon_provider.dart';

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;
  final PokemonProvider provider;

  const PokemonDetailPage({
    super.key,
    required this.pokemon,
    required this.provider,
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  Pokemon? _detailedPokemon;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final details = await widget.provider.searchByName(widget.pokemon.name);
      if (mounted) {
        setState(() {
          _detailedPokemon = details;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si tenemos los detalles cargados, usamos eso, si no, usamos el pokemon basico para mostrar los huesos (skeleton)
    final displayPokemon = _detailedPokemon ?? widget.pokemon;

    return Scaffold(
      appBar: AppBar(title: Text(widget.pokemon.name.toUpperCase())),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header con fondo de color
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Hero(
                tag: 'pokemon_image_${widget.pokemon.id}',
                child: Image.network(
                  widget.pokemon.imageUrl,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _errorMessage != null
                  ? Center(
                      child: Column(
                        children: [
                          Text(
                            'Error: $_errorMessage',
                            style: const TextStyle(color: Colors.red),
                          ),
                          TextButton(
                            onPressed: _fetchDetails,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    )
                  : Skeletonizer(
                      enabled: _isLoading,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('ID', '#${displayPokemon.id}'),
                              const Divider(),
                              _buildInfoRow(
                                'Nombre',
                                displayPokemon.name.toUpperCase(),
                              ),
                              const Divider(),
                              // Altura y peso falsos para el skeleton si aun no hay detalles
                              _buildInfoRow(
                                'Altura',
                                _isLoading
                                    ? '0.0 m'
                                    : '${(displayPokemon.height ?? 0) / 10} m',
                              ),
                              const Divider(),
                              _buildInfoRow(
                                'Peso',
                                _isLoading
                                    ? '0.0 kg'
                                    : '${(displayPokemon.weight ?? 0) / 10} kg',
                              ),
                              const Divider(),
                              const Text(
                                'Tipos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8.0,
                                children: _isLoading
                                    ? [
                                        const Chip(label: Text('Loading')),
                                        const Chip(label: Text('Loading')),
                                      ]
                                    : (displayPokemon.types ?? [])
                                          .map(
                                            (type) => Chip(
                                              label: Text(type.toUpperCase()),
                                              backgroundColor:
                                                  Colors.red.shade100,
                                            ),
                                          )
                                          .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
