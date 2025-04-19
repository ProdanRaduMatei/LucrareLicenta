// --- StoreyStatsRequest.java ---
package org.example.backend.web;

public class StoreyStatsRequest {
    private String storeyName;
    private String date; // in format yyyy-MM-dd

    public String getStoreyName() {
        return storeyName;
    }

    public void setStoreyName(String storeyName) {
        this.storeyName = storeyName;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}
