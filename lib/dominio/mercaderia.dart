class Mercaderia {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock; // Campo agregado

  Mercaderia({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
  });

  // Método para obtener una copia con stock modificado.
  Mercaderia copyWith({int? stock}) {
    return Mercaderia(
      id: id,
      nombre: nombre,
      descripcion: descripcion,
      precio: precio,
      stock: stock ?? this.stock,
    );
  }
}
