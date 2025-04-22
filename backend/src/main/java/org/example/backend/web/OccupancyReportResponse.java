package org.example.backend.web;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class OccupancyReportResponse {
    private int totalSeats;
    private int bookedSeats;
    private int unbookedSeats;
    private double occupancyPercent;
}