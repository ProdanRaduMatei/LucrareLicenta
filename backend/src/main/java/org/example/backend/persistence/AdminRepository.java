package org.example.backend.persistence;

import org.example.backend.domain.Admin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.Optional;

@RepositoryRestResource
public interface AdminRepository extends JpaRepository<Admin, Long> {
}
