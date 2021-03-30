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