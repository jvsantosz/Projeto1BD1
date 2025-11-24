package com.example.pjbd1.repository;

import com.example.pjbd1.model.UsuarioAvaliacao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.Objects;

@Repository
public class UsuarioAvaliacaoRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<UsuarioAvaliacao> rowMapper = new RowMapper<UsuarioAvaliacao>() {
        @Override
        public UsuarioAvaliacao mapRow(ResultSet rs, int rowNum) throws SQLException {
            UsuarioAvaliacao ua = new UsuarioAvaliacao();
            ua.setIdUsuarioAvaliacao(rs.getLong("id_usuario_avaliacao"));
            ua.setIdUsuario(rs.getLong("id_usuario"));
            ua.setIdAvaliacao(rs.getLong("id_avaliacao"));
            ua.setDataInicioReal(rs.getTimestamp("data_inicio_real") != null ?
                    rs.getTimestamp("data_inicio_real").toLocalDateTime() : null);
            ua.setDataFimReal(rs.getTimestamp("data_fim_real") != null ?
                    rs.getTimestamp("data_fim_real").toLocalDateTime() : null);
            ua.setStatusResposta(rs.getString("status_resposta"));
            ua.setNotaTotalObtida(rs.getBigDecimal("nota_total_obtida"));
            return ua;
        }
    };

    public UsuarioAvaliacao buscarPorId(Long idUsuarioAvaliacao) {
        String sql = "SELECT * FROM usuario_avaliacao WHERE id_usuario_avaliacao = ?";
        try {
            return jdbcTemplate.queryForObject(sql, rowMapper, idUsuarioAvaliacao);
        } catch (Exception e) {
            return null;
        }
    }

    public UsuarioAvaliacao findByUsuarioAndAvaliacao(Long idUsuario, Long idAvaliacao) {
        String sql = "SELECT * FROM usuario_avaliacao WHERE id_usuario = ? AND id_avaliacao = ?";
        try {
            return jdbcTemplate.queryForObject(sql, rowMapper, idUsuario, idAvaliacao);
        } catch (Exception e) {
            return null;
        }
    }

    public List<UsuarioAvaliacao> listarPorAvaliacao(Long idAvaliacao) {
        String sql = "SELECT * FROM usuario_avaliacao WHERE id_avaliacao = ?";
        return jdbcTemplate.query(sql, rowMapper, idAvaliacao);
    }

    public List<UsuarioAvaliacao> findByUsuario(Long idUsuario) {
        String sql = "SELECT * FROM usuario_avaliacao WHERE id_usuario = ? ORDER BY data_inicio_real DESC";
        return jdbcTemplate.query(sql, rowMapper, idUsuario);
    }

    public void salvar(UsuarioAvaliacao usuarioAvaliacao) {
        String sql = "INSERT INTO usuario_avaliacao (id_usuario, id_avaliacao, data_inicio_real, status_resposta, nota_total_obtida) " +
                "VALUES (?, ?, ?, ?, ?)";

        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id_usuario_avaliacao"});
            ps.setLong(1, usuarioAvaliacao.getIdUsuario());
            ps.setLong(2, usuarioAvaliacao.getIdAvaliacao());
            ps.setTimestamp(3, usuarioAvaliacao.getDataInicioReal() != null ?
                    java.sql.Timestamp.valueOf(usuarioAvaliacao.getDataInicioReal()) : null);
            ps.setString(4, usuarioAvaliacao.getStatusResposta());
            ps.setBigDecimal(5, usuarioAvaliacao.getNotaTotalObtida());
            return ps;
        }, keyHolder);

        usuarioAvaliacao.setIdUsuarioAvaliacao(Objects.requireNonNull(keyHolder.getKey()).longValue());
    }

    public void atualizar(UsuarioAvaliacao usuarioAvaliacao) {
        String sql = "UPDATE usuario_avaliacao SET data_fim_real = ?, status_resposta = ?, nota_total_obtida = ? " +
                "WHERE id_usuario_avaliacao = ?";
        jdbcTemplate.update(sql,
                usuarioAvaliacao.getDataFimReal() != null ?
                        java.sql.Timestamp.valueOf(usuarioAvaliacao.getDataFimReal()) : null,
                usuarioAvaliacao.getStatusResposta(),
                usuarioAvaliacao.getNotaTotalObtida(),
                usuarioAvaliacao.getIdUsuarioAvaliacao());
    }

    public void atualizarStatus(Long id, String status) {
        String sql = "UPDATE usuario_avaliacao SET status_resposta = ? WHERE id_usuario_avaliacao = ?";
        jdbcTemplate.update(sql, status, id);
    }

    public void atualizarNota(Long id, java.math.BigDecimal nota) {
        String sql = "UPDATE usuario_avaliacao SET nota_total_obtida = ? WHERE id_usuario_avaliacao = ?";
        jdbcTemplate.update(sql, nota, id);
    }
}