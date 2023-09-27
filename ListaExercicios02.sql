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


DELIMITER //

CREATE PROCEDURE sp_AdicionarLivro(
    IN titulo_livro VARCHAR(255),
    IN editora_id INT,
    IN ano_publicacao INT,
    IN numero_paginas INT,
    IN categoria_id INT,
    OUT mensagem VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SET mensagem = 'Erro: O título do livro já existe.';
    END;

    INSERT INTO Livro (Titulo, Editora_ID, Ano_Publicacao, Numero_Paginas, Categoria_ID)
    VALUES (titulo_livro, editora_id, ano_publicacao, numero_paginas, categoria_id);
    
    SET mensagem = 'Livro adicionado com sucesso.';
END //

DELIMITER ;

-- Tentativa de adicionar um livro com um título existente (deve gerar um erro)
CALL sp_AdicionarLivro('A Jornada', 1, 2022, 400, 1, @mensagem);
-- Exibe a mensagem de retorno
SELECT @mensagem;

-- Tentativa de adicionar um novo livro
CALL sp_AdicionarLivro('Novo Livro', 2, 2022, 300, 2, @mensagem);
-- Exibe a mensagem de retorno
SELECT @mensagem;


DELIMITER //

CREATE PROCEDURE sp_AutorMaisAntigo(OUT nome_autor VARCHAR(255))
BEGIN
    SELECT CONCAT(Nome, ' ', Sobrenome) INTO nome_autor
    FROM Autor
    WHERE Data_Nascimento = (SELECT MIN(Data_Nascimento) FROM Autor);
END //

DELIMITER ;

-- Chama a stored procedure para encontrar o autor mais antigo
CALL sp_AutorMaisAntigo(@nome_autor);

-- Exibe o nome do autor mais antigo
SELECT @nome_autor;


-- 9 SELECT Livro.Titulo, CONCAT(Autor.Nome, ' ', Autor.Sobrenome) AS 'Nome do Autor': Esta parte da consulta SQL seleciona o título do livro da tabela "Livro" e concatena o nome e sobrenome do autor da tabela "Autor" em uma única coluna chamada 'Nome do Autor'. Usamos a função CONCAT para combinar o nome e o sobrenome do autor.
-- FROM Livro: Estamos selecionando dados da tabela "Livro."
-- INNER JOIN Autor_Livro ON Livro.Livro_ID = Autor_Livro.Livro_ID: Usamos uma junção interna para combinar os registros da tabela "Livro" com os registros da tabela "Autor_Livro" com base na correspondência dos IDs de livro.
-- INNER JOIN Autor ON Autor_Livro.Autor_ID = Autor.Autor_ID: Continuamos com outra junção interna, ligando os registros da tabela "Autor_Livro" aos registros da tabela "Autor" usando a correspondência dos IDs de autor.
-- Essa stored procedure retorna uma lista de todos os livros e seus respectivos autores, onde cada linha contém o título do livro e o nome


DELIMITER //

CREATE PROCEDURE sp_LivrosESeusAutores()
BEGIN
    -- Seleciona o título do livro, nome e sobrenome do autor
    SELECT Livro.Titulo, CONCAT(Autor.Nome, ' ', Autor.Sobrenome) AS 'Nome do Autor'
    FROM Livro
    INNER JOIN Autor_Livro ON Livro.Livro_ID = Autor_Livro.Livro_ID
    INNER JOIN Autor ON Autor_Livro.Autor_ID = Autor.Autor_ID;
END //

DELIMITER ;

-- Chama a stored procedure para listar os livros e seus autores
CALL sp_LivrosESeusAutores();
