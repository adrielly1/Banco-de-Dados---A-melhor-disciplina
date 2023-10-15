-- 1
DELIMITER //
CREATE FUNCTION total_livros_por_genero(genero VARCHAR(255))
RETURNS INT
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Livro L
    INNER JOIN Genero G ON L.id_genero = G.id
    WHERE G.genero = genero;
    RETURN total;
END;
//
DELIMITER ;

-- 2

DELIMITER //
CREATE FUNCTION livros_por_autor(p_nome VARCHAR(255), u_nome VARCHAR(255))
RETURNS TEXT
BEGIN
    DECLARE l_livros TEXT;
    SET l_livros = '';

    SELECT GROUP_CONCAT(L.titulo) INTO l_livros
    FROM Livro_Autor LA
    INNER JOIN Livro L ON LA.id_livro = L.id
    INNER JOIN Autor A ON LA.id_autor = A.id
    WHERE A.p_nome = p_nome AND A.u_nome = u_nome;

    RETURN l_livros;
END;
//
DELIMITER ;

-- 3

DELIMITER //
CREATE FUNCTION resumos()
RETURNS INT
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE livro_id INT;

    DECLARE cur CURSOR FOR
    SELECT id
    FROM Livro;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    up_loop: LOOP
        FETCH cur INTO livro_id;

        IF done = 1 THEN
            LEAVE up_loop;
        END IF;

        UPDATE Livro
        SET resumo = CONCAT(resumo, ' Este é um excelente livro!')
        WHERE id = livro_id;
    END LOOP;

    CLOSE cur;

    RETURN 1;
END;
//
DELIMITER ;

-- 4
DELIMITER //
CREATE FUNCTION livros_por_editora()
RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE media DECIMAL(5,2);

    SELECT AVG(editora) INTO media
    FROM (SELECT id_editora, COUNT(*) AS editora
          FROM Livro
          GROUP BY id_editora) AS temp;

    RETURN media;
END;
//
DELIMITER ;



-- 5 

DELIMITER //
CREATE FUNCTION autores_sem_livros()
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE l_autores_sem_livros TEXT;
    SET l_autores_sem_livros = '';

    SELECT GROUP_CONCAT(CONCAT(p_nome, ' ', u_nome)) INTO l_autores_sem_livros
    FROM Autor
    WHERE id NOT IN (SELECT DISTINCT id_autor FROM Livro_Autor);

    RETURN l_autores_sem_livros;
END;
//
DELIMITER ;
