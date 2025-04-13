package org.example.backend.web;

import org.example.backend.domain.Building;
import org.example.backend.service.BuildingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/building")
public class BuildingController {
    @Autowired
    private BuildingService buildingService;

    @GetMapping("/names")
    public List<BuildingDTO> getAllBuildings() {
        return buildingService.findAll()
                .stream()
                .map(b -> new BuildingDTO(b.getId(), b.getName()))
                .collect(Collectors.toList());
    }
}
