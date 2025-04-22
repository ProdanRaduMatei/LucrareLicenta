package org.example.backend.web;

import org.example.backend.domain.Seat;
import org.example.backend.domain.Storey;
import org.example.backend.persistence.BookingRepository;
import org.example.backend.service.SeatService;
import org.example.backend.service.StoreyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/storey")
public class StoreyController {
    @Autowired
    private StoreyService storeyService;
    @Autowired
    private SeatService seatService;
    @Autowired
    private BookingRepository bookingRepository;

    @GetMapping("/all")
    public List<String> getAllStoreyNames() {
        return storeyService.getAllStoreyNames();
    }

    @PostMapping("/name")
    public String getStoreyName(@RequestBody Map<String, Integer> requestBody) {
        Integer seatId = requestBody.get("seatId");
        if (seatId == null) {
            return null;
        }
        Long longSeatId = seatId.longValue();
        Seat seat = seatService.getSeatById(longSeatId);
        Long storeyId = seat.getStorey().getId();
        Storey storey = storeyService.getStoreyById(storeyId).orElse(null);
        if (storey == null) {
            return null;
        }
        return storey.getName();
    }

    @PostMapping("/layout")
    public ResponseEntity<?> createStoreyLayout(@RequestBody StoreyLayoutDTO dto) {
        storeyService.createStoreyLayout(dto);
        return ResponseEntity.ok("Storey layout created");
    }

    @PostMapping("/stats")
    public ResponseEntity<StoreyStatsDTO> getStats(@RequestBody StoreyStatsRequest request) {
        LocalDate date = LocalDate.parse(request.getDate()); // Format: yyyy-MM-dd
        StoreyStatsDTO stats = storeyService.getStoreyStats(request.getStoreyName(), date);
        return ResponseEntity.ok(stats);
    }

    @PostMapping("/occupancy")
    public ResponseEntity<OccupancyReportResponse> getOccupancyReport(@RequestBody OccupancyReportRequest request) {
        OccupancyReportResponse response = storeyService.getOccupancyReport(request.getStoreyName(), request.getStartDate(), request.getEndDate());
        return ResponseEntity.ok(response);
    }
}
