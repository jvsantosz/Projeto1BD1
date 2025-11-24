package com.example.pjbd1.repository;

import com.example.pjbd1.model.AvaliacaoQuestao;
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
import java.util.List;
import java.util.Objects;

@Repository
public class AvaliacaoQuestaoRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final AvaliacaoQuestaoRowMapper rowMapper = new AvaliacaoQuestaoRowMapper();

    private static class AvaliacaoQuestaoRowMapper implements RowMapper<AvaliacaoQuestao> {
        @Override
        public AvaliacaoQuestao mapRow(ResultSet rs, int rowNum) throws SQLException {
            AvaliacaoQuestao aq = new AvaliacaoQuestao();
            aq.setIdAvaliacaoQuestao(rs.getLong("id_avaliacao_questao"));
            aq.setIdAvaliacao(rs.getLong("id_avaliacao"));
            aq.setIdQuestao(rs.getLong("id_questao"));
            aq.setOrdemNaAvaliacao(rs.getShort("ordem_na_avaliacao"));

            String pontuacaoStr = rs.getString("pontuacao_especifica_na_avaliacao");
            if (pontuacaoStr != null) {
                aq.setPontuacaoEspecificaNaAvaliacao(new BigDecimal(pontuacaoStr));
            } else {
                aq.setPontuacaoEspecificaNaAvaliacao(null);
            }

            return aq;
        }
    }

    public void salvar(AvaliacaoQuestao avaliacaoQuestao) {
        String sql = """
            INSERT INTO avaliacao_questao 
            (id_avaliacao, id_questao, ordem_na_avaliacao, pontuacao_especifica_na_avaliacao)
            VALUES (?, ?, ?, ?)
        """;

        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(connection -> {
            // CORREÇÃO: Especificar a coluna de chave primária
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id_avaliacao_questao"});
            ps.setLong(1, avaliacaoQuestao.getIdAvaliacao());
            ps.setLong(2, avaliacaoQuestao.getIdQuestao());
            ps.setShort(3, avaliacaoQuestao.getOrdemNaAvaliacao());

            if (avaliacaoQuestao.getPontuacaoEspecificaNaAvaliacao() != null) {
                ps.setBigDecimal(4, avaliacaoQuestao.getPontuacaoEspecificaNaAvaliacao());
            } else {
                ps.setNull(4, java.sql.Types.DECIMAL);
            }

            return ps;
        }, keyHolder);

        // CORREÇÃO: Obter apenas a chave primária
        avaliacaoQuestao.setIdAvaliacaoQuestao(Objects.requireNonNull(keyHolder.getKey()).longValue());
    }

    public List<AvaliacaoQuestao> findByAvaliacao(Long idAvaliacao) {
        String sql = """
            SELECT aq.*, q.descricao_questao, q.valor_pontuacao as valor_padrao_questao
            FROM avaliacao_questao aq
            JOIN questoes q ON q.id_questao = aq.id_questao
            WHERE aq.id_avaliacao = ?
            ORDER BY aq.ordem_na_avaliacao
        """;
        return jdbcTemplate.query(sql, rowMapper, idAvaliacao);
    }

    public List<AvaliacaoQuestao> listarPorAvaliacao(Long idAvaliacao) {
        return findByAvaliacao(idAvaliacao);
    }

    public void deletarPorAvaliacao(Long idAvaliacao) {
        String sql = "DELETE FROM avaliacao_questao WHERE id_avaliacao = ?";
        jdbcTemplate.update(sql, idAvaliacao);
    }

    public void deletar(Long idAvaliacaoQuestao) {
        String sql = "DELETE FROM avaliacao_questao WHERE id_avaliacao_questao = ?";
        jdbcTemplate.update(sql, idAvaliacaoQuestao);
    }

    public void deletarPorQuestaoEAvaliacao(Long idAvaliacao, Long idQuestao) {
        String sql = "DELETE FROM avaliacao_questao WHERE id_avaliacao = ? AND id_questao = ?";
        jdbcTemplate.update(sql, idAvaliacao, idQuestao);
    }

    public AvaliacaoQuestao buscarPorId(Long idAvaliacaoQuestao) {
        String sql = "SELECT * FROM avaliacao_questao WHERE id_avaliacao_questao = ?";
        try {
            return jdbcTemplate.queryForObject(sql, rowMapper, idAvaliacaoQuestao);
        } catch (Exception e) {
            return null;
        }
    }

    public boolean existeQuestaoNaAvaliacao(Long idAvaliacao, Long idQuestao) {
        String sql = "SELECT COUNT(*) FROM avaliacao_questao WHERE id_avaliacao = ? AND id_questao = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, idAvaliacao, idQuestao);
        return count != null && count > 0;
    }

    public int contarQuestoesPorAvaliacao(Long idAvaliacao) {
        String sql = "SELECT COUNT(*) FROM avaliacao_questao WHERE id_avaliacao = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, idAvaliacao);
        return count != null ? count : 0;
    }

    public void atualizarOrdemQuestoes(Long idAvaliacao, Long idQuestao, Short novaOrdem) {
        String sql = "UPDATE avaliacao_questao SET ordem_na_avaliacao = ? WHERE id_avaliacao = ? AND id_questao = ?";
        jdbcTemplate.update(sql, novaOrdem, idAvaliacao, idQuestao);
    }

    public void atualizarPontuacaoEspecifica(Long idAvaliacaoQuestao, BigDecimal novaPontuacao) {
        String sql = "UPDATE avaliacao_questao SET pontuacao_especifica_na_avaliacao = ? WHERE id_avaliacao_questao = ?";
        jdbcTemplate.update(sql, novaPontuacao, idAvaliacaoQuestao);
    }
}