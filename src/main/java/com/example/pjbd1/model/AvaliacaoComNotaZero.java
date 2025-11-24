package com.example.pjbd1.model;

public class AvaliacaoComNotaZero {
    private Long idAvaliacao;
    private String titulo;
    private Integer totalAlunosZero;

    // getters e setters
    public Long getIdAvaliacao() { return idAvaliacao; }
    public void setIdAvaliacao(Long idAvaliacao) { this.idAvaliacao = idAvaliacao; }
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    public Integer getTotalAlunosZero() { return totalAlunosZero; }
    public void setTotalAlunosZero(Integer totalAlunosZero) { this.totalAlunosZero = totalAlunosZero; }
}