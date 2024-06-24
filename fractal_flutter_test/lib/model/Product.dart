class Product {
  final int id;
  final String name;
  final double unitPrice;
  final int qty;
  final double totalPrice;

  Product({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.qty,
    required this.totalPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      unitPrice: json['unit_price'].toDouble(),
      qty: json['qty'],
      totalPrice: json['total_price'].toDouble(),
    );
  }
}
