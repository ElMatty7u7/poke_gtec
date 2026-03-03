import 'package:flutter/material.dart';
import 'package:gtec/domain/entities/pokemon.dart';
import 'package:gtec/domain/usecases/get_pokemons.dart';
import 'package:gtec/domain/usecases/search_pokemon.dart';

class PokemonProvider extends ChangeNotifier {
  final GetPokemons getPokemonsUseCase;
  final SearchPokemon searchPokemonUseCase;

  PokemonProvider({
    required this.getPokemonsUseCase,
    required this.searchPokemonUseCase,
  });

  // State
  List<Pokemon> _pokemons = [];
  List<Pokemon> get pokemons => _pokemons;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFetchingMore = false;
  bool get isFetchingMore => _isFetchingMore;

  bool _hasReachedMax = false;
  bool get hasReachedMax => _hasReachedMax;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Pagination parameters
  final int limit = 20;
  int _offset = 0;

  Future<void> loadInitialPokemons() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _offset = 0;
      final results = await getPokemonsUseCase(offset: _offset, limit: limit);
      _pokemons = results;

      if (results.length < limit) {
        _hasReachedMax = true;
      } else {
        _hasReachedMax = false;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePokemons() async {
    if (_isFetchingMore || _isLoading || _hasReachedMax) return;

    _isFetchingMore = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _offset += limit;
      final results = await getPokemonsUseCase(offset: _offset, limit: limit);

      if (results.isEmpty || results.length < limit) {
        _hasReachedMax = true;
      }

      _pokemons.addAll(results);
    } catch (e) {
      _errorMessage = e.toString();
      _offset -= limit; // Revert offset if error
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<Pokemon?> searchByName(String name) async {
    if (name.isEmpty) return null;
    try {
      return await searchPokemonUseCase(name: name);
    } catch (e) {
      return null;
    }
  }
}
