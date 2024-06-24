package com.azpdev.fractal_flutter_test_bk.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.azpdev.fractal_flutter_test_bk.model.Orders;

public interface OrdersRepo extends JpaRepository<Orders, Integer> {
    Optional<Orders> findFirstByOrderByIdDesc();
}
