package org.example.backend.web;
import org.example.backend.domain.Admin;

public class AdminDTO {
    private String email;
    private String password;
    public AdminDTO() {}

    public AdminDTO(String email, String password) {
        this.email = email;
        this.password = password;
    }

    public AdminDTO(Admin admin) {
        this.email = admin.getEmail();
        this.password = admin.getPassword();
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
