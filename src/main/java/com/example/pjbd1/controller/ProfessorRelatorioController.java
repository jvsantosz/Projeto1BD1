package com.example.pjbd1.controller;

import com.example.pjbd1.model.*;
import com.example.pjbd1.service.RelatorioService;
import com.example.pjbd1.service.AvaliacaoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.util.List;

@Controller
@RequestMapping("/professor/relatorios")
public class ProfessorRelatorioController {

    @Autowired
    private RelatorioService relatorioService;

    @Autowired
    private AvaliacaoService avaliacaoService;

    // 📊 Página Principal de Relatórios
    @GetMapping
    public String relatoriosProfessor(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Avaliacao> avaliacoes = avaliacaoService.getAvaliacoesPorProfessor(usuario.getIdUsuario());
        model.addAttribute("professor", usuario);
        model.addAttribute("avaliacoes", avaliacoes);
        return "professor-relatorios";
    }

    // 🏆 Top 5 Alunos Geral - CORRETO
    @GetMapping("/top5-geral")
    public String top5Geral(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<AlunoRanking> top5 = relatorioService.getTop5AlunosRanking();
        model.addAttribute("top5Alunos", top5);
        return "top5-geral";
    }

    // ❌ Questões sem Alternativas Corretas - CORRETO
    @GetMapping("/questoes-sem-corretas")
    public String questoesSemCorretas(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Questao> questoes = relatorioService.getQuestoesSemAlternativasCorretas();
        model.addAttribute("questoes", questoes);
        return "questoes-sem-corretas";
    }

    // 📝 Avaliações sem Questões - CORRETO
    @GetMapping("/avaliacoes-sem-questoes")
    public String avaliacoesSemQuestoes(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Avaliacao> avaliacoes = relatorioService.getAvaliacoesSemQuestoes();
        model.addAttribute("avaliacoes", avaliacoes);
        return "avaliacoes-sem-questoes";
    }

    // 📋 Alunos que Nunca Fizeram Avaliação - CORRETO
    @GetMapping("/alunos-nunca-fizeram")
    public String alunosNuncaFizeram(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Usuario> alunos = relatorioService.getAlunosNuncaFizeramAvaliacao();
        model.addAttribute("alunos", alunos);
        return "alunos-nunca-fizeram";
    }

    // 📊 Questões Nunca Utilizadas - CORRETO
    @GetMapping("/questoes-nunca-utilizadas")
    public String questoesNuncaUtilizadas(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Questao> questoes = relatorioService.getQuestoesNuncaUtilizadas();
        model.addAttribute("questoes", questoes);
        return "questoes-nunca-utilizadas";
    }

    // ⭐ Alunos com Nota Máxima - CORRETO
    @GetMapping("/alunos-nota-maxima")
    public String alunosNotaMaxima(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Usuario> alunos = relatorioService.getAlunosNotaMaximaTodasAvaliacoes();
        model.addAttribute("alunos", alunos);
        return "alunos-nota-maxima";
    }

    // 📈 Alunos Acima da Média Geral - CORRETO
    @GetMapping("/alunos-acima-media")
    public String alunosAcimaMedia(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<AlunoMedia> alunos = relatorioService.getAlunosAcimaMediaGeral();
        model.addAttribute("alunos", alunos);
        return "alunos-acima-media";
    }

    // ❓ Questões com Múltiplas Alternativas Corretas - CORRETO
    @GetMapping("/questoes-multiplas-corretas")
    public String questoesMultiplasCorretas(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Questao> questoes = relatorioService.getQuestoesMultiplasCorretas();
        model.addAttribute("questoes", questoes);
        return "questoes-multiplas-corretas";
    }

    // 📝 Questões Nunca Respondidas - CORRETO
    @GetMapping("/questoes-nunca-respondidas")
    public String questoesNuncaRespondidas(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Questao> questoes = relatorioService.getQuestoesNuncaRespondidas();
        model.addAttribute("questoes", questoes);
        return "questoes-nunca-respondidas";
    }

    // 0️⃣ Avaliações com Alunos que Zeraram - CORRETO
    @GetMapping("/avaliacoes-com-nota-zero")
    public String avaliacoesComNotaZero(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<AvaliacaoComNotaZero> avaliacoes = relatorioService.getAvaliacoesComNotaZero();
        model.addAttribute("avaliacoes", avaliacoes);
        return "avaliacoes-com-nota-zero";
    }

    // ⏰ Avaliações com Duração Acima da Média - CORRETO
    @GetMapping("/avaliacoes-duracao-acima-media")
    public String avaliacoesDuracaoAcimaMedia(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Avaliacao> avaliacoes = relatorioService.getAvaliacoesAcimaMediaDuracao();
        model.addAttribute("avaliacoes", avaliacoes);
        return "avaliacoes-duracao-acima-media";
    }

    // ✅ Alunos que Completaram Todas as Avaliações - CORRETO
    @GetMapping("/alunos-completaram-todas")
    public String alunosCompletaramTodas(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Usuario> alunos = relatorioService.getAlunosCompletaramTodasAvaliacoes();
        model.addAttribute("alunos", alunos);
        return "alunos-completaram-todas";
    }

    // 📊 Notas Percentuais por Aluno - CORRETO
    @GetMapping("/notas-percentuais")
    public String notasPercentuais(Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<NotaAlunoAvaliacao> notas = relatorioService.getNotasPercentuaisPorAvaliacao();
        model.addAttribute("notas", notas);
        return "notas-percentuais";
    }

    // 🏆 Top 5 por Avaliação Específica - CORRETO
    @GetMapping("/top5-avaliacao/{idAvaliacao}")
    public String top5PorAvaliacao(@PathVariable Long idAvaliacao, Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<AlunoRankingAvaliacao> top5 = relatorioService.getTop5AlunosPorAvaliacao(idAvaliacao);
        model.addAttribute("top5Alunos", top5);
        model.addAttribute("idAvaliacao", idAvaliacao);
        return "top5-avaliacao";
    }

    // 0️⃣ Alunos que Zeraram uma Avaliação - CORRETO
    @GetMapping("/zeraram-avaliacao/{idAvaliacao}")
    public String alunosZeraramAvaliacao(@PathVariable Long idAvaliacao, Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        List<Usuario> alunosZero = relatorioService.getAlunosZeraramAvaliacao(idAvaliacao);
        model.addAttribute("alunosZero", alunosZero);
        model.addAttribute("idAvaliacao", idAvaliacao);
        return "zeraram-avaliacao";
    }

    // 📈 Estatísticas Gerais da Avaliação - CORRETO
    @GetMapping("/estatisticas-avaliacao/{idAvaliacao}")
    public String estatisticasAvaliacao(@PathVariable Long idAvaliacao, Model model, HttpSession session) {
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        if (usuario == null || !"PROFESSOR".equals(usuario.getTipoUsuario())) {
            return "redirect:/?erro=Acesso não autorizado";
        }

        EstatisticasAvaliacao stats = relatorioService.getEstatisticasAvaliacao(idAvaliacao);
        model.addAttribute("estatisticas", stats);
        model.addAttribute("idAvaliacao", idAvaliacao);
        return "estatisticas-avaliacao";
    }
}