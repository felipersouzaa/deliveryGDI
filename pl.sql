DECLARE
TYPE TIPO_RESTAURANTE IS RECORD(
  CNPJ NUMBER,
  NOME VARCHAR2(20)
);

Podrao_dos_crias TIPO_RESTAURANTE;

------------------------------------------------------
DECLARE

TYPE listaRestaurantes is TABLE OF restaurante%rowtype;

lista listaRestaurantes := listaRestaurantes();

BEGIN
	FOR ESTABELECIMENTO IN (
  	SELECT * FROM restaurante R  
  ) LOOP
  
      lista.EXTEND;

        IF ESTABELECIMENTO.cnpj > 1111111111 THEN
            CASE ESTABELECIMENTO.restaurante_nome
                WHEN 'Acarajezinho Suave' THEN
                    lista(lista.LAST).restaurante_nome := 'TopTop';
                ELSE 
                    lista(lista.LAST).restaurante_nome := ESTABELECIMENTO.restaurante_nome;

            END CASE;
				lista(lista.LAST).cnpj := ESTABELECIMENTO.cnpj;
        ELSIF ESTABELECIMENTO.restaurante_nome LIKE 'Pizza%' THEN
        				lista(lista.LAST).restaurante_nome := 'Italianinho Brabo';
                lista(lista.LAST).cnpj := 2020202020;
        END IF;
        
    END LOOP;
    
END;

------------------------------------------------------

CREATE OR REPLACE PROCEDURE NOVO_HUMANO(
  h_nome pessoa.pessoa_name%TYPE,
  h_CPF pessoa.cpf%TYPE,
  h_telefone pessoa.telefone%TYPE) IS 
  BEGIN
  	INSERT INTO pessoa (pessoa_name, cpf, telefone) VALUES (h_nome, h_CPF, h_telefone);
  END NOVO_HUMANO;
/
------------------------------------------------------
BEGIN
	NOVO_HUMANO('Zouza', 12121212121, 989898989);
  
END;

-----------------------------------------------------
	-- função que, a partir do pedido, retorna o cep do endereço do cliente que o realizou
CREATE OR REPLACE FUNCTION achar_endereco_cliente
(c_pedido pedido.pedido_codigo%TYPE)
RETURN enderecoCliente.endereco_cep%TYPE IS

	v_CEP enderecoCliente.endereco_cep%TYPE;
  cpf_cliente cliente.cliente_cpf%TYPE;

BEGIN
	/* código do pedido --> cpf pessoa desde que isso seja o cpf do cliente*/
	SELECT P.pedido_cliente INTO cpf_cliente
  FROM pedido P
  WHERE P.pedido_codigo = c_pedido;
  
  IF c_pedido IS NULL THEN

    v_CEP := 'inexistente';
  
  ELSE
  	
    SELECT E.endereco_cep INTO v_CEP
    FROM enderecoCliente E
    WHERE E.cliente_cpf = cpf_cliente;
    
      IF v_CEP IS NULL THEN
         v_CEP := 'inexistente'; 
      END IF;
      
  END IF;
  
  RETURN v_CEP;

END achar_endereco_cliente;
/

-----------------------------------------------------

DECLARE
   n_counter NUMBER := 1;
BEGIN
   WHILE n_counter <= 5
      LOOP
        DBMS_OUTPUT.PUT_LINE( 'Counter : ' || n_counter );
        n_counter := n_counter + 1;
        EXIT WHEN n_counter = 3;
      END LOOP;
   END;

------------------------------------------------------

DECLARE
r_telefone telefone_restaurante.restaurante_numero%TYPE,
r_CNPJ_telefone telefone_restaurante.restaurante_cnpj%TYPE:=1212121212,

CURSOR c_telefone IS
SELECT restaurante_numero
FROM telefone_restaurante
WHERE telefone_restaurante.restaurante_cnpj = r_CNPJ_telefone;

BEGIN
    OPEN c_telefone;
    LOOP
        FETCH c_telefone INTO r_telefone;
        EXIT WHEN c_telefone%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(r_telefone));
    END LOOP;
    CLOSE c_telefone;

EXCEPTION 
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('Voce tentou manipular incorretamente o cursor.')
END;
/

CREATE OR REPLACE TRIGGER NaoPode
BEFORE DELETE ON pessoa
FOR EACH ROW
BEGIN
    IF :OLD.pessoa_name='Fiuk' THEN
        RAISE_APPLICATION_ERROR(-20011, 'Voltou do paredao!');
     END IF;
END;
/

DELETE FROM pessoa
WHERE pessoa_name = 'Fiuk';

------------------------------
CREATE OR REPLACE TRIGGER quantosProdutos
AFTER DELETE ON produto 
DECLARE
quantProdutos INTEGER;
BEGIN
SELECT COUNT(*) INTO quantProdutos
FROM produto;

    DBMS_OUTPUT.PUT_LINE('Tabela Produto agora tem ' quantProdutos  ' produtos');
END;
/


DELETE FROM produto
WHERE produto_nome = 'Frango Xadrez';