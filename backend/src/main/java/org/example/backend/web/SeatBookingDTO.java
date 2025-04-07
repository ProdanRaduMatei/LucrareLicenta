package org.example.backend.web;

public class SeatBookingDTO {
    private int seatId;
    private String date;
    private Long bookingId;

    public SeatBookingDTO(int seatId, String date, Long bookingId) {
        this.seatId = seatId;
        this.date = date;
        this.bookingId = bookingId;
    }

    public int getSeatId() {
        return seatId;
    }

    public String getDate() {
        return date;
    }

    public Long getBookingId() {
        return bookingId;
    }
}