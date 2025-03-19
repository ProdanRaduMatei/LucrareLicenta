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

    @GetMapping("/bookings")
    public ResponseEntity<int[]> getUserBookings(@RequestBody UserEmailDTO userEmailDTO) {
        // Ensure the request contains an email
        if (userEmailDTO == null || userEmailDTO.getUserEmail() == null || userEmailDTO.getUserEmail().isEmpty()) {
            return ResponseEntity.badRequest().build(); // Return 400 Bad Request
        }

        // Find user by email
        User user = userService.findUserByEmail(userEmailDTO.getUserEmail());
        if (user == null) {
            return ResponseEntity.notFound().build(); // Return 404 Not Found
        }

        // Get user bookings
        List<Booking> bookings = bookingService.getUserBookings(user.getId());
        int[] seats = new int[bookings.size()];
        for (Booking booking : bookings) {
            seats[bookings.indexOf(booking)] = booking.getSeat().getId().intValue();
        }
        return ResponseEntity.ok(seats);
    }
}
