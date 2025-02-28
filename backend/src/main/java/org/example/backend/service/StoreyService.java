package org.example.backend.service;

import org.example.backend.domain.Storey;
import org.example.backend.persistence.StoreyRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class StoreyService {
    private final StoreyRepository storeyRepository;

    public StoreyService(StoreyRepository storeyRepository) {
        this.storeyRepository = storeyRepository;
    }

    public List<Storey> getAllStoreys() {
        return storeyRepository.findAll();
    }

    public List<String> getAllStoreyNames() {
        return storeyRepository.findAll().stream().map(Storey::getName).toList();
    }

    public Optional<Storey> getStoreyById(Long id) {
        return storeyRepository.findById(id);
    }

    public Storey createStorey(Storey storey) {
        return storeyRepository.save(storey);
    }

    public Storey updateStorey(Long id, Storey storeyDetails) {
        Storey storey = storeyRepository.findById(id).orElseThrow();
        storey.setName(storeyDetails.getName());
        storey.setBuilding(storeyDetails.getBuilding());
        storey.setSeats(storeyDetails.getSeats());
        return storeyRepository.save(storey);
    }

    public void deleteStorey(Long id) {
        storeyRepository.deleteById(id);
    }

    public Optional<Storey> getStoreyByName(String name) {
        return Optional.ofNullable(storeyRepository.findByName(name));
    }
}
