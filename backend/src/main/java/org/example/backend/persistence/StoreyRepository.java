package org.example.backend.persistence;

import org.example.backend.domain.Storey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource
public interface StoreyRepository extends JpaRepository<Storey, Long> {
    Storey findStoreyByName(String name);
}
