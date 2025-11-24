package com.example.pjbd1.model;

public class AlunoMedia {
    private Long idUsuario;
    private String nome;
    private Double mediaAluno;

    // getters e setters
    public Long getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Long idUsuario) { this.idUsuario = idUsuario; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public Double getMediaAluno() { return mediaAluno; }
    public void setMediaAluno(Double mediaAluno) { this.mediaAluno = mediaAluno; }
}