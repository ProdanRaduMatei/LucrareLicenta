package org.example.backend.persistence;

import org.example.backend.domain.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.List;

@RepositoryRestResource
public interface SeatRepository extends JpaRepository<Seat, Long> {
    List<Seat> findByStoreyName(String storeyName);
    Seat findByColAndLineAndStoreyName(Integer col, Integer line, String storeyName);
}
