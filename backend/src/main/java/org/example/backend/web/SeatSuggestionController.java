package org.example.backend.web;

import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.example.backend.service.SeatSuggestionService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ai")
@RequiredArgsConstructor
public class SeatSuggestionController {
    private final SeatSuggestionService seatSuggestionService;

    @PostMapping("/suggest-seats")
    public ResponseEntity<?> suggestSeats(@RequestBody SuggestRequest request) {
        Instant date = request.date.atStartOfDay().toInstant(ZoneOffset.UTC);
        List<Map<String, Object>> suggestions = seatSuggestionService.getSuggestions(
                request.storeyName, request.userEmail, date
        );
        return ResponseEntity.ok(Map.of("suggestions", suggestions));
    }

    @Data
    public static class SuggestRequest {
        private String userEmail;
        private String storeyName;

        @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
        private LocalDate date;
    }
}