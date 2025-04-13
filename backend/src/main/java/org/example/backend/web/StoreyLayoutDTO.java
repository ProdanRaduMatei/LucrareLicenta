package org.example.backend.web;

import java.util.List;

public class StoreyLayoutDTO {
    private String storeyName;
    private Long buildingId;
    private List<SeatDTO> seats;

    public String getStoreyName() {
        return storeyName;
    }

    public void setStoreyName(String storeyName) {
        this.storeyName = storeyName;
    }

    public Long getBuildingId() {
        return buildingId;
    }

    public void setBuildingId(Long buildingId) {
        this.buildingId = buildingId;
    }

    public List<SeatDTO> getSeats() {
        return seats;
    }

    public void setSeats(List<SeatDTO> seats) {
        this.seats = seats;
    }
}