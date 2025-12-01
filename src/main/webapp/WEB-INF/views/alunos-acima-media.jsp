<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.pjbd1.model.AlunoMedia" %>
<%
    List<AlunoMedia> alunos = (List<AlunoMedia>) request.getAttribute("alunos");
    if (alunos == null) {
        alunos = new java.util.ArrayList<>();
    }

    // Calcular média geral dos alunos acima (opcional)
    double mediaDosMelhores = 0;
    if (!alunos.isEmpty()) {
        double soma = 0;
        for (AlunoMedia aluno : alunos) {
            soma += aluno.getMediaAluno();
        }
        mediaDosMelhores = soma / alunos.size();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Alunos Acima da Média</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 3px solid #667eea;
        }
        h1 {
            color: #333;
            margin: 0;
            font-size: 28px;
        }
        h1 i {
            color: #667eea;
            margin-right: 10px;
        }
        .btn-voltar {
            padding: 10px 20px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .btn-voltar:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .stats {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            gap: 30px;
            border-left: 5px solid #667eea;
        }
        .stat-item {
            text-align: center;
        }
        .stat-number {
            font-size: 36px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th {
            background: #667eea;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
        }
        tr:hover {
            background: #f8f9ff;
            transform: scale(1.01);
            transition: all 0.2s;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
        }
        .media-cell {
            font-size: 18px;
            font-weight: bold;
            color: #28a745;
            position: relative;
        }
        .media-cell:after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 50px;
            height: 3px;
            background: #28a745;
            border-radius: 2px;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        .empty-state i {
            font-size: 60px;
            color: #667eea;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        .empty-state h3 {
            color: #333;
            margin-bottom: 10px;
        }
        .aluno-nome {
            font-weight: 500;
            color: #333;
        }
        .aluno-id {
            font-size: 12px;
            color: #999;
            margin-top: 3px;
        }
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            .stats {
                flex-direction: column;
                gap: 15px;
            }
            table {
                font-size: 14px;
            }
            th, td {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1><i>📈</i> Alunos Acima da Média Geral</h1>
        <a href="/professor/relatorios" class="btn-voltar">← Voltar</a>
    </div>

    <% if (alunos.isEmpty()) { %>
    <div class="empty-state">
        <div>📊</div>
        <h3>Nenhum aluno acima da média</h3>
        <p>Não há alunos com desempenho acima da média geral no momento.</p>
    </div>
    <% } else { %>
    <div class="stats">
        <div class="stat-item">
            <div class="stat-number"><%= alunos.size() %></div>
            <div class="stat-label">Alunos Acima da Média</div>
        </div>
        <div class="stat-item">
            <div class="stat-number"><%= String.format("%.2f", mediaDosMelhores) %></div>
            <div class="stat-label">Média dos Melhores</div>
        </div>
    </div>

    <table>
        <thead>
        <tr>
            <th>Aluno</th>
            <th>Média</th>
        </tr>
        </thead>
        <tbody>
        <% for (AlunoMedia aluno : alunos) { %>
        <tr>
            <td>
                <div class="aluno-nome"><%= aluno.getNome() %></div>
                <div class="aluno-id">ID: <%= aluno.getIdUsuario() %></div>
            </td>
            <td class="media-cell">
                <%= String.format("%.2f", aluno.getMediaAluno()) %>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</div>
</body>
</html>