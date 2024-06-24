package com.azpdev.fractal_flutter_test_bk.controller;

import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.azpdev.fractal_flutter_test_bk.model.Producto;
import com.azpdev.fractal_flutter_test_bk.repository.ProductoRepo;

@RestController
@RequestMapping(value = "/producto")
public class ProductoController {

    @Autowired
    ProductoRepo productoRepo;

    @PostMapping("/add")
    Producto addProducto(@RequestBody Producto producto) {
        productoRepo.save(producto);
        return producto;
    }

    @GetMapping("/getAll")
    List<Producto> getProducto() {
        List<Producto> producto = productoRepo.findAll();
        return producto;
    }

    @GetMapping("/get/{id}")
    ResponseEntity<Producto> getProductoById(@PathVariable Integer id) {
        Optional<Producto> producto = productoRepo.findById(id);
        if (producto.isPresent()) {
            return ResponseEntity.ok(producto.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PutMapping("/update/{id}")
    ResponseEntity<Producto> updateProducto(@PathVariable Integer id, @RequestBody Producto productoDetails) {
        Optional<Producto> optionalProducto = productoRepo.findById(id);
        if (optionalProducto.isPresent()) {
            Producto producto = optionalProducto.get();
            producto.setName(productoDetails.getName());
            producto.setUnit_price(productoDetails.getUnit_price());
            producto.setQty(productoDetails.getQty());
            producto.setTotal_price(productoDetails.getTotal_price());
            productoRepo.save(producto);
            return ResponseEntity.ok(producto);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/delete/{id}")
    ResponseEntity<Void> deleteProducto(@PathVariable Integer id) {
        Optional<Producto> optionalProducto = productoRepo.findById(id);
        if (optionalProducto.isPresent()) {
            productoRepo.deleteById(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

}
