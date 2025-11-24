package com.example.pjbd1.controller;

import com.example.pjbd1.model.UsuarioAvaliacao;
import com.example.pjbd1.repository.UsuarioAvaliacaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/usuario-avaliacoes")
public class UsuarioAvaliacaoController {

    @Autowired
    private UsuarioAvaliacaoRepository usuarioAvaliacaoRepo;

    @GetMapping("/{idAvaliacao}")
    public String listarPorAvaliacao(@PathVariable Long idAvaliacao, Model model) {
        model.addAttribute("atribuicoes", usuarioAvaliacaoRepo.listarPorAvaliacao(idAvaliacao));
        model.addAttribute("idAvaliacao", idAvaliacao);
        return "usuario-avaliacoes";
    }

    @PostMapping("/salvar")
    public String salvar(@ModelAttribute UsuarioAvaliacao ua) {
        usuarioAvaliacaoRepo.salvar(ua);
        return "redirect:/avaliacoes";
    }

    @GetMapping("/status/{id}/{status}")
    public String atualizarStatus(@PathVariable Long id, @PathVariable String status) {
        usuarioAvaliacaoRepo.atualizarStatus(id, status);
        return "redirect:/avaliacoes";
    }
}
