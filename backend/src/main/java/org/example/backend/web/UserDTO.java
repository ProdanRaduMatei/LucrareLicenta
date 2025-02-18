package org.example.backend.web;

import org.example.backend.domain.User;

public class UserDTO {
    private String email;
    private String password;

    public UserDTO() {}

    public UserDTO(String email, String password) {
        this.email = email;
        this.password = password;
    }

    public UserDTO(User user) {
        this.email = user.getEmail();
        this.password = user.getPassword();
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}