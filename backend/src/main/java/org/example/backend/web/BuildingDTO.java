package org.example.backend.web;

// BuildingDTO.java
public class BuildingDTO {
    private Long id;
    private String name;

    // Constructors
    public BuildingDTO(Long id, String name) {
        this.id = id;
        this.name = name;
    }

    // Getters
    public Long getId() { return id; }
    public String getName() { return name; }
}
