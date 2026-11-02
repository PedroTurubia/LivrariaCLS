-- Consulta 1 - Relatório de volume de vendas por produto (Livros e Diversos)
SELECT 
    p.nome_comercial,
    'Livro / Exemplar' AS categoria,
    COUNT(le.id_exemplar) AS total_vendido,
    SUM(le.preco_unitario) AS faturamento_total
FROM Produto p
JOIN Edicao e ON p.id_produto = e.id_produto
JOIN Exemplar ex ON e.id_produto = ex.id_edicao
JOIN Lista_Exemplares le ON ex.id_exemplar = le.id_exemplar
GROUP BY p.id_produto, p.nome_comercial

UNION ALL

SELECT 
    p.nome_comercial,
    'Produto Diverso' AS categoria,
    SUM(cd.quantidade) AS total_vendido,
    SUM(cd.quantidade * cd.preco_unitario) AS faturamento_total
FROM Produto p
JOIN Compra_Diversos cd ON p.id_produto = cd.id_produto
GROUP BY p.id_produto, p.nome_comercial
ORDER BY faturamento_total DESC;

-- Consulta 2 - Ranking de clientes por faturamento gerado
SELECT 
    pf.primeiro_nome,
    pf.sobrenome,
    pf.cpf,
    COUNT(cc.id_compra) AS quantidade_compras,
    SUM(cc.valor_total) AS valor_total_gasto
FROM Cliente c
JOIN Pessoa_Fisica pf ON c.id_pessoa = pf.id_pessoa
JOIN Compra_Cliente cc ON c.id_cliente = cc.id_cliente
WHERE cc.status_venda = 'CONCLUIDA'
GROUP BY c.id_cliente, pf.primeiro_nome, pf.sobrenome, pf.cpf
ORDER BY valor_total_gasto DESC;

-- Consulta 3 - Consolidado de faturamento por tipo de receita (Vendas vs Locações)
SELECT 
    td.descricao AS tipo_receita,
    COUNT(c.id_conta) AS quantidade_transacoes,
    SUM(c.valor) AS valor_total_arrecadado
FROM Conta c
JOIN Tipo_Despesa td ON c.id_tipo = td.id_tipo
WHERE c.status = 'PAGA'
GROUP BY td.id_tipo, td.descricao;

-- agora vem as consultas de auditoria, para elas funcionarem, é necessario que coloque essas duas pequenas massas de dados com erros propositais

-- Erro 1 - Criar conta pendente para o teste de auditoria
INSERT INTO Conta (id_conta, status, valor, data_vencimento, data_pagamento, id_tipo) 
VALUES (6, 'PENDENTE', 14.50, '2026-10-20', NULL, 2);

-- Erro 2 - Criar locação ativa e já atrasada (era para o dia 20 de outubro)
INSERT INTO Locacao (id_locacao, data_retirada, data_devolucao_prevista, data_devolucao_real, status, status_multa, valor_aluguel, valor_multa_atraso, valor_multa_avaria, condicao_livro, id_cliente, id_funcionario, id_exemplar, id_conta) 
VALUES (3, '2026-10-05', '2026-10-20', NULL, 'ATIVO', 'PENDENTE', 14.50, 0.00, 0.00, 'NOVO', 2, 1, 2, 6);

-- Erro 3 - Simulando uma falha de integridade: conta gerada sem transação vinculada
INSERT INTO Conta (status, valor, data_vencimento, data_pagamento, id_tipo) 
VALUES ('PENDENTE', 120.00, '2026-12-05', NULL, 1);

-- Consulta 1 Auditoria de locações atrasadas e com pendência financeira
SELECT 
    l.id_locacao,
    pf.primeiro_nome,
    pf.sobrenome,
    t.ddd, t.numero AS telefone,
    l.data_devolucao_prevista,
    DATEDIFF(CURRENT_DATE, l.data_devolucao_prevista) AS dias_atraso,
    l.status_multa
FROM Locacao l
JOIN Cliente c ON l.id_cliente = c.id_cliente
JOIN Pessoa_Fisica pf ON c.id_pessoa = pf.id_pessoa
LEFT JOIN Telefone t ON pf.id_pessoa = t.id_pessoa
WHERE l.status = 'ATIVO' 
  AND l.data_devolucao_prevista < CURRENT_DATE;

-- Consulta 2 - Auditoria de integridade da tabela Conta
SELECT 
    c.id_conta,
    c.status,
    c.valor,
    c.data_vencimento
FROM Conta c
LEFT JOIN Compra_Cliente cc ON c.id_conta = cc.id_conta
LEFT JOIN Pedido p ON c.id_conta = p.id_conta
LEFT JOIN Locacao l ON c.id_conta = l.id_conta
WHERE cc.id_compra IS NULL 
  AND p.id_pedido IS NULL 

  AND l.id_locacao IS NULL;

