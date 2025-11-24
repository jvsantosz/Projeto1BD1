package com.example.pjbd1.service;

import com.example.pjbd1.model.AvaliacaoQuestao;
import com.example.pjbd1.repository.AvaliacaoQuestaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AvaliacaoQuestaoService {

    @Autowired
    private AvaliacaoQuestaoRepository avaliacaoQuestaoRepo;

    public List<AvaliacaoQuestao> listarPorAvaliacao(Long idAvaliacao) {
        return avaliacaoQuestaoRepo.listarPorAvaliacao(idAvaliacao);
    }

    public void salvar(AvaliacaoQuestao aq) {
        avaliacaoQuestaoRepo.salvar(aq);
    }

    public void deletar(Long id) {
        avaliacaoQuestaoRepo.deletar(id);
    }
}
