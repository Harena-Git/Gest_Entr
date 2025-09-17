package com.example.gestion.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TestController {

    @GetMapping("/bonjour")
    public String direBonjour(Model model) {
        model.addAttribute("message", "Bonjour depuis JSP !");
        return "bonjour"; // Spring cherchera WEB-INF/views/bonjour.jsp
    }
}
