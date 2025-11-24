package com.example.pjbd1.service;

import com.example.pjbd1.model.Avaliacao;
import com.example.pjbd1.model.AvaliacaoQuestao;
import com.example.pjbd1.model.Questao;
import com.example.pjbd1.repository.AvaliacaoRepository;
import com.example.pjbd1.repository.AvaliacaoQuestaoRepository;
import com.example.pjbd1.repository.QuestaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Service
public class AvaliacaoService {

    @Autowired
    private AvaliacaoRepository avaliacaoRepository;

    @Autowired
    private QuestaoRepository questaoRepository;

    @Autowired
    private AvaliacaoQuestaoRepository avaliacaoQuestaoRepository;

    @Autowired
    private RelatorioService relatorioService;

    @Autowired
    private JdbcTemplate jdbcTemplate;
    // 📊 CLASSE DashboardStats - ADICIONE ESTA CLASSE DENTRO DO AvaliacaoService
    public static class DashboardStats {
        private int totalAvaliacoes;
        private int totalQuestoes;
        private int avaliacoesSemQuestoes;
        private int questoesNaoUtilizadas;

        // Getters e Setters CORRETOS
        public int getTotalAvaliacoes() {
            return totalAvaliacoes;
        }

        public void setTotalAvaliacoes(int totalAvaliacoes) {
            this.totalAvaliacoes = totalAvaliacoes;
        }

        public int getTotalQuestoes() {
            return totalQuestoes;
        }

        public void setTotalQuestoes(int totalQuestoes) {
            this.totalQuestoes = totalQuestoes;
        }

        public int getAvaliacoesSemQuestoes() {
            return avaliacoesSemQuestoes;
        }

        public void setAvaliacoesSemQuestoes(int avaliacoesSemQuestoes) {
            this.avaliacoesSemQuestoes = avaliacoesSemQuestoes;
        }

        public int getQuestoesNaoUtilizadas() {
            return questoesNaoUtilizadas;
        }

        public void setQuestoesNaoUtilizadas(int questoesNaoUtilizadas) {
            this.questoesNaoUtilizadas = questoesNaoUtilizadas;
        }
    }



//    // 📋 Buscar avaliações por professor - CORRIGIDO
//    public List<Avaliacao> getAvaliacoesPorProfessor(Long idProfessor) {
//        String sql = """
//            SELECT a.id_avaliacao, a.titulo, a.descricao, a.duracao_minutos,
//                   a.data_inicio, a.data_fim, a.status
//            FROM avaliacoes a
//            WHERE a.id_usuario_criador = ?
//            ORDER BY a.data_inicio DESC
//        """;
//
//        return jdbcTemplate.query(sql, new RowMapper<Avaliacao>() {
//            @Override
//            public Avaliacao mapRow(ResultSet rs, int rowNum) throws SQLException {
//                Avaliacao a = new Avaliacao();
//                a.setIdAvaliacao(rs.getLong("id_avaliacao"));
//                a.setTitulo(rs.getString("titulo"));
//                a.setDescricao(rs.getString("descricao"));
//                a.setDuracaoMinutos(rs.getInt("duracao_minutos"));
//
//                // Usando os métodos existentes da classe Avaliacao
//                a.setDataInicio(rs.getTimestamp("data_inicio") != null ?
//                        rs.getTimestamp("data_inicio").toLocalDateTime() : null);
//
//                a.setDataFim(rs.getTimestamp("data_fim") != null ?
//                        rs.getTimestamp("data_fim").toLocalDateTime() : null);
//
//                a.setStatus(rs.getString("status"));
//
//                return a;
//            }
//        }, idProfessor);
//    }

    // 📝 Criar avaliação com questões
    public boolean criarAvaliacaoComQuestoes(Avaliacao avaliacao, List<Long> questaoIds, List<BigDecimal> pontuacoes) {
        try {
            // Salvar avaliação
            avaliacaoRepository.salvar(avaliacao);

            // Adicionar questões
            if (questaoIds != null && !questaoIds.isEmpty()) {
                for (int i = 0; i < questaoIds.size(); i++) {
                    AvaliacaoQuestao aq = new AvaliacaoQuestao();
                    aq.setIdAvaliacao(avaliacao.getIdAvaliacao());
                    aq.setIdQuestao(questaoIds.get(i));
                    aq.setOrdemNaAvaliacao((short) (i + 1));

                    if (pontuacoes != null && i < pontuacoes.size() && pontuacoes.get(i) != null) {
                        aq.setPontuacaoEspecificaNaAvaliacao(pontuacoes.get(i));
                    }

                    avaliacaoQuestaoRepository.salvar(aq);
                }
            }
            return true;
        } catch (Exception e) {
            System.out.println("❌ Erro ao criar avaliação: " + e.getMessage());
            return false;
        }
    }

    // 📊 Estatísticas da avaliação
    public EstatisticasAvaliacao getEstatisticasAvaliacao(Long idAvaliacao) {
        EstatisticasAvaliacao stats = new EstatisticasAvaliacao();

        Avaliacao avaliacao = avaliacaoRepository.buscarPorId(idAvaliacao);
        if (avaliacao == null) return stats;

        stats.setAvaliacao(avaliacao);
        stats.setTotalQuestoes(avaliacaoQuestaoRepository.contarQuestoesPorAvaliacao(idAvaliacao));
        stats.setAvaliacoesSemQuestoes(relatorioService.getAvaliacoesSemQuestoes().size());

        return stats;
    }

