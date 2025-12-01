package com.example.pjbd1.repository;

import com.example.pjbd1.model.Questao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;
import java.util.Objects;

@Repository
public class QuestaoRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final QuestaoRowMapper rowMapper = new QuestaoRowMapper();

    private static class QuestaoRowMapper implements RowMapper<Questao> {
        @Override
        public Questao mapRow(ResultSet rs, int rowNum) throws SQLException {
            Questao q = new Questao();
            q.setIdQuestao(rs.getLong("id_questao"));
            q.setDescricaoQuestao(rs.getString("descricao_questao"));
            q.setTipoQuestao(rs.getString("tipo_questao"));

            // ✅ BigDecimal para valor_pontuacao
            String valorPontuacaoStr = rs.getString("valor_pontuacao");
            if (valorPontuacaoStr != null) {
                q.setValorPontuacao(new BigDecimal(valorPontuacaoStr));
            } else {
                q.setValorPontuacao(null);
            }

            q.setFeedbackCorreto(rs.getString("feedback_correto"));
            q.setFeedbackIncorreto(rs.getString("feedback_incorreto"));
            q.setDataCriacao(rs.getTimestamp("data_criacao").toLocalDateTime());
            q.setIdUsuarioCriador(rs.getLong("id_usuario_criador"));
            return q;
        }
    }

    // ✅ CORRIGIDO: Método listarTodas não existe, usar findAll
    public List<Questao> findAll() {
        String sql = "SELECT * FROM questoes ORDER BY data_criacao DESC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    public Questao buscarPorId(Long id) {
        String sql = "SELECT * FROM questoes WHERE id_questao = ?";
        try {
            return jdbcTemplate.queryForObject(sql, rowMapper, id);
        } catch (Exception e) {
            return null;
        }
    }

    public void salvar(Questao questao) {
        String sql = """
        INSERT INTO questoes 
        (descricao_questao, tipo_questao, valor_pontuacao, feedback_correto, 
         feedback_incorreto, data_criacao, id_usuario_criador)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

        KeyHolder keyHolder = new GeneratedKeyHolder();

        try {
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id_questao"}); // ✅ ESPECIFIQUE APENAS A COLUNA DO ID
                ps.setString(1, questao.getDescricaoQuestao());
                ps.setString(2, questao.getTipoQuestao());

                if (questao.getValorPontuacao() != null) {
                    ps.setBigDecimal(3, questao.getValorPontuacao());
                } else {
                    ps.setNull(3, java.sql.Types.DECIMAL);
                }

                ps.setString(4, questao.getFeedbackCorreto());
                ps.setString(5, questao.getFeedbackIncorreto());
                ps.setTimestamp(6, Timestamp.valueOf(questao.getDataCriacao()));
                ps.setLong(7, questao.getIdUsuarioCriador());
                return ps;
            }, keyHolder);

            // ✅ AGORA VAI FUNCIONAR - especificamos que queremos apenas o id_questao
            Number generatedKey = keyHolder.getKey();
            System.out.println("🔑 KeyHolder getKey(): " + generatedKey);

            if (generatedKey != null) {
                Long idGerado = generatedKey.longValue();
                questao.setIdQuestao(idGerado);
                System.out.println("✅ ID gerado para questão: " + idGerado);
            } else {
                System.out.println("❌ ERRO: KeyHolder retornou null!");
                throw new RuntimeException("Não foi possível obter o ID da questão criada");
            }

        } catch (Exception e) {
            System.out.println("❌ ERRO CRÍTICO no QuestaoRepository.salvar: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    public void atualizar(Questao questao) {
        String sql = """
            UPDATE questoes 
            SET descricao_questao=?, tipo_questao=?, valor_pontuacao=?, 
                feedback_correto=?, feedback_incorreto=?
            WHERE id_questao=?
        """;

        jdbcTemplate.update(sql,
                questao.getDescricaoQuestao(),
                questao.getTipoQuestao(),
                questao.getValorPontuacao(),
                questao.getFeedbackCorreto(),
                questao.getFeedbackIncorreto(),
                questao.getIdQuestao()
        );
    }

    public void deletar(Long id) {
        String sql = "DELETE FROM questoes WHERE id_questao = ?";
        jdbcTemplate.update(sql, id);
    }

    public List<Questao> findByCriador(Long idUsuarioCriador) {
        String sql = "SELECT * FROM questoes WHERE id_usuario_criador = ? ORDER BY data_criacao DESC";
        return jdbcTemplate.query(sql, rowMapper, idUsuarioCriador);
    }

    public List<Questao> findByTipo(String tipoQuestao) {
        String sql = "SELECT * FROM questoes WHERE tipo_questao = ? ORDER BY data_criacao DESC";
        return jdbcTemplate.query(sql, rowMapper, tipoQuestao);
    }

    public List<Questao> findQuestoesNaoUtilizadas() {
        String sql = """
            SELECT q.* FROM questoes q
            LEFT JOIN avaliacao_questao aq ON q.id_questao = aq.id_questao
            WHERE aq.id_avaliacao_questao IS NULL
            ORDER BY q.data_criacao DESC
        """;
        return jdbcTemplate.query(sql, rowMapper);
    }

    public List<Questao> findQuestoesComOpcoesCorretas() {
        String sql = """
            SELECT DISTINCT q.* 
            FROM questoes q
            JOIN opcoes_questao oq ON q.id_questao = oq.id_questao
            WHERE oq.eh_correta = true
            ORDER BY q.data_criacao DESC
        """;
        return jdbcTemplate.query(sql, rowMapper);
    }

    public List<Questao> findQuestoesSemOpcoesCorretas() {
        String sql = """
        SELECT q.*
        FROM questoes q
        WHERE q.tipo_questao = 'MULTIPLA_ESCOLHA'
        AND NOT EXISTS (
            SELECT 1
            FROM opcoes_questao oq
            WHERE oq.id_questao = q.id_questao
            AND oq.eh_correta = true
        )
        ORDER BY q.data_criacao DESC
    """;

        return jdbcTemplate.query(sql, rowMapper);
    }


    public int contarQuestoesPorUsuario(Long idUsuarioCriador) {
        String sql = "SELECT COUNT(*) FROM questoes WHERE id_usuario_criador = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, idUsuarioCriador);
        return count != null ? count : 0;
    }

    public List<Questao> buscarPorDescricao(String termo) {
        String sql = "SELECT * FROM questoes WHERE descricao_questao ILIKE ? ORDER BY data_criacao DESC";
        return jdbcTemplate.query(sql, rowMapper, "%" + termo + "%");
    }

    // ✅ ADICIONADO: Método listarTodas para compatibilidade
    public List<Questao> listarTodas() {
        return findAll();
    }



}