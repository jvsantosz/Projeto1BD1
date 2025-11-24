package com.example.pjbd1.controller;

import com.example.pjbd1.model.Usuario;
import com.example.pjbd1.model.Avaliacao;
import com.example.pjbd1.service.AvaliacaoService;
import com.example.pjbd1.service.RelatorioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/menu-professor")
public class MenuProfessorController {

    @Autowired
    private AvaliacaoService avaliacaoService;

    @Autowired
    private RelatorioService relatorioService;

    @GetMapping
    public String menuProfessor(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            // Buscar estatísticas do dashboard
            AvaliacaoService.DashboardStats stats = avaliacaoService.getDashboardStats(usuario.getIdUsuario());

            // Buscar últimas avaliações
            List<Avaliacao> ultimasAvaliacoes = avaliacaoService.getAvaliacoesPorProfessor(usuario.getIdUsuario())
                    .stream()
                    .limit(5)
                    .collect(Collectors.toList());

            model.addAttribute("totalAvaliacoes", stats.getTotalAvaliacoes());
            model.addAttribute("totalQuestoes", stats.getTotalQuestoes());
            model.addAttribute("avaliacoesSemQuestoes", stats.getAvaliacoesSemQuestoes());
            model.addAttribute("questoesNaoUtilizadas", stats.getQuestoesNaoUtilizadas());
            model.addAttribute("ultimasAvaliacoes", ultimasAvaliacoes);

        } catch (Exception e) {
            // Em caso de erro, definir valores padrão
            model.addAttribute("totalAvaliacoes", 0);
            model.addAttribute("totalQuestoes", 0);
            model.addAttribute("avaliacoesSemQuestoes", 0);
            model.addAttribute("questoesNaoUtilizadas", 0);
            model.addAttribute("ultimasAvaliacoes", List.of());
        }

        return "mp-professor";
    }
}