class OrderDetail {
  final int orderId;
  final int productId;
  final double price;
  final int qty;

  OrderDetail({
    required this.orderId,
    required this.productId,
    required this.price,
    required this.qty,
  });

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'product_id': productId,
      'price': price,
      'qty': qty,
    };
  }

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderId: json['order_id'],
      productId: json['product_id'],
      price: json['price'],
      qty: json['qty'],
    );
  }
}