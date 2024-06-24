import 'package:flutter/material.dart';
import 'views/my_orders.dart';
import 'views/add_edit_order.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/my-orders',
      routes: {
        '/my-orders': (context) => MyOrders(),
      },
      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/add-order/')) {
          final id = settings.name!.replaceFirst('/add-order/', '');
          return MaterialPageRoute(
            builder: (context) => AddEditOrder(id: int.parse(id)),
          );
        }
        return null;
      },
    );
  }
}
