// 📊 Models auxiliares para os relatórios
package com.example.pjbd1.model;

public class NotaAlunoAvaliacao {
    private Long idUsuario;
    private String nomeAluno;
    private Long idAvaliacao;
    private String tituloAvaliacao;
    private Double notaPercentual;
    private String dataRealizacao;


    // getters e setters
    public Long getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Long idUsuario) { this.idUsuario = idUsuario; }
    public String getNomeAluno() { return nomeAluno; }
    public void setNomeAluno(String nomeAluno) { this.nomeAluno = nomeAluno; }
    public Long getIdAvaliacao() { return idAvaliacao; }
    public void setIdAvaliacao(Long idAvaliacao) { this.idAvaliacao = idAvaliacao; }
    public String getTituloAvaliacao() { return tituloAvaliacao; }
    public void setTituloAvaliacao(String tituloAvaliacao) { this.tituloAvaliacao = tituloAvaliacao; }
    public Double getNotaPercentual() { return notaPercentual; }
    public void setNotaPercentual(Double notaPercentual) { this.notaPercentual = notaPercentual; }

    public String getDataRealizacao() {
        return dataRealizacao;
    }

    public void setDataRealizacao(String dataRealizacao) {
        this.dataRealizacao = dataRealizacao;
    }
}

