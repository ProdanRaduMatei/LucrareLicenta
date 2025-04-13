package org.example.backend.web;

import lombok.Getter;

import java.util.List;

@Getter
public class BuildingStoreyDTO {
    private String buildingName;
    private List<String> storeys;

    public BuildingStoreyDTO(Long id, String buildingName, List<String> storeys) {
        this.buildingName = buildingName;
        this.storeys = storeys;
    }

}
