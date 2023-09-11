SELECT titulo FROM livros;

SELECT nome, nascimento FROM autores WHERE YEAR(nascimento) < 1900;

SELECT l.titulo
FROM livros l
JOIN autores a ON l.autor_id = a.id
WHERE a.nome = 'J.K. Rowling';

SELECT alunos.nome
FROM alunos
INNER JOIN matriculas ON alunos.id = matriculas.aluno_id
WHERE matriculas.curso = 'Engenharia de Software';

SELECT produto, SUM(receita) as receita_totalFROM vendasGROUP BY produto;

SELECT a.nome, COUNT(l.id) as numero_livros
FROM autores a
LEFT JOIN livros l ON a.id = l.autor_id
GROUP BY a.nome;

SELECT curso, COUNT(*) as numero_alunosFROM matriculasGROUP BY curso;

SELECT produto, AVG(receita) as media_receitaFROM vendasGROUP BY produto;

SELECT produto, SUM(receita) as receita_totalFROM vendasGROUP BY produtoHAVING receita_total > 10000;

SELECT a.nome, COUNT(l.id) as numero_livrosFROM autores aLEFT JOIN livros l ON a.id = l.autor_idGROUP BY a.nomeHAVING numero_livros > 2;

SELECT l.titulo, a.nome
FROM livros l
JOIN autores a ON l.autor_id = a.id;

SELECT alunos.nome, matriculas.curso
FROM alunos
LEFT JOIN matriculas ON alunos.id = matriculas.aluno_id;

SELECT a.nome, l.titulo
FROM autores a
LEFT JOIN livros l ON a.id = l.autor_id;

SELECT alunos.nome, matriculas.cursoFROM matriculasRIGHT JOIN alunos ON matriculas.aluno_id = alunos.id;

SELECT alunos.nome, matriculas.curso
FROM alunos
INNER JOIN matriculas ON alunos.id = matriculas.aluno_id;

SELECT a.nome, COUNT(l.id) as numero_livros
FROM autores a
LEFT JOIN livros l ON a.id = l.autor_id
GROUP BY a.nome
ORDER BY numero_livros DESC
LIMIT 1;
