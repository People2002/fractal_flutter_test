import 'package:flutter/material.dart';
import 'package:fractal_flutter_test/methods/orders_methods.dart';
import 'package:fractal_flutter_test/model/Order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyOrders extends StatefulWidget {
  MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Order> orders = [];
  int nextOrderId = 0;

  Future<void> fetchOrders() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8080/orders/getAll'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          orders = jsonResponse.map((data) => Order.fromJson(data)).toList();
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void deleteOrder(int orderId) async {
    await OrdersMethods.deleteOrder(context, orderId);
    await fetchOrders();
  }

  Future<void> getNextOrderId() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8080/orders/nextId'));
      if (response.statusCode == 200) {
        setState(() {
          nextOrderId = int.parse(response.body);
        });
      } else {
        print('Failed to get next order ID: ${response.statusCode}');
        setState(() {
          nextOrderId = -1;
        });
      }
    } catch (e) {
      print('Error fetching next order ID: $e');
      setState(() {
        nextOrderId = -1;
      });
    }
  }

  Future<void> _refreshOrders() async {
    await fetchOrders();
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshOrders,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
                  orders.isEmpty
                      ? const Center(child: Text('No Orders found'))
                      : DataTable(
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Order Number')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('# Products')),
                            DataColumn(label: Text('Final Price')),
                            DataColumn(label: Text('Options')),
                          ],
                          rows: orders.map((order) {
                            return DataRow(cells: [
                              DataCell(Text(order.id.toString())),
                              DataCell(Text(order.numOrder)),
                              DataCell(Text(order.date)),
                              DataCell(Text(order.numProducts.toString())),
                              DataCell(Text(order.finalPrice.toString())),
                              DataCell(
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context,
                                            '/add-order/${order.id.toString()}');
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteOrder(order.id);
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
            ),
            ElevatedButton(
              onPressed: () async {
                await getNextOrderId();
                await Navigator.pushNamed(context, '/add-order/$nextOrderId');
                _refreshOrders;
              },
              child: const Text('New Order'),
            ),

          ],
        ),
      ),
    );
  }
}
