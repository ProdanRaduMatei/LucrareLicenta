package org.example.backend.web;

import org.example.backend.domain.Seat;
import org.example.backend.service.BookingService;
import org.example.backend.service.SeatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.List;

@RestController
@RequestMapping("/seats")
public class SeatController {
    @Autowired
    private SeatService seatService;

    @Autowired
    private BookingService bookingService;

    public SeatController(SeatService seatService, BookingService bookingService) {
        this.seatService = seatService;
        this.bookingService = bookingService;
    }

    @PostMapping("/layout")
    public ResponseEntity<int[][]> getSeatLayout(@RequestBody LayoutDTO layoutDTO) {
        // Parse the date string into an Instant.
        Instant instantDate = Instant.parse(layoutDTO.getDate());
        // Set the time to 00:00:00 by subtracting the seconds passed since midnight.
        instantDate = instantDate.minusSeconds(instantDate.getEpochSecond() % 86400);

        // Retrieve all seats for the given storey.
        String storeyName = layoutDTO.getStoreyName();
        List<Seat> seats = seatService.getSeatsByStoreyName(storeyName);

        // Create a 25x25 seat matrix initialized to 0.
        int[][] seatMatrix = new int[25][25];
        for (int i = 0; i < 25; i++) {
            for (int j = 0; j < 25; j++) {
                seatMatrix[i][j] = 0;
            }
        }

        // For each seat, check if it's booked at the given date.
        for (Seat seat : seats) {
            boolean isBooked = bookingService.isSeatBooked(seat.getId(), instantDate);
            seatMatrix[seat.getLine()][seat.getCol()] = isBooked ? 2 : 1;
        }

        return ResponseEntity.ok(seatMatrix);
    }
}
