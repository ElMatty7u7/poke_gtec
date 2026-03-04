class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final int? height;
  final int? weight;
  final List<String>? types;

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.height,
    this.weight,
    this.types,
  });
}
