package org.example.backend.web;

public class SeatBookingDTO {
    private int seatId;
    private String date; // ISO 8601 format

    public SeatBookingDTO(int seatId, String date) {
        this.seatId = seatId;
        this.date = date;
    }

    public int getSeatId() {
        return seatId;
    }

    public String getDate() {
        return date;
    }
}