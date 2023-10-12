--1 a)
CREATE TABLE nomes (
    nome VARCHAR(255)
);
INSERT INTO nomes (nome) 
VALUES ('Roberta'), ('Roberto'), ('Maria Clara'), ('João');

-- b) 
SELECT UPPER(nome) FROM nomes;

-- c)
SELECT nome, LENGTH(nome) as tamanho FROM nomes;

-- d)
SELECT 
    CASE 
        WHEN nome LIKE 'Roberto' OR nome LIKE 'João' THEN CONCAT('Sr. ', nome)
        ELSE CONCAT('Sra. ', nome)
    END AS nome_com_tratamento
FROM nomes;

-- 2 a)
CREATE TABLE produtos (
    produto VARCHAR(255),
    preco DECIMAL(10, 2),
    quantidade INT
);

-- b)
SELECT produto, ROUND(preco, 2) as preco_arredondado FROM produtos;

-- c)
SELECT produto, ABS(quantidade) as quantidade_absoluta FROM produtos;

-- d)
SELECT AVG(preco) as media_precos FROM produtos;

-- 3 a)
CREATE TABLE eventos (
    data_evento DATE
);

INSERT INTO eventos (data_evento)
VALUES
    ('2023-10-01'),
    ('2023-10-05'),
    ('2023-10-10');

-- b)
INSERT INTO eventos (data_evento) VALUES (NOW());

-- c)
SELECT DATEDIFF('2023-10-10', '2023-10-01') as dias_entre_datas;

-- d)
SELECT data_evento, DAYNAME(data_evento) as nome_dia_semana FROM eventos;

-- 4 a)
SELECT produto,
    IF(quantidade > 0, 'Em estoque', 'Fora de estoque') as status_estoque
FROM produtos;

-- b)
SELECT produto,
    CASE 
        WHEN preco < 10 THEN 'Barato'
        WHEN preco >= 10 AND preco < 50 THEN 'Médio'
        ELSE 'Caro'
    END AS categoria_preco
FROM produtos;

-- 5 a)
DELIMITER //
CREATE FUNCTION TOTAL_VALOR(preco DECIMAL(10, 2), quantidade INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    RETURN preco * quantidade;
END;
//
DELIMITER ;

-- b)
SELECT produto, TOTAL_VALOR(preco, quantidade) as valor_total FROM produtos;

-- 6 a)
SELECT COUNT(*) as total_produtos FROM produtos;

-- b)
SELECT produto, MAX(preco) AS produto_mais_caro
FROM produtos
GROUP BY produto;

-- c)
SELECT produto, MIN(preco) AS produto_mais_barato
FROM produtos
GROUP BY produto;

-- d)
SELECT SUM(IF(quantidade > 0, preco, 0)) as soma_total_estoque FROM produtos;

-- 7 a)
DELIMITER //
CREATE FUNCTION Fatorial(n INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE resultado INT DEFAULT 1;
    WHILE n > 0 DO
        SET resultado = resultado * n;
        SET n = n - 1;
    END WHILE;
    RETURN resultado;
END;
//
DELIMITER ;

-- b)
DELIMITER //
CREATE FUNCTION CalculaExponencial(base INT, expoente INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE resultado INT DEFAULT 1;
    DECLARE i INT;
    
    SET i = 1;
    
    WHILE i <= expoente DO
        SET resultado = resultado * base;
        SET i = i + 1;
    END WHILE;
    
    RETURN resultado;
END;
//
DELIMITER ;

-- c)
DELIMITER //
CREATE FUNCTION VerificaPalindromo(palavra VARCHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE reverso VARCHAR(255);
    
    SET reverso = REVERSE(palavra);
    
    IF palavra = reverso THEN
        RETURN 1; -- É um palíndromo
    ELSE
        RETURN 0; -- Não é um palíndromo
    END IF;
END;
//
DELIMITER ;
