package com.example.pjbd1.controller;

import com.example.pjbd1.model.Questao;
import com.example.pjbd1.model.OpcaoQuestao;
import com.example.pjbd1.model.Usuario;
import com.example.pjbd1.repository.QuestaoRepository;
import com.example.pjbd1.repository.OpcaoQuestaoRepository;
import com.example.pjbd1.service.QuestaoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/questoes")
public class QuestaoController {

    @Autowired
    private QuestaoRepository questaoRepo;

    @Autowired
    private OpcaoQuestaoRepository opcaoQuestaoRepo;

    @Autowired
    private QuestaoService questaoService;

    // 📝 LISTAR QUESTÕES
    @GetMapping
    public String listar(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            List<Questao> questões = questaoRepo.listarTodas();
            model.addAttribute("questoes", questões);
            return "questoes";
        } catch (Exception e) {
            System.out.println("❌ Erro ao listar questões: " + e.getMessage());
            model.addAttribute("erro", "Erro ao carregar questões");
            return "questoes";
        }
    }

    // 📝 FORMULÁRIO NOVA QUESTÃO
    @GetMapping("/nova")
    public String nova(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        model.addAttribute("questao", new Questao());
        return "form-questao";
    }

    // 💾 SALVAR QUESTÃO COM OPÇÕES
    @PostMapping("/salvar")
    public String salvar(@RequestParam String descricaoQuestao,
                         @RequestParam String tipoQuestao,
                         @RequestParam Double valorPontuacao,
                         @RequestParam(required = false) String feedbackCorreto,
                         @RequestParam(required = false) String feedbackIncorreto,
                         @RequestParam(value = "opcoesTexto", required = false) List<String> opcoesTexto,
                         @RequestParam(value = "opcoesCorretas", required = false) List<String> opcoesCorretas,
                         HttpSession session) {

        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            // 1. Criar a questão
            Questao questao = new Questao();
            questao.setDescricaoQuestao(descricaoQuestao);
            questao.setTipoQuestao(tipoQuestao);
            questao.setValorPontuacao(java.math.BigDecimal.valueOf(valorPontuacao));
            questao.setFeedbackCorreto(feedbackCorreto);
            questao.setFeedbackIncorreto(feedbackIncorreto);
            questao.setDataCriacao(LocalDateTime.now());
            questao.setIdUsuarioCriador(usuario.getIdUsuario());

            // Validação básica
            if (descricaoQuestao == null || descricaoQuestao.trim().isEmpty()) {
                return "redirect:/questoes/nova?erro=Descrição da questão é obrigatória";
            }

            // 2. Salvar a questão primeiro para obter o ID
            questaoRepo.salvar(questao);
            System.out.println("✅ Questão salva com ID: " + questao.getIdQuestao());

            // 3. Se for múltipla escolha, salvar as opções
            if ("MULTIPLA".equals(tipoQuestao) && opcoesTexto != null) {
                List<OpcaoQuestao> opcoes = new ArrayList<>();

                for (int i = 0; i < opcoesTexto.size(); i++) {
                    String texto = opcoesTexto.get(i);
                    if (texto != null && !texto.trim().isEmpty()) {
                        OpcaoQuestao opcao = new OpcaoQuestao();
                        opcao.setIdQuestao(questao.getIdQuestao());
                        opcao.setTextoOpcao(texto.trim());

                        // Verificar se esta opção está marcada como correta
                        boolean ehCorreta = opcoesCorretas != null &&
                                opcoesCorretas.contains(String.valueOf(i + 1));
                        opcao.setEhCorreta(ehCorreta);

                        opcao.setOrdem((short) (i + 1));
                        opcoes.add(opcao);

                        System.out.println("📝 Opção " + (i + 1) + ": " + texto + " - Correta: " + ehCorreta);
                    }
                }

                // Salvar cada opção no banco
                for (OpcaoQuestao opcao : opcoes) {
                    opcaoQuestaoRepo.salvar(opcao);
                    System.out.println("✅ Opção salva: " + opcao.getTextoOpcao());
                }

                System.out.println("✅ Total de opções salvas: " + opcoes.size());
            }

            return "redirect:/questoes?sucesso=Questão criada com sucesso";

        } catch (Exception e) {
            System.out.println("❌ Erro ao salvar questão: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/questoes/nova?erro=Erro ao criar questão: " + e.getMessage();
        }
    }

    // 👀 VER DETALHES DA QUESTÃO
    @GetMapping("/{id}")
    public String visualizarQuestao(@PathVariable Long id, Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            Questao questao = questaoRepo.buscarPorId(id);
            if (questao == null) {
                return "redirect:/questoes?erro=Questão não encontrada";
            }

            // Carregar opções se for múltipla escolha
            if ("MULTIPLA".equals(questao.getTipoQuestao())) {
                List<OpcaoQuestao> opcoes = opcaoQuestaoRepo.listarPorQuestao(id);
                model.addAttribute("opcoes", opcoes);
            }

            model.addAttribute("questao", questao);
            return "detalhes-questao";

        } catch (Exception e) {
            System.out.println("❌ Erro ao buscar questão: " + e.getMessage());
            return "redirect:/questoes?erro=Erro ao carregar questão";
        }
    }

    // ✏️ EDITAR QUESTÃO
    @GetMapping("/editar/{id}")
    public String editarQuestao(@PathVariable Long id, Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            Questao questao = questaoRepo.buscarPorId(id);
            if (questao == null) {
                return "redirect:/questoes?erro=Questão não encontrada";
            }

            // Carregar opções se for múltipla escolha
            if ("MULTIPLA".equals(questao.getTipoQuestao())) {
                List<OpcaoQuestao> opcoes = opcaoQuestaoRepo.listarPorQuestao(id);
                model.addAttribute("opcoes", opcoes);
            }

            model.addAttribute("questao", questao);
            return "form-questao-editar";

        } catch (Exception e) {
            System.out.println("❌ Erro ao carregar edição: " + e.getMessage());
            return "redirect:/questoes?erro=Erro ao carregar questão para edição";
        }
    }

    // 💾 ATUALIZAR QUESTÃO COM OPÇÕES
    @PostMapping("/atualizar")
    public String atualizar(@RequestParam Long idQuestao,
                            @RequestParam String descricaoQuestao,
                            @RequestParam String tipoQuestao,
                            @RequestParam Double valorPontuacao,
                            @RequestParam(required = false) String feedbackCorreto,
                            @RequestParam(required = false) String feedbackIncorreto,
                            @RequestParam(value = "opcoesTexto", required = false) List<String> opcoesTexto,
                            @RequestParam(value = "opcoesCorretas", required = false) List<String> opcoesCorretas,
                            HttpSession session) {

        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            Questao questao = questaoRepo.buscarPorId(idQuestao);
            if (questao == null) {
                return "redirect:/questoes?erro=Questão não encontrada";
            }

            // Atualizar dados da questão
            questao.setDescricaoQuestao(descricaoQuestao);
            questao.setTipoQuestao(tipoQuestao);
            questao.setValorPontuacao(java.math.BigDecimal.valueOf(valorPontuacao));
            questao.setFeedbackCorreto(feedbackCorreto);
            questao.setFeedbackIncorreto(feedbackIncorreto);

            questaoRepo.atualizar(questao);

            // Se for múltipla escolha, atualizar opções
            if ("MULTIPLA".equals(tipoQuestao) && opcoesTexto != null) {
                // Remover opções antigas
                opcaoQuestaoRepo.deletarPorQuestao(idQuestao);

                // Adicionar novas opções
                List<OpcaoQuestao> opcoes = new ArrayList<>();

                for (int i = 0; i < opcoesTexto.size(); i++) {
                    String texto = opcoesTexto.get(i);
                    if (texto != null && !texto.trim().isEmpty()) {
                        OpcaoQuestao opcao = new OpcaoQuestao();
                        opcao.setIdQuestao(idQuestao);
                        opcao.setTextoOpcao(texto.trim());

                        boolean ehCorreta = opcoesCorretas != null &&
                                opcoesCorretas.contains(String.valueOf(i + 1));
                        opcao.setEhCorreta(ehCorreta);
                        opcao.setOrdem((short) (i + 1));
                        opcoes.add(opcao);
                    }
                }

                // Salvar novas opções
                for (OpcaoQuestao opcao : opcoes) {
                    opcaoQuestaoRepo.salvar(opcao);
                }
            }

            return "redirect:/questoes?sucesso=Questão atualizada com sucesso";

        } catch (Exception e) {
            System.out.println("❌ Erro ao atualizar questão: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/questoes/editar/" + idQuestao + "?erro=Erro ao atualizar questão";
        }
    }

    // 🗑️ EXCLUIR QUESTÃO
    @GetMapping("/deletar/{id}")
    public String deletar(@PathVariable Long id, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            Questao questao = questaoRepo.buscarPorId(id);
            if (questao != null) {
                // Primeiro excluir as opções (se houver)
                if ("MULTIPLA".equals(questao.getTipoQuestao())) {
                    opcaoQuestaoRepo.deletarPorQuestao(id);
                }
                // Depois excluir a questão
                questaoRepo.deletar(id);
                return "redirect:/questoes?sucesso=Questão excluída com sucesso";
            }
            return "redirect:/questoes?erro=Questão não encontrada";

        } catch (Exception e) {
            System.out.println("❌ Erro ao excluir questão: " + e.getMessage());
            return "redirect:/questoes?erro=Erro ao excluir questão";
        }
    }

    // 📊 ESTATÍSTICAS DAS QUESTÕES
    @GetMapping("/estatisticas")
    public String estatisticas(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            QuestaoService.EstatisticasQuestao stats = questaoService.getEstatisticasQuestoes(usuario.getIdUsuario());
            model.addAttribute("estatisticas", stats);
            return "estatisticas-questoes";
        } catch (Exception e) {
            System.out.println("❌ Erro ao carregar estatísticas: " + e.getMessage());
            model.addAttribute("erro", "Erro ao carregar estatísticas");
            return "estatisticas-questoes";
        }
    }
}