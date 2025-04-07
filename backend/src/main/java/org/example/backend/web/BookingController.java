package org.example.backend.web;

import org.example.backend.domain.Booking;
import org.example.backend.domain.Seat;
import org.example.backend.domain.Storey;
import org.example.backend.domain.User;
import org.example.backend.service.BookingService;
import org.example.backend.service.SeatService;
import org.example.backend.service.StoreyService;
import org.example.backend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/booking")
public class BookingController {
    @Autowired
    private BookingService bookingService;

    @Autowired
    private UserService userService;
    @Autowired
    private StoreyService storeyService;
    @Autowired
    private SeatService seatService;

    @GetMapping
    public List<Booking> getAllBookings() {
        return bookingService.getAllBookings();
    }

    @PostMapping("/book")
    public ResponseEntity<String> createBooking(@RequestBody BookingDTO bookingDTO) {
        User user = userService.findUserByEmail(bookingDTO.getUserEmail());
        Instant date = Instant.parse(bookingDTO.getDate());
        Storey storey = storeyService.findStoreyByName(bookingDTO.getStoreyName());
        List<SeatDTO> seatDTOS = bookingDTO.getSelectedSeats();
        for (SeatDTO seatDTO : seatDTOS) {
            Seat seat = seatService.findSeatByColAndRowAndStoreyName(seatDTO.getCol(), seatDTO.getRow(), storey.getName());
            bookingService.createBooking(user, seat, date);
        }
        return ResponseEntity.ok("Booking created successfully");
    }

    @PostMapping("/bookings")
    public ResponseEntity<List<SeatBookingDTO>> getUserBookings(@RequestBody UserEmailDTO userEmailDTO) {
        if (userEmailDTO == null || userEmailDTO.getUserEmail() == null || userEmailDTO.getUserEmail().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        User user = userService.findUserByEmail(userEmailDTO.getUserEmail());
        if (user == null) {
            return ResponseEntity.notFound().build();
        }

        List<Booking> bookings = bookingService.getUserBookings(user.getId());
        List<SeatBookingDTO> seatBookingDTOs = bookings.stream()
                .map(b -> new SeatBookingDTO(
                        b.getSeat().getId().intValue(),
                        b.getDate().toString(),
                        b.getId()))
                .toList();

        return ResponseEntity.ok(seatBookingDTOs);
    }

    @DeleteMapping("/delete")
    public ResponseEntity<String> deleteBooking(@RequestBody Map<String, Long> request) {
        Long bookingId = request.get("bookingId");
        if (bookingId == null) {
            return ResponseEntity.badRequest().body("Missing bookingId");
        }

        boolean deleted = bookingService.deleteBookingById(bookingId);
        if (deleted) {
            return ResponseEntity.ok("Booking deleted successfully");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
