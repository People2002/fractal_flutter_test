package com.azpdev.fractal_flutter_test_bk.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.azpdev.fractal_flutter_test_bk.model.OrderDetail;
import com.azpdev.fractal_flutter_test_bk.model.Producto;
import com.azpdev.fractal_flutter_test_bk.repository.OrderDetailRepo;
import com.azpdev.fractal_flutter_test_bk.repository.ProductoRepo;

@RestController
@RequestMapping(value = "/orderdetails")
public class OrderDetailController {

    @Autowired
    OrderDetailRepo orderDetailRepo;

    @Autowired
    ProductoRepo productRepo;

    // Añadir un nuevo detalle de orden
    @PostMapping("/add")
    public OrderDetail addOrderDetail(@RequestBody OrderDetail orderDetail) {
        orderDetailRepo.save(orderDetail);
        return orderDetail;
    }

    @GetMapping("/getAll")
    public List<OrderDetail> getAllOrderDetails() {
        return orderDetailRepo.findAll();
    }

    @GetMapping("/get/{id}")
    public ResponseEntity<OrderDetail> getOrderDetailById(@PathVariable Integer id) {
        Optional<OrderDetail> orderDetail = orderDetailRepo.findById(id);
        if (orderDetail.isPresent()) {
            return ResponseEntity.ok(orderDetail.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<OrderDetail> updateOrderDetail(@PathVariable Integer id,
            @RequestBody OrderDetail orderDetailDetails) {
        Optional<OrderDetail> optionalOrderDetail = orderDetailRepo.findById(id);
        if (optionalOrderDetail.isPresent()) {
            OrderDetail orderDetail = optionalOrderDetail.get();
            orderDetail.setOrder_id(orderDetailDetails.getOrder_id());
            orderDetail.setProduct_id(orderDetailDetails.getProduct_id());
            orderDetail.setPrice(orderDetailDetails.getPrice());
            orderDetail.setQty(orderDetailDetails.getQty());
            orderDetailRepo.save(orderDetail);
            return ResponseEntity.ok(orderDetail);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteOrderDetail(@PathVariable Integer id) {
        Optional<OrderDetail> optionalOrderDetail = orderDetailRepo.findById(id);
        if (optionalOrderDetail.isPresent()) {
            orderDetailRepo.deleteById(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/products/{orderId}")
    public List<Producto> getProductsByOrderId(@PathVariable Integer orderId) {
        List<OrderDetail> orderDetails = orderDetailRepo.findByOrderId(orderId);
        List<Producto> products = new ArrayList<>();

        for (OrderDetail orderDetail : orderDetails) {
            Integer orderDetailId = orderDetail.getId();
            Integer productId = orderDetail.getProduct_id();
            Double priceOrder = orderDetail.getPrice();
            Integer qtyOrder = orderDetail.getQty();

            Optional<Producto> optionalProduct = productRepo.findById(productId);
            if (optionalProduct.isPresent()) {
                Producto product = optionalProduct.get();
                product.setId(orderDetailId);
                product.setUnit_price(priceOrder);
                product.setQty(qtyOrder);
                product.setTotal_price(priceOrder * qtyOrder);
                products.add(product);
            }
        }
        return products;
    }

    @GetMapping("/products/{orderId}/totalPrice")
    public Double getTotalPriceByOrderId(@PathVariable Integer orderId) {
        List<OrderDetail> orderDetails = orderDetailRepo.findByOrderId(orderId);
        Double totalPrice = 0.0;

        for (OrderDetail orderDetail : orderDetails) {
            Double price = orderDetail.getPrice();
            Integer qty = orderDetail.getQty();
            totalPrice += price * qty;
        }

        return totalPrice;

    }

    @GetMapping("/products/{orderId}/totalQty")
    public Integer getTotalQtyByOrderId(@PathVariable Integer orderId) {
        List<OrderDetail> orderDetails = orderDetailRepo.findByOrderId(orderId);
        Integer totalQty = 0;

        for (OrderDetail orderDetail : orderDetails) {
            totalQty += orderDetail.getQty();
        }

        return totalQty;
    }

}
