package org.example.backend.web;

import org.example.backend.domain.Seat;
import org.example.backend.service.BookingService;
import org.example.backend.service.SeatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.List;
import java.util.Map;

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
        Instant instantDate = Instant.parse(layoutDTO.getDate());
        instantDate = instantDate.minusSeconds(instantDate.getEpochSecond() % 86400);
        String storeyName = layoutDTO.getStoreyName();
        List<Seat> seats = seatService.getSeatsByStoreyName(storeyName);
        int[][] seatMatrix = new int[25][25];
        for (int i = 0; i < 25; i++) {
            for (int j = 0; j < 25; j++) {
                seatMatrix[i][j] = 0;
            }
        }
        for (Seat seat : seats) {
            boolean isBooked = bookingService.isSeatBooked(seat.getId(), instantDate);
            seatMatrix[seat.getLine()][seat.getCol()] = isBooked ? 2 : 1;
        }
        return ResponseEntity.ok(seatMatrix);
    }

    @PostMapping("/seat")
    public ResponseEntity<int[]> getLineCol(@RequestBody Map<String, Integer> requestBody) {
        Integer seatId = requestBody.get("seatId");
        if (seatId == null) {
            return ResponseEntity.badRequest().build();
        }
        Long lSeatId = seatId.longValue();
        Seat seat = seatService.getSeatById(lSeatId);
        if (seat == null) {
            return ResponseEntity.notFound().build();
        }
        int[] lineCol = new int[2];
        lineCol[0] = seat.getLine();
        lineCol[1] = seat.getCol();
        return ResponseEntity.ok(lineCol);
    }


}
