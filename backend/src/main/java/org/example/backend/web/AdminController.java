package org.example.backend.web;

import org.example.backend.domain.Admin;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.example.backend.service.AdminService;

import java.util.List;

@RestController
@RequestMapping("/admin")
public class AdminController {
    @Autowired
    private AdminService adminService;

    @PostMapping("/register")
    public Admin Register(@RequestBody Admin admin) {
        return adminService.createAdmin(admin);
    }
    @PostMapping("/login")
    public Admin Login(@RequestBody String email, String password) {
        Admin oldAdmin = adminService.findAdminByEmailAndPassword(email, password);
        return oldAdmin;
    }
}
