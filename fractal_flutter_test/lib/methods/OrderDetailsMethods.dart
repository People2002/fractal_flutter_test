import 'package:flutter/material.dart';
import 'package:fractal_flutter_test/model/OrderDetail.dart';
import 'package:fractal_flutter_test/model/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderDetailMethods {
  static Future<List<Product>> fetchSelectedProducts(int id) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/orderdetails/products/$id'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => Product.fromJson(data)).toList();
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  static Future<OrderDetail?> getOrderDetailById(int id) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/orderdetails/get/$id'));

      if (response.statusCode == 200) {
        return OrderDetail.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load order detail with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching order detail: $e');
      return null;
    }
  }
  static Future<void> addOrderDetail(
      int orderId, OrderDetail orderDetail) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/orderdetails/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderDetail.toJson()),
    );

    if (response.statusCode == 200) {
      print('OrderDetail added successfully');
    } else {
      print('Failed to add OrderDetail. Error: ${response.statusCode}');
    }
  }

  static Future<void> updateOrderDetail(
      int id, OrderDetail orderDetail) async {
    Map<String, dynamic> orderDetailDetails = {
      'order_id': orderDetail.orderId,
      'product_id': orderDetail.productId,
      'price': orderDetail.price,
      'qty': orderDetail.qty,
    };
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8080/orderdetails/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderDetailDetails),
    );

    if (response.statusCode == 200) {
      print('OrderDetail update successfully');
    } else {
      print('Failed to update OrderDetail. Error: ${response.statusCode}');
    }
  }

  static Future<void> deleteOrderDetail(
      BuildContext context, int orderDetailId) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Product in Order'),
            content:
                Text('Are you sure you want to delete this Product?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Confirm'),
                onPressed: () async {
                  Navigator.of(context).pop();

                  try {
                    final response = await http.delete(Uri.parse(
                        'http://10.0.2.2:8080/orderdetails/delete/$orderDetailId'));

                    if (response.statusCode == 200) {
                      print('OrderDetail successfully deleted');
                    } else {
                      print(
                          'Error deleting the OrderDetail: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('HTTP request error: $e');
                  }
                },
              ),
            ],
          );
        });
  }

  static Future<double> getOrderDetailsTotalPrice(int id) async {
    final totalPriceUrl =
    Uri.parse('http://10.0.2.2:8080/orderdetails/products/$id/totalPrice');

    final totalPriceResponse = await http.get(totalPriceUrl);
    if (totalPriceResponse.statusCode == 200) {
      return double.parse(totalPriceResponse.body);
    } else {
      print(
          'Failed to load total price. Error ${totalPriceResponse.statusCode}');
    }
    return 0;
  }

  static Future<int> getOrderDetailsNumProducts(int id) async {
    final totalQtyUrl =
    Uri.parse('http://10.0.2.2:8080/orderdetails/products/$id/totalQty');

    final totalQtyResponse = await http.get(totalQtyUrl);
    if (totalQtyResponse.statusCode == 200) {
      return int.parse(totalQtyResponse.body);
    } else {
      print(
          'Failed to load total quantity. Error ${totalQtyResponse.statusCode}');
    }
    return 0;
  }
}
