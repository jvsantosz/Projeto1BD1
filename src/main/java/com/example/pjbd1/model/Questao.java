package com.example.pjbd1.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Questao {
    private Long idQuestao;
    private String descricaoQuestao;
    private String tipoQuestao; // MULTIPLA, TEXTO, NUMERICA
    private BigDecimal valorPontuacao;
    private String feedbackCorreto;
    private String feedbackIncorreto;
    private LocalDateTime dataCriacao;
    private Long idUsuarioCriador;

    public Questao() {}

    public Long getIdQuestao() {
        return idQuestao;
    }

    public void setIdQuestao(Long idQuestao) {
        this.idQuestao = idQuestao;
    }

    public String getDescricaoQuestao() {
        return descricaoQuestao;
    }

    public void setDescricaoQuestao(String descricaoQuestao) {
        this.descricaoQuestao = descricaoQuestao;
    }

    public String getTipoQuestao() {
        return tipoQuestao;
    }

    public void setTipoQuestao(String tipoQuestao) {
        this.tipoQuestao = tipoQuestao;
    }

    public BigDecimal getValorPontuacao() {
        return valorPontuacao;
    }

    public void setValorPontuacao(BigDecimal valorPontuacao) {
        this.valorPontuacao = valorPontuacao;
    }

    public String getFeedbackCorreto() {
        return feedbackCorreto;
    }

    public void setFeedbackCorreto(String feedbackCorreto) {
        this.feedbackCorreto = feedbackCorreto;
    }

    public String getFeedbackIncorreto() {
        return feedbackIncorreto;
    }

    public void setFeedbackIncorreto(String feedbackIncorreto) {
        this.feedbackIncorreto = feedbackIncorreto;
    }

    public LocalDateTime getDataCriacao() {
        return dataCriacao;
    }

    public void setDataCriacao(LocalDateTime dataCriacao) {
        this.dataCriacao = dataCriacao;
    }

    public Long getIdUsuarioCriador() {
        return idUsuarioCriador;
    }

    public void setIdUsuarioCriador(Long idUsuarioCriador) {
        this.idUsuarioCriador = idUsuarioCriador;
    }
}
