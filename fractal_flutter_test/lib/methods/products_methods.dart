import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/Product.dart';

class ProductsMethods {
  static Future<List<Product>> fetchProducts() async {
    try {
      final response =
      await http.get(Uri.parse('http://10.0.2.2:8080/producto/getAll'));

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

  static Future<void> deleteProduct(BuildContext context, int productId) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmar eliminación'),
            content: Text(
                '¿Estás seguro de que deseas eliminar este producto?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Eliminar'),
                onPressed: () async {
                  Navigator.of(context).pop();

                  try {
                    final response = await http.delete(
                        Uri.parse(
                            'http://10.0.2.2:8080/producto/delete/$productId'));

                    if (response.statusCode == 200) {
                      print('Producto eliminado exitosamente');
                    } else {
                      print(
                          'Error al eliminar el producto: ${response
                              .statusCode}');
                    }
                  } catch (e) {
                    print('Error en la solicitud HTTP: $e');
                  }
                },
              ),
            ],
          );
        }
    );
  }


}
