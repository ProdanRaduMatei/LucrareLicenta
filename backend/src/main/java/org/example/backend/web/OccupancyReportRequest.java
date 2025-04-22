package org.example.backend.web;

import lombok.Data;
import java.time.LocalDate;

@Data
public class OccupancyReportRequest {
    private String storeyName;
    private LocalDate startDate;
    private LocalDate endDate;
}