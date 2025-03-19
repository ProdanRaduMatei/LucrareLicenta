package org.example.backend.service;

import org.example.backend.domain.Booking;
import org.example.backend.domain.Seat;
import org.example.backend.domain.User;
import org.example.backend.persistence.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

@Service
public class BookingService {

    @Autowired
    private BookingRepository bookingRepository;

    public List<Booking> getAllBookings() {
        return bookingRepository.findAll();
    }

    public Optional<Booking> getBookingById(Long id) {
        return bookingRepository.findById(id);
    }

    public Booking updateBooking(Long id, Booking bookingDetails) {
        Booking booking = bookingRepository.findById(id).orElseThrow();
        booking.setDate(bookingDetails.getDate());
        booking.setSeat(bookingDetails.getSeat());
        booking.setUser(bookingDetails.getUser());
        booking.setConfirmed(bookingDetails.isConfirmed());
        return bookingRepository.save(booking);
    }

    public void deleteBooking(Long id) {
        bookingRepository.deleteById(id);
    }

    public boolean isSeatBooked(Long seatId, Instant date) {
        return bookingRepository.existsBySeatIdAndDate(seatId, date);
    }

    public void createBooking(User user, Seat seat, Instant date) {
        Booking booking = new Booking();
        booking.setUser(user);
        booking.setSeat(seat);
        booking.setDate(date);
        booking.setConfirmed(true);
        bookingRepository.save(booking);
    }

    public List<Booking> getUserBookings(Long userId) {
        return bookingRepository.findByUserId(userId);
    }
}
