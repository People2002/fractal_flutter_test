import 'package:flutter/material.dart';
import 'package:fractal_flutter_test/methods/OrderDetailsMethods.dart';
import 'package:fractal_flutter_test/methods/orders_methods.dart';
import 'package:fractal_flutter_test/methods/products_methods.dart';
import 'package:fractal_flutter_test/model/Order.dart';
import 'package:fractal_flutter_test/model/OrderDetail.dart';
import 'package:intl/intl.dart';
import '../model/Product.dart';

class AddEditOrder extends StatefulWidget {
  final int id;

  const AddEditOrder({super.key, required this.id});

  @override
  _AddEditOrderState createState() => _AddEditOrderState();
}

class _AddEditOrderState extends State<AddEditOrder> {
  String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final OrdersMethods _ordersMethods = OrdersMethods();
  late int id;
  late String numOrder;
  late String date;
  late int numProducts;
  late double finalPrice;
  bool nuevo = false;

  List<Product> products = [];
  List<Product> selectProducts = [];

  Future<void> fetchProducts() async {
    List<Product> fetchedProducts = await ProductsMethods.fetchProducts();
    setState(() {
      products = fetchedProducts;
    });
  }

  Future<void> fetchProductsSelected(int id) async {
    List<Product> fetchedProductsSelected =
        await OrderDetailMethods.fetchSelectedProducts(id);
    setState(() {
      selectProducts = fetchedProductsSelected;
    });
  }

  Future<void> fetchOrderDetails() async {
    Map<String, dynamic> orderData =
        await _ordersMethods.getOrderById(widget.id);
    setState(() {
      id = orderData['id'] ?? 0;
      numOrder = orderData['num_order'] ?? '';
      date = orderData['date'] ?? '';
      numProducts = orderData['num_products'] ?? 0;
      finalPrice = orderData['final_price'] ?? 0.0;
      nuevo = orderData['nuevo'] ?? false;
    });
  }

  void deleteProduct(int productId) async {
    await ProductsMethods.deleteProduct(context, productId);
    await fetchProducts();
  }

  void deleteOrderDetail(int orderDetailId) async {
    await OrderDetailMethods.deleteOrderDetail(context, orderDetailId);
    await fetchProducts();
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchOrderDetails();
    fetchProductsSelected(widget.id);
  }

  void addProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedValue;
        final List<String> productNames =
            products.map((product) => product.name).toList();
        final TextEditingController numberController = TextEditingController();
        int selectedProductId = 0;
        int qty = 0;
        return AlertDialog(
          title: const Text('Select a Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField<String>(
                items: productNames.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue!;
                    selectedProductId =
                        products.firstWhere(
                              (element) => element.name == selectedValue,
                        ).id;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Products',
                ),
              ),
              TextFormField(
                controller: numberController,
                onChanged: (value) {
                  setState(() {
                    qty = int.parse(value);
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Enter quantity',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                double price = calculatePrice(selectedProductId);
                OrderDetail orderDetail = OrderDetail(orderId: widget.id, productId: selectedProductId, price: price, qty: qty);
                await OrderDetailMethods.addOrderDetail(widget.id, orderDetail);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void editProductSelectedDialog(String name, int orderDetailId, double unitPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController priceController = TextEditingController();
        double price = unitPrice;
        return AlertDialog(
          title: const Text('Edit a Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                ),
                readOnly: true,
              ),
              TextFormField(
                controller: priceController,
                onChanged: (value) {
                  setState(() {
                    price = double.parse(value);
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Enter new price',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                OrderDetail? orderDetailUpdated = await OrderDetailMethods.getOrderDetailById(orderDetailId);
                await OrderDetailMethods.updateOrderDetail(orderDetailId, OrderDetail(orderId: orderDetailUpdated!.orderId, productId: orderDetailUpdated.productId, price: price, qty: orderDetailUpdated.qty));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  double calculatePrice(int productId) {
    Product product = products.firstWhere((element) => element.id == productId);
    return product.unitPrice;
  }

  Future<void> _refreshOrders() async {
    print(widget.id);
    await fetchProducts();
    await fetchProductsSelected(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: nuevo ? const Text('Add Order') : const Text('Edit Order'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshOrders,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: numOrder,
                onChanged: (value) {
                  setState(() {
                    numOrder = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Order #',
                ),
                readOnly: false,
              ),
              TextFormField(
                initialValue: date,
                decoration: const InputDecoration(
                  labelText: 'Date',
                ),
                readOnly: true,
              ),
              TextFormField(
                initialValue: numProducts.toString(),
                decoration: const InputDecoration(
                  labelText: '# Products',
                ),
                readOnly: true,
              ),
              TextFormField(
                initialValue: finalPrice.toString(),
                decoration: const InputDecoration(
                  labelText: 'Final Price',
                ),
                readOnly: true,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: addProductDialog,
                  child: const Text('Add Product'),
                ),
              ),
              const Text('Selected products',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 16.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                selectProducts.isEmpty
                    ? const Center(child: Text('No Products selected'))
                    : DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Unit price')),
                    DataColumn(label: Text('Qty')),
                    DataColumn(label: Text('Total Price')),
                    DataColumn(label: Text('Options')),
                  ],
                  rows: selectProducts.map((product) {
                    return DataRow(cells: [
                      DataCell(Text(product.id.toString())),
                      DataCell(Text(product.name)),
                      DataCell(Text(product.unitPrice.toString())),
                      DataCell(Text(product.qty.toString())),
                      DataCell(Text(product.totalPrice.toString())),
                      DataCell(
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                editProductSelectedDialog(product.name, product.id, product.unitPrice);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteOrderDetail(product.id);
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
              const Text('Available products',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 16.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                products.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Unit price')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Total Price')),
                  ],
                  rows: products.map((product) {
                    return DataRow(cells: [
                      DataCell(Text(product.id.toString())),
                      DataCell(Text(product.name)),
                      DataCell(Text(product.unitPrice.toString())),
                      DataCell(Text(product.qty.toString())),
                      DataCell(Text(product.totalPrice.toString())),
                    ]);
                  }).toList(),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    double totalPriceOrder = await OrderDetailMethods.getOrderDetailsTotalPrice(widget.id);
                    int numProductsOrder = await OrderDetailMethods.getOrderDetailsNumProducts(widget.id);
                    Order updatedOrder = Order(id: widget.id, numOrder: numOrder, date: date, numProducts: numProductsOrder, finalPrice: totalPriceOrder);
                    print("numero ${updatedOrder.numOrder}");
                    if(nuevo){
                      await OrdersMethods.addOrder(updatedOrder);
                    }else{
                      await OrdersMethods.updateOrder(widget.id, updatedOrder);
                    }
                   setState(() {
                   });
                    Navigator.pop(context, true);
                  },
                  child: const Text('Save Order'),
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}

