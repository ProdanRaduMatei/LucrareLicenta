package org.example.backend.web;

public class StoreyStatsDTO {
    private int totalSeats;
    private int bookedSeats;
    private int unbookedSeats;

    public StoreyStatsDTO(int totalSeats, int bookedSeats) {
        this.totalSeats = totalSeats;
        this.bookedSeats = bookedSeats;
        this.unbookedSeats = totalSeats - bookedSeats;
    }

    public int getTotalSeats() {
        return totalSeats;
    }

    public int getBookedSeats() {
        return bookedSeats;
    }

    public int getUnbookedSeats() {
        return unbookedSeats;
    }
}