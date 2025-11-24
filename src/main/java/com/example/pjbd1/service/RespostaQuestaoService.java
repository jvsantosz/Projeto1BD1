package com.example.pjbd1.service;

import com.example.pjbd1.model.RespostaQuestao;
import com.example.pjbd1.repository.RespostaQuestaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RespostaQuestaoService {

    @Autowired
    private RespostaQuestaoRepository respostaRepo;

    public List<RespostaQuestao> listarPorUsuarioAvaliacao(Long idUsuarioAvaliacao) {
        return respostaRepo.listarPorUsuarioAvaliacao(idUsuarioAvaliacao);
    }

    public void salvar(RespostaQuestao resposta) {
        // Verifica se já existe resposta para esta questão
        RespostaQuestao respostaExistente = respostaRepo.findByUsuarioAvaliacaoAndQuestao(
                resposta.getIdUsuarioAvaliacao(),
                resposta.getIdAvaliacaoQuestao()
        );

        if (respostaExistente != null) {
            // Atualiza a resposta existente
            resposta.setIdRespostaQuestao(respostaExistente.getIdRespostaQuestao());
            respostaRepo.atualizar(resposta);
        } else {
            // Salva nova resposta
            respostaRepo.salvar(resposta);
        }
    }

    // Método alternativo mais simples
    public void salvarResposta(RespostaQuestao resposta) {
        respostaRepo.salvarOuAtualizar(resposta);
    }
}