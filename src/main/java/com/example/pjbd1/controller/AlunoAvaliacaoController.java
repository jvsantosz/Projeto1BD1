package com.example.pjbd1.controller;

import com.example.pjbd1.model.*;
import com.example.pjbd1.repository.*;
import com.example.pjbd1.service.AvaliacaoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Map;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/aluno-avaliacoes")
public class AlunoAvaliacaoController {

    @Autowired
    private AvaliacaoRepository avaliacaoRepository;

    @Autowired
    private UsuarioAvaliacaoRepository usuarioAvaliacaoRepository;

    @Autowired
    private RespostaQuestaoRepository respostaQuestaoRepository;

    @Autowired
    private AvaliacaoQuestaoRepository avaliacaoQuestaoRepository;

    @Autowired
    private QuestaoRepository questaoRepository;

    @Autowired
    private AvaliacaoService avaliacaoService;

    @Autowired
    private OpcaoQuestaoRepository opcaoQuestaoRepo;

    // 📋 LISTAR AVALIAÇÕES DISPONÍVEIS PARA ALUNO
    @GetMapping
    public String listarAvaliacoesDisponiveis(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"ALUNO".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            List<Avaliacao> avaliacoesDisponiveis = avaliacaoService.getAvaliacoesDisponiveisParaAluno();

            model.addAttribute("avaliacoes", avaliacoesDisponiveis);
            model.addAttribute("aluno", usuario);
            return "aluno-avaliacoes-disponiveis";
        } catch (Exception e) {
            System.out.println("❌ Erro ao listar avaliações: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/menu-aluno?erro=Erro ao carregar avaliações";
        }
    }

    // 🚀 INICIAR AVALIAÇÃO
    @GetMapping("/iniciar/{idAvaliacao}")
    public String iniciarAvaliacao(@PathVariable Long idAvaliacao, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"ALUNO".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            Avaliacao avaliacao = avaliacaoRepository.buscarPorId(idAvaliacao);
            if (avaliacao == null || !"ATIVA".equals(avaliacao.getStatus())) {
                return "redirect:/aluno-avaliacoes?erro=Avaliação não disponível";
            }

            // Verificar se aluno já iniciou esta avaliação
            UsuarioAvaliacao usuarioAvaliacaoExistente =
                    usuarioAvaliacaoRepository.findByUsuarioAndAvaliacao(usuario.getIdUsuario(), idAvaliacao);

            if (usuarioAvaliacaoExistente != null) {
                if ("EM_ANDAMENTO".equals(usuarioAvaliacaoExistente.getStatusResposta())) {
                    return "redirect:/aluno-avaliacoes/realizar/" + usuarioAvaliacaoExistente.getIdUsuarioAvaliacao();
                } else {
                    return "redirect:/aluno-avaliacoes/resultado/" + usuarioAvaliacaoExistente.getIdUsuarioAvaliacao();
                }
            }

            // Criar novo registro
            UsuarioAvaliacao usuarioAvaliacao = new UsuarioAvaliacao();
            usuarioAvaliacao.setIdUsuario(usuario.getIdUsuario());
            usuarioAvaliacao.setIdAvaliacao(idAvaliacao);
            usuarioAvaliacao.setDataInicioReal(LocalDateTime.now());
            usuarioAvaliacao.setStatusResposta("EM_ANDAMENTO");
            usuarioAvaliacao.setNotaTotalObtida(BigDecimal.ZERO);

            usuarioAvaliacaoRepository.salvar(usuarioAvaliacao);

            return "redirect:/aluno-avaliacoes/realizar/" + usuarioAvaliacao.getIdUsuarioAvaliacao();

        } catch (Exception e) {
            System.out.println("❌ Erro ao iniciar avaliação: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/aluno-avaliacoes?erro=Erro ao iniciar avaliação";
        }
    }

    // 📝 REALIZAR AVALIAÇÃO
    @GetMapping("/realizar/{idUsuarioAvaliacao}")
    public String realizarAvaliacao(@PathVariable Long idUsuarioAvaliacao,
                                    Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"ALUNO".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            UsuarioAvaliacao usuarioAvaliacao = usuarioAvaliacaoRepository.buscarPorId(idUsuarioAvaliacao);
            if (usuarioAvaliacao == null || !usuarioAvaliacao.getIdUsuario().equals(usuario.getIdUsuario())) {
                return "redirect:/aluno-avaliacoes?erro=Avaliação não encontrada";
            }

            if (!"EM_ANDAMENTO".equals(usuarioAvaliacao.getStatusResposta())) {
                return "redirect:/aluno-avaliacoes/resultado/" + idUsuarioAvaliacao;
            }

            Avaliacao avaliacao = avaliacaoRepository.buscarPorId(usuarioAvaliacao.getIdAvaliacao());
            List<AvaliacaoQuestao> questoes = avaliacaoQuestaoRepository.findByAvaliacao(avaliacao.getIdAvaliacao());
            List<RespostaQuestao> respostas = respostaQuestaoRepository.findByUsuarioAvaliacao(idUsuarioAvaliacao);

            // ✅ CORREÇÃO: Mapear detalhes das questões corretamente
            Map<Long, Questao> detalhesQuestoes = new HashMap<>();
            Map<Long, List<OpcaoQuestao>> opcoesPorQuestao = new HashMap<>();

            for (AvaliacaoQuestao aq : questoes) {
                Questao questaoDetalhes = questaoRepository.buscarPorId(aq.getIdQuestao());
                if (questaoDetalhes != null) {
                    // ✅ CORREÇÃO: Usar idAvaliacaoQuestao como chave
                    detalhesQuestoes.put(aq.getIdAvaliacaoQuestao(), questaoDetalhes);

                    if ("MULTIPLA_ESCOLHA".equals(questaoDetalhes.getTipoQuestao()) ||
                            "MULTIPLA".equals(questaoDetalhes.getTipoQuestao())) {
                        List<OpcaoQuestao> opcoes = opcaoQuestaoRepo.listarPorQuestao(questaoDetalhes.getIdQuestao());
                        opcoesPorQuestao.put(aq.getIdAvaliacaoQuestao(), opcoes);
                    }
                }
            }

            // Verificar tempo
            LocalDateTime inicio = usuarioAvaliacao.getDataInicioReal();
            LocalDateTime terminoPrevisto = inicio.plusMinutes(avaliacao.getDuracaoMinutos());

            if (LocalDateTime.now().isAfter(terminoPrevisto)) {
                return finalizarAvaliacaoTempoEsgotado(idUsuarioAvaliacao);
            }

            model.addAttribute("usuarioAvaliacao", usuarioAvaliacao);
            model.addAttribute("avaliacao", avaliacao);
            model.addAttribute("questoes", questoes);
            model.addAttribute("respostas", respostas);
            model.addAttribute("detalhesQuestoes", detalhesQuestoes);
            model.addAttribute("opcoesPorQuestao", opcoesPorQuestao);
            model.addAttribute("tempoRestante", calcularTempoRestante(terminoPrevisto));

            return "aluno-realizar-avaliacao";

        } catch (Exception e) {
            System.out.println("❌ Erro ao carregar avaliação: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/aluno-avaliacoes?erro=Erro ao carregar avaliação";
        }
    }

    // 💾 SALVAR RESPOSTA (AJAX)
    @PostMapping("/salvar-resposta")
    @ResponseBody
    public Map<String, Object> salvarResposta(@RequestParam Long idUsuarioAvaliacao,
                                              @RequestParam Long idAvaliacaoQuestao,
                                              @RequestParam(required = false) String textoResposta,
                                              @RequestParam(required = false) Long idOpcaoSelecionada,
                                              HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        if (usuario == null || !"ALUNO".equals(usuario.getTipoUsuario())) {
            response.put("success", false);
            response.put("message", "Acesso não autorizado");
            return response;
        }

        try {
            UsuarioAvaliacao usuarioAvaliacao = usuarioAvaliacaoRepository.buscarPorId(idUsuarioAvaliacao);
            if (usuarioAvaliacao == null || !"EM_ANDAMENTO".equals(usuarioAvaliacao.getStatusResposta())) {
                response.put("success", false);
                response.put("message", "Avaliação não está em andamento");
                return response;
            }

            RespostaQuestao respostaExistente = buscarRespostaExistente(idUsuarioAvaliacao, idAvaliacaoQuestao);
            RespostaQuestao resposta;

            if (respostaExistente != null) {
                resposta = respostaExistente;
            } else {
                resposta = new RespostaQuestao();
                resposta.setIdUsuarioAvaliacao(idUsuarioAvaliacao);
                resposta.setIdAvaliacaoQuestao(idAvaliacaoQuestao);
            }

            resposta.setTextoResposta(textoResposta);
            resposta.setIdOpcaoSelecionada(idOpcaoSelecionada);
            resposta.setDataResposta(LocalDateTime.now());
            resposta.setNotaObtida(BigDecimal.ZERO);

            if (respostaExistente == null) {
                respostaQuestaoRepository.salvar(resposta);
            } else {
                respostaQuestaoRepository.atualizar(resposta);
            }

            response.put("success", true);
            response.put("message", "Resposta salva com sucesso");
            return response;

        } catch (Exception e) {
            System.out.println("❌ Erro ao salvar resposta: " + e.getMessage());
            response.put("success", false);
            response.put("message", "Erro ao salvar resposta");
            return response;
        }
    }

    // 🏁 FINALIZAR AVALIAÇÃO
    @PostMapping("/finalizar")
    public String finalizarAvaliacao(@RequestParam Long idUsuarioAvaliacao, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"ALUNO".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            UsuarioAvaliacao usuarioAvaliacao = usuarioAvaliacaoRepository.buscarPorId(idUsuarioAvaliacao);
            if (usuarioAvaliacao == null || !usuarioAvaliacao.getIdUsuario().equals(usuario.getIdUsuario())) {
                return "redirect:/aluno-avaliacoes?erro=Avaliação não encontrada";
            }

            // Calcular nota antes de finalizar
            BigDecimal notaTotal = calcularNotaAvaliacao(idUsuarioAvaliacao);

            // Atualizar status e nota
            usuarioAvaliacao.setStatusResposta("CONCLUIDA");
            usuarioAvaliacao.setDataFimReal(LocalDateTime.now());
            usuarioAvaliacao.setNotaTotalObtida(notaTotal);

            usuarioAvaliacaoRepository.atualizar(usuarioAvaliacao);

            System.out.println("✅ Avaliação finalizada: " + usuarioAvaliacao.getIdUsuarioAvaliacao() + " - Nota: " + notaTotal);

            return "redirect:/aluno-avaliacoes/resultado/" + idUsuarioAvaliacao;

        } catch (Exception e) {
            System.out.println("❌ Erro ao finalizar avaliação: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/aluno-avaliacoes/realizar/" + idUsuarioAvaliacao + "?erro=Erro+ao+finalizar";
        }
    }

    // 📊 VER RESULTADO - MÉTODO CORRIGIDO
    @GetMapping("/resultado/{idUsuarioAvaliacao}")
    public String verResultado(@PathVariable Long idUsuarioAvaliacao, Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"ALUNO".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        try {
            // DEBUG
            System.out.println("=== DEBUG RESULTADO ===");
            System.out.println("ID UsuarioAvaliacao: " + idUsuarioAvaliacao);

            UsuarioAvaliacao usuarioAvaliacao = usuarioAvaliacaoRepository.buscarPorId(idUsuarioAvaliacao);
            if (usuarioAvaliacao == null || !usuarioAvaliacao.getIdUsuario().equals(usuario.getIdUsuario())) {
                System.out.println("❌ UsuarioAvaliacao não encontrado ou não pertence ao usuário");
                return "redirect:/aluno-avaliacoes?erro=Avaliação não encontrada";
            }

            System.out.println("UsuarioAvaliacao encontrado - Status: " + usuarioAvaliacao.getStatusResposta());

            Avaliacao avaliacao = avaliacaoRepository.buscarPorId(usuarioAvaliacao.getIdAvaliacao());
            List<AvaliacaoQuestao> questoes = avaliacaoQuestaoRepository.findByAvaliacao(avaliacao.getIdAvaliacao());
            List<RespostaQuestao> respostas = respostaQuestaoRepository.findByUsuarioAvaliacao(idUsuarioAvaliacao);

            System.out.println("Avaliação: " + avaliacao.getTitulo());
            System.out.println("Quantidade de Questões: " + questoes.size());
            System.out.println("Quantidade de Respostas: " + respostas.size());

            // ✅ CORREÇÃO: Mapear usando idAvaliacaoQuestao como chave
            Map<Long, Questao> detalhesQuestoes = new HashMap<>();
            Map<Long, List<OpcaoQuestao>> opcoesPorQuestao = new HashMap<>();

            for (AvaliacaoQuestao aq : questoes) {
                Questao questaoDetalhes = questaoRepository.buscarPorId(aq.getIdQuestao());
                if (questaoDetalhes != null) {
                    // ✅ CORREÇÃO: Usar idAvaliacaoQuestao como chave
                    detalhesQuestoes.put(aq.getIdAvaliacaoQuestao(), questaoDetalhes);

                    if ("MULTIPLA_ESCOLHA".equals(questaoDetalhes.getTipoQuestao()) ||
                            "MULTIPLA".equals(questaoDetalhes.getTipoQuestao())) {
                        List<OpcaoQuestao> opcoes = opcaoQuestaoRepo.listarPorQuestao(questaoDetalhes.getIdQuestao());
                        opcoesPorQuestao.put(aq.getIdAvaliacaoQuestao(), opcoes);
                    }
                }
            }

            // DEBUG dos maps
            System.out.println("DetalhesQuestoes size: " + detalhesQuestoes.size());
            System.out.println("OpcoesPorQuestao size: " + opcoesPorQuestao.size());

            model.addAttribute("usuarioAvaliacao", usuarioAvaliacao);
            model.addAttribute("avaliacao", avaliacao);
            model.addAttribute("questoes", questoes);
            model.addAttribute("respostas", respostas);
            model.addAttribute("detalhesQuestoes", detalhesQuestoes);
            model.addAttribute("opcoesPorQuestao", opcoesPorQuestao);
            model.addAttribute("aluno", usuario);

            return "aluno-resultado-avaliacao";

        } catch (Exception e) {
            System.out.println("❌ Erro ao carregar resultado: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/menu-aluno?erro=Erro+ao+carregar+resultado";
        }
    }

    // 🔧 MÉTODOS AUXILIARES
    private RespostaQuestao buscarRespostaExistente(Long idUsuarioAvaliacao, Long idAvaliacaoQuestao) {
        List<RespostaQuestao> respostas = respostaQuestaoRepository.findByUsuarioAvaliacao(idUsuarioAvaliacao);
        return respostas.stream()
                .filter(r -> r.getIdAvaliacaoQuestao().equals(idAvaliacaoQuestao))
                .findFirst()
                .orElse(null);
    }

    private String calcularTempoRestante(LocalDateTime terminoPrevisto) {
        LocalDateTime agora = LocalDateTime.now();
        if (agora.isAfter(terminoPrevisto)) {
            return "00:00";
        }

        java.time.Duration duracao = java.time.Duration.between(agora, terminoPrevisto);
        long minutos = duracao.toMinutes();
        long segundos = duracao.minusMinutes(minutos).getSeconds();

        return String.format("%02d:%02d", minutos, segundos);
    }

    private String finalizarAvaliacaoTempoEsgotado(Long idUsuarioAvaliacao) {
        try {
            UsuarioAvaliacao usuarioAvaliacao = usuarioAvaliacaoRepository.buscarPorId(idUsuarioAvaliacao);
            BigDecimal notaTotal = calcularNotaAvaliacao(idUsuarioAvaliacao);

            usuarioAvaliacao.setStatusResposta("CONCLUIDA");
            usuarioAvaliacao.setDataFimReal(LocalDateTime.now());
            usuarioAvaliacao.setNotaTotalObtida(notaTotal);

            usuarioAvaliacaoRepository.atualizar(usuarioAvaliacao);

            return "redirect:/aluno-avaliacoes/resultado/" + idUsuarioAvaliacao + "?info=Tempo+esgotado";
        } catch (Exception e) {
            return "redirect:/menu-aluno?erro=Erro+ao+finalizar+avaliação";
        }
    }

    private BigDecimal calcularNotaAvaliacao(Long idUsuarioAvaliacao) {
        try {
            List<RespostaQuestao> respostas = respostaQuestaoRepository.findByUsuarioAvaliacao(idUsuarioAvaliacao);
            BigDecimal notaTotal = BigDecimal.ZERO;

            for (RespostaQuestao resposta : respostas) {
                AvaliacaoQuestao avaliacaoQuestao = avaliacaoQuestaoRepository.buscarPorId(resposta.getIdAvaliacaoQuestao());
                if (avaliacaoQuestao != null && avaliacaoQuestao.getPontuacaoEspecificaNaAvaliacao() != null) {
                    // TODO: Implementar lógica de correção real
                    // Por enquanto, assume que todas as respostas estão corretas
                    notaTotal = notaTotal.add(avaliacaoQuestao.getPontuacaoEspecificaNaAvaliacao());
                    resposta.setNotaObtida(avaliacaoQuestao.getPontuacaoEspecificaNaAvaliacao());
                    respostaQuestaoRepository.atualizar(resposta);
                }
            }

            return notaTotal;
        } catch (Exception e) {
            System.out.println("❌ Erro ao calcular nota: " + e.getMessage());
            return BigDecimal.ZERO;
        }
    }
}