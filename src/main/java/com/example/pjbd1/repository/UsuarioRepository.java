package com.example.pjbd1.repository;

import com.example.pjbd1.model.Usuario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class UsuarioRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // ✅ MANTIDO: RowMapper como classe interna
    private static class UsuarioRowMapper implements RowMapper<Usuario> {
        @Override
        public Usuario mapRow(ResultSet rs, int rowNum) throws SQLException {
            Usuario u = new Usuario();
            u.setIdUsuario(rs.getLong("id_usuario"));
            u.setNome(rs.getString("nome"));
            u.setEmail(rs.getString("email"));
            u.setSenha(rs.getString("senha"));
            u.setTipoUsuario(rs.getString("tipo_usuario"));
            u.setDataCadastro(rs.getTimestamp("data_cadastro").toLocalDateTime());
            u.setAtivo(rs.getBoolean("ativo"));
            return u;
        }
    }

    // ✅ MANTIDO: Método de mapeamento compatível
    private Usuario mapRow(ResultSet rs, int rowNum) throws SQLException {
        return new UsuarioRowMapper().mapRow(rs, rowNum);
    }

    // ✅ MANTIDO: Todos os métodos existentes
    public List<Usuario> listarTodos() {
        String sql = "SELECT * FROM usuarios ORDER BY id_usuario";
        return jdbcTemplate.query(sql, this::mapRow);
    }

    public Usuario buscarPorId(Long id) {
        String sql = "SELECT * FROM usuarios WHERE id_usuario = ?";
        try {
            return jdbcTemplate.queryForObject(sql, this::mapRow, id);
        } catch (Exception e) {
            return null;
        }
    }

    public void salvar(Usuario u) {
        String sql = """
            INSERT INTO usuarios (nome, email, senha, tipo_usuario, data_cadastro, ativo)
            VALUES (?, ?, ?, ?, now(), ?)
        """;
        jdbcTemplate.update(sql, u.getNome(), u.getEmail(), u.getSenha(), u.getTipoUsuario(), u.getAtivo());
    }

    public void atualizar(Usuario u) {
        String sql = """
            UPDATE usuarios
            SET nome=?, email=?, senha=?, tipo_usuario=?, ativo=?
            WHERE id_usuario=?
        """;
        jdbcTemplate.update(sql, u.getNome(), u.getEmail(), u.getSenha(),
                u.getTipoUsuario(), u.getAtivo(), u.getIdUsuario());
    }

    public void deletar(Long id) {
        String sql = "DELETE FROM usuarios WHERE id_usuario=?";
        jdbcTemplate.update(sql, id);
    }

    public void testarConexao() {
        try {
            System.out.println("=== TESTANDO REPOSITÓRIO ===");
            String sql = "SELECT COUNT(*) FROM usuarios";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class);
            System.out.println("Total de usuários no banco: " + count);
        } catch (Exception e) {
            System.out.println("ERRO no repositório:");
            e.printStackTrace();
        }
    }

    public Usuario buscarPorEmailESenha(String email, String senha) {
        try {
            String sql = "SELECT * FROM usuarios WHERE email = ? AND senha = ? AND ativo = true";

            List<Usuario> usuarios = jdbcTemplate.query(sql, new UsuarioRowMapper(), email, senha);

            if (usuarios.isEmpty()) {
                System.out.println("Nenhum usuário encontrado com email: " + email);
                return null;
            }

            Usuario usuario = usuarios.get(0);
            System.out.println("Usuário encontrado: " + usuario.getNome() + " - " + usuario.getTipoUsuario());
            return usuario;

        } catch (Exception e) {
            System.out.println("Erro ao buscar usuário por email e senha: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    // ✅ ADICIONADO: Métodos extras sem quebrar código existente
    public List<Usuario> buscarPorTipo(String tipoUsuario) {
        String sql = "SELECT * FROM usuarios WHERE tipo_usuario = ? AND ativo = true ORDER BY nome";
        return jdbcTemplate.query(sql, this::mapRow, tipoUsuario);
    }

    public boolean existeEmail(String email) {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE email = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
        return count != null && count > 0;
    }

    public void desativarUsuario(Long id) {
        String sql = "UPDATE usuarios SET ativo = false WHERE id_usuario = ?";
        jdbcTemplate.update(sql, id);
    }
}