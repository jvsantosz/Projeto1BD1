package com.example.pjbd1.service;

import com.example.pjbd1.model.UsuarioAvaliacao;
import com.example.pjbd1.repository.UsuarioAvaliacaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UsuarioAvaliacaoService {

    @Autowired
    private UsuarioAvaliacaoRepository usuarioAvaliacaoRepo;

    public List<UsuarioAvaliacao> listarPorAvaliacao(Long idAvaliacao) {
        return usuarioAvaliacaoRepo.listarPorAvaliacao(idAvaliacao);
    }

    public void salvar(UsuarioAvaliacao ua) {
        // Regra: evitar duplicar atribuições
        List<UsuarioAvaliacao> jaAtribuidos = usuarioAvaliacaoRepo.listarPorAvaliacao(ua.getIdAvaliacao());
        boolean duplicado = jaAtribuidos.stream()
                .anyMatch(x -> x.getIdUsuario().equals(ua.getIdUsuario()));
        if (!duplicado) {
            usuarioAvaliacaoRepo.salvar(ua);
        } else {
            throw new IllegalArgumentException("Usuário já possui atribuição nesta avaliação");
        }
    }

    public void atualizarStatus(Long id, String status) {
        usuarioAvaliacaoRepo.atualizarStatus(id, status);
    }
}
