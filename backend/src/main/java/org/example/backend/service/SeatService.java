package org.example.backend.service;

import org.example.backend.domain.Seat;
import org.example.backend.persistence.SeatRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class SeatService {
    private final SeatRepository seatRepository;

    public SeatService(SeatRepository seatRepository) {
        this.seatRepository = seatRepository;
    }

    public List<Seat> getAllSeats() {
        return seatRepository.findAll();
    }

    public Seat getSeatById(Long id) {
        return seatRepository.findById(id).orElseThrow();
    }

    public Seat createSeat(Seat seat) {
        return seatRepository.save(seat);
    }

    public Seat updateSeat(Long id, Seat seatDetails) {
        Seat seat = seatRepository.findById(id).orElseThrow();
        seat.setLine(seatDetails.getLine());
        seat.setCol(seatDetails.getCol());
        seat.setStorey(seatDetails.getStorey());
        return seatRepository.save(seat);
    }

    public void deleteSeat(Long id) {
        seatRepository.deleteById(id);
    }

    public List<Seat> getSeatsByStoreyName(String storeyName) {
        return seatRepository.findByStoreyName(storeyName);
    }

    public Seat findSeatByColAndRowAndStoreyName(Integer col, Integer line, String storeyName) {
        return seatRepository.findByColAndLineAndStoreyName(col, line, storeyName);
    }
}
