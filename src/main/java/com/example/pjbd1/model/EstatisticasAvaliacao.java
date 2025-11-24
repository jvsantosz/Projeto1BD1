package com.example.pjbd1.model;

import java.math.BigDecimal;

// 📈 Para estatísticas
public class EstatisticasAvaliacao {
    private String tituloAvaliacao;
    private Integer totalAlunos;
    private Integer alunosConcluiram;
    private Double mediaGeral;
    private BigDecimal maiorNota;
    private BigDecimal menorNota;
    private Integer totalZeros;
    private Integer totalQuestoes;
    private Double taxaConclusao;

    public String getTituloAvaliacao() {
        return tituloAvaliacao;
    }

    public void setTituloAvaliacao(String tituloAvaliacao) {
        this.tituloAvaliacao = tituloAvaliacao;
    }

    public Integer getTotalAlunos() {
        return totalAlunos;
    }

    public void setTotalAlunos(Integer totalAlunos) {
        this.totalAlunos = totalAlunos;
    }

    public Integer getAlunosConcluiram() {
        return alunosConcluiram;
    }

    public void setAlunosConcluiram(Integer alunosConcluiram) {
        this.alunosConcluiram = alunosConcluiram;
    }

    public Double getMediaGeral() {
        return mediaGeral;
    }

    public void setMediaGeral(Double mediaGeral) {
        this.mediaGeral = mediaGeral;
    }

    public BigDecimal getMaiorNota() {
        return maiorNota;
    }

    public void setMaiorNota(BigDecimal maiorNota) {
        this.maiorNota = maiorNota;
    }

    public BigDecimal getMenorNota() {
        return menorNota;
    }

    public void setMenorNota(BigDecimal menorNota) {
        this.menorNota = menorNota;
    }

    public Integer getTotalZeros() {
        return totalZeros;
    }

    public void setTotalZeros(Integer totalZeros) {
        this.totalZeros = totalZeros;
    }

    public Integer getTotalQuestoes() {
        return totalQuestoes;
    }

    public void setTotalQuestoes(Integer totalQuestoes) {
        this.totalQuestoes = totalQuestoes;
    }

    public Double getTaxaConclusao() {
        return taxaConclusao;
    }

    public void setTaxaConclusao(Double taxaConclusao) {
        this.taxaConclusao = taxaConclusao;
    }
}