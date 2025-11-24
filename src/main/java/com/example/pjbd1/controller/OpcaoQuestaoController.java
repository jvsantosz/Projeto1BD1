package com.example.pjbd1.controller;

import com.example.pjbd1.model.OpcaoQuestao;
import com.example.pjbd1.repository.OpcaoQuestaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/opcoes")
public class OpcaoQuestaoController {

    @Autowired
    private OpcaoQuestaoRepository opcaoRepo;

    @GetMapping("/{idQuestao}")
    public String listarPorQuestao(@PathVariable Long idQuestao, Model model) {
        try {
            model.addAttribute("opcoes", opcaoRepo.listarPorQuestao(idQuestao));
            model.addAttribute("idQuestao", idQuestao);
            return "opcoes";
        } catch (Exception e) {
            System.out.println("❌ Erro ao listar opções: " + e.getMessage());
            model.addAttribute("erro", "Erro ao carregar opções");
            return "opcoes";
        }
    }

    @PostMapping("/salvar")
    public String salvar(@ModelAttribute OpcaoQuestao opcao) {
        try {
            opcaoRepo.salvar(opcao);
            return "redirect:/questoes";
        } catch (Exception e) {
            System.out.println("❌ Erro ao salvar opção: " + e.getMessage());
            return "redirect:/questoes?erro=Erro ao salvar opção";
        }
    }

    @GetMapping("/deletar/{id}")
    public String deletar(@PathVariable Long id) {
        try {
            opcaoRepo.deletar(id);
            return "redirect:/questoes?sucesso=Opção excluída";
        } catch (Exception e) {
            System.out.println("❌ Erro ao excluir opção: " + e.getMessage());
            return "redirect:/questoes?erro=Erro ao excluir opção";
        }
    }
}