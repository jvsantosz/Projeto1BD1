package com.example.pjbd1.controller;

import com.example.pjbd1.model.Usuario;
import com.example.pjbd1.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @PostMapping("/login")
    public String login(@RequestParam String usuario,
                        @RequestParam String senha,
                        HttpSession session) {

        System.out.println("=== TENTATIVA DE LOGIN ===");
        System.out.println("Email: " + usuario);
        System.out.println("Senha: " + senha);

        try {
            // Busca usuário no banco usando seu repositório JDBC
            Usuario user = usuarioRepository.buscarPorEmailESenha(usuario, senha);

            if (user != null && user.getAtivo()) {
                System.out.println("✅ LOGIN BEM-SUCEDIDO: " + user.getNome());
                System.out.println("Tipo de usuário: " + user.getTipoUsuario());
                session.setAttribute("usuarioLogado", user);

                // Redireciona para o menu correto
                if ("ALUNO".equals(user.getTipoUsuario())) {
                    return "redirect:/menu-aluno";
                } else if ("PROFESSOR".equals(user.getTipoUsuario())) {
                    return "redirect:/menu-professor";
                } else if ("ADMIN".equals(user.getTipoUsuario())) {
                    return "redirect:/usuarios"; // ou para admin dashboard
                } else {
                    return "redirect:/?erro=Tipo de usuário desconhecido";
                }
            } else {
                System.out.println("❌ LOGIN FALHOU - Usuário não encontrado ou inativo");
                return "redirect:/?erro=Email ou senha inválidos";
            }
        } catch (Exception e) {
            System.out.println("❌ ERRO NO LOGIN: " + e.getMessage());
            return "redirect:/?erro=Erro interno no sistema";
        }
    }


}