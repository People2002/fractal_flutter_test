package com.azpdev.fractal_flutter_test_bk.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import com.azpdev.fractal_flutter_test_bk.model.OrderDetail;

public interface OrderDetailRepo extends JpaRepository<OrderDetail, Integer> {
    List<OrderDetail> findByOrderId(Integer orderId);

}
