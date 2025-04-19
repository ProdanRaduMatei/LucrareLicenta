package org.example.backend.persistence;

import org.example.backend.domain.Booking;
import org.example.backend.domain.Storey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

@RepositoryRestResource
public interface BookingRepository extends JpaRepository<Booking, Long> {
    boolean existsBySeatIdAndDate(Long seatId, Instant date);

    List<Booking> findByUserId(Long userId);
    int countBySeat_Storey_NameAndDate(String storeyName, Instant date);
}
