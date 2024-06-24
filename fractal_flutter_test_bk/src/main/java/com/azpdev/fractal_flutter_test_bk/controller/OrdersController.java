package com.azpdev.fractal_flutter_test_bk.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.azpdev.fractal_flutter_test_bk.model.Orders;
import com.azpdev.fractal_flutter_test_bk.repository.OrdersRepo;

@RestController
@RequestMapping(value = "/orders")
public class OrdersController {

    @Autowired
    OrdersRepo ordersRepo;

    @PostMapping("/add")
    public Orders addOrder(@RequestBody Orders order) {
        ordersRepo.save(order);
        return order;
    }

    @GetMapping("/getAll")
    public List<Orders> getAllOrders() {
        return ordersRepo.findAll();
    }

    @GetMapping("/get/{id}")
    public ResponseEntity<Orders> getOrderById(@PathVariable Integer id) {
        Optional<Orders> order = ordersRepo.findById(id);
        if (order.isPresent()) {
            return ResponseEntity.ok(order.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/nextId")
    public Integer getNextId() {
        Optional<Orders> maxIdOrder = ordersRepo.findFirstByOrderByIdDesc();
        Integer nextId = maxIdOrder.map(order -> order.getId() + 1).orElse(1);
        return nextId;
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<Orders> updateOrder(@PathVariable Integer id, @RequestBody Orders orderDetails) {
        Optional<Orders> optionalOrder = ordersRepo.findById(id);
        if (optionalOrder.isPresent()) {
            Orders order = optionalOrder.get();
            order.setNum_order(orderDetails.getNum_order());
            order.setDate(orderDetails.getDate());
            order.setNum_products(orderDetails.getNum_products());
            order.setFinal_price(orderDetails.getFinal_price());
            ordersRepo.save(order);
            return ResponseEntity.ok(order);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteOrder(@PathVariable Integer id) {
        Optional<Orders> optionalOrder = ordersRepo.findById(id);
        if (optionalOrder.isPresent()) {
            ordersRepo.deleteById(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
