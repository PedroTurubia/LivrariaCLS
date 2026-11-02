CREATE TABLE Tipo_Despesa (
    id_tipo INT(11) AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(256) NOT NULL
);

CREATE TABLE Cargo (
    id_cargo INT(11) AUTO_INCREMENT PRIMARY KEY,
    nome_cargo VARCHAR(128) NOT NULL UNIQUE,
    nivel_acesso VARCHAR(13) NOT NULL CHECK (nivel_acesso IN ('ADMINISTRADOR', 'GERENTE', 'FUNCIONARIO')),
    salario_base DECIMAL(10,2) NOT NULL
);

CREATE TABLE Autor (
    id_autor INT(11) AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(64) NOT NULL,
    biografia VARCHAR(256)
);

CREATE TABLE Editora (
    id_editora INT(11) AUTO_INCREMENT PRIMARY KEY,
    nome_editora VARCHAR(128) NOT NULL UNIQUE,
    pais_origem VARCHAR(64)
);

CREATE TABLE Genero (
    id_genero INT(11) AUTO_INCREMENT PRIMARY KEY,
    descricao TEXT NOT NULL
);

CREATE TABLE Pessoa (
    id_pessoa INT(11) AUTO_INCREMENT PRIMARY KEY
);

CREATE TABLE Produto (
    id_produto INT(11) AUTO_INCREMENT PRIMARY KEY,
    nome_comercial VARCHAR(128) NOT NULL,
    margem_lucro DECIMAL(10,2) NOT NULL CHECK (margem_lucro >= 0),
    descricao TEXT NOT NULL,
    codigo_barras VARCHAR(36) NOT NULL UNIQUE
);

CREATE TABLE Livro (
    id_livro INT(11) AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(128) NOT NULL,
    serie VARCHAR(128)
);
-- pessoa
CREATE TABLE Pessoa_Fisica (
    cpf CHAR(11) PRIMARY KEY CHECK (LENGTH(cpf) = 11),
    primeiro_nome VARCHAR(64) NOT NULL,
    sobrenome VARCHAR(64) NOT NULL,
    data_nascimento DATE NOT NULL,
    id_pessoa INT(11) NOT NULL UNIQUE,
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Pessoa_Juridica (
    cnpj CHAR(14) PRIMARY KEY CHECK (LENGTH(cnpj) = 14),
    inscricao_estadual VARCHAR(64),
    razao_social VARCHAR(128) NOT NULL,
    id_pessoa INT(11) NOT NULL UNIQUE,
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Cliente (
    id_cliente INT(11) AUTO_INCREMENT PRIMARY KEY,
    id_pessoa INT(11) NOT NULL UNIQUE,
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Funcionario (
    id_funcionario INT(11) AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(64) NOT NULL UNIQUE,
    senha VARCHAR(64) NOT NULL,
    id_pessoa INT(11) NOT NULL UNIQUE,
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Fornecedor (
    id_fornecedor INT(11) AUTO_INCREMENT PRIMARY KEY,
    id_pessoa INT(11) NOT NULL UNIQUE,
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Telefone (
    ddi CHAR(2) NOT NULL DEFAULT '55',
    ddd VARCHAR(15) NOT NULL,
    numero VARCHAR(15) NOT NULL,
    id_pessoa INT(11) NOT NULL,
    PRIMARY KEY (ddi, ddd, numero, id_pessoa),
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Email (
    endereco_email VARCHAR(128) PRIMARY KEY,
    tipo VARCHAR(9) NOT NULL CHECK (tipo IN ('PESSOAL', 'COMERCIAL')),
    id_pessoa INT(11) NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Endereco (
    id_endereco INT(11) AUTO_INCREMENT PRIMARY KEY,
    cep CHAR(8) NOT NULL CHECK (LENGTH(cep) = 8),
    uf CHAR(2) NOT NULL CHECK (LENGTH(uf) = 2),
    cidade VARCHAR(128) NOT NULL,
    bairro VARCHAR(128) NOT NULL,
    logradouro VARCHAR(128) NOT NULL,
    numero VARCHAR(8) NOT NULL,
    complemento VARCHAR(128)
);

-- produto, livro e etc
CREATE TABLE Produtos_Diversos (
    id_produto INT(11) PRIMARY KEY,
    tipo_produto VARCHAR(64) NOT NULL,
    valor_venda DECIMAL(10,2) NOT NULL,
    marca VARCHAR(64),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

CREATE TABLE Edicao (
    id_produto INT(11) PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    ano_edicao YEAR NOT NULL,
    numero_edicao TEXT NOT NULL,
    id_livro INT(11) NOT NULL,
    id_editora INT(11) NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_livro) REFERENCES Livro(id_livro),
    FOREIGN KEY (id_editora) REFERENCES Editora(id_editora)
);

CREATE TABLE Exemplar (
    id_exemplar INT(11) AUTO_INCREMENT PRIMARY KEY,
    data_aquisicao DATE NOT NULL,
    estado_conservacao VARCHAR(16) NOT NULL CHECK (estado_conservacao IN ('NOVO', 'REGULAR', 'REPARÁVEL', 'IRREPARÁVEL')),
    status_disponibilidade VARCHAR(12) NOT NULL CHECK (status_disponibilidade IN ('DISPONÍVEL', 'VENDIDO', 'ALUGADO', 'RESERVADO', 'INDISPONÍVEL')),
    tipo_estoque VARCHAR(7) NOT NULL CHECK (tipo_estoque IN ('VENDA', 'ALUGUEL')),
    valor_venda DECIMAL(10,2),
    id_edicao INT(11) NOT NULL,
    FOREIGN KEY (id_edicao) REFERENCES Edicao(id_produto)
);

-- financeiro, eh
CREATE TABLE Conta (
    id_conta INT(11) AUTO_INCREMENT PRIMARY KEY,
    status VARCHAR(15) NOT NULL CHECK (status IN ('PENDENTE', 'PAGA', 'CANCELADA')),
    valor DECIMAL(10,2) NOT NULL,
    data_vencimento DATE,
    data_pagamento DATE,
    id_tipo INT(11),
    FOREIGN KEY (id_tipo) REFERENCES Tipo_Despesa(id_tipo)
);

CREATE TABLE Pagamento (
    id_pagamento INT(11) AUTO_INCREMENT PRIMARY KEY,
    forma_pagamento VARCHAR(20) NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL CHECK (valor_pago > 0),
    status_pagamento VARCHAR(12) NOT NULL CHECK (status_pagamento IN ('PENDENTE', 'CONCLUÍDO', 'CANCELADO')),
    id_conta INT(11) NOT NULL,
    FOREIGN KEY (id_conta) REFERENCES Conta(id_conta)
);

CREATE TABLE Compra_Cliente (
    id_compra INT(11) AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL CHECK (valor_total > 0),
    status_venda VARCHAR(9) NOT NULL CHECK (status_venda IN ('ABERTA', 'CONCLUÍDA', 'CANCELADA')),
    id_cliente INT(11) NOT NULL,
    id_funcionario INT(11) NOT NULL,
    id_conta INT(11) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario),
    FOREIGN KEY (id_conta) REFERENCES Conta(id_conta)
);

CREATE TABLE Pedido (
    id_pedido INT(11) AUTO_INCREMENT PRIMARY KEY,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    status_pedido VARCHAR(9) NOT NULL CHECK (status_pedido IN ('PENDENTE', 'ENVIADO', 'ENTREGUE', 'CANCELADO')),
    id_conta INT(11) NOT NULL,
    id_fornecedor INT(11) NOT NULL,
    FOREIGN KEY (id_conta) REFERENCES Conta(id_conta),
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor)
);
-- locacao ficou aqui
CREATE TABLE Locacao (
    id_locacao INT(11) AUTO_INCREMENT PRIMARY KEY,
    data_retirada DATE NOT NULL,
    data_devolucao_prevista DATE NOT NULL,
    data_devolucao_real DATE,
    status VARCHAR(9) NOT NULL CHECK (status IN ('ATIVO', 'DEVOLVIDO', 'ATRASADO', 'PERDIDO')),
    status_multa VARCHAR(9) NOT NULL CHECK (status_multa IN ('SEM MULTA', 'PENDENTE', 'PAGA')),
    valor_aluguel DECIMAL(10,2) NOT NULL,
    valor_multa_atraso DECIMAL(10,2) NOT NULL,
    valor_multa_avaria DECIMAL(10,2) NOT NULL,
    condicao_livro VARCHAR(16) NOT NULL CHECK (condicao_livro IN ('NOVO', 'REGULAR', 'REPARÁVEL', 'IRREPARÁVEL')),
    id_cliente INT(11) NOT NULL,
    id_funcionario INT(11) NOT NULL,
    id_exemplar INT(11) NOT NULL,
    id_conta INT(11) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario),
    FOREIGN KEY (id_exemplar) REFERENCES Exemplar(id_exemplar),
    FOREIGN KEY (id_conta) REFERENCES Conta(id_conta),
    CHECK (data_devolucao_prevista >= data_retirada)
);

-- tabelas associativas
CREATE TABLE Endereco_Pessoa (
    id_endereco INT(11) NOT NULL,
    id_pessoa INT(11) NOT NULL,
    PRIMARY KEY (id_endereco, id_pessoa),
    FOREIGN KEY (id_endereco) REFERENCES Endereco(id_endereco),
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Cargo_Funcionario (
    id_cargo INT(11) NOT NULL,
    id_funcionario INT(11) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    PRIMARY KEY (id_cargo, id_funcionario),
    FOREIGN KEY (id_cargo) REFERENCES Cargo(id_cargo),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
);

CREATE TABLE Livro_Autor (
    id_autor INT(11) NOT NULL,
    id_livro INT(11) NOT NULL,
    ordem_autoria INT NOT NULL,
    tipo_contribuicao VARCHAR(32),
    PRIMARY KEY (id_autor, id_livro),
    FOREIGN KEY (id_autor) REFERENCES Autor(id_autor),
    FOREIGN KEY (id_livro) REFERENCES Livro(id_livro)
);

CREATE TABLE Livro_Genero (
    id_livro INT(11) NOT NULL,
    id_genero INT(11) NOT NULL,
    PRIMARY KEY (id_livro, id_genero),
    FOREIGN KEY (id_livro) REFERENCES Livro(id_livro),
    FOREIGN KEY (id_genero) REFERENCES Genero(id_genero)
);
-- essa nn é uma tabela associativa, não confundir
CREATE TABLE Lista_Exemplares (
    id_exemplar INT(11) NOT NULL,
    id_compra INT(11) NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),
    PRIMARY KEY (id_exemplar, id_compra),
    FOREIGN KEY (id_exemplar) REFERENCES Exemplar(id_exemplar),
    FOREIGN KEY (id_compra) REFERENCES Compra_Cliente(id_compra)
);


CREATE TABLE Compra_Diversos (
    id_compra INT(11) NOT NULL,
    id_produto INT(11) NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),
    PRIMARY KEY (id_compra, id_produto),
    FOREIGN KEY (id_compra) REFERENCES Compra_Cliente(id_compra),
    FOREIGN KEY (id_produto) REFERENCES Produtos_Diversos(id_produto)
);

CREATE TABLE Produto_Pedido (
    id_produto INT(11) NOT NULL,
    id_pedido INT(11) NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),
    quantidade INT NOT NULL,
    PRIMARY KEY (id_produto, id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

CREATE TABLE Movimentacao Estoque (
    id_movimento INT(11) AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_movimento VARCHAR(7) NOT NULL CHECK (tipo_movimento IN ('ENTRADA', 'SAIDA')),
    motivo VARCHAR(128) NOT NULL,
    id_funcionario INT(11) NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
);

CREATE TABLE Movimentacao_Exemplar (
    id_exemplar INT(11) NOT NULL,
    id_movimento INT(11) NOT NULL,
    PRIMARY KEY (id_exemplar, id_movimento),
    FOREIGN KEY (id_exemplar) REFERENCES Exemplar(id_exemplar),
    FOREIGN KEY (id_movimento) REFERENCES Movimentacao_Estoque(id_movimento)
);

CREATE TABLE Movimentacao_Diversos (
    id_movimento INT(11) NOT NULL,
    id_produto INT(11) NOT NULL,
    quantidade_movimentada INT NOT NULL,
    PRIMARY KEY (id_movimento, id_produto),
    FOREIGN KEY (id_movimento) REFERENCES Movimentacao_Estoque(id_movimento),
    FOREIGN KEY (id_produto) REFERENCES Produtos_Diversos(id_produto)
);
