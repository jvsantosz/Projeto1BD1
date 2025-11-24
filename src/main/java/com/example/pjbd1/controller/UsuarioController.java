package com.example.pjbd1.controller;

import com.example.pjbd1.model.Usuario;
import com.example.pjbd1.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/usuarios")
public class UsuarioController {

    @Autowired
    private UsuarioRepository usuarioRepo;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("usuarios", usuarioRepo.listarTodos());
        return "usuarios";
    }

    @GetMapping("/novo")
    public String novo(Model model) {
        model.addAttribute("usuario", new Usuario());
        return "form-usuario";
    }

    // No UsuarioController.java

    @PostMapping("/salvar")
    public String salvar(@ModelAttribute Usuario usuario) {

        // ... tratamento do campo 'ativo' e salvamento ...
        if (usuario.getAtivo() == null) {
            usuario.setAtivo(true);
        }
        usuarioRepo.salvar(usuario);

        System.out.println("Salvo com sucesso");

        // CORRIGIDO: Redireciona para o Controller de Raiz que tem o mapeamento @GetMapping("/")
        return "redirect:/";
    }



    @GetMapping("/deletar/{id}")
    public String deletar(@PathVariable Long id) {
        usuarioRepo.deletar(id);
        return "redirect:/usuarios";
    }



}
