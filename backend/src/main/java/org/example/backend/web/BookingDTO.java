package org.example.backend.web;

import java.util.List;

public class BookingDTO {
    private String date;
    private String storeyName;
    private String userEmail;
    private List<SeatDTO> selectedSeats;

    public String getDate() {
        return date;
    }
    public void setDate(String date) { this.date = date; }

    public String getStoreyName() {
        return storeyName;
    }
    public void setStoreyName(String storeyName) {
        this.storeyName = storeyName;
    }

    public String getUserEmail() {
        return userEmail;
    }
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public List<SeatDTO> getSelectedSeats() {
        return selectedSeats;
    }
    public void setSelectedSeats(List<SeatDTO> selectedSeats) {
        this.selectedSeats = selectedSeats;
    }
}
