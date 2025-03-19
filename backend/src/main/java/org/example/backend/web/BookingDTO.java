package org.example.backend.web;

import java.util.List;

public class BookingDTO {
    private String date;
    private String storeyName;
    private String userEmail;
    private List<SeatDTO> selectedSeats;
    private Integer row;
    private Integer col;

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

    public Integer getRow() {
        return row;
    }
    public void setRow(Integer row) {
        this.row = row;
    }

    public Integer getCol() {
        return col;
    }
    public void setCol(Integer col) {
        this.col = col;
    }

}
