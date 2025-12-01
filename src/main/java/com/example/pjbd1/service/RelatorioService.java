package com.example.pjbd1.service;

import com.example.pjbd1.model.*;
import com.example.pjbd1.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Service
public class RelatorioService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 📊 Nota Percentual por Aluno em Cada Avaliação - CORRIGIDO
    public List<NotaAlunoAvaliacao> getNotasPercentuaisPorAvaliacao() {
        String sql = """
            SELECT
                u.id_usuario,
                u.nome,
                av.id_avaliacao,
                av.titulo,
                CASE 
                    WHEN ua.nota_total_obtida IS NOT NULL AND ua.nota_total_obtida > 0 
                    THEN ROUND((ua.nota_total_obtida / 
                         (SELECT COALESCE(SUM(COALESCE(aq.pontuacao_especifica_na_avaliacao, q.valor_pontuacao)), 1)
                          FROM avaliacao_questao aq
                          JOIN questoes q ON q.id_questao = aq.id_questao
                          WHERE aq.id_avaliacao = av.id_avaliacao)
                         ) * 100, 2)
                    ELSE 0 
                END AS nota_percentual
            FROM usuarios u
            JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
            JOIN avaliacoes av ON av.id_avaliacao = ua.id_avaliacao
            WHERE u.tipo_usuario = 'ALUNO'
            ORDER BY u.nome, av.titulo
        """;

        return jdbcTemplate.query(sql, new RowMapper<NotaAlunoAvaliacao>() {
            @Override
            public NotaAlunoAvaliacao mapRow(ResultSet rs, int rowNum) throws SQLException {
                NotaAlunoAvaliacao nota = new NotaAlunoAvaliacao();
                nota.setIdUsuario(rs.getLong("id_usuario"));
                nota.setNomeAluno(rs.getString("nome"));
                nota.setIdAvaliacao(rs.getLong("id_avaliacao"));
                nota.setTituloAvaliacao(rs.getString("titulo"));
                nota.setNotaPercentual(rs.getDouble("nota_percentual"));
                return nota;
            }
        });
    }

    // ❌ Questões onde TODAS as alternativas são incorretas - CORRIGIDO
    public List<Questao> getQuestoesSemAlternativasCorretas() {
        String sql = """
            SELECT DISTINCT q.id_questao, q.descricao_questao
            FROM questoes q
            JOIN opcoes_questao oq ON oq.id_questao = q.id_questao
            WHERE q.id_questao NOT IN (
                SELECT DISTINCT id_questao 
                FROM opcoes_questao 
                WHERE eh_correta = true
            )
            AND q.tipo_questao = 'MULTIPLA'
        """;
        return jdbcTemplate.query(sql, new RowMapper<Questao>() {
            @Override
            public Questao mapRow(ResultSet rs, int rowNum) throws SQLException {
                Questao q = new Questao();
                q.setIdQuestao(rs.getLong("id_questao"));
                q.setDescricaoQuestao(rs.getString("descricao_questao"));
                return q;
            }
        });
    }

    public List<Usuario> getAlunosCompletaramTodasAvaliacoes() {
        // Primeiro, vamos ver quantas avaliações ativas existem
        String countAvaliacoes = "SELECT COUNT(*) as total FROM avaliacoes WHERE status = 'ATIVA'";
        Integer totalAvaliacoes = jdbcTemplate.queryForObject(countAvaliacoes, Integer.class);
        System.out.println("Total de avaliações ATIVAS no sistema: " + totalAvaliacoes);

        // Query principal
        String sql = """
        SELECT 
            u.id_usuario,
            u.nome,
            COUNT(DISTINCT ua.id_avaliacao) as avaliacoes_completadas
        FROM usuarios u
        LEFT JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario 
            AND ua.status_resposta = 'CONCLUIDA'
        WHERE u.tipo_usuario = 'ALUNO'
        GROUP BY u.id_usuario, u.nome
        HAVING COUNT(DISTINCT ua.id_avaliacao) = ?
    """;

        List<Usuario> alunos = jdbcTemplate.query(sql, new Object[]{totalAvaliacoes}, new RowMapper<Usuario>() {
            @Override
            public Usuario mapRow(ResultSet rs, int rowNum) throws SQLException {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getLong("id_usuario"));
                usuario.setNome(rs.getString("nome"));

                int completadas = rs.getInt("avaliacoes_completadas");
                System.out.println("DEBUG: " + usuario.getNome() + " completou " + completadas + "/" + totalAvaliacoes + " avaliações");

                return usuario;
            }
        });

        System.out.println("Total de alunos que completaram todas: " + alunos.size());
        return alunos;
    }
    // ⏰ Avaliações com tempo de duração ACIMA da média - CORRIGIDO
    public List<Avaliacao> getAvaliacoesAcimaMediaDuracao() {
        String sql = """
            SELECT id_avaliacao, titulo, duracao_minutos
            FROM avaliacoes
            WHERE duracao_minutos > (
                SELECT COALESCE(AVG(duracao_minutos), 0) 
                FROM avaliacoes 
                WHERE duracao_minutos IS NOT NULL
            )
        """;
        return jdbcTemplate.query(sql, new RowMapper<Avaliacao>() {
            @Override
            public Avaliacao mapRow(ResultSet rs, int rowNum) throws SQLException {
                Avaliacao a = new Avaliacao();
                a.setIdAvaliacao(rs.getLong("id_avaliacao"));
                a.setTitulo(rs.getString("titulo"));
                a.setDuracaoMinutos(rs.getInt("duracao_minutos"));
                return a;
            }
        });
    }

    // 🏆 Ranking dos 5 alunos com maior média geral - CORRIGIDO
    public List<AlunoRanking> getTop5AlunosRanking() {
        String sql = """
        SELECT
            u.id_usuario,
            u.nome,
            u.email,
            ROUND(AVG(COALESCE(ua.nota_total_obtida, 0)), 2) AS media_geral,
            COUNT(ua.id_usuario_avaliacao) AS total_avaliacoes
        FROM usuarios u
        LEFT JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
        WHERE u.tipo_usuario = 'ALUNO'
        GROUP BY u.id_usuario, u.nome, u.email
        HAVING COUNT(ua.id_usuario_avaliacao) > 0
        ORDER BY media_geral DESC
        LIMIT 5
    """;

        return jdbcTemplate.query(sql, new RowMapper<AlunoRanking>() {
            @Override
            public AlunoRanking mapRow(ResultSet rs, int rowNum) throws SQLException {
                AlunoRanking ranking = new AlunoRanking();
                ranking.setIdUsuario(rs.getLong("id_usuario"));
                ranking.setNome(rs.getString("nome"));
                ranking.setEmail(rs.getString("email"));
                ranking.setMediaGeral(rs.getDouble("media_geral"));
                ranking.setTotalAvaliacoes(rs.getInt("total_avaliacoes"));
                return ranking;
            }
        });
    }

    // 📋 Alunos que NUNCA fizeram avaliação - CORRIGIDO
    public List<Usuario> getAlunosNuncaFizeramAvaliacao() {
        String sql = """
            SELECT u.id_usuario, u.nome
            FROM usuarios u
            WHERE u.tipo_usuario = 'ALUNO'
            AND NOT EXISTS (
                SELECT 1
                FROM usuario_avaliacao ua
                WHERE ua.id_usuario = u.id_usuario
            )
        """;
        return jdbcTemplate.query(sql, new RowMapper<Usuario>() {
            @Override
            public Usuario mapRow(ResultSet rs, int rowNum) throws SQLException {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getLong("id_usuario"));
                u.setNome(rs.getString("nome"));
                return u;
            }
        });
    }

    // 📝 Avaliações sem nenhuma questão cadastrada - CORRIGIDO
    public List<Avaliacao> getAvaliacoesSemQuestoes() {
        String sql = """
            SELECT av.id_avaliacao, av.titulo
            FROM avaliacoes av
            WHERE NOT EXISTS (
                SELECT 1
                FROM avaliacao_questao aq
                WHERE aq.id_avaliacao = av.id_avaliacao
            )
        """;
        return jdbcTemplate.query(sql, new RowMapper<Avaliacao>() {
            @Override
            public Avaliacao mapRow(ResultSet rs, int rowNum) throws SQLException {
                Avaliacao a = new Avaliacao();
                a.setIdAvaliacao(rs.getLong("id_avaliacao"));
                a.setTitulo(rs.getString("titulo"));
                return a;
            }
        });
    }

    // 📊 Questões que NUNCA foram usadas em nenhuma avaliação - CORRIGIDO
    public List<Questao> getQuestoesNuncaUtilizadas() {
        String sql = """
            SELECT q.id_questao, q.descricao_questao
            FROM questoes q
            WHERE NOT EXISTS (
                SELECT 1
                FROM avaliacao_questao aq
                WHERE aq.id_questao = q.id_questao
            )
        """;
        return jdbcTemplate.query(sql, new RowMapper<Questao>() {
            @Override
            public Questao mapRow(ResultSet rs, int rowNum) throws SQLException {
                Questao q = new Questao();
                q.setIdQuestao(rs.getLong("id_questao"));
                q.setDescricaoQuestao(rs.getString("descricao_questao"));
                return q;
            }
        });
    }

    public List<Usuario> getAlunosNotaMaximaTodasAvaliacoes() {
        String sql = """
        SELECT u.id_usuario, u.nome
        FROM usuarios u
        WHERE u.tipo_usuario = 'ALUNO'
        AND NOT EXISTS (
            SELECT 1
            FROM usuario_avaliacao ua
            WHERE ua.id_usuario = u.id_usuario
            AND ua.status_resposta = 'CONCLUIDA'
            AND (
                ua.nota_total_obtida IS NULL
                OR ua.nota_total_obtida < (
                    SELECT COALESCE(SUM(COALESCE(aq.pontuacao_especifica_na_avaliacao, q.valor_pontuacao)), 0)
                    FROM avaliacao_questao aq
                    JOIN questoes q ON q.id_questao = aq.id_questao
                    WHERE aq.id_avaliacao = ua.id_avaliacao
                )
            )
        )
        AND EXISTS (
            SELECT 1 
            FROM usuario_avaliacao 
            WHERE id_usuario = u.id_usuario 
            AND status_resposta = 'CONCLUIDA'
        )
    """;
        return jdbcTemplate.query(sql, new RowMapper<Usuario>() {
            @Override
            public Usuario mapRow(ResultSet rs, int rowNum) throws SQLException {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getLong("id_usuario"));
                u.setNome(rs.getString("nome"));
                return u;
            }
        });
    }

    // 📈 Alunos acima da média geral - CORRIGIDO
    public List<AlunoMedia> getAlunosAcimaMediaGeral() {
        String sql = """
            SELECT
                u.id_usuario,
                u.nome,
                ROUND(AVG(COALESCE(ua.nota_total_obtida, 0)), 2) AS media_aluno
            FROM usuarios u
            JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
            WHERE u.tipo_usuario = 'ALUNO'
            GROUP BY u.id_usuario, u.nome
            HAVING AVG(COALESCE(ua.nota_total_obtida, 0)) > (
                SELECT COALESCE(AVG(COALESCE(nota_total_obtida, 0)), 0)
                FROM usuario_avaliacao
                WHERE nota_total_obtida IS NOT NULL
            )
        """;
        return jdbcTemplate.query(sql, new RowMapper<AlunoMedia>() {
            @Override
            public AlunoMedia mapRow(ResultSet rs, int rowNum) throws SQLException {
                AlunoMedia aluno = new AlunoMedia();
                aluno.setIdUsuario(rs.getLong("id_usuario"));
                aluno.setNome(rs.getString("nome"));
                aluno.setMediaAluno(rs.getDouble("media_aluno"));
                return aluno;
            }
        });
    }

    // ❓ Questões com MAIS de uma alternativa correta - CORRIGIDO
    public List<Questao> getQuestoesMultiplasCorretas() {
        String sql = """
            SELECT q.id_questao, q.descricao_questao
            FROM questoes q
            WHERE q.id_questao IN (
                SELECT id_questao
                FROM opcoes_questao
                WHERE eh_correta = true
                GROUP BY id_questao
                HAVING COUNT(*) > 1
            )
        """;
        return jdbcTemplate.query(sql, new RowMapper<Questao>() {
            @Override
            public Questao mapRow(ResultSet rs, int rowNum) throws SQLException {
                Questao q = new Questao();
                q.setIdQuestao(rs.getLong("id_questao"));
                q.setDescricaoQuestao(rs.getString("descricao_questao"));
                return q;
            }
        });
    }

    // 📝 Questões que NUNCA foram respondidas - CORRIGIDO
    public List<Questao> getQuestoesNuncaRespondidas() {
        String sql = """
            SELECT q.id_questao, q.descricao_questao
            FROM questoes q
            WHERE NOT EXISTS (
                SELECT 1
                FROM avaliacao_questao aq
                JOIN respostas_questao rq ON rq.id_avaliacao_questao = aq.id_avaliacao_questao
                WHERE aq.id_questao = q.id_questao
            )
            AND EXISTS (
                SELECT 1 FROM avaliacao_questao WHERE id_questao = q.id_questao
            )
        """;
        return jdbcTemplate.query(sql, new RowMapper<Questao>() {
            @Override
            public Questao mapRow(ResultSet rs, int rowNum) throws SQLException {
                Questao q = new Questao();
                q.setIdQuestao(rs.getLong("id_questao"));
                q.setDescricaoQuestao(rs.getString("descricao_questao"));
                return q;
            }
        });
    }

    // 0️⃣ Avaliações com pelo menos UM aluno com nota 0 - CORRIGIDO
    public List<AvaliacaoComNotaZero> getAvaliacoesComNotaZero() {
        String sql = """
            SELECT DISTINCT av.id_avaliacao, av.titulo
            FROM avaliacoes av
            JOIN usuario_avaliacao ua ON ua.id_avaliacao = av.id_avaliacao
            WHERE COALESCE(ua.nota_total_obtida, 0) = 0
        """;
        return jdbcTemplate.query(sql, new RowMapper<AvaliacaoComNotaZero>() {
            @Override
            public AvaliacaoComNotaZero mapRow(ResultSet rs, int rowNum) throws SQLException {
                AvaliacaoComNotaZero avaliacao = new AvaliacaoComNotaZero();
                avaliacao.setIdAvaliacao(rs.getLong("id_avaliacao"));
                avaliacao.setTitulo(rs.getString("titulo"));
                return avaliacao;
            }
        });
    }

    // 🏆 Top 5 Alunos por Avaliação Específica
    public List<AlunoRankingAvaliacao> getTop5AlunosPorAvaliacao(Long idAvaliacao) {
        String sql = """
        SELECT
            u.id_usuario,
            u.nome,
            ua.nota_total_obtida as nota,
            ROUND((ua.nota_total_obtida / 
                 (SELECT COALESCE(SUM(COALESCE(aq.pontuacao_especifica_na_avaliacao, q.valor_pontuacao)), 1)
                  FROM avaliacao_questao aq
                  JOIN questoes q ON q.id_questao = aq.id_questao
                  WHERE aq.id_avaliacao = ?)
                 ) * 100, 2) AS percentual
        FROM usuarios u
        JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
        WHERE ua.id_avaliacao = ?
        AND ua.status_resposta = 'CONCLUIDA'
        ORDER BY ua.nota_total_obtida DESC
        LIMIT 5
    """;

        return jdbcTemplate.query(sql, new RowMapper<AlunoRankingAvaliacao>() {
            @Override
            public AlunoRankingAvaliacao mapRow(ResultSet rs, int rowNum) throws SQLException {
                AlunoRankingAvaliacao aluno = new AlunoRankingAvaliacao();
                aluno.setIdUsuario(rs.getLong("id_usuario"));
                aluno.setNome(rs.getString("nome"));
                aluno.setNota(rs.getBigDecimal("nota"));
                aluno.setPercentual(rs.getDouble("percentual"));
                return aluno;
            }
        }, idAvaliacao, idAvaliacao);
    }

    // 0️⃣ Alunos que Zeraram uma Avaliação
    public List<Usuario> getAlunosZeraramAvaliacao(Long idAvaliacao) {
        String sql = """
        SELECT u.id_usuario, u.nome
        FROM usuarios u
        JOIN usuario_avaliacao ua ON ua.id_usuario = u.id_usuario
        WHERE ua.id_avaliacao = ?
        AND COALESCE(ua.nota_total_obtida, 0) = 0
        AND ua.status_resposta = 'CONCLUIDA'
    """;

        return jdbcTemplate.query(sql, new RowMapper<Usuario>() {
            @Override
            public Usuario mapRow(ResultSet rs, int rowNum) throws SQLException {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getLong("id_usuario"));
                u.setNome(rs.getString("nome"));
                return u;
            }
        }, idAvaliacao);
    }

    // 📈 Estatísticas Gerais da Avaliação - CORRIGIDO
    public EstatisticasAvaliacao getEstatisticasAvaliacao(Long idAvaliacao) {
        String sql = """
        SELECT
            av.titulo,
            COUNT(DISTINCT ua.id_usuario) as total_alunos,
            COUNT(CASE WHEN ua.status_resposta = 'CONCLUIDA' THEN 1 END) as alunos_concluiram,
            COALESCE(AVG(CASE WHEN ua.status_resposta = 'CONCLUIDA' THEN ua.nota_total_obtida END), 0) as media_geral,
            COALESCE(MAX(CASE WHEN ua.status_resposta = 'CONCLUIDA' THEN ua.nota_total_obtida END), 0) as maior_nota,
            COALESCE(MIN(CASE WHEN ua.status_resposta = 'CONCLUIDA' AND ua.nota_total_obtida > 0 THEN ua.nota_total_obtida END), 0) as menor_nota,
            COUNT(CASE WHEN ua.status_resposta = 'CONCLUIDA' AND COALESCE(ua.nota_total_obtida, 0) = 0 THEN 1 END) as total_zeros,
            (SELECT COUNT(*) FROM avaliacao_questao WHERE id_avaliacao = ?) as total_questoes
        FROM avaliacoes av
        LEFT JOIN usuario_avaliacao ua ON ua.id_avaliacao = av.id_avaliacao
        WHERE av.id_avaliacao = ?
        GROUP BY av.id_avaliacao, av.titulo
    """;

        try {
            return jdbcTemplate.queryForObject(sql, new RowMapper<EstatisticasAvaliacao>() {
                @Override
                public EstatisticasAvaliacao mapRow(ResultSet rs, int rowNum) throws SQLException {
                    EstatisticasAvaliacao stats = new EstatisticasAvaliacao();
                    stats.setTituloAvaliacao(rs.getString("titulo"));
                    stats.setTotalAlunos(rs.getInt("total_alunos"));
                    stats.setAlunosConcluiram(rs.getInt("alunos_concluiram"));
                    stats.setMediaGeral(rs.getDouble("media_geral"));
                    stats.setMaiorNota(rs.getBigDecimal("maior_nota"));
                    stats.setMenorNota(rs.getBigDecimal("menor_nota"));
                    stats.setTotalZeros(rs.getInt("total_zeros"));
                    stats.setTotalQuestoes(rs.getInt("total_questoes"));

                    // Calcular taxa de conclusão
                    if (rs.getInt("total_alunos") > 0) {
                        double taxaConclusao = (rs.getDouble("alunos_concluiram") / rs.getDouble("total_alunos")) * 100;
                        stats.setTaxaConclusao(taxaConclusao);
                    } else {
                        stats.setTaxaConclusao(0.0);
                    }

                    return stats;
                }
            }, idAvaliacao, idAvaliacao);
        } catch (Exception e) {
            // Retorna estatísticas vazias em caso de erro
            EstatisticasAvaliacao stats = new EstatisticasAvaliacao();
            stats.setTituloAvaliacao("Avaliação não encontrada");
            return stats;
        }
    }


}