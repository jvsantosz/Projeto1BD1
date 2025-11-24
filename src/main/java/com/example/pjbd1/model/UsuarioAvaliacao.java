package com.example.pjbd1.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class UsuarioAvaliacao {
    private Long idUsuarioAvaliacao;
    private Long idUsuario;
    private Long idAvaliacao;
    private LocalDateTime dataInicioReal;
    private LocalDateTime dataFimReal;
    private String statusResposta; // ATRIBUIDA, EM_ANDAMENTO, ENVIADA
    private BigDecimal notaTotalObtida;

    public UsuarioAvaliacao() {}

    public Long getIdUsuarioAvaliacao() {
        return idUsuarioAvaliacao;
    }

    public void setIdUsuarioAvaliacao(Long idUsuarioAvaliacao) {
        this.idUsuarioAvaliacao = idUsuarioAvaliacao;
    }

    public Long getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Long idUsuario) {
        this.idUsuario = idUsuario;
    }

    public Long getIdAvaliacao() {
        return idAvaliacao;
    }

    public void setIdAvaliacao(Long idAvaliacao) {
        this.idAvaliacao = idAvaliacao;
    }

    public LocalDateTime getDataInicioReal() {
        return dataInicioReal;
    }

    public void setDataInicioReal(LocalDateTime dataInicioReal) {
        this.dataInicioReal = dataInicioReal;
    }

    public LocalDateTime getDataFimReal() {
        return dataFimReal;
    }

    public void setDataFimReal(LocalDateTime dataFimReal) {
        this.dataFimReal = dataFimReal;
    }

    public String getStatusResposta() {
        return statusResposta;
    }

    public void setStatusResposta(String statusResposta) {
        this.statusResposta = statusResposta;
    }

    public BigDecimal getNotaTotalObtida() {
        return notaTotalObtida;
    }

    public void setNotaTotalObtida(BigDecimal notaTotalObtida) {
        this.notaTotalObtida = notaTotalObtida;
    }
}
