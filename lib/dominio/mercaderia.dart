class Mercaderia {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;

  Mercaderia({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
  });

  Mercaderia copyWith({int? stock}) {
    return Mercaderia(
      id: id,
      nombre: nombre,
      descripcion: descripcion,
      precio: precio,
      stock: stock ?? this.stock,
    );
  }

  factory Mercaderia.fromJson(Map<String, dynamic> json) {
    return Mercaderia(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: (json['precio'] as num).toDouble(),
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
    };
  }
}
