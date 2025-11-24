package com.example.pjbd1.model;

import java.math.BigDecimal;

public class AvaliacaoQuestao {
    private Long idAvaliacaoQuestao;
    private Long idAvaliacao;
    private Long idQuestao;
    private Short ordemNaAvaliacao;
    private BigDecimal pontuacaoEspecificaNaAvaliacao;

    public AvaliacaoQuestao() {}

    public Long getIdAvaliacaoQuestao() {
        return idAvaliacaoQuestao;
    }

    public void setIdAvaliacaoQuestao(Long idAvaliacaoQuestao) {
        this.idAvaliacaoQuestao = idAvaliacaoQuestao;
    }

    public Long getIdAvaliacao() {
        return idAvaliacao;
    }

    public void setIdAvaliacao(Long idAvaliacao) {
        this.idAvaliacao = idAvaliacao;
    }

    public Long getIdQuestao() {
        return idQuestao;
    }

    public void setIdQuestao(Long idQuestao) {
        this.idQuestao = idQuestao;
    }

    public Short getOrdemNaAvaliacao() {
        return ordemNaAvaliacao;
    }

    public void setOrdemNaAvaliacao(Short ordemNaAvaliacao) {
        this.ordemNaAvaliacao = ordemNaAvaliacao;
    }

    public BigDecimal getPontuacaoEspecificaNaAvaliacao() {
        return pontuacaoEspecificaNaAvaliacao;
    }

    public void setPontuacaoEspecificaNaAvaliacao(BigDecimal pontuacaoEspecificaNaAvaliacao) {
        this.pontuacaoEspecificaNaAvaliacao = pontuacaoEspecificaNaAvaliacao;
    }
}
