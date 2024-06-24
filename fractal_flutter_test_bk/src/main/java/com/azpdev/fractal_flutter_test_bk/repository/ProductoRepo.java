package com.azpdev.fractal_flutter_test_bk.repository;

import com.azpdev.fractal_flutter_test_bk.model.Producto;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductoRepo extends JpaRepository<Producto, Integer> {

}
