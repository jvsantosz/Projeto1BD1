package com.example.pjbd1.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TestController {

    @GetMapping("/test-professor")
    public String testProfessor() {
        System.out.println("=== TESTANDO PROFESSOR ===");
        return "mp-professor";
    }

    @GetMapping("/test-aluno")
    public String testAluno() {
        System.out.println("=== TESTANDO ALUNO ===");
        return "mp-aluno";
    }
}