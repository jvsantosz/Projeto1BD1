package com.example.pjbd1.model;

import java.math.BigDecimal;

public class AlunoRankingAvaliacao {
    private Long idUsuario;
    private String nome;
    private BigDecimal nota;
    private Double percentual;
    // getters e setterspublic class AlunoRankingAvaliacao


    public Long getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Long idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public BigDecimal getNota() {
        return nota;
    }

    public void setNota(BigDecimal nota) {
        this.nota = nota;
    }

    public Double getPercentual() {
        return percentual;
    }

    public void setPercentual(Double percentual) {
        this.percentual = percentual;
    }
}