    // 🔍 Verificar se avaliação pode ser realizada
    public boolean podeRealizarAvaliacao(Long idAvaliacao) {
        Avaliacao avaliacao = avaliacaoRepository.buscarPorId(idAvaliacao);
        if (avaliacao == null) return false;

        // Verificar se tem questões
        int totalQuestoes = avaliacaoQuestaoRepository.contarQuestoesPorAvaliacao(idAvaliacao);
        if (totalQuestoes == 0) return false;

        // Verificar datas (se aplicável)
        // if (avaliacao.getDataInicio() != null && avaliacao.getDataFim() != null) {
        //     // Lógica de verificação de datas
        // }

        return "ATIVA".equals(avaliacao.getStatus());
    }

    // 📋 Listar avaliações disponíveis para aluno
    public List<Avaliacao> getAvaliacoesDisponiveisParaAluno() {
        List<Avaliacao> disponiveis = avaliacaoRepository.findAvaliacoesDisponiveis();
        return disponiveis.stream()
                .filter(avaliacao -> podeRealizarAvaliacao(avaliacao.getIdAvaliacao()))
                .toList();
    }

    // Model auxiliar para estatísticas
    public static class EstatisticasAvaliacao {
        private Avaliacao avaliacao;
        private int totalQuestoes;
        private int avaliacoesSemQuestoes;

        // getters e setters
        public Avaliacao getAvaliacao() { return avaliacao; }
        public void setAvaliacao(Avaliacao avaliacao) { this.avaliacao = avaliacao; }
        public int getTotalQuestoes() { return totalQuestoes; }
        public void setTotalQuestoes(int totalQuestoes) { this.totalQuestoes = totalQuestoes; }
        public int getAvaliacoesSemQuestoes() { return avaliacoesSemQuestoes; }
        public void setAvaliacoesSemQuestoes(int avaliacoesSemQuestoes) { this.avaliacoesSemQuestoes = avaliacoesSemQuestoes; }
    }

    // 📊 Buscar estatísticas para o dashboard - MÉTODO CORRIGIDO
    public DashboardStats getDashboardStats(Long idProfessor) {
        DashboardStats stats = new DashboardStats();

        try {
            // Total de avaliações do professor
            String sqlAvaliacoes = "SELECT COUNT(*) FROM avaliacoes WHERE id_usuario_criador = ?";
            Integer totalAval = jdbcTemplate.queryForObject(sqlAvaliacoes, Integer.class, idProfessor);
            stats.setTotalAvaliacoes(totalAval != null ? totalAval : 0);

            // Total de questões do professor
            String sqlQuestoes = "SELECT COUNT(*) FROM questoes WHERE id_usuario_criador = ?";
            Integer totalQuest = jdbcTemplate.queryForObject(sqlQuestoes, Integer.class, idProfessor);
            stats.setTotalQuestoes(totalQuest != null ? totalQuest : 0);

            // Avaliações sem questões
            stats.setAvaliacoesSemQuestoes(relatorioService.getAvaliacoesSemQuestoes().size());

            // Questões não utilizadas
            stats.setQuestoesNaoUtilizadas(relatorioService.getQuestoesNuncaUtilizadas().size());

        } catch (Exception e) {
            // Em caso de erro, definir valores zero
            stats.setTotalAvaliacoes(0);
            stats.setTotalQuestoes(0);
            stats.setAvaliacoesSemQuestoes(0);
            stats.setQuestoesNaoUtilizadas(0);
        }

        return stats;
    }

    // 📋 Buscar avaliações por professor
    public List<Avaliacao> getAvaliacoesPorProfessor(Long idProfessor) {
        String sql = """
            SELECT a.id_avaliacao, a.titulo, a.descricao, a.duracao_minutos, 
                   a.data_inicio, a.data_fim, a.status
            FROM avaliacoes a
            WHERE a.id_usuario_criador = ?
            ORDER BY a.data_inicio DESC
        """;

        return jdbcTemplate.query(sql, new RowMapper<Avaliacao>() {
            @Override
            public Avaliacao mapRow(ResultSet rs, int rowNum) throws SQLException {
                Avaliacao a = new Avaliacao();
                a.setIdAvaliacao(rs.getLong("id_avaliacao"));
                a.setTitulo(rs.getString("titulo"));
                a.setDescricao(rs.getString("descricao"));
                a.setDuracaoMinutos(rs.getInt("duracao_minutos"));

                a.setDataInicio(rs.getTimestamp("data_inicio") != null ?
                        rs.getTimestamp("data_inicio").toLocalDateTime() : null);

                a.setDataFim(rs.getTimestamp("data_fim") != null ?
                        rs.getTimestamp("data_fim").toLocalDateTime() : null);

                a.setStatus(rs.getString("status"));
                a.setIdUsuarioCriador(idProfessor);

                return a;
            }
        }, idProfessor);
    }


}