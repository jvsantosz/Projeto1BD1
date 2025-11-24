package com.example.pjbd1.repository;

import com.example.pjbd1.model.OpcaoQuestao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class OpcaoQuestaoRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private OpcaoQuestao mapRow(ResultSet rs, int rowNum) throws SQLException {
        OpcaoQuestao o = new OpcaoQuestao();
        o.setIdOpcao(rs.getLong("id_opcao"));
        o.setIdQuestao(rs.getLong("id_questao"));
        o.setTextoOpcao(rs.getString("texto_opcao"));
        o.setEhCorreta(rs.getBoolean("eh_correta"));
        o.setOrdem(rs.getShort("ordem"));
        return o;
    }

    public List<OpcaoQuestao> listarPorQuestao(Long idQuestao) {
        String sql = "SELECT * FROM opcoes_questao WHERE id_questao = ? ORDER BY ordem";
        return jdbcTemplate.query(sql, this::mapRow, idQuestao);
    }

    public void salvar(OpcaoQuestao o) {
        try {
            String sql = """
            INSERT INTO opcoes_questao (id_questao, texto_opcao, eh_correta, ordem)
            VALUES (?, ?, ?, ?)
        """;
            System.out.println("💾 Tentando salvar opção - Questão ID: " + o.getIdQuestao() + ", Texto: " + o.getTextoOpcao());
            jdbcTemplate.update(sql, o.getIdQuestao(), o.getTextoOpcao(), o.getEhCorreta(), o.getOrdem());
            System.out.println("✅ Opção salva com sucesso");
        } catch (Exception e) {
            System.out.println("❌ ERRO ao salvar opção: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public void deletarPorQuestao(Long idQuestao) {
        String sql = "DELETE FROM opcoes_questao WHERE id_questao = ?";
        jdbcTemplate.update(sql, idQuestao);
    }


    public void deletar(Long id) {
        String sql = "DELETE FROM opcoes_questao WHERE id_opcao = ?";
        jdbcTemplate.update(sql, id);
    }
}