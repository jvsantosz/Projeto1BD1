package com.example.pjbd1.controller;

import com.example.pjbd1.model.AvaliacaoQuestao;
import com.example.pjbd1.model.Usuario;
import com.example.pjbd1.repository.AvaliacaoQuestaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.math.BigDecimal;

@Controller
@RequestMapping("/avaliacao-questoes")
public class AvaliacaoQuestaoController {

    @Autowired
    private AvaliacaoQuestaoRepository avaliacaoQuestaoRepo;

    // 📋 LISTAR QUESTÕES DE UMA AVALIAÇÃO
    @GetMapping("/{idAvaliacao}")
    public String listarPorAvaliacao(@PathVariable Long idAvaliacao, Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        model.addAttribute("questoes", avaliacaoQuestaoRepo.listarPorAvaliacao(idAvaliacao));
        model.addAttribute("idAvaliacao", idAvaliacao);
        return "avaliacao-questoes";
    }

    // 💾 SALVAR RELAÇÃO AVALIAÇÃO-QUESTÃO
    @PostMapping("/salvar")
    public String salvar(@ModelAttribute AvaliacaoQuestao aq,
                         @RequestParam(required = false) Double pontuacaoEspecifica,
                         HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            // ✅ Converter Double para BigDecimal se necessário
            if (pontuacaoEspecifica != null) {
                aq.setPontuacaoEspecificaNaAvaliacao(BigDecimal.valueOf(pontuacaoEspecifica));
            }

            avaliacaoQuestaoRepo.salvar(aq);
            return "redirect:/avaliacoes/" + aq.getIdAvaliacao() + "?sucesso=Questão adicionada com sucesso";
        } catch (Exception e) {
            System.out.println("❌ Erro ao salvar questão na avaliação: " + e.getMessage());
            return "redirect:/avaliacoes/" + aq.getIdAvaliacao() + "?erro=Erro ao adicionar questão";
        }
    }

    // 🗑️ EXCLUIR QUESTÃO DA AVALIAÇÃO
    @GetMapping("/deletar/{id}")
    public String deletar(@PathVariable Long id, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            // Buscar a relação para obter o ID da avaliação antes de deletar
            AvaliacaoQuestao aq = avaliacaoQuestaoRepo.buscarPorId(id);
            if (aq != null) {
                Long idAvaliacao = aq.getIdAvaliacao();
                avaliacaoQuestaoRepo.deletar(id);
                return "redirect:/avaliacoes/" + idAvaliacao + "?sucesso=Questão removida com sucesso";
            }
            return "redirect:/avaliacoes?erro=Relação não encontrada";
        } catch (Exception e) {
            System.out.println("❌ Erro ao excluir questão da avaliação: " + e.getMessage());
            return "redirect:/avaliacoes?erro=Erro ao remover questão";
        }
    }

    // ✏️ FORMULÁRIO EDITAR QUESTÃO NA AVALIAÇÃO
    @GetMapping("/editar/{id}")
    public String editarForm(@PathVariable Long id, Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        AvaliacaoQuestao aq = avaliacaoQuestaoRepo.buscarPorId(id);
        if (aq == null) {
            return "redirect:/avaliacoes?erro=Relação não encontrada";
        }

        model.addAttribute("avaliacaoQuestao", aq);
        return "form-avaliacao-questao-editar";
    }

    // 💾 ATUALIZAR QUESTÃO NA AVALIAÇÃO
    @PostMapping("/atualizar")
    public String atualizar(@ModelAttribute AvaliacaoQuestao aq,
                            @RequestParam(required = false) Double pontuacaoEspecifica,
                            HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            // ✅ Converter Double para BigDecimal se necessário
            if (pontuacaoEspecifica != null) {
                aq.setPontuacaoEspecificaNaAvaliacao(BigDecimal.valueOf(pontuacaoEspecifica));
            }

            // Atualizar ordem e pontuação
            avaliacaoQuestaoRepo.atualizarOrdemQuestoes(aq.getIdAvaliacao(), aq.getIdQuestao(), aq.getOrdemNaAvaliacao());

            if (aq.getPontuacaoEspecificaNaAvaliacao() != null) {
                avaliacaoQuestaoRepo.atualizarPontuacaoEspecifica(aq.getIdAvaliacaoQuestao(), aq.getPontuacaoEspecificaNaAvaliacao());
            }

            return "redirect:/avaliacoes/" + aq.getIdAvaliacao() + "?sucesso=Questão atualizada com sucesso";
        } catch (Exception e) {
            System.out.println("❌ Erro ao atualizar questão na avaliação: " + e.getMessage());
            return "redirect:/avaliacoes/" + aq.getIdAvaliacao() + "?erro=Erro ao atualizar questão";
        }
    }

    // 🔼 REORDENAR QUESTÃO PARA CIMA
    @GetMapping("/{idAvaliacaoQuestao}/mover-cima")
    public String moverParaCima(@PathVariable Long idAvaliacaoQuestao, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            AvaliacaoQuestao aq = avaliacaoQuestaoRepo.buscarPorId(idAvaliacaoQuestao);
            if (aq != null && aq.getOrdemNaAvaliacao() > 1) {
                Short novaOrdem = (short) (aq.getOrdemNaAvaliacao() - 1);
                avaliacaoQuestaoRepo.atualizarOrdemQuestoes(aq.getIdAvaliacao(), aq.getIdQuestao(), novaOrdem);
            }
            return "redirect:/avaliacoes/" + aq.getIdAvaliacao() + "?sucesso=Questão movida";
        } catch (Exception e) {
            return "redirect:/avaliacoes?erro=Erro ao mover questão";
        }
    }

    // 🔽 REORDENAR QUESTÃO PARA BAIXO
    @GetMapping("/{idAvaliacaoQuestao}/mover-baixo")
    public String moverParaBaixo(@PathVariable Long idAvaliacaoQuestao, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            AvaliacaoQuestao aq = avaliacaoQuestaoRepo.buscarPorId(idAvaliacaoQuestao);
            if (aq != null) {
                Short novaOrdem = (short) (aq.getOrdemNaAvaliacao() + 1);
                avaliacaoQuestaoRepo.atualizarOrdemQuestoes(aq.getIdAvaliacao(), aq.getIdQuestao(), novaOrdem);
            }
            return "redirect:/avaliacoes/" + aq.getIdAvaliacao() + "?sucesso=Questão movida";
        } catch (Exception e) {
            return "redirect:/avaliacoes?erro=Erro ao mover questão";
        }
    }
}