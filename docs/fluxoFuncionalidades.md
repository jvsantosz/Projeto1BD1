# Fluxo de funcionalidades (uso básico)

-Admin cadastra usuários, cursos/disciplinas e questões (definir tipo e, se MCQ, opções).

-Professor cria avaliação, escolhe questões e atribui pesos. Define período (data/hora início e término), se é anônima e lista de alunos/turmas.

-Sistema gera atribuições (assignment) para cada usuário-alvo; cada atribuição tem um token único.

-Aluno acessa a avaliação no período, responde questões. Ao submeter:

-Se avaliação avaliativa: respostas são armazenadas e notas podem ser atribuídas automaticamente (se objetiva) ou manualmente pelo corretor (se discursiva).

-Se anônima: as respostas são armazenadas sem referência direta ao usuário; o sistema grava apenas que “uma atribuição daquele usuário foi concluída” — impede nova submissão.

-Professores/administradores consultam relatórios (tabelas + gráficos) com filtros por avaliação, disciplina, período.

-Relatórios podem exportar CSV/PDF e exibir gráficos interativos (média por questão, evolução por data, comparação entre alunos).
