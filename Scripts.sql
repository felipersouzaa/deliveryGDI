--1, 3, 5
CREATE TABLE pessoa (
    pessoa_nome VARCHAR(255) NOT NULL,
    cpf NUMERIC(11) NOT NULL,
    telefone NUMERIC (9) NOT NULL,
    CONSTRAINT cpf_pk PRIMARY KEY (cpf),
    CHECK (cpf > 0)
);

--2
ALTER TABLE pessoa RENAME COLUMN pessoa_nome TO pessoa_name;

--6
CREATE INDEX pessoa_index_ ON pessoa (cpf, pessoa_name);

--4
CREATE SEQUENCE id_seq
    MINVALUE 1
    MAXVALUE 99999999999
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE cliente (
    cliente_cpf NUMERIC(11) NOT NULL,
    CONSTRAINT cliente_cpf_pk PRIMARY KEY (cliente_cpf),
    CONSTRAINT cliente_cpf_fk
        FOREIGN KEY(cliente_cpf)
        REFERENCES pessoa(cpf)    
);

CREATE TABLE enderecoCliente (
    cliente_cpf NUMERIC(11) NOT NULL,
    endereco_cep NUMERIC(8) NOT NULL,
    endereco_numero NUMERIC(5) NOT NULL,
    endereco_rua VARCHAR(255) NOT NULL,
    CONSTRAINT endereco_cep_pk PRIMARY KEY (endereco_cep),
    CONSTRAINT enderecoCliente_cliente_cpf_fk
        FOREIGN KEY(cliente_cpf)
        REFERENCES cliente(cliente_cpf)  
);

CREATE TABLE entregador (
    entregador_cpf NUMERIC(11) NOT NULL,
    conta_bancaria NUMERIC(10) NOT NULL,
    CONSTRAINT entregador_cpf_pk PRIMARY KEY (entregador_cpf),
    CONSTRAINT entregador_cpf_fk
        FOREIGN KEY(entregador_cpf)
        REFERENCES pessoa(cpf)
);

CREATE TABLE veiculo (
    entregador_cpf NUMERIC(11) NOT NULL,
    veiculo_placa VARCHAR(8),
    veiculo_tipo VARCHAR(50),
    CONSTRAINT veiculo_placa_pk PRIMARY KEY (veiculo_placa),
    CONSTRAINT veiculo_entregador_cpf_fk
        FOREIGN KEY(entregador_cpf)
        REFERENCES pessoa(cpf)
);

CREATE TABLE restaurante (
    restaurante_nome VARCHAR(255) NOT NULL,
    cnpj NUMERIC(14) NOT NULL,
  	CONSTRAINT restaurante_cnpj_pk PRIMARY KEY (cnpj)
);

CREATE TABLE telefone_restaurante (
    restaurante_cnpj NUMERIC(14),
    restaurante_numero NUMERIC(11) NOT NULL,
  	CONSTRAINT restaurante_numero_pk PRIMARY KEY (restaurante_numero),
    CONSTRAINT restaurante_cnpj_fk
        FOREIGN KEY(restaurante_cnpj)
        REFERENCES restaurante(cnpj)
);

CREATE TABLE endereco_restaurante (
    endereco_cep NUMERIC(8) NOT NULL,
    endereco_numero NUMERIC(5) NOT NULL,
    endereco_rua VARCHAR(255) NOT NULL,
    restaurante_cnpj NUMERIC(14),
  	CONSTRAINT restaurante_cep_pk PRIMARY KEY (endereco_cep),
    CONSTRAINT endereco_restaurante_cnpj_fk
        FOREIGN KEY(restaurante_cnpj)
        REFERENCES restaurante(cnpj)
);

CREATE TABLE produto (
  	produto_codigo VARCHAR(10) NOT NULL,
    produto_nome VARCHAR (255) NOT NULL,
    produto_preco NUMBER (*, 2) NOT NULL,
  	restaurante_cnpj NUMERIC(14) NOT NULL, 
  	CONSTRAINT produto_cod_pk PRIMARY KEY (produto_codigo),
  	CONSTRAINT produto_restaurante_cnpj_fk
        FOREIGN KEY (restaurante_cnpj)
        REFERENCES restaurante(cnpj)
);

CREATE TABLE tipoProduto (
    tipo_produto VARCHAR(50) NOT NULL,
    tproduto_codigo VARCHAR(10) NOT NULL,
  	CONSTRAINT tproduto_codigo_fk
  			FOREIGN KEY(tproduto_codigo)
  			REFERENCES produto(produto_codigo)
);

CREATE TABLE carrinho (
  	codigo_carrinho NUMERIC(15) NOT NULL,
  	preco_carrinho NUMBER (*, 2) NOT NULL,
  	CONSTRAINT codigo_carrinho_pk PRIMARY KEY (codigo_carrinho)
);

CREATE TABLE pedido (
    pedido_cliente NUMERIC(11) NOT NULL,
	  pedido_restaurante NUMERIC(14) NOT NULL,
	  pedido_entregador NUMERIC(11) NOT NULL,
	  pedido_carrinho NUMERIC(15) NOT NULL,
    pedido_preco NUMBER (*, 2) NOT NULL,
	  pedido_codigo NUMERIC(15) NOT NULL,
    CONSTRAINT pedido_codigo_pk PRIMARY KEY (pedido_codigo),
	  CONSTRAINT pedido_cliente_fk
        FOREIGN KEY(pedido_cliente)
        REFERENCES cliente(cliente_cpf),
	  CONSTRAINT pedido_restaurante_fk
        FOREIGN KEY(pedido_restaurante)
        REFERENCES restaurante(cnpj),
    CONSTRAINT pedido_entregador_fk
        FOREIGN KEY(pedido_entregador)
        REFERENCES entregador(entregador_cpf),
    CONSTRAINT pedido_carrinho_fk
        FOREIGN KEY(pedido_carrinho)
        REFERENCES carrinho(codigo_carrinho)
);

CREATE TABLE pagamento(
  	pagamento_formaPagamento VARCHAR(50) NOT NULL,
  	pagamento_pedido NUMERIC(15) NOT NULL,
  	CONSTRAINT pagamento_pedido_fk
  			FOREIGN KEY(pagamento_pedido)
  			REFERENCES pedido(pedido_codigo)
);

CREATE TABLE avaliacao(
    avaliacao_avaliacao NUMERIC(2) NOT NULL,
    avaliacao_data TIMESTAMP NOT NULL,
  	avaliacao_cliente NUMERIC(11) NOT NULL,
		avaliacao_restaurante NUMERIC(14) NOT NULL,
		avaliacao_entregador NUMERIC(11) NOT NULL,
  	CONSTRAINT avaliacao_data_pk PRIMARY KEY (avaliacao_data),
    CONSTRAINT avaliacao_cliente_fk
        FOREIGN KEY(avaliacao_cliente)
        REFERENCES cliente(cliente_cpf),
	  CONSTRAINT avaliacao_restaurante_fk
        FOREIGN KEY(avaliacao_restaurante)
        REFERENCES restaurante(cnpj),
  	CONSTRAINT avaliacao_entregador_fk
  			FOREIGN KEY(avaliacao_entregador)
  			REFERENCES entregador(entregador_cpf)
);

CREATE TABLE combinaCom(
    combinaCom_produto VARCHAR(10) NOT NULL,
    combinaCom_combinacao VARCHAR(10) NOT NULL,
    CONSTRAINT combinaCom_produto_fk
        FOREIGN KEY(combinaCom_produto)
        REFERENCES produto(produto_codigo),
   	CONSTRAINT combinaCom_combinacao_fk
        FOREIGN KEY(combinaCom_combinacao)
        REFERENCES produto(produto_codigo)
);

CREATE TABLE atualizaCarrinho (
		atualizaCarrinho_cliente NUMERIC(11) NOT NULL,
  	atualizaCarrinho_produto VARCHAR(10) NOT NULL,
		atualizaCarrinho_carrinho NUMERIC(15) NOT NULL,
  	CONSTRAINT atualizaCarrinho_cliente_fk
        FOREIGN KEY(atualizaCarrinho_cliente)
        REFERENCES cliente(cliente_cpf),
  	CONSTRAINT atualizaCarrinho_produto_fk
  			FOREIGN KEY(atualizaCarrinho_produto)
  			REFERENCES produto(produto_codigo),
     CONSTRAINT atualizaCarrinho_carrinho_fk
        FOREIGN KEY(atualizaCarrinho_carrinho)
        REFERENCES carrinho(codigo_carrinho)         
);

--7
INSERT INTO pessoa (pessoa_name, cpf, telefone) VALUES ('Gil do Vigor', 11111111111, 999988888);
INSERT INTO pessoa (pessoa_name, cpf, telefone) VALUES ('Viih Tube', 22222222222, 99997777);
INSERT INTO pessoa (pessoa_name, cpf, telefone) VALUES ('Projota', 33333333333, 99996666);
INSERT INTO pessoa (pessoa_name, cpf, telefone) VALUES ('Carla Diaz', 44444444444, 99995555);
INSERT INTO pessoa (pessoa_name, cpf, telefone) VALUES ('Fiuk', 55555555555, 99994444);
INSERT INTO pessoa (pessoa_name, cpf, telefone) VALUES ('Carol Conka', 66666666666, 99993333);
INSERT INTO pessoa (pessoa_name, cpf, telefone) VALUES ('Thais', 77777777777, 99992222);
INSERT INTO pessoa (pessoa_name, cpf, telefone) VALUES ('Nego Di', 88888888888, 99991111);
INSERT INTO pessoa (pessoa_name, cpf, telefone) VALUES ('Delete', 99999999999, 99999999);

INSERT INTO cliente (cliente_cpf) VALUES (11111111111);
INSERT INTO cliente (cliente_cpf) VALUES (22222222222);
INSERT INTO cliente (cliente_cpf) VALUES (33333333333);
INSERT INTO cliente (cliente_cpf) VALUES (44444444444);
INSERT INTO cliente (cliente_cpf) VALUES (55555555555);

INSERT INTO enderecoCliente (cliente_cpf, endereco_cep, endereco_numero, endereco_rua) VALUES (11111111111, 12345678, 00015, 'Amora');
INSERT INTO enderecoCliente (cliente_cpf, endereco_cep, endereco_numero, endereco_rua) VALUES (22222222222, 50985239, 10201, 'Francisco Araujo');
INSERT INTO enderecoCliente (cliente_cpf, endereco_cep, endereco_numero, endereco_rua) VALUES (33333333333, 89009834, 33322, 'Guimaraes Rosa');
INSERT INTO enderecoCliente (cliente_cpf, endereco_cep, endereco_numero, endereco_rua) VALUES (44444444444, 78912784, 87678, 'Das Babosas');
INSERT INTO enderecoCliente (cliente_cpf, endereco_cep, endereco_numero, endereco_rua) VALUES (55555555555, 95631742, 02846, 'Arueiras');

INSERT INTO entregador (entregador_cpf, conta_bancaria) VALUES (66666666666, 1234567890);
INSERT INTO entregador (entregador_cpf, conta_bancaria) VALUES (77777777777, 0987654321);

INSERT INTO veiculo (entregador_cpf, veiculo_placa, veiculo_tipo) VALUES (66666666666, 'AAA-1234', 'Moto');
INSERT INTO veiculo (entregador_cpf, veiculo_placa, veiculo_tipo) VALUES (66666666666, 'BBB-1234', 'Carro');
INSERT INTO veiculo (entregador_cpf, veiculo_placa, veiculo_tipo) VALUES (77777777777, 'CCC-1234', 'Moto');

INSERT INTO restaurante (restaurante_nome, cnpj) VALUES ('Comida Chinesa Top', 1212121212);
INSERT INTO restaurante (restaurante_nome, cnpj) VALUES ('Acarajezinho Suave', 1313131313);
INSERT INTO restaurante (restaurante_nome, cnpj) VALUES ('Podrao dos crias', 1414141414);
INSERT INTO restaurante (restaurante_nome, cnpj) VALUES ('Pizza da Massa', 1515151515);

INSERT INTO telefone_restaurante (restaurante_cnpj, restaurante_numero) VALUES (1212121212, 81908896545);
INSERT INTO telefone_restaurante (restaurante_cnpj, restaurante_numero) VALUES (1313131313, 81936995872);
INSERT INTO telefone_restaurante (restaurante_cnpj, restaurante_numero) VALUES (1414141414, 81998587889);
INSERT INTO telefone_restaurante (restaurante_cnpj, restaurante_numero) VALUES (1515151515, 81922245487);

INSERT INTO endereco_restaurante (endereco_cep, endereco_numero, endereco_rua, restaurante_cnpj) VALUES (11122233, 98765, 'Rua Silva Lima', 1212121212); 
INSERT INTO endereco_restaurante (endereco_cep, endereco_numero, endereco_rua, restaurante_cnpj) VALUES (11122234, 98764, 'Rua Bernardo Pontes', 1313131313);
INSERT INTO endereco_restaurante (endereco_cep, endereco_numero, endereco_rua, restaurante_cnpj) VALUES (11122235, 98763, 'Rua São Jorge', 1414141414);
INSERT INTO endereco_restaurante (endereco_cep, endereco_numero, endereco_rua, restaurante_cnpj) VALUES (11122236, 98762, 'Rua Pedro Paiva', 1515151515);
    
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('CHN1234567', 'Yakissoba', 24.90, 1212121212);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('CHN2345678', 'Carne Acebolada', 19.90, 1212121212);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('CHN3456789', 'Frango Xadrez', 19.90, 1212121212);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('CHN4567891', 'Rolinho Primavera', 4.90, 1212121212);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('CHN5678912', 'Arroz Chopsuey', 4.90, 1212121212);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('CHN6789123', 'Coca-Cola', 5.90, 1212121212);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('CHN7891234', 'Kirin Ichiban', 6.90, 1212121212);

INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('ACR1234567', 'Acaraje', 14.90, 1313131313);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('ACR2345678', 'Abara', 16.90, 1313131313);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('ACR6789123', 'Coca-Cola', 5.90, 1212121212);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('ACR7891234', 'Heineken', 7.90, 1212121212);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('ACR8912345', 'Agua', 2.90, 1212121212);

INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('FFD1234567', 'X-Burger', 14.90, 1414141414);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('FFD2345678', 'Porcao Batata', 9.90, 1414141414);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('FFD4516789', 'Coquinha Gelada', 5.00, 1414141414);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('FFD4567891', 'Egg-Bacon Burger', 8.90, 1414141414);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('FFD5678912', 'Coxinha', 2.90, 1414141414);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('FFD6789123', 'Coca-Cola', 4.90, 1212121212);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('FFD7891234', 'Itaipava', 4.90, 1212121212);

INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('PZZ1234567', 'Pizza Marguerita', 29.90, 1515151515);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('PZZ2345678', 'Pizza Portuguesa', 25.90, 1515151515);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('PZZ3456789', 'Pizza 4 Queijos', 32.90, 1515151515);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('PZZ4567891', 'Pizza Pepperoni', 29.90, 1515151515);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('PZZ5678912', 'Pizza Mussarela', 21.90, 1515151515);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('PZZ6789123', 'Pepsi 2L', 10.90, 1212121212);
INSERT INTO produto (produto_codigo, produto_nome, produto_preco, restaurante_cnpj) VALUES ('PZZ7891234', 'Guarana 2L', 10.90, 1212121212);

                                                                                                         
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Chinesa', 'CHN1234567');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Chinesa', 'CHN2345678');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Chinesa', 'CHN4567891');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Chinesa', 'CHN5678912');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Bebida', 'CHN6789123');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Bebida', 'CHN7891234');

INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Baiana', 'ACR1234567');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Baiano', 'ACR2345678');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Bebida', 'ACR6789123');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Bebida', 'ACR7891234');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Bebida', 'ACR6789123');

INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Fast-Food', 'FFD1234567');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Fast-Food', 'FFD2345678');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Bebida', 'FFD4516789');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Fast-Food', 'FFD4567891');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Fast-Food', 'FFD5678912');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Bebida', 'FFD6789123');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Bebida', 'FFD7891234');

INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Italiana', 'PZZ1234567');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Italiana', 'PZZ2345678');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Italiana', 'PZZ3456789');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Italiana', 'PZZ4567891');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Italiana', 'PZZ5678912');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Bebida', 'PZZ6789123');
INSERT INTO tipoProduto (tipo_produto, tproduto_codigo) VALUES	('Bebida', 'PZZ7891234');

INSERT INTO carrinho (codigo_carrinho, preco_carrinho) VALUES (352148532548612, 64.80);
INSERT INTO carrinho (codigo_carrinho, preco_carrinho) VALUES (524852136972549, 84.70);
INSERT INTO carrinho (codigo_carrinho, preco_carrinho) VALUES (215852721981254, 40.00);
INSERT INTO carrinho (codigo_carrinho, preco_carrinho) VALUES (314958919309104, 109.80);
INSERT INTO carrinho (codigo_carrinho, preco_carrinho) VALUES (999999222222222, 65.12);
  
INSERT INTO pedido (pedido_cliente, pedido_restaurante, pedido_entregador, pedido_carrinho, pedido_preco, pedido_codigo) VALUES (11111111111, 1212121212, 66666666666, 352148532548612, 64.80, 963852741963852); 
INSERT INTO pedido (pedido_cliente, pedido_restaurante, pedido_entregador, pedido_carrinho, pedido_preco, pedido_codigo) VALUES (22222222222, 1515151515, 66666666666, 524852136972549, 84.70, 963852741963857);
INSERT INTO pedido (pedido_cliente, pedido_restaurante, pedido_entregador, pedido_carrinho, pedido_preco, pedido_codigo) VALUES (33333333333, 1414141414, 77777777777, 215852721981254, 40.00, 963852741963854);
INSERT INTO pedido (pedido_cliente, pedido_restaurante, pedido_entregador, pedido_carrinho, pedido_preco, pedido_codigo) VALUES (44444444444, 1313131313, 77777777777, 314958919309104, 109.80, 963852741963851); 
INSERT INTO pedido (pedido_cliente, pedido_restaurante, pedido_entregador, pedido_carrinho, pedido_preco, pedido_codigo) VALUES (11111111111, 1313131313, 66666666666, 999999222222222, 65.12, 963852741963850);
                                                                                                                                  
INSERT INTO pagamento (pagamento_formaPagamento, pagamento_Pedido) VALUES ('Dinheiro',963852741963852);
INSERT INTO pagamento (pagamento_formaPagamento, pagamento_Pedido) VALUES ('Cartao Credito',963852741963854);
INSERT INTO pagamento (pagamento_formaPagamento, pagamento_Pedido) VALUES ('Vale Refeicao',963852741963850);
                      
INSERT INTO avaliacao (avaliacao_avaliacao, avaliacao_data, avaliacao_cliente, avaliacao_restaurante, avaliacao_entregador) VALUES (6, CURRENT_TIMESTAMP, 11111111111, 1212121212, 66666666666);
INSERT INTO avaliacao (avaliacao_avaliacao, avaliacao_data, avaliacao_cliente, avaliacao_restaurante, avaliacao_entregador) VALUES (8, CURRENT_TIMESTAMP, 22222222222, 1515151515, 66666666666);
INSERT INTO avaliacao (avaliacao_avaliacao, avaliacao_data, avaliacao_cliente, avaliacao_restaurante, avaliacao_entregador) VALUES (10, CURRENT_TIMESTAMP, 33333333333, 1414141414, 77777777777);
INSERT INTO avaliacao (avaliacao_avaliacao, avaliacao_data, avaliacao_cliente, avaliacao_restaurante, avaliacao_entregador) VALUES (7, CURRENT_TIMESTAMP, 44444444444, 1313131313, 77777777777);
INSERT INTO avaliacao (avaliacao_avaliacao, avaliacao_data, avaliacao_cliente, avaliacao_restaurante, avaliacao_entregador) VALUES (7, CURRENT_TIMESTAMP, 11111111111, 1313131313, 66666666666);

--8
UPDATE pessoa SET pessoa_name = 'Gil do Vigor Atualizado' WHERE cpf = 11111111111;

--9
DELETE FROM pessoa WHERE cpf = 99999999999;

--10, 11
SELECT * FROM pessoa WHERE cpf BETWEEN 44444444444 AND 77777777777;

--12
SELECT * FROM pessoa WHERE cpf IN (11111111111, 22222222222);

--13
SELECT * FROM pessoa WHERE pessoa_name LIKE '%Gil%';

--14
SELECT * FROM pessoa WHERE pessoa_name IS NOT NULL;

--15
SELECT * FROM pessoa INNER JOIN cliente ON pessoa.cpf = cliente.cliente_cpf;

--16, 21
SELECT * FROM pedido WHERE pedido_preco = (SELECT MAX(pedido_preco) FROM pedido);

--17
SELECT * FROM pedido WHERE pedido_preco = (SELECT MIN(pedido_preco) FROM pedido);

--18
SELECT AVG(pedido_preco) FROM pedido;

--19, 25, 26, 27
SELECT COUNT(*), pedido_cliente FROM pedido GROUP BY pedido_cliente HAVING pedido_cliente > 00000000000 ORDER BY pedido_cliente;

--20
SELECT * FROM pessoa LEFT OUTER JOIN cliente ON pessoa.cpf = cliente.cliente_cpf;

--22
SELECT * FROM pedido WHERE pedido_preco IN (SELECT pedido_preco FROM pedido WHERE pedido_preco > 70);

--23
SELECT * FROM pedido WHERE pedido_preco < ANY (SELECT pedido_preco FROM pedido where pedido_preco > 70);

--24
SELECT * FROM pedido WHERE pedido_preco > ALL (70, 75, 80);

--28
SELECT cliente_cpf FROM cliente UNION SELECT entregador_cpf FROM entregador;

-- 29 
CREATE VIEW view_pessoa AS SELECT * FROM pessoa;

/* 
30
GRANT ALL ON pessoa TO public;

31
REVOKE ALL ON pessoa FROM public;
*/ 