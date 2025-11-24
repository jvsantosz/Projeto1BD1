package com.example.pjbd1.repository;

import com.example.pjbd1.model.RespostaQuestao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class RespostaQuestaoRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<RespostaQuestao> rowMapper = new RowMapper<RespostaQuestao>() {
        @Override
        public RespostaQuestao mapRow(ResultSet rs, int rowNum) throws SQLException {
            RespostaQuestao resposta = new RespostaQuestao();
            resposta.setIdRespostaQuestao(rs.getLong("id_resposta_questao"));
            resposta.setIdUsuarioAvaliacao(rs.getLong("id_usuario_avaliacao"));
            resposta.setIdAvaliacaoQuestao(rs.getLong("id_avaliacao_questao"));
            resposta.setTextoResposta(rs.getString("texto_resposta"));

            // Tratamento para id_opcao_selecionada que pode ser NULL
            long idOpcao = rs.getLong("id_opcao_selecionada");
            resposta.setIdOpcaoSelecionada(rs.wasNull() ? null : idOpcao);

            resposta.setNotaObtida(rs.getBigDecimal("nota_obtida"));
            resposta.setDataResposta(rs.getTimestamp("data_resposta") != null ?
                    rs.getTimestamp("data_resposta").toLocalDateTime() : null);
            return resposta;
        }
    };

    public List<RespostaQuestao> findByUsuarioAvaliacao(Long idUsuarioAvaliacao) {
        String sql = "SELECT * FROM respostas_questao WHERE id_usuario_avaliacao = ?";
        return jdbcTemplate.query(sql, rowMapper, idUsuarioAvaliacao);
    }

    // Método adicional que o Service precisa
    public List<RespostaQuestao> listarPorUsuarioAvaliacao(Long idUsuarioAvaliacao) {
        return findByUsuarioAvaliacao(idUsuarioAvaliacao); // Reutiliza o método existente
    }

    public RespostaQuestao buscarPorId(Long idRespostaQuestao) {
        String sql = "SELECT * FROM respostas_questao WHERE id_resposta_questao = ?";
        try {
            return jdbcTemplate.queryForObject(sql, rowMapper, idRespostaQuestao);
        } catch (Exception e) {
            return null;
        }
    }

    // Método para buscar resposta específica por questão e usuário
    public RespostaQuestao findByUsuarioAvaliacaoAndQuestao(Long idUsuarioAvaliacao, Long idAvaliacaoQuestao) {
        String sql = "SELECT * FROM respostas_questao WHERE id_usuario_avaliacao = ? AND id_avaliacao_questao = ?";
        try {
            return jdbcTemplate.queryForObject(sql, rowMapper, idUsuarioAvaliacao, idAvaliacaoQuestao);
        } catch (Exception e) {
            return null;
        }
    }

    public void salvar(RespostaQuestao respostaQuestao) {
        String sql = "INSERT INTO respostas_questao (id_usuario_avaliacao, id_avaliacao_questao, texto_resposta, " +
                "id_opcao_selecionada, nota_obtida, data_resposta) VALUES (?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,
                respostaQuestao.getIdUsuarioAvaliacao(),
                respostaQuestao.getIdAvaliacaoQuestao(),
                respostaQuestao.getTextoResposta(),
                respostaQuestao.getIdOpcaoSelecionada(),
                respostaQuestao.getNotaObtida(),
                respostaQuestao.getDataResposta());
    }

    public void atualizar(RespostaQuestao respostaQuestao) {
        String sql = "UPDATE respostas_questao SET texto_resposta = ?, id_opcao_selecionada = ?, " +
                "nota_obtida = ?, data_resposta = ? WHERE id_resposta_questao = ?";
        jdbcTemplate.update(sql,
                respostaQuestao.getTextoResposta(),
                respostaQuestao.getIdOpcaoSelecionada(),
                respostaQuestao.getNotaObtida(),
                respostaQuestao.getDataResposta(),
                respostaQuestao.getIdRespostaQuestao());
    }

    // Método para salvar ou atualizar (upsert)
    public void salvarOuAtualizar(RespostaQuestao respostaQuestao) {
        RespostaQuestao existente = findByUsuarioAvaliacaoAndQuestao(
                respostaQuestao.getIdUsuarioAvaliacao(),
                respostaQuestao.getIdAvaliacaoQuestao()
        );

        if (existente != null) {
            respostaQuestao.setIdRespostaQuestao(existente.getIdRespostaQuestao());
            atualizar(respostaQuestao);
        } else {
            salvar(respostaQuestao);
        }
    }
}