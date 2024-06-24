import 'package:flutter/material.dart';
import 'package:fractal_flutter_test/model/Order.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';



class OrdersMethods {
  Future<Map<String, dynamic>> getOrderById(int id) async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8080/orders/get/$id'));
      String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 404) {
        return {
          'id': null,
          'num_order': '',
          'date': currentDate,
          'num_products': null,
          'final_price': null,
          'nuevo': true
        };
      } else {
        return {
          'id': null,
          'num_order': '',
          'date': '',
          'num_products': null,
          'final_price': null,
          'nuevo': true
        };
      }
    } catch (e) {
      return {
        'id': null,
        'num_order': '',
        'date': '',
        'num_products': null,
        'final_price': null,
        'nuevo': true
      };
    }
  }

  static Future<void> addOrder(Order order) async {
    Map<String, dynamic> orderDetails = {
      'num_order': order.numOrder,
      'date': order.date,
      'num_products': order.numProducts,
      'final_price': order.finalPrice,
    };
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/orders/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderDetails),
    );

    if (response.statusCode == 200) {
      print('Order added successfully');
    } else {
      print('Failed to added Order. Error: ${response.statusCode}');
    }
  }

  static Future<void> updateOrder(
      int id, Order order) async {
    Map<String, dynamic> orderDetails = {
      'num_order': order.numOrder,
      'date': order.date,
      'num_products': order.numProducts,
      'final_price': order.finalPrice,
    };
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8080/orders/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderDetails),
    );

    if (response.statusCode == 200) {
      print('Order update successfully');
    } else {
      print('Failed to update Order. Error: ${response.statusCode}');
    }
  }

  static Future<void> deleteOrder(BuildContext context, int orderId) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Order'),
            content:
                Text('Are you sure you want to delete this Order?'),
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
                        'http://10.0.2.2:8080/orders/delete/$orderId'));

                    if (response.statusCode == 200) {
                      print('Order successfully deleted');
                    } else {
                      print(
                          'Error deleting the order: ${response.statusCode}');
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
}
