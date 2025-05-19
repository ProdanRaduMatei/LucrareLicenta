package org.example.backend.service;

import lombok.RequiredArgsConstructor;
import org.example.backend.domain.Booking;
import org.example.backend.domain.Seat;
import org.example.backend.domain.Storey;
import org.example.backend.persistence.BookingRepository;
import org.example.backend.persistence.SeatRepository;
import org.example.backend.persistence.StoreyRepository;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SeatSuggestionService {
    private final WebClient.Builder webClientBuilder;
    private final StoreyRepository storeyRepository;
    private final SeatRepository seatRepository;
    private final BookingRepository bookingRepository;

    public List<Map<String, Object>> getSuggestions(String storeyName, String userEmail, Instant date) {
        Storey storey = storeyRepository.findByName(storeyName)
                .orElseThrow(() -> new RuntimeException("Storey not found"));

        List<Seat> allSeats = seatRepository.findByStoreyName(storeyName);
        List<Booking> bookings = bookingRepository.findBySeat_Storey_NameAndDate(storeyName, date);
        List<Seat> bookedSeats = bookings.stream().map(Booking::getSeat).toList();

        List<Map<String, Object>> all = allSeats.stream().map(s -> {
            Map<String, Object> map = new HashMap<>();
            map.put("row", s.getLine());
            map.put("col", s.getCol());
            return map;
        }).collect(Collectors.toList());

        List<Map<String, Object>> bookedList = bookedSeats.stream().map(seat -> {
            Map<String, Object> map = new HashMap<>();
            map.put("row", seat.getLine());
            map.put("col", seat.getCol());
            return map;
        }).collect(Collectors.toList());

        Map<String, Object> payload = new HashMap<>();
        payload.put("userEmail", userEmail);
        payload.put("storeyName", storeyName);
        payload.put("date", date.toString());
        payload.put("seats", all);
        payload.put("bookedSeats", bookedList);

        WebClient webClient = webClientBuilder.baseUrl("http://localhost:5001").build();

        Mono<Map> response = webClient.post()
                .uri("/suggest")
                .bodyValue(payload)
                .retrieve()
                .bodyToMono(Map.class);

        Map result = response.block();

        return (List<Map<String, Object>>) result.get("suggestions");
    }
}