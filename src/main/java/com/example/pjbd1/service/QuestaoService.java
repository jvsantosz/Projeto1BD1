package com.example.pjbd1.service;

import com.example.pjbd1.model.Questao;
import com.example.pjbd1.model.OpcaoQuestao;
import com.example.pjbd1.repository.QuestaoRepository;
import com.example.pjbd1.repository.OpcaoQuestaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class QuestaoService {

    @Autowired
    private QuestaoRepository questaoRepository;

    @Autowired
    private OpcaoQuestaoRepository opcaoQuestaoRepository;

    @Autowired
    private RelatorioService relatorioService;

    // 📝 Criar questão com opções
    public boolean criarQuestaoComOpcoes(Questao questao, List<OpcaoQuestao> opcoes) {
        try {
            questao.setDataCriacao(LocalDateTime.now());
            questaoRepository.salvar(questao);

            if (opcoes != null && !opcoes.isEmpty()) {
                for (int i = 0; i < opcoes.size(); i++) {
                    OpcaoQuestao opcao = opcoes.get(i);
                    opcao.setIdQuestao(questao.getIdQuestao());
                    opcao.setOrdem((short) (i + 1));
                    opcaoQuestaoRepository.salvar(opcao);
                }
            }
            return true;
        } catch (Exception e) {
            System.out.println("❌ Erro ao criar questão: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // 🔍 Validar questão
    public List<String> validarQuestao(Questao questao) {
        List<String> erros = new ArrayList<>();

        if (questao.getDescricaoQuestao() == null || questao.getDescricaoQuestao().trim().isEmpty()) {
            erros.add("Descrição da questão é obrigatória");
        }

        if (questao.getTipoQuestao() == null || questao.getTipoQuestao().trim().isEmpty()) {
            erros.add("Tipo da questão é obrigatório");
        } else if (!questao.getTipoQuestao().matches("MULTIPLA|TEXTO|NUMERICA")) {
            erros.add("Tipo de questão inválido. Use: MULTIPLA, TEXTO ou NUMERICA");
        }

        if (questao.getValorPontuacao() == null || questao.getValorPontuacao().compareTo(java.math.BigDecimal.ZERO) <= 0) {
            erros.add("Valor de pontuação deve ser maior que zero");
        }

        if (questao.getValorPontuacao() != null && questao.getValorPontuacao().compareTo(java.math.BigDecimal.valueOf(100)) > 0) {
            erros.add("Valor de pontuação não pode ser maior que 100");
        }

        return erros;
    }

    // 🔍 Validar opções de questão múltipla escolha
    public List<String> validarOpcoesQuestao(List<OpcaoQuestao> opcoes, String tipoQuestao) {
        List<String> erros = new ArrayList<>();

        if ("MULTIPLA".equals(tipoQuestao)) {
            if (opcoes == null || opcoes.isEmpty()) {
                erros.add("Questões de múltipla escolha devem ter opções");
                return erros;
            }

            if (opcoes.size() < 2) {
                erros.add("Questões de múltipla escolha devem ter pelo menos 2 opções");
            }

            // Verificar se há pelo menos uma opção correta
            boolean temCorreta = opcoes.stream().anyMatch(OpcaoQuestao::getEhCorreta);
            if (!temCorreta) {
                erros.add("Questão de múltipla escolha deve ter pelo menos uma opção correta");
            }

            // Verificar se há opções duplicadas
            long opcoesUnicas = opcoes.stream()
                    .map(OpcaoQuestao::getTextoOpcao)
                    .distinct()
                    .count();
            if (opcoesUnicas != opcoes.size()) {
                erros.add("Não podem existir opções com texto duplicado");
            }
        }

        return erros;
    }

    // 📊 Estatísticas de questões
    public EstatisticasQuestao getEstatisticasQuestoes(Long idUsuario) {
        EstatisticasQuestao stats = new EstatisticasQuestao();

        try {
            stats.setTotalQuestoes(questaoRepository.contarQuestoesPorUsuario(idUsuario));
            stats.setQuestoesNaoUtilizadas(questaoRepository.findQuestoesNaoUtilizadas().size());
            stats.setQuestoesSemCorretas(questaoRepository.findQuestoesSemOpcoesCorretas().size());
            stats.setQuestoesMultiplasCorretas(questaoRepository.findQuestoesComOpcoesCorretas().size());

            // Estatísticas por tipo
            stats.setQuestoesMultiplaEscolha(questaoRepository.findByTipo("MULTIPLA").size());
            stats.setQuestoesTexto(questaoRepository.findByTipo("TEXTO").size());
            stats.setQuestoesNumerica(questaoRepository.findByTipo("NUMERICA").size());

        } catch (Exception e) {
            System.out.println("❌ Erro ao calcular estatísticas: " + e.getMessage());
        }

        return stats;
    }

    // 🔧 Corrigir questões problemáticas
    public int corrigirQuestoesSemOpcoesCorretas() {
        try {
            List<Questao> problemas = questaoRepository.findQuestoesSemOpcoesCorretas();
            System.out.println("📋 Encontradas " + problemas.size() + " questões sem opções corretas");

            // Aqui você pode implementar lógica para:
            // 1. Notificar os professores
            // 2. Sugerir correções automáticas
            // 3. Marcar para revisão
            return problemas.size();
        } catch (Exception e) {
            System.out.println("❌ Erro ao corrigir questões: " + e.getMessage());
            return 0;
        }
    }

    // 🔄 Atualizar questão com validação
    public boolean atualizarQuestaoComValidacao(Questao questao) {
        try {
            List<String> erros = validarQuestao(questao);
            if (!erros.isEmpty()) {
                System.out.println("❌ Erros de validação: " + String.join(", ", erros));
                return false;
            }

            questaoRepository.atualizar(questao);
            System.out.println("✅ Questão atualizada: " + questao.getDescricaoQuestao());
            return true;
        } catch (Exception e) {
            System.out.println("❌ Erro ao atualizar questão: " + e.getMessage());
            return false;
        }
    }

    // 📈 Calcular média de pontuação das questões
    public java.math.BigDecimal calcularMediaPontuacaoQuestoes(Long idUsuario) {
        try {
            List<Questao> questões = questaoRepository.findByCriador(idUsuario);
            if (questões.isEmpty()) {
                return java.math.BigDecimal.ZERO;
            }

            java.math.BigDecimal soma = java.math.BigDecimal.ZERO;
            for (Questao q : questões) {
                if (q.getValorPontuacao() != null) {
                    soma = soma.add(q.getValorPontuacao());
                }
            }

            return soma.divide(java.math.BigDecimal.valueOf(questões.size()), 2, java.math.RoundingMode.HALF_UP);
        } catch (Exception e) {
            System.out.println("❌ Erro ao calcular média: " + e.getMessage());
            return java.math.BigDecimal.ZERO;
        }
    }

    // 🔍 Buscar questões por critérios avançados
    public List<Questao> buscarQuestoesAvancado(String termo, String tipo, Boolean utilizada, Long idUsuario) {
        try {
            List<Questao> resultados = new ArrayList<>();

            if (termo != null && !termo.trim().isEmpty()) {
                resultados = questaoRepository.buscarPorDescricao(termo);
            } else {
                resultados = questaoRepository.findByCriador(idUsuario);
            }

            // Filtrar por tipo se especificado
            if (tipo != null && !tipo.trim().isEmpty()) {
                resultados = resultados.stream()
                        .filter(q -> tipo.equals(q.getTipoQuestao()))
                        .toList();
            }

            // Filtrar por utilização se especificado
            if (utilizada != null) {
                List<Questao> naoUtilizadas = questaoRepository.findQuestoesNaoUtilizadas();
                if (utilizada) {
                    // Manter apenas as utilizadas (não estão na lista de não utilizadas)
                    resultados = resultados.stream()
                            .filter(q -> naoUtilizadas.stream()
                                    .noneMatch(nu -> nu.getIdQuestao().equals(q.getIdQuestao())))
                            .toList();
                } else {
                    // Manter apenas as não utilizadas
                    resultados = resultados.stream()
                            .filter(q -> naoUtilizadas.stream()
                                    .anyMatch(nu -> nu.getIdQuestao().equals(q.getIdQuestao())))
                            .toList();
                }
            }

            return resultados;
        } catch (Exception e) {
            System.out.println("❌ Erro na busca avançada: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    // Model auxiliar para estatísticas
    public static class EstatisticasQuestao {
        private int totalQuestoes;
        private int questoesNaoUtilizadas;
        private int questoesSemCorretas;
        private int questoesMultiplasCorretas;
        private int questõesMultiplaEscolha;
        private int questõesTexto;
        private int questõesNumerica;

        // getters e setters
        public int getTotalQuestoes() { return totalQuestoes; }
        public void setTotalQuestoes(int totalQuestoes) { this.totalQuestoes = totalQuestoes; }

        public int getQuestoesNaoUtilizadas() { return questoesNaoUtilizadas; }
        public void setQuestoesNaoUtilizadas(int questoesNaoUtilizadas) { this.questoesNaoUtilizadas = questoesNaoUtilizadas; }

        public int getQuestoesSemCorretas() { return questoesSemCorretas; }
        public void setQuestoesSemCorretas(int questoesSemCorretas) { this.questoesSemCorretas = questoesSemCorretas; }

        public int getQuestoesMultiplasCorretas() { return questoesMultiplasCorretas; }
        public void setQuestoesMultiplasCorretas(int questoesMultiplasCorretas) { this.questoesMultiplasCorretas = questoesMultiplasCorretas; }

        public int getQuestoesMultiplaEscolha() { return questõesMultiplaEscolha; }
        public void setQuestoesMultiplaEscolha(int questõesMultiplaEscolha) { this.questõesMultiplaEscolha = questõesMultiplaEscolha; }

        public int getQuestoesTexto() { return questõesTexto; }
        public void setQuestoesTexto(int questõesTexto) { this.questõesTexto = questõesTexto; }

        public int getQuestoesNumerica() { return questõesNumerica; }
        public void setQuestoesNumerica(int questõesNumerica) { this.questõesNumerica = questõesNumerica; }
    }
}