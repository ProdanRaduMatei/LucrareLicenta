package org.example.backend.web;

import lombok.Data;
import java.util.List;

@Data
public class UpcomingBookingDTO {
    private String date;
    private String storeyName;
    private List<SeatDTO> seats;
}