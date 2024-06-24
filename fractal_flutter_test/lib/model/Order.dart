class Order {
  final int id;
  final String numOrder;
  final String date;
  final int numProducts;
  final double finalPrice;

  Order({
    required this.id,
    required this.numOrder,
    required this.date,
    required this.numProducts,
    required this.finalPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      numOrder: json['num_order'],
      date: json['date'],
      numProducts: json['num_products'],
      finalPrice: json['final_price'].toDouble(),
    );
  }


}
