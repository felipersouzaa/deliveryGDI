CREATE OR REPLACE TYPE tp_fone AS OBJECT(
    numero NUMBER
);
/

CREATE OR REPLACE TYPE rest_fones AS VARRAY(4) OF tp_fone;
/

CREATE TABLE tb_fones_restaurante(
  cnpj_restaurante VARCHAR(10) PRIMARY KEY,
  lista_fones rest_fones NOT NULL
  );
/

INSERT INTO tb_fones_restaurante VALUES('1212121212', rest_fones (tp_fone(81992222222), tp_fone(81993333333), tp_fone(81994444444)));

SELECT * FROM tb_fones_restaurante;

CREATE OR REPLACE TYPE tp_tipos AS OBJECT(
    tipoProduto VARCHAR2(50)
    );
/

CREATE TYPE tp_nt_tipos AS TABLE OF tp_tipos;

/

CREATE TABLE tb_lista_tipos_produtos(
    codigo_produto VARCHAR2(10),
    lista_produto tp_nt_tipos)
NESTED TABLE lista_produto STORE AS tb_lista_produtos;
/

INSERT INTO tb_lista_tipos_produtos VALUES('PZZ1234567', tp_nt_tipos(tp_tipos('Pizza'), tp_tipos('Vegetariana')));
/

SELECT * FROM tb_lista_tipos_produtos;

SELECT * FROM TABLE (SELECT P.LISTA_PRODUTO FROM tb_lista_tipos_produtos P WHERE P.CODIGO_PRODUTO = 'PZZ1234567');
/

CREATE OR REPLACE TYPE TP_ENDERECO AS OBJECT(
    CEP VARCHAR2(8),
    Rua VARCHAR2(30),
  	MAP MEMBER FUNCTION pegarEndereco RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY TP_ENDERECO AS
    MAP MEMBER FUNCTION pegarEndereco RETURN VARCHAR2 IS
        BEGIN
            RETURN CEP || ´ - ´ || Rua;
        END;
END;
/

ALTER TYPE TP_ENDERECO
    ADD ATTRIBUTE (NUMERO NUMBER)CASCADE;


CREATE OR REPLACE TYPE TP_PESSOA AS OBJECT(
    CPF NUMBER,
    p_nome VARCHAR2(30),
    Telefone Number
) NOT INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE tp_cliente UNDER tp_pessoa (
    endereco tp_endereco
);
/

CREATE OR REPLACE TYPE tp_entregador UNDER tp_pessoa (
    conta NUMBER,
  	MEMBER PROCEDURE setConta(c NUMBER)
);
/

CREATE OR REPLACE TYPE BODY tp_entregador AS
	MEMBER PROCEDURE setConta(c NUMBER) IS
		BEGIN
			conta := c;
		END;
END;
/

CREATE OR REPLACE TYPE BODY TP_PESSOA AS
MEMBER FUNCTION comparaCPF (p TP_PESSOA) RETURN INTEGER IS
RETURN      
      CASE
            WHEN SELF.CPF = P.CPF then 0
            WHEN SELF.CPF <> P.CPF then 1            
            END;
      END;
/     
CREATE OR REPLACE TYPE Avaliacao_Type AS OBJECT (
  	Avaliacao NUMBER,
    Datas TIMESTAMP,
    Cliente REF Cliente_Type,
    Restaurante REF Restaurante_Type,
    Entregador REF Entregador_Type
);
);/


CREATE OR REPLACE TYPE BODY Pessoa_Type AS
	CONSTRUCTOR FUNCTION Pessoa_Type
  	(Cpf NUMBER)
    	BEGIN
      	Cpf >= 5;
      END;
    END;
    /


----------------------------------------------------------------TABELA--------------------------------------------------------------------
CREATE TABLE Pessoa_Table of TP_PESSOA(
    p_nome NOT NULL,
    CPF PRIMARY KEY,
    Telefone NOT NULL   
);
/

CREATE TABLE Cliente_Table of tp_cliente(
    Cpf SCOPE IS Pessoa_Table
);
/

CREATE TABLE EnderecoCliente_Table of EnderecoCliente_Type(
    Cpf SCOPE IS Cliente_Table,
    Cep PRIMARY KEY,
    Numero NOT NULL,
    RUA NOT NULL
);
/
CREATE TABLE Entregador_Table of tp_entregador(
    Cpf SCOPE is Pessoa_Table,
   	conta	 is NOT NULL
);
/
CREATE TABLE Veiculo_Table of Veiculo_Type(
    Entregador SCOPE IS Entregador_Table,
    Placa PRIMARY KEY,
    Tipo NOT NULL
);
/
CREATE TABLE Restaurante_Table of Restaurante_Type (
    Nome NOT NULL,
    Cnpj PRIMARY KEY
);
/
CREATE TABLE TelefoneRestaurante_Table of TelefoneRestaurante_Type(
    Cnpj SCOPE is Restaurante_Table,
    Numero PRIMARY KEY
);
/
CREATE TABLE EnderecoRestaurante_Table of EnderecoRestaurante_Type(
    Cep PRIMARY KEY,
    Numero NOT NULL,
    Rua NOT NULL,
    Cnpj SCOPE IS Restaurante_Table
);
/
CREATE TABLE Produto_Table of Produto_Type(
    Codigo PRIMARY KEY,
    Nome NOT NULL,
    Preco NOT NULL,
    Numero NOT NULL,
    Cnpj SCOPE IS Restaurante_Table
);
/
CREATE TABLE tipoProduto_Table of tipoProduto_Type(
    tipo NOT NULL,
    Codigo SCOPE is Produto_Table
);
/
CREATE Carrinho_Table of Carrinho_Type(
    Codigo PRIMARY KEY,
    preco NOT NULL
);
/
CREATE TABLE Pedido_Table of Pedido_Type(
    Cliente SCOPE IS Cliente_Table,
    Restaurante SCOPE IS Restaurante_Table,
    Carrinho SCOPE IS Carrinho_Table,
    Preco NOT NULL,
    Codigo PRIMARY KEY
);
/
CREATE TABLE Pagamento_Table of Pagamento_Type(
    FormaPagamento NOT NULL,
    Pedido SCOPE IS Pedido_Table
);
/
CREATE TABLE Avaliacao_Table of Avaliacao_Type(
    Avaliacao NOT NULL,
    Datas PRIMARY KEY,
    Cliente SCOPE IS Cliente_Table,
    Restaurante SCOPE S Restaurante_Table,
    Entregador SCOPE IS Entregador_Table
);
/
CREATE TABLE CombinaCom_Table of CombinaCOm_Type(
    Produto SCOPE IS Produto_Table,
    Combinacao SCOPE IS Produto_Table
);
/
CREATE TABLE AtualizaCarrinho_Table of AtualizaCarrinho_Type(
    Cliente SCOPE IS Cliente_Table,
    Produto SCOPE IS Produto_Table,
    Carrinho SCOPE IS Carrinho_Table,
);
/



------------------------------------Enchendo tabela-----------------------------------------------


INSERT INTO Pessoa_Table VALUES (
  TP_PESSOA ('Gil do Vigor', 11111111111, 999988888);
);/
