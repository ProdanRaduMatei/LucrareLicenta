package org.example.backend.service;

import org.example.backend.domain.Building;
import org.example.backend.domain.Storey;
import org.example.backend.persistence.BuildingRepository;
import org.example.backend.web.BuildingStoreyDTO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class BuildingService {
    private final BuildingRepository buildingRepository;

    public BuildingService(BuildingRepository buildingRepository) {
        this.buildingRepository = buildingRepository;
    }

    public List<Building> getAllBuildings() {
        return buildingRepository.findAll();
    }

    public Optional<Building> getBuildingById(Long id) {
        return buildingRepository.findById(id);
    }

    public Building createBuilding(Building building) {
        return buildingRepository.save(building);
    }

    public Building updateBuilding(Long id, Building buildingDetails) {
        Building building = buildingRepository.findById(id).orElseThrow();
        building.setName(buildingDetails.getName());
        building.setAdmin(buildingDetails.getAdmin());
        return buildingRepository.save(building);
    }

    public void deleteBuilding(Long id) {
        buildingRepository.deleteById(id);
    }

    public List<Building> findAll() {
        return buildingRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<BuildingStoreyDTO> getBuildingsWithStoreys() {
        return buildingRepository.findAll().stream()
                .map(b -> new BuildingStoreyDTO(
                        b.getId(),
                        b.getName(),
                        b.getStoreys().stream()
                                .map(Storey::getName)
                                .collect(Collectors.toList())
                ))
                .collect(Collectors.toList());
    }
}
