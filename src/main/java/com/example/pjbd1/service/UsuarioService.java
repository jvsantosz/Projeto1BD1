package com.example.pjbd1.service;

import com.example.pjbd1.model.Usuario;
import com.example.pjbd1.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepo;

    public List<Usuario> listarTodos() {
        return usuarioRepo.listarTodos();
    }

    public Usuario buscarPorId(Long id) {
        return usuarioRepo.buscarPorId(id);
    }

    public void criarUsuario(Usuario usuario) {
        // Exemplo: gerar hash da senha antes de salvar
        if (usuario.getSenha() == null || usuario.getSenha().isEmpty()) {
            throw new IllegalArgumentException("Senha obrigatória");
        }
        usuarioRepo.salvar(usuario);
    }

    public void atualizarUsuario(Usuario usuario) {
        usuarioRepo.atualizar(usuario);
    }

    public void deletar(Long id) {
        usuarioRepo.deletar(id);
    }
}
