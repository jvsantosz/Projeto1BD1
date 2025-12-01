# Descrição geral do sistema 

-Sistema de Avaliações Web para ambiente acadêmico/profissional

-Foco em relatórios criação de avaliações e questões e edicão

-Obs: feito sem JPA utilizando JDBC

## Funcionalidades principais:
-Cadastro de usuários (alunos, professores).

-Cadastro de questões de diferentes tipos (Múltipla Escolha, Dissertativa / Texto Livre, Numérica).

-Criação de avaliações (nome , descrição , duração ,questões e seus pesos,status).

-Associação de questões a avaliações com valor (peso/pontos) — mesma questão pode pertencer a várias avaliações.

-Registro das respostas (texto ou opção selecionada) e, quando aplicável, nota por questão.

-Relatórios: médias por avaliação, comparação entre alunos, ranking, perguntas com maior erro/mais mal respondidas, taxas de participação, etc.

-Painel do professor/aluno com varias informações 

-Pagina de administração utilizada para exclusão e edição de perfil acessado só por URL /admin
