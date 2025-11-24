package com.example.pjbd1.controller;

import com.example.pjbd1.model.*;
import com.example.pjbd1.service.RelatorioService;
import com.example.pjbd1.service.AvaliacaoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import jakarta.servlet.http.HttpSession;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

@Controller
public class MenuAlunoController {

    @Autowired
    private RelatorioService relatorioService;

    @Autowired
    private AvaliacaoService avaliacaoService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/menu-aluno")
    public String menuAluno(Model model, HttpSession session) {
        System.out.println("=== MENU ALUNO ACESSADO ===");

        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        System.out.println("Usuário na sessão: " + usuario);

        if (usuario == null) {
            System.out.println("❌ Usuário NÃO logado - redirecionando");
            return "redirect:/?erro=Faça login primeiro";
        }

        if (!"ALUNO".equals(usuario.getTipoUsuario())) {
            System.out.println("❌ Usuário NÃO é aluno - redirecionando");
            return "redirect:/?erro=Acesso permitido apenas para alunos";
        }

        try {
            System.out.println("✅ Usuário é ALUNO - carregando dados...");

            // 1. Estatísticas básicas
            Double mediaGeral = calcularMediaGeral(usuario.getIdUsuario());
            Integer totalAvaliacoes = getTotalAvaliacoesRealizadas(usuario.getIdUsuario());
            List<Avaliacao> avaliacoesDisponiveis = avaliacaoService.getAvaliacoesDisponiveisParaAluno();
            List<AlunoRanking> rankingAlunos = relatorioService.getTop5AlunosRanking();
            Integer posicaoRanking = calcularPosicaoRanking(usuario.getIdUsuario(), rankingAlunos);

            // 2. Avaliações recentes (limitar para 3)
            List<Avaliacao> avaliacoesRecentes = avaliacoesDisponiveis.stream()
                    .limit(3)
                    .collect(Collectors.toList());

            // 3. Notas recentes
            List<NotaAlunoAvaliacao> notasRecentes = getNotasRecentes(usuario.getIdUsuario());

            // DEBUG
            System.out.println("📊 Estatísticas carregadas:");
            System.out.println(" - Média Geral: " + mediaGeral);
            System.out.println(" - Total Avaliações: " + totalAvaliacoes);
            System.out.println(" - Disponíveis: " + avaliacoesDisponiveis.size());
            System.out.println(" - Posição Ranking: " + posicaoRanking);
            System.out.println(" - Avaliações Recentes: " + avaliacoesRecentes.size());
            System.out.println(" - Notas Recentes: " + notasRecentes.size());

            // Adicionar atributos ao model
            model.addAttribute("usuario", usuario);
            model.addAttribute("mediaGeral", mediaGeral != null ? String.format("%.1f", mediaGeral) : "N/A");
            model.addAttribute("totalAvaliacoes", totalAvaliacoes);
            model.addAttribute("avaliacoesDisponiveis", avaliacoesDisponiveis.size());
            model.addAttribute("avaliacoesRecentes", avaliacoesRecentes);
            model.addAttribute("notasRecentes", notasRecentes);
            model.addAttribute("rankingAlunos", rankingAlunos);
            model.addAttribute("posicaoRanking", posicaoRanking);

            return "mp-aluno"; // ✅ NOME CORRETO DA PÁGINA

        } catch (Exception e) {
            System.out.println("❌ Erro no menu aluno: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/?erro=Erro ao carregar dashboard";
        }
    }

    private Double calcularMediaGeral(Long idUsuario) {
        try {
            String sql = "SELECT COALESCE(AVG(nota_total_obtida), 0) FROM usuario_avaliacao WHERE id_usuario = ? AND status_resposta = 'CONCLUIDA'";
            Double media = jdbcTemplate.queryForObject(sql, Double.class, idUsuario);
            return media != null ? media : 0.0;
        } catch (Exception e) {
            System.out.println("❌ Erro ao calcular média: " + e.getMessage());
            return 0.0;
        }
    }

    private Integer getTotalAvaliacoesRealizadas(Long idUsuario) {
        try {
            String sql = "SELECT COUNT(*) FROM usuario_avaliacao WHERE id_usuario = ? AND status_resposta = 'CONCLUIDA'";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, idUsuario);
            return count != null ? count : 0;
        } catch (Exception e) {
            System.out.println("❌ Erro ao contar avaliações: " + e.getMessage());
            return 0;
        }
    }

    private Integer calcularPosicaoRanking(Long idUsuario, List<AlunoRanking> ranking) {
        if (ranking == null || ranking.isEmpty()) {
            return null;
        }

        for (int i = 0; i < ranking.size(); i++) {
            if (ranking.get(i).getIdUsuario().equals(idUsuario)) {
                return i + 1;
            }
        }
        return null;
    }

    private List<NotaAlunoAvaliacao> getNotasRecentes(Long idUsuario) {
        try {
            String sql = """
            SELECT a.titulo as titulo_avaliacao, 
                   ua.nota_total_obtida,
                   ua.data_fim_real
            FROM usuario_avaliacao ua
            JOIN avaliacoes a ON a.id_avaliacao = ua.id_avaliacao
            WHERE ua.id_usuario = ? AND ua.status_resposta = 'CONCLUIDA'
            ORDER BY ua.data_fim_real DESC
            LIMIT 5
        """;

            return jdbcTemplate.query(sql, new RowMapper<NotaAlunoAvaliacao>() {
                @Override
                public NotaAlunoAvaliacao mapRow(ResultSet rs, int rowNum) throws SQLException {
                    NotaAlunoAvaliacao nota = new NotaAlunoAvaliacao();
                    nota.setTituloAvaliacao(rs.getString("titulo_avaliacao"));

                    // Calcular nota percentual (simplificado)
                    Double notaTotal = rs.getDouble("nota_total_obtida");
                    nota.setNotaPercentual(notaTotal != null ? notaTotal : 0.0);

                    // Formatar data
                    if (rs.getTimestamp("data_fim_real") != null) {
                        String dataFormatada = rs.getTimestamp("data_fim_real")
                                .toLocalDateTime()
                                .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
                        // Usando reflexão para setar data se houver o campo
                        try {
                            java.lang.reflect.Field field = nota.getClass().getDeclaredField("dataRealizacao");
                            field.setAccessible(true);
                            field.set(nota, dataFormatada);
                        } catch (Exception e) {
                            // Ignora se não existir o campo
                        }
                    }

                    return nota;
                }
            }, idUsuario);

        } catch (Exception e) {
            System.out.println("❌ Erro ao buscar notas recentes: " + e.getMessage());
            return new ArrayList<>();
        }
    }
}