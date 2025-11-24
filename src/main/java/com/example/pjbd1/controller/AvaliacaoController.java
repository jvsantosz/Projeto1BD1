package com.example.pjbd1.controller;

import com.example.pjbd1.model.Avaliacao;
import com.example.pjbd1.model.AvaliacaoQuestao;
import com.example.pjbd1.model.Questao;
import com.example.pjbd1.model.Usuario;
import com.example.pjbd1.repository.AvaliacaoRepository;
import com.example.pjbd1.repository.AvaliacaoQuestaoRepository;
import com.example.pjbd1.repository.QuestaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.math.BigDecimal;
import java.util.List;

@Controller
@RequestMapping("/avaliacoes")
public class AvaliacaoController {

    @Autowired
    private AvaliacaoRepository avaliacaoRepository;

    @Autowired
    private QuestaoRepository questaoRepository;

    @Autowired
    private AvaliacaoQuestaoRepository avaliacaoQuestaoRepository;

    // 📝 LISTAR AVALIAÇÕES
    @GetMapping
    public String listarAvaliacoes(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Avaliacao> avaliacoes = avaliacaoRepository.findByCriador(usuario.getIdUsuario());
        model.addAttribute("avaliacoes", avaliacoes);
        return "lista-avaliacoes";
    }

    // 📝 FORMULÁRIO NOVA AVALIAÇÃO
    @GetMapping("/nova")
    public String novaAvaliacao(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Questao> questões = questaoRepository.findByCriador(usuario.getIdUsuario());
        model.addAttribute("avaliacao", new Avaliacao());
        model.addAttribute("questoes", questões);
        return "form-avaliacao";
    }

    // 💾 SALVAR AVALIAÇÃO (VERSÃO FINAL CORRIGIDA)
    @PostMapping("/salvar")
    public String salvarAvaliacao(@RequestParam String titulo,
                                  @RequestParam(required = false) String descricao,
                                  @RequestParam Integer duracaoMinutos,
                                  @RequestParam(value = "questoesSelecionadas", required = false) List<Long> questõesIds,
                                  @RequestParam(value = "pontuacoes", required = false) List<Double> pontuacoes,
                                  HttpSession session) {

        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            // DEBUG: Verificar o que está chegando
            System.out.println("=== DEBUG SALVAR AVALIAÇÃO ===");
            System.out.println("Título: " + titulo);
            System.out.println("Questões IDs: " + (questõesIds != null ? questõesIds : "NULL"));
            System.out.println("Questões IDs tamanho: " + (questõesIds != null ? questõesIds.size() : 0));
            System.out.println("Pontuações: " + (pontuacoes != null ? pontuacoes : "NULL"));
            System.out.println("Pontuações tamanho: " + (pontuacoes != null ? pontuacoes.size() : 0));

            // Criar avaliação básica
            Avaliacao avaliacao = new Avaliacao();
            avaliacao.setTitulo(titulo);
            avaliacao.setDescricao(descricao);
            avaliacao.setDuracaoMinutos(duracaoMinutos);
            avaliacao.setIdUsuarioCriador(usuario.getIdUsuario());
            avaliacao.setStatus("ATIVA");
            avaliacao.setDataInicio(null);
            avaliacao.setDataFim(null);

            // Salvar avaliação
            avaliacaoRepository.salvar(avaliacao);
            System.out.println("✅ Avaliação salva: " + avaliacao.getTitulo() + " - ID: " + avaliacao.getIdAvaliacao());

            // Adicionar questões à avaliação (se houver)
            if (questõesIds != null && !questõesIds.isEmpty()) {
                for (int i = 0; i < questõesIds.size(); i++) {
                    Long questaoId = questõesIds.get(i);
                    Double pontuacao = 1.0; // Valor padrão

                    // CORREÇÃO: Usar apenas as pontuações correspondentes às questões selecionadas
                    if (pontuacoes != null && i < pontuacoes.size() && pontuacoes.get(i) != null) {
                        pontuacao = pontuacoes.get(i);
                    } else {
                        System.out.println("⚠️  Usando pontuação padrão para questão " + questaoId);
                    }

                    System.out.println("➕ Adicionando questão " + questaoId + " com pontuação " + pontuacao);

                    AvaliacaoQuestao aq = new AvaliacaoQuestao();
                    aq.setIdAvaliacao(avaliacao.getIdAvaliacao());
                    aq.setIdQuestao(questaoId);
                    aq.setOrdemNaAvaliacao((short) (i + 1));
                    aq.setPontuacaoEspecificaNaAvaliacao(BigDecimal.valueOf(pontuacao));

                    avaliacaoQuestaoRepository.salvar(aq);
                }
                System.out.println("✅ " + questõesIds.size() + " questões adicionadas à avaliação");
            } else {
                System.out.println("ℹ️ Avaliação criada sem questões");
            }

            return "redirect:/avaliacoes?sucesso=Avaliação criada com sucesso";

        } catch (Exception e) {
            System.out.println("❌ Erro ao salvar avaliação: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/avaliacoes/nova?erro=Erro+ao+criar+avaliacao";
        }
    }

    // 👀 VER DETALHES DA AVALIAÇÃO
    @GetMapping("/{idAvaliacao}")
    public String verAvaliacao(@PathVariable Long idAvaliacao, Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            Avaliacao avaliacao = avaliacaoRepository.buscarPorId(idAvaliacao);
            if (avaliacao == null) {
                return "redirect:/avaliacoes?erro=Avaliação não encontrada";
            }

            List<AvaliacaoQuestao> avaliacaoQuestoes = avaliacaoQuestaoRepository.findByAvaliacao(idAvaliacao);

            model.addAttribute("avaliacao", avaliacao);
            model.addAttribute("avaliacaoQuestoes", avaliacaoQuestoes);
            model.addAttribute("totalQuestoes", avaliacaoQuestoes.size());

            return "detalhes-avaliacao";

        } catch (Exception e) {
            System.out.println("❌ Erro ao carregar avaliação: " + e.getMessage());
            return "redirect:/avaliacoes?erro=Erro+ao+carregar+avaliacao";
        }
    }

    // 🗑️ EXCLUIR AVALIAÇÃO
    @GetMapping("/excluir/{idAvaliacao}")
    public String excluirAvaliacao(@PathVariable Long idAvaliacao, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            Avaliacao avaliacao = avaliacaoRepository.buscarPorId(idAvaliacao);
            if (avaliacao == null) {
                return "redirect:/avaliacoes?erro=Avaliação não encontrada";
            }

            // Primeiro excluir as questões vinculadas
            avaliacaoQuestaoRepository.deletarPorAvaliacao(idAvaliacao);

            // Depois excluir a avaliação
            avaliacaoRepository.excluir(idAvaliacao);

            System.out.println("✅ Avaliação excluída: " + avaliacao.getTitulo());
            return "redirect:/avaliacoes?sucesso=Avaliação+excluída+com+sucesso";

        } catch (Exception e) {
            System.out.println("❌ Erro ao excluir avaliação: " + e.getMessage());
            return "redirect:/avaliacoes?erro=Erro+ao+excluir+avaliacao";
        }
    }

    // 🔄 ALTERAR STATUS DA AVALIAÇÃO
    @GetMapping("/status/{idAvaliacao}/{status}")
    public String alterarStatus(@PathVariable Long idAvaliacao,
                                @PathVariable String status,
                                HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            Avaliacao avaliacao = avaliacaoRepository.buscarPorId(idAvaliacao);
            if (avaliacao == null) {
                return "redirect:/avaliacoes?erro=Avaliação não encontrada";
            }

            avaliacao.setStatus(status);
            avaliacaoRepository.atualizar(avaliacao);

            System.out.println("✅ Status alterado: " + avaliacao.getTitulo() + " -> " + status);
            return "redirect:/avaliacoes/" + idAvaliacao + "?sucesso=Status+alterado+para+" + status;

        } catch (Exception e) {
            System.out.println("❌ Erro ao alterar status: " + e.getMessage());
            return "redirect:/avaliacoes/" + idAvaliacao + "?erro=Erro+ao+alterar+status";
        }
    }
}