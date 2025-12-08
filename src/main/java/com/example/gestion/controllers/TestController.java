package com.example.gestion.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TestController {
    
    @GetMapping("/test-jsp")
    public String testJsp() {
        return "test-jsp";
    }
}
