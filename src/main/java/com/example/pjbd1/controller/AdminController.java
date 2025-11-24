package com.example.pjbd1.controller;

import com.example.pjbd1.model.Usuario;
import com.example.pjbd1.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UsuarioRepository usuarioRepo;

    // Página principal - LISTAR todos os usuários
    @GetMapping
    public String adminPage(Model model) {
        try {
            List<Usuario> usuarios = usuarioRepo.listarTodos();
            model.addAttribute("usuarios", usuarios);
            return "admin";
        } catch (Exception e) {
            model.addAttribute("erro", "Erro ao carregar usuários: " + e.getMessage());
            return "admin";
        }
    }

    // Formulário para EDITAR usuário
    @GetMapping("/editar/{id}")
    public String editarUsuario(@PathVariable Long id, Model model) {
        try {
            Usuario usuario = usuarioRepo.buscarPorId(id);
            if (usuario != null) {
                model.addAttribute("usuario", usuario);
                return "form-editar-usuario";
            }
            return "redirect:/admin?erro=Usuário não encontrado";
        } catch (Exception e) {
            return "redirect:/admin?erro=Erro ao carregar usuário";
        }
    }

    // PROCESSAR edição do usuário
    @PostMapping("/atualizar")
    public String atualizarUsuario(@ModelAttribute Usuario usuario) {
        try {
            // Se senha está vazia, mantém a senha atual
            if (usuario.getSenha() == null || usuario.getSenha().trim().isEmpty()) {
                Usuario usuarioExistente = usuarioRepo.buscarPorId(usuario.getIdUsuario());
                usuario.setSenha(usuarioExistente.getSenha());
            }

            usuarioRepo.atualizar(usuario);
            return "redirect:/admin?sucesso=Usuário atualizado com sucesso";
        } catch (Exception e) {
            return "redirect:/admin?erro=Erro ao atualizar usuário";
        }
    }

    // EXCLUIR usuário
    @GetMapping("/excluir/{id}")
    public String excluirUsuario(@PathVariable Long id) {
        try {
            usuarioRepo.deletar(id);
            return "redirect:/admin?sucesso=Usuário excluído com sucesso";
        } catch (Exception e) {
            return "redirect:/admin?erro=Erro ao excluir usuário";
        }
    }
}