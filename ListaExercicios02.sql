DELIMITER //
CREATE PROCEDURE sp_ListarAutores()
BEGIN
    SELECT * FROM Autor;
END //
DELIMITER ;
CALL sp_ListarAutores();


DELIMITER //

CREATE PROCEDURE sp_LivrosPorCategoria(IN categoria_nome VARCHAR(100))
BEGIN
    SELECT Livro.Titulo, Autor.Nome, Autor.Sobrenome
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    INNER JOIN Autor_Livro ON Livro.Livro_ID = Autor_Livro.Livro_ID
    INNER JOIN Autor ON Autor_Livro.Autor_ID = Autor.Autor_ID
    WHERE Categoria.Nome = categoria_nome;
END //
DELIMITER ;
-- Teste com a categoria "Romance"
CALL sp_LivrosPorCategoria('Romance');

-- Teste com a categoria "Ciência"
CALL sp_LivrosPorCategoria('Ciência');

-- Teste com a categoria "Ficção Científica"
CALL sp_LivrosPorCategoria('Ficção Científica');


DELIMITER //

CREATE PROCEDURE sp_ContarLivrosPorCategoria(IN categoria_nome VARCHAR(100), OUT total_livros INT)
BEGIN
    SELECT COUNT(*) INTO total_livros
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoria_nome;
END //

DELIMITER ;

-- Chama a stored procedure com a categoria "Romance"
SET @resultado = 0;
CALL sp_ContarLivrosPorCategoria('Romance', @resultado);

-- Exibe o resultado
SELECT @resultado;


DELIMITER //

CREATE PROCEDURE sp_VerificarLivrosCategoria(IN categoria_nome VARCHAR(100), OUT possui_livros BOOLEAN)
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoria_nome;
    
    IF total > 0 THEN
        SET possui_livros = TRUE;
    ELSE
        SET possui_livros = FALSE;
    END IF;
END //

DELIMITER ;

-- Chama a stored procedure com a categoria "Romance"
CALL sp_VerificarLivrosCategoria('Romance', @resultado);

-- Exibe o resultado (0 para "Não possui livros" ou 1 para "Possui livros")
SELECT @resultado;


DELIMITER //

CREATE PROCEDURE sp_LivrosAteAno(IN ano_limite INT)
BEGIN
    SELECT Titulo, Ano_Publicacao
    FROM Livro
    WHERE Ano_Publicacao <= ano_limite;
END //

DELIMITER ;

-- Chama a stored procedure para listar livros publicados até o ano de 2010
CALL sp_LivrosAteAno(2010);


DELIMITER //

CREATE PROCEDURE sp_TitulosPorCategoria(IN categoria_nome VARCHAR(100))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE livro_titulo VARCHAR(255);
    DECLARE cur CURSOR FOR
        SELECT Livro.Titulo
        FROM Livro
        INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
        WHERE Categoria.Nome = categoria_nome;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    FETCH cur INTO livro_titulo;

    WHILE NOT done DO
        SELECT livro_titulo AS 'Título do Livro';
        FETCH cur INTO livro_titulo;
    END WHILE;

    CLOSE cur;
END //

DELIMITER ;

-- Chama a stored procedure para extrair títulos da categoria "Romance"
CALL sp_TitulosPorCategoria('Romance');
