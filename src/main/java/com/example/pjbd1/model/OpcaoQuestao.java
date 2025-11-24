package com.example.pjbd1.model;

public class OpcaoQuestao {
    private Long idOpcao;
    private Long idQuestao;
    private String textoOpcao;
    private Boolean ehCorreta;
    private Short ordem;

    public OpcaoQuestao() {}

    public Long getIdOpcao() {
        return idOpcao;
    }

    public void setIdOpcao(Long idOpcao) {
        this.idOpcao = idOpcao;
    }

    public Long getIdQuestao() {
        return idQuestao;
    }

    public void setIdQuestao(Long idQuestao) {
        this.idQuestao = idQuestao;
    }

    public String getTextoOpcao() {
        return textoOpcao;
    }

    public void setTextoOpcao(String textoOpcao) {
        this.textoOpcao = textoOpcao;
    }

    public Boolean getEhCorreta() {
        return ehCorreta;
    }

    public void setEhCorreta(Boolean ehCorreta) {
        this.ehCorreta = ehCorreta;
    }

    public Short getOrdem() {
        return ordem;
    }

    public void setOrdem(Short ordem) {
        this.ordem = ordem;
    }
}
