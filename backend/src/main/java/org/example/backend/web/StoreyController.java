package org.example.backend.web;

import org.example.backend.service.StoreyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.example.backend.domain.Storey;

import java.util.List;

@RestController
@RequestMapping("/storey")
public class StoreyController {
    @Autowired
    private StoreyService storeyService;

    @GetMapping("/all")
    public List<String> getAllStoreyNames() {
        return storeyService.getAllStoreyNames();
    }
}
