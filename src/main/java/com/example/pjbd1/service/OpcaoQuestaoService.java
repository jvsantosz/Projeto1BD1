package com.example.pjbd1.service;

import com.example.pjbd1.model.OpcaoQuestao;
import com.example.pjbd1.repository.OpcaoQuestaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OpcaoQuestaoService {

    @Autowired
    private OpcaoQuestaoRepository opcaoRepo;

    public List<OpcaoQuestao> listarPorQuestao(Long idQuestao) {
        return opcaoRepo.listarPorQuestao(idQuestao);
    }

    public void salvar(OpcaoQuestao opcao) {
        opcaoRepo.salvar(opcao);
    }

    public void deletar(Long id) {
        opcaoRepo.deletar(id);
    }
}
