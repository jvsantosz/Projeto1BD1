package com.example.pjbd1.repository;

import com.example.pjbd1.model.Avaliacao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.List;
import java.util.Objects;

@Repository
public class AvaliacaoRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final AvaliacaoRowMapper rowMapper = new AvaliacaoRowMapper();

    private static class AvaliacaoRowMapper implements RowMapper<Avaliacao> {
        @Override
        public Avaliacao mapRow(ResultSet rs, int rowNum) throws SQLException {
            Avaliacao a = new Avaliacao();
            a.setIdAvaliacao(rs.getLong("id_avaliacao"));
            a.setIdUsuarioCriador(rs.getLong("id_usuario_criador"));
            a.setTitulo(rs.getString("titulo"));
            a.setDescricao(rs.getString("descricao"));
            a.setDataInicio(rs.getTimestamp("data_inicio") != null ?
                    rs.getTimestamp("data_inicio").toLocalDateTime() : null);
            a.setDataFim(rs.getTimestamp("data_fim") != null ?
                    rs.getTimestamp("data_fim").toLocalDateTime() : null);
            a.setDuracaoMinutos(rs.getInt("duracao_minutos"));
            a.setStatus(rs.getString("status"));
            return a;
        }
    }

    public void salvar(Avaliacao avaliacao) {
        String sql = """
            INSERT INTO avaliacoes 
            (id_usuario_criador, titulo, descricao, data_inicio, data_fim, 
             duracao_minutos, status)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(connection -> {
            // CORREÇÃO: Especificar a coluna de chave primária
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id_avaliacao"});
            ps.setLong(1, avaliacao.getIdUsuarioCriador());
            ps.setString(2, avaliacao.getTitulo());
            ps.setString(3, avaliacao.getDescricao());
            ps.setTimestamp(4, avaliacao.getDataInicio() != null ?
                    Timestamp.valueOf(avaliacao.getDataInicio()) : null);
            ps.setTimestamp(5, avaliacao.getDataFim() != null ?
                    Timestamp.valueOf(avaliacao.getDataFim()) : null);
            ps.setInt(6, avaliacao.getDuracaoMinutos());
            ps.setString(7, avaliacao.getStatus());
            return ps;
        }, keyHolder);

        // CORREÇÃO: Obter apenas a chave primária
        avaliacao.setIdAvaliacao(Objects.requireNonNull(keyHolder.getKey()).longValue());
    }

    public List<Avaliacao> findByCriador(Long idUsuarioCriador) {
        String sql = "SELECT * FROM avaliacoes WHERE id_usuario_criador = ? ORDER BY id_avaliacao DESC";
        return jdbcTemplate.query(sql, rowMapper, idUsuarioCriador);
    }

    public Avaliacao buscarPorId(Long id) {
        String sql = "SELECT * FROM avaliacoes WHERE id_avaliacao = ?";
        try {
            return jdbcTemplate.queryForObject(sql, rowMapper, id);
        } catch (Exception e) {
            return null;
        }
    }

    public void atualizar(Avaliacao avaliacao) {
        String sql = """
            UPDATE avaliacoes SET 
            titulo=?, descricao=?, data_inicio=?, data_fim=?, 
            duracao_minutos=?, status=?
            WHERE id_avaliacao=?
        """;

        jdbcTemplate.update(sql,
                avaliacao.getTitulo(),
                avaliacao.getDescricao(),
                avaliacao.getDataInicio() != null ? Timestamp.valueOf(avaliacao.getDataInicio()) : null,
                avaliacao.getDataFim() != null ? Timestamp.valueOf(avaliacao.getDataFim()) : null,
                avaliacao.getDuracaoMinutos(),
                avaliacao.getStatus(),
                avaliacao.getIdAvaliacao()
        );
    }

    public void excluir(Long id) {
        String sql = "DELETE FROM avaliacoes WHERE id_avaliacao = ?";
        jdbcTemplate.update(sql, id);
    }

    public List<Avaliacao> findAvaliacoesDisponiveis() {
        String sql = """
            SELECT * FROM avaliacoes 
            WHERE status = 'ATIVA' 
            AND (data_inicio IS NULL OR data_inicio <= NOW())
            AND (data_fim IS NULL OR data_fim >= NOW())
            ORDER BY id_avaliacao DESC
        """;
        return jdbcTemplate.query(sql, rowMapper);
    }

    public List<Avaliacao> findAll() {
        String sql = "SELECT * FROM avaliacoes ORDER BY id_avaliacao DESC";
        return jdbcTemplate.query(sql, rowMapper);
    }
}