package org.example.backend.web;

import org.example.backend.domain.User;
import org.example.backend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public User Register(@RequestBody UserDTO userDTO) {
        User user = new User();
        user.setName(userDTO.getEmail().substring(0, userDTO.getEmail().indexOf('@')));
        user.setEmail(userDTO.getEmail());
        user.setPassword(userDTO.getPassword());
        return userService.createUser(user);
    }

    @PostMapping("/login")
    public ResponseEntity<?> Login(@RequestBody UserDTO userDTO) {
        User user = userService.findUserByEmailAndPassword(userDTO.getEmail(), userDTO.getPassword());

        if (user != null) {
            return ResponseEntity.ok(new UserDTO(user));
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
    }
}
