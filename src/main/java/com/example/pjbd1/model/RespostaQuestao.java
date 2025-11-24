package com.example.pjbd1.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class RespostaQuestao {
    private Long idRespostaQuestao;
    private Long idUsuarioAvaliacao;
    private Long idAvaliacaoQuestao;
    private String textoResposta;
    private Long idOpcaoSelecionada;
    private BigDecimal notaObtida;
    private LocalDateTime dataResposta;

    public RespostaQuestao() {}

    public Long getIdRespostaQuestao() {
        return idRespostaQuestao;
    }

    public void setIdRespostaQuestao(Long idRespostaQuestao) {
        this.idRespostaQuestao = idRespostaQuestao;
    }

    public Long getIdUsuarioAvaliacao() {
        return idUsuarioAvaliacao;
    }

    public void setIdUsuarioAvaliacao(Long idUsuarioAvaliacao) {
        this.idUsuarioAvaliacao = idUsuarioAvaliacao;
    }

    public Long getIdAvaliacaoQuestao() {
        return idAvaliacaoQuestao;
    }

    public void setIdAvaliacaoQuestao(Long idAvaliacaoQuestao) {
        this.idAvaliacaoQuestao = idAvaliacaoQuestao;
    }

    public String getTextoResposta() {
        return textoResposta;
    }

    public void setTextoResposta(String textoResposta) {
        this.textoResposta = textoResposta;
    }

    public Long getIdOpcaoSelecionada() {
        return idOpcaoSelecionada;
    }

    public void setIdOpcaoSelecionada(Long idOpcaoSelecionada) {
        this.idOpcaoSelecionada = idOpcaoSelecionada;
    }

    public BigDecimal getNotaObtida() {
        return notaObtida;
    }

    public void setNotaObtida(BigDecimal notaObtida) {
        this.notaObtida = notaObtida;
    }

    public LocalDateTime getDataResposta() {
        return dataResposta;
    }

    public void setDataResposta(LocalDateTime dataResposta) {
        this.dataResposta = dataResposta;
    }
}
