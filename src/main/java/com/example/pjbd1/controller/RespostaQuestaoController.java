package com.example.pjbd1.controller;

import com.example.pjbd1.model.RespostaQuestao;
import com.example.pjbd1.repository.RespostaQuestaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/respostas")
public class RespostaQuestaoController {

    @Autowired
    private RespostaQuestaoRepository respostaRepo;

    @GetMapping("/{idAvaliacaoUsuario}")
    public String listarPorUsuarioAvaliacao(@PathVariable Long idAvaliacaoUsuario, Model model) {
        model.addAttribute("respostas", respostaRepo.listarPorUsuarioAvaliacao(idAvaliacaoUsuario));
        model.addAttribute("idAvaliacaoUsuario", idAvaliacaoUsuario);
        return "respostas";
    }

    @PostMapping("/salvar")
    public String salvar(@ModelAttribute RespostaQuestao resposta) {
        respostaRepo.salvar(resposta);
        return "redirect:/avaliacoes";
    }
}
