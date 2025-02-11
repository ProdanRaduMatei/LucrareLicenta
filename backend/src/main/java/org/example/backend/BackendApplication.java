package org.example.backend;

import jakarta.transaction.Transactional;
import org.example.backend.config.RsaKeyProperties;
import org.example.backend.domain.*;
import org.example.backend.persistence.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@EnableConfigurationProperties(RsaKeyProperties.class)
@SpringBootApplication
public class BackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(BackendApplication.class, args);
    }

//    @Bean
//    @Transactional
//    CommandLineRunner commandLineRunner(
//            AdminRepository adminRepository,
//            UserRepository userRepository,
//            BuildingRepository buildingRepository,
//            StoreyRepository storeyRepository,
//            SeatRepository seatRepository,
//            BookingRepository bookingRepository
//    ) {
//        return args -> {
//            // 1) Admin
//            Admin admin = new Admin();
//            admin.setName("Admin Name");
//            admin.setEmail("admin@gmail.com");
//            admin.setPassword("admin");
//
//            // 2) Users
//            User user1 = new User();
//            user1.setName("User Name1");
//            user1.setEmail("user1@gmail.com");
//            user1.setPassword("user1");
//
//            User user2 = new User();
//            user2.setName("User Name2");
//            user2.setEmail("user2@gmail.com");
//            user2.setPassword("user2");
//
//            // 3) Buildings
//            Building building1 = new Building();
//            building1.setName("Building Name1");
//            building1.setAdmin(admin);
//
//            Building building2 = new Building();
//            building2.setName("Building Name2");
//            building2.setAdmin(admin);
//
//            // 4) Storeys
//            Storey storey1 = new Storey();
//            storey1.setName("etaj4");
//            storey1.setBuilding(building1);
//
//            Storey storey2 = new Storey();
//            storey2.setName("etaj6");
//            storey2.setBuilding(building1);
//
//            // 5) Seats
//            Seat seat1 = createSeat(1,1,"Standing","2021-01-01T00:00:00Z","2026-01-01T00:00:00Z", storey1);
//            Seat seat2 = createSeat(1,2,"2 Monitors","2021-01-01T00:00:00Z","2026-01-01T00:00:00Z", storey1);
//            Seat seat3 = createSeat(2,1,"1 Monitor","2021-01-01T00:00:00Z","2026-01-01T00:00:00Z", storey1);
//            Seat seat4 = createSeat(2,2,"No Monitors","2021-01-01T00:00:00Z","2026-01-01T00:00:00Z", storey1);
//
//            Seat seat5 = createSeat(1,1,"Standing","2021-01-01T00:00:00Z","2026-01-01T00:00:00Z", storey2);
//            Seat seat6 = createSeat(1,2,"2 Monitors","2021-01-01T00:00:00Z","2026-01-01T00:00:00Z", storey2);
//            Seat seat7 = createSeat(2,1,"1 Monitor","2021-01-01T00:00:00Z","2026-01-01T00:00:00Z", storey2);
//            Seat seat8 = createSeat(2,2,"No Monitors","2021-01-01T00:00:00Z","2026-01-01T00:00:00Z", storey2);
//
//            building1.setStoreys(List.of(storey1, storey2));
//            admin.setBuildings(List.of(building1, building2));
//
//            // ---- Salvăm Admin și User întâi ----
//            adminRepository.save(admin);
//            userRepository.saveAll(List.of(user1, user2));
//
//            // ---- Salvăm Building, Storey, Seat ----
//            buildingRepository.saveAll(List.of(building1, building2));
//            storeyRepository.saveAll(List.of(storey1, storey2));
//            seatRepository.saveAll(List.of(seat1, seat2, seat3, seat4, seat5, seat6, seat7, seat8));
//
//            // 6) Bookings (creăm abia după ce seat & user sunt salvate)
//            Booking booking1 = createBooking("2025-08-02T00:00:00Z", seat1, user1);
//            Booking booking2 = createBooking("2025-08-02T00:00:00Z", seat2, user2);
//            Booking booking3 = createBooking("2025-08-02T00:00:00Z", seat3, user1);
//            Booking booking4 = createBooking("2025-08-02T00:00:00Z", seat1, user2);
//
//            // ---- Salvăm Booking ----
//            bookingRepository.saveAll(List.of(booking1, booking2, booking3, booking4));
//
//            // Gata: datele sunt în BD
//        };
//    }
//
//    private Seat createSeat(int line, int col, String seatType,
//                            String creationStr, String endStr, Storey storey) {
//        Seat seat = new Seat();
//        seat.setLine(line);
//        seat.setCol(col);
//        seat.setSeatType(seatType);
//        seat.setCreationDate(Instant.parse(creationStr));
//        seat.setEndAvailabilityDate(Instant.parse(endStr));
//        seat.setStorey(storey);
//        return seat;
//    }
//
//    private Booking createBooking(String dateStr, Seat seat, User user) {
//        Booking booking = new Booking();
//        booking.setDate(Instant.parse(dateStr));
//        booking.setUser(user);
//        booking.setSeat(seat);
//        booking.setConfirmed(false);
//        return booking;
//    }
}