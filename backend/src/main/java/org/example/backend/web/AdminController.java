package org.example.backend.web;

import org.example.backend.domain.Admin;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.example.backend.service.AdminService;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/admin")
public class AdminController {
    @Autowired
    private AdminService adminService;

    @PostMapping("/register")
    public Admin Register(@RequestBody AdminDTO adminDTO) {
        Admin admin = new Admin();
        admin.setName(adminDTO.getEmail().substring(0, adminDTO.getEmail().indexOf('@')));
        admin.setEmail(adminDTO.getEmail());
        admin.setPassword(adminDTO.getPassword());
        return adminService.createAdmin(admin);
    }
    @PostMapping("/login")
    public ResponseEntity<?> Login(@RequestBody AdminDTO adminDTO) {
        Admin admin = adminService.findAdminByEmailAndPassword(adminDTO.getEmail(), adminDTO.getPassword());

        if (admin != null) {
            return ResponseEntity.ok(new AdminDTO(admin));
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
    }
}
