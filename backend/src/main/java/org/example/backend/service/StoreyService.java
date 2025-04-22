package org.example.backend.service;

import jakarta.transaction.Transactional;
import org.apache.tomcat.util.http.fileupload.ByteArrayOutputStream;
import org.example.backend.domain.Booking;
import org.example.backend.domain.Building;
import org.example.backend.domain.Seat;
import org.example.backend.domain.Storey;
import org.example.backend.persistence.BookingRepository;
import org.example.backend.persistence.BuildingRepository;
import org.example.backend.persistence.SeatRepository;
import org.example.backend.persistence.StoreyRepository;
import org.example.backend.web.OccupancyReportResponse;
import org.example.backend.web.SeatDTO;
import org.example.backend.web.StoreyLayoutDTO;
import org.example.backend.web.StoreyStatsDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.swing.text.Document;
import java.io.IOException;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class StoreyService {
    private final StoreyRepository storeyRepository;

    @Autowired
    private BuildingRepository buildingRepository;

    @Autowired
    private SeatRepository seatRepository;

    @Autowired
    private BookingRepository bookingRepository;

    public StoreyService(StoreyRepository storeyRepository) {
        this.storeyRepository = storeyRepository;
    }

    public List<Storey> getAllStoreys() {
        return storeyRepository.findAll();
    }

    public List<String> getAllStoreyNames() {
        return storeyRepository.findAll().stream().map(Storey::getName).toList();
    }

    public Optional<Storey> getStoreyById(Long id) {
        return storeyRepository.findById(id);
    }

    public Storey createStorey(Storey storey) {
        return storeyRepository.save(storey);
    }

    public Storey updateStorey(Long id, Storey storeyDetails) {
        Storey storey = storeyRepository.findById(id).orElseThrow();
        storey.setName(storeyDetails.getName());
        storey.setBuilding(storeyDetails.getBuilding());
        storey.setSeats(storeyDetails.getSeats());
        return storeyRepository.save(storey);
    }

    public void deleteStorey(Long id) {
        storeyRepository.deleteById(id);
    }

    public Storey findStoreyByName(String name) {
        return storeyRepository.findStoreyByName(name);
    }

    public String getStoreyNameById(Long id) {
        return storeyRepository.findById(id).map(Storey::getName).orElse(null);
    }

    public void createStoreyLayout(StoreyLayoutDTO dto) {
        Building building = buildingRepository.findById(dto.getBuildingId())
                .orElseThrow(() -> new RuntimeException("Building not found"));

        Storey storey = new Storey();
        storey.setName(dto.getStoreyName());
        storey.setBuilding(building);
        storey = storeyRepository.save(storey);

        for (SeatDTO seatDTO : dto.getSeats()) {
            Seat seat = new Seat();
            seat.setLine(seatDTO.getRow());
            seat.setCol(seatDTO.getCol());
            seat.setSeatType("standard"); // optional: make this dynamic later
            seat.setCreationDate(Instant.now());
            seat.setStorey(storey);
            seatRepository.save(seat);
        }
    }

    @Transactional
    public StoreyStatsDTO getStoreyStats(String storeyName, LocalDate date) {
        Optional<Storey> optionalStorey = storeyRepository.findByName(storeyName);
        if (optionalStorey.isEmpty()) {
            throw new RuntimeException("Storey not found");
        }

        Storey storey = optionalStorey.get();

        // ✅ Asta funcționează acum deoarece suntem într-o tranzacție activă
        int totalSeats = storey.getSeats().size();

        Instant instantDate = date.atStartOfDay(ZoneId.of("UTC")).toInstant();
        int bookedSeats = bookingRepository.countBySeat_Storey_NameAndDate(storeyName, instantDate);

        return new StoreyStatsDTO(totalSeats, bookedSeats);
    }

    @Transactional
    public OccupancyReportResponse getOccupancyReport(String storeyName, LocalDate start, LocalDate end) {
        Storey storey = storeyRepository.findByName(storeyName)
                .orElseThrow(() -> new RuntimeException("Storey not found"));

        List<Seat> seats = storey.getSeats();
        int total = seats.size();

        int booked = 0;
        for (Seat seat : seats) {
            for (Booking booking : seat.getBookings()) {
                LocalDate date = booking.getDate().atZone(ZoneId.systemDefault()).toLocalDate();
                if (!date.isBefore(start) && !date.isAfter(end)) {
                    booked++;
                    break;
                }
            }
        }

        int unbooked = total - booked;
        double percent = total == 0 ? 0 : (booked * 100.0) / total;

        return new OccupancyReportResponse(total, booked, unbooked, percent);
    }
}
