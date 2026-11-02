-- momento de efetuar os cadastros
INSERT INTO Tipo_Despesa (descricao) VALUES
('Comercialização de Livros e Artigos Variados'),
('Empréstimo de Obras'),
('Remuneração de Colaboradores'),
('Aquisição de Acervo e Estoque');


INSERT INTO Cargo (nome_cargo, nivel_acesso, salario_base) VALUES
('Gerente de Operações', 'GERENTE', 4500.00),
('Atendente de Loja', 'FUNCIONARIO', 2100.00);


INSERT INTO Autor (nome, biografia) VALUES
('Gege Akutami', 'Autor responsável pelo mangá de grande alcance Jujutsu Kaisen.'),
('Hiromu Arakawa', 'Quadrinista japonesa responsável por títulos renomados como Fullmetal Alchemist e Yomi no Tsugai.'),
('Ai Yazawa', 'Ilustradora e autora reconhecida por obras focadas em moda e drama, incluindo Paradise Kiss e Nana.');


INSERT INTO Editora (nome_editora, pais_origem) VALUES
('Panini Comics', 'Itália'),
('JBC', 'Brasil');


INSERT INTO Genero (descricao) VALUES
('Shounen'), ('Shoujo'), ('Fantasia Sombria'), ('Ação');


-- inclusão de dados de pessoas (Generalização e Especialização)
-- inclusão de 6 Pessoas na superclasse: 2 Funcionários, 3 Clientes e 1 Fornecedor.
INSERT INTO Pessoa (id_pessoa) VALUES (1), (2), (3), (4), (5), (6);


-- Funcionário 1 (Gerente de Operações)
INSERT INTO Pessoa_Fisica (cpf, primeiro_nome, sobrenome, data_nascimento, id_pessoa)
VALUES ('11122233344', 'Carlos', 'Silva', '1990-05-20', 1);
INSERT INTO Funcionario (login, senha, id_pessoa) VALUES ('carlos.silva', 'senha123', 1);
INSERT INTO Cargo_Funcionario (id_cargo, id_funcionario, data_inicio) VALUES (1, 1, '2025-01-10');


-- Funcionário 2 (Atendente de Loja)
INSERT INTO Pessoa_Fisica (cpf, primeiro_nome, sobrenome, data_nascimento, id_pessoa)
VALUES ('22233344455', 'Mariana', 'Costa', '2001-03-12', 2);
INSERT INTO Funcionario (login, senha, id_pessoa) VALUES ('mariana.c', 'senha456', 2);
INSERT INTO Cargo_Funcionario (id_cargo, id_funcionario, data_inicio) VALUES (2, 2, '2026-02-01');


-- Registros dos Clientes 1, 2 e 3
INSERT INTO Pessoa_Fisica (cpf, primeiro_nome, sobrenome, data_nascimento, id_pessoa) VALUES
('33344455566', 'Lucas', 'Fernandes', '1998-08-15', 3),
('44455566677', 'Beatriz', 'Almeida', '2004-11-30', 4),
('55566677788', 'Rafael', 'Souza', '1995-07-07', 5);
INSERT INTO Cliente (id_pessoa) VALUES (3), (4), (5);


-- Fornecedor 1 (Entidade Pessoa Jurídica)
INSERT INTO Pessoa_Juridica (cnpj, inscricao_estadual, razao_social, id_pessoa)
VALUES ('12345678000199', '123.456.789.000', 'Distribuidora Geek S.A.', 6);
INSERT INTO Fornecedor (id_pessoa) VALUES (6);


-- acervo e produtos disponíveis
INSERT INTO Produto (id_produto, nome_comercial, margem_lucro, descricao, codigo_barras) VALUES
(1, 'Jujutsu Kaisen - Vol 1', 35.00, 'Volume inicial impresso', '9781974710027'),
(2, 'Yomi no Tsugai - Vol 1', 40.00, 'Volume inicial impresso', '9780007136591'),
(3, 'NANA - Vol 21', 45.00, 'Edição especial de colecionador', '9788535914842'),
(4, 'Copo de Vidro Morango', 50.00, 'Copo estilizado em vidro com estampa temática', '7891234567890'),
(5, 'Caneca de Porcelana Divisão', 60.00, 'Caneca em porcelana na cor preta', '7890987654321');




INSERT INTO Livro (id_livro, titulo, serie) VALUES
(1, 'Jujutsu Kaisen', 'Série Regular'),
(2, 'Yomi no Tsugai', 'Série Regular'),
(3, 'NANA', 'Série Clássica');


INSERT INTO Livro_Autor (id_autor, id_livro, ordem_autoria, tipo_contribuicao) VALUES
(1, 1, 1, 'Escritor e Ilustrador'),
(2, 2, 1, 'Escritora e Ilustradora'),
(3, 3, 1, 'Escritora e Ilustradora');


INSERT INTO Livro_Genero (id_livro, id_genero) VALUES (1, 1), (1, 4), (2, 3), (3, 2);


INSERT INTO Edicao (id_produto, isbn, ano_edicao, numero_edicao, id_livro, id_editora) VALUES
(1, '9781974710027', 2021, '1ª Edição', 1, 1),
(2, '9780007136591', 2024, '1ª Edição', 2, 1),
(3, '9788535914842', 2008, 'Edição Definitiva', 3, 2);


-- detalhamento da entidade Produtos Diversos
INSERT INTO Produtos_Diversos (id_produto, tipo_produto, valor_venda, marca) VALUES
(4, 'Utensílio', 25.90, 'Artesanal'),
(5, 'Utensílio', 35.00, 'GeekStore');


-- controle dos exemplares em estoque
INSERT INTO Exemplar (id_exemplar, data_aquisicao, estado_conservacao, status_disponibilidade, tipo_estoque, valor_venda, id_edicao) VALUES
(1, '2026-10-01', 'NOVO', 'DISPONÍVEL', 'VENDA', 39.90, 1),
(2, '2026-10-01', 'REGULAR', 'DISPONÍVEL', 'ALUGUEL', NULL, 1),
(3, '2026-10-15', 'NOVO', 'VENDIDO', 'VENDA', 42.90, 2),
(4, '2026-10-15', 'REPARÁVEL', 'ALUGADO', 'ALUGUEL', NULL, 3);






-- Cenário 1: Venda Concluída de Livro e Produto Diverso no Balcão
INSERT INTO Conta (id_conta, status, valor, data_vencimento, data_pagamento, id_tipo) VALUES
(1, 'PAGA', 68.80, '2026-11-02', '2026-11-02', 1);


INSERT INTO Compra_Cliente (id_compra, data_hora, valor_total, status_venda, id_cliente, id_funcionario, id_conta) VALUES
(1, '2026-11-02 14:30:00', 68.80, 'CONCLUIDA', 1, 2, 1);


INSERT INTO Lista_Exemplares (id_exemplar, id_compra, preco_unitario) VALUES (3, 1, 42.90);
INSERT INTO Compra_Diversos (id_compra, id_produto, quantidade, preco_unitario) VALUES (1, 4, 1, 25.90);
INSERT INTO Pagamento (forma_pagamento, valor_pago, status_pagamento, id_conta) VALUES ('PIX', 68.80, 'CONCLUÍDO', 1);


-- Cenário 2: Venda Cancelada por Desistência no Balcão
INSERT INTO Conta (id_conta, status, valor, data_vencimento, data_pagamento, id_tipo) VALUES
(2, 'CANCELADA', 35.00, '2026-11-02', NULL, 1);


INSERT INTO Compra_Cliente (id_compra, data_hora, valor_total, status_venda, id_cliente, id_funcionario, id_conta) VALUES
(2, '2026-11-02 15:00:00', 35.00, 'CANCELADA', 2, 2, 2);


-- Cenário 3: Registro de Empréstimo Ativo em Andamento
INSERT INTO Conta (id_conta, status, valor, data_vencimento, data_pagamento, id_tipo) VALUES
(3, 'PENDENTE', 12.50, '2026-11-15', NULL, 2);


INSERT INTO Locacao (id_locacao, data_retirada, data_devolucao_prevista, data_devolucao_real, status, status_multa, valor_aluguel, valor_multa_atraso, valor_multa_avaria, condicao_livro, id_cliente, id_funcionario, id_exemplar, id_conta) VALUES
(1, '2026-11-01', '2026-11-15', NULL, 'ATIVO', 'SEM MULTA', 12.50, 0.00, 0.00, 'REPARÁVEL', 3, 2, 4, 3);


-- Cenário 4: Processamento de Devolução com Aplicação de Multa por Atraso
INSERT INTO Conta (id_conta, status, valor, data_vencimento, data_pagamento, id_tipo) VALUES
(4, 'PAGA', 18.00, '2026-10-30', '2026-11-02', 2);


INSERT INTO Locacao (id_locacao, data_retirada, data_devolucao_prevista, data_devolucao_real, status, status_multa, valor_aluguel, valor_multa_atraso, valor_multa_avaria, condicao_livro, id_cliente, id_funcionario, id_exemplar, id_conta) VALUES
(2, '2026-10-15', '2026-10-30', '2026-11-02', 'DEVOLVIDO', 'PAGA', 15.00, 3.00, 0.00, 'REGULAR', 2, 1, 2, 4);
INSERT INTO Pagamento (forma_pagamento, valor_pago, status_pagamento, id_conta) VALUES ('CARTÃO DE CRÉDITO', 18.00, 'CONCLUÍDO', 4);


-- Cenário 5: Pedido Logístico de Reposição Junto ao Fornecedor
INSERT INTO Conta (id_conta, status, valor, data_vencimento, data_pagamento, id_tipo) VALUES
(5, 'PENDENTE', 350.00, '2026-12-01', NULL, 4);


INSERT INTO Pedido (id_pedido, data_pedido, valor_total, status_pedido, id_conta, id_fornecedor) VALUES
(1, '2026-11-02', 350.00, 'ENVIADO', 5, 1);


INSERT INTO Produto_Pedido (id_produto, id_pedido, preco_unitario, quantidade) VALUES
(1, 1, 15.00, 10), (5, 1, 20.00, 10);
