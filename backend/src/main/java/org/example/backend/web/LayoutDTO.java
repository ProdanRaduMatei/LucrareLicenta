package org.example.backend.web;

public class LayoutDTO {
    private String date;
    private String storeyName;

    public LayoutDTO() {
    }

    public LayoutDTO(String date, String storeyName) {
        this.date = date;
        this.storeyName = storeyName;
    }

    public String getDate() {
        return date;
    }

    public String getStoreyName() {
        return storeyName;
    }
}
