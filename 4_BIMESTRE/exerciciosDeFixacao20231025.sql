-- 1
DELIMITER //
CREATE TRIGGER insert_cliente
AFTER INSERT ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Cliente inserido no dia', NOW()));
END;
//
DELIMITER ;

-- 2
DELIMITER //
CREATE TRIGGER exclusao_cliente_trigger
BEFORE DELETE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Tentativa de excluir o cliente ', OLD.nome, ' no dia ', NOW()));
END;
//
DELIMITER ;

-- 3 e 4
DELIMITER //
CREATE TRIGGER atualiza_nome_trigger
BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL OR NEW.nome = '' THEN
        INSERT INTO Auditoria (mensagem) VALUES ('Não pode seer vazio ou NULL.');
    ELSE
        INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Atualização do nome', OLD.nome, ' para ', NEW.nome, ' no dia ', NOW()));
    END IF;
END;
//
DELIMITER ;

-- 5

DELIMITER //
CREATE TRIGGER estoque_trigger
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    UPDATE Produtos
    SET estoque = estoque - NEW.quantidade
    WHERE id = NEW.produto_id;
    
    IF (SELECT estoque FROM Produtos WHERE id = NEW.produto_id) < 5 THEN
        INSERT INTO Auditoria (mensagem) VALUES (CONCAT('O produto', (SELECT nome FROM Produtos WHERE id = NEW.produto_id), ' ficou abaixo de 5 unidades no dia ', NOW()));
    END IF;
END;
//
DELIMITER ;
