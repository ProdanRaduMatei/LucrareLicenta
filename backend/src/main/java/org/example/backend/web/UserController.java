package org.example.backend.web;

import org.example.backend.domain.User;
import org.example.backend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public User Register(@RequestBody User user) {
        return userService.createUser(user);
    }
    @PostMapping("/login")
    public User Login(@RequestBody String email, String password) {
        User oldUser = userService.findByEmailAndPassword(email, password);
        return oldUser;
    }
}
