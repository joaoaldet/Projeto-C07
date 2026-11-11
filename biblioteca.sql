-- PROJETO DE BANCO DE DADOS - BIBLIOTECA
-- MySQL 8.0+ | Executar com uma conta autorizada a criar banco, usuarios e roles.
-- ATENCAO: a execucao apaga e recria o banco biblioteca_db.

-- 1. CRIACAO DO BANCO E DAS TABELAS (DDL)
DROP DATABASE IF EXISTS biblioteca_db;
CREATE DATABASE biblioteca_db CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE biblioteca_db;

CREATE TABLE autor (
    id_autor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50) DEFAULT NULL
);

CREATE TABLE editora (
    id_editora INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(50) DEFAULT NULL
);

CREATE TABLE usuario (
    id_usuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE DEFAULT NULL -- email opcional, mas unico quando informado
);

CREATE TABLE livro (
    id_livro INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    ano_publicacao INT DEFAULT NULL,
    id_editora INT DEFAULT NULL,
    CONSTRAINT fk_livro_editora FOREIGN KEY (id_editora) REFERENCES editora(id_editora)
);

CREATE TABLE emprestimo (
    id_emprestimo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE DEFAULT NULL,
    id_usuario INT DEFAULT NULL,
    CONSTRAINT fk_emprestimo_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- N:M entre livro e autor; a PK composta impede a repeticao do par.
CREATE TABLE autoria_livro (
    id_livro INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_livro, id_autor),
    CONSTRAINT fk_autoria_livro_livro FOREIGN KEY (id_livro) REFERENCES livro(id_livro),
    CONSTRAINT fk_autoria_livro_autor FOREIGN KEY (id_autor) REFERENCES autor(id_autor)
);

-- N:M entre emprestimo e livro; cada emprestimo pode conter diversos livros.
CREATE TABLE item_emprestimo (
    id_emprestimo INT NOT NULL,
    id_livro INT NOT NULL,
    PRIMARY KEY (id_emprestimo, id_livro),
    CONSTRAINT fk_item_emprestimo_emprestimo FOREIGN KEY (id_emprestimo) REFERENCES emprestimo(id_emprestimo),
    CONSTRAINT fk_item_emprestimo_livro FOREIGN KEY (id_livro) REFERENCES livro(id_livro)
);

-- 1:1 opcional do lado de emprestimo: cada emprestimo possui no maximo uma multa.
-- Uma multa, quando existe, deve apontar obrigatoriamente para um emprestimo.
CREATE TABLE multa (
    id_multa INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    valor DECIMAL(10,2) NOT NULL,
    paga TINYINT(1) NOT NULL DEFAULT 0,
    id_emprestimo INT NOT NULL UNIQUE,
    CONSTRAINT fk_multa_emprestimo FOREIGN KEY (id_emprestimo) REFERENCES emprestimo(id_emprestimo),
    CONSTRAINT chk_multa_valor CHECK (valor >= 0),
    CONSTRAINT chk_multa_paga CHECK (paga IN (0, 1))
);

-- 2. REGISTROS INICIAIS (DML: INSERT)
-- INSERT cadastra novos dados necessarios para utilizar e testar o sistema.
INSERT INTO autor (nome, nacionalidade) VALUES
('Machado de Assis', 'Brasileira'),
('J. K. Rowling', 'Britânica'),
('George Orwell', 'Britânica'),
('Clarice Lispector', 'Ucraniana'),
('J. R. R. Tolkien', 'Britânica');

INSERT INTO editora (nome, cidade) VALUES
('Companhia das Letras', 'São Paulo'),
('Rocco', 'Rio de Janeiro'),
('Intrínseca', 'Rio de Janeiro'),
('Editora Record', 'Rio de Janeiro'),
('HarperCollins', 'São Paulo');

INSERT INTO usuario (nome, email) VALUES
('João Silva', 'joao@gmail.com'),
('Maria Oliveira', 'maria@gmail.com'),
('Pedro Santos', 'pedro@gmail.com'),
('Ana Costa', 'ana@gmail.com'),
('Lucas Ferreira', 'lucas@gmail.com');

INSERT INTO livro (titulo, ano_publicacao, id_editora) VALUES
('Dom Casmurro', 1899, 1),
('Harry Potter e a Pedra Filosofal', 1997, 2),
('1984', 1949, 3),
('A Hora da Estrela', 1977, 4),
('O Senhor dos Anéis', 1954, 5);

INSERT INTO emprestimo (data_emprestimo, data_devolucao, id_usuario) VALUES
('2026-10-01', '2026-10-15', 1),
('2026-10-03', '2026-10-17', 2),
('2026-10-05', NULL, 3),
('2026-10-07', '2026-10-21', 4),
('2026-10-10', NULL, 5);

INSERT INTO autoria_livro (id_livro, id_autor) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

INSERT INTO item_emprestimo (id_emprestimo, id_livro) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

INSERT INTO multa (valor, paga, id_emprestimo) VALUES
(15.00, 1, 1),
(25.50, 0, 2),
(10.00, 0, 3),
(30.00, 1, 4),
(12.50, 0, 5);

-- 3. EXEMPLOS ADICIONAIS DE DML: INSERT, UPDATE E DELETE
-- INSERT: cadastrar um novo livro comprado pela biblioteca.
INSERT INTO livro (titulo, ano_publicacao, id_editora)
VALUES ('O Hobbit', 1937, 5);
-- INSERT: registrar um emprestimo ficticio e seu livro correspondente.
INSERT INTO emprestimo (data_emprestimo, data_devolucao, id_usuario)
VALUES ('2026-10-20', NULL, 1);
INSERT INTO item_emprestimo (id_emprestimo, id_livro)
VALUES (6, 6);

-- UPDATE: atualizar o email informado por um usuario.
UPDATE usuario
SET email = 'joao.silva@gmail.com'
WHERE id_usuario = 1;

-- INSERT: cadastrar uma multa relativa ao sexto emprestimo (exemplo didatico).
INSERT INTO multa (valor, paga, id_emprestimo)
VALUES (20.00, 0, 6);

-- UPDATE: registrar uma devolucao ja ocorrida, em data posterior ao emprestimo.
UPDATE emprestimo
SET data_devolucao = '2026-11-10'
WHERE id_emprestimo = 6;

-- UPDATE: marcar a multa como paga apos a confirmacao do pagamento.
UPDATE multa
SET paga = 1
WHERE id_emprestimo = 6;

-- DELETE: demonstrar a exclusao de uma associacao inserida por engano.
-- O livro 6 permanece associado ao emprestimo 6; nao fica emprestimo sem item.
INSERT INTO item_emprestimo (id_emprestimo, id_livro)
VALUES (6, 1); -- associacao indevida simulada
DELETE FROM item_emprestimo
WHERE id_emprestimo = 6 AND id_livro = 1;

-- 4. ROLE E USUARIOS (DCL)
-- Credenciais apenas didaticas; para uso real, substitua por senhas fortes e secretas.
DROP USER IF EXISTS 'bibliotecario1'@'localhost', 'bibliotecario2'@'localhost';
DROP ROLE IF EXISTS 'bibliotecario';
CREATE ROLE 'bibliotecario';
GRANT SELECT, INSERT, UPDATE, DELETE ON biblioteca_db.* TO 'bibliotecario';
CREATE USER 'bibliotecario1'@'localhost' IDENTIFIED BY 'senha123';
CREATE USER 'bibliotecario2'@'localhost' IDENTIFIED BY 'senha456';
GRANT 'bibliotecario' TO 'bibliotecario1'@'localhost';
GRANT 'bibliotecario' TO 'bibliotecario2'@'localhost';
SET DEFAULT ROLE 'bibliotecario' TO 'bibliotecario1'@'localhost';
SET DEFAULT ROLE 'bibliotecario' TO 'bibliotecario2'@'localhost';

-- 5. CONSULTAS COMPLEXAS COM JOIN
-- 1:1 (emprestimo/multa): identificar as multas ligadas a emprestimos e usuarios.
SELECT e.id_emprestimo, u.nome AS nome_usuario,
       e.data_emprestimo, e.data_devolucao,
       m.id_multa, m.valor AS valor_multa, m.paga
FROM emprestimo AS e
JOIN usuario AS u ON e.id_usuario = u.id_usuario
JOIN multa AS m ON e.id_emprestimo = m.id_emprestimo;

-- 1:N (usuario/emprestimo): contar emprestimos por usuario, inclusive quem nao emprestou.
SELECT u.id_usuario, u.nome AS nome_usuario,
       COUNT(e.id_emprestimo) AS quantidade_emprestimos
FROM usuario AS u
LEFT JOIN emprestimo AS e ON u.id_usuario = e.id_usuario
GROUP BY u.id_usuario, u.nome;

-- N:M (livro/autor): mostrar titulo, autor e editora por meio da tabela associativa.
SELECT l.id_livro, l.titulo, a.nome AS nome_autor,
       a.nacionalidade, ed.nome AS nome_editora
FROM livro AS l
JOIN autoria_livro AS al ON l.id_livro = al.id_livro
JOIN autor AS a ON al.id_autor = a.id_autor
JOIN editora AS ed ON l.id_editora = ed.id_editora;

-- 6. PROCEDURE: registrar emprestimo e item como uma unica operacao atomica.
DELIMITER $$
CREATE PROCEDURE registrar_emprestimo(
    IN p_id_usuario INT,
    IN p_id_livro INT,
    IN p_data_emprestimo DATE
)
BEGIN
    DECLARE v_id_emprestimo INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    INSERT INTO emprestimo (data_emprestimo, data_devolucao, id_usuario)
    VALUES (p_data_emprestimo, NULL, p_id_usuario);
    SET v_id_emprestimo = LAST_INSERT_ID();
    INSERT INTO item_emprestimo (id_emprestimo, id_livro)
    VALUES (v_id_emprestimo, p_id_livro);
    COMMIT;
END$$
DELIMITER ;

-- 7. VIEW: consulta reutilizavel de livros, autores e editoras.
CREATE VIEW vw_livros_autores AS
SELECT l.id_livro, l.titulo, l.ano_publicacao,
       a.nome AS nome_autor, ed.nome AS nome_editora
FROM livro AS l
JOIN autoria_livro AS al ON l.id_livro = al.id_livro
JOIN autor AS a ON al.id_autor = a.id_autor
JOIN editora AS ed ON l.id_editora = ed.id_editora;

-- 8. TRIGGERS: rejeitar multas negativas em INSERT e em UPDATE.
-- CHECK reforca a mesma regra no nivel da tabela (defesa adicional).
DELIMITER $$
CREATE TRIGGER verificar_valor_multa
BEFORE INSERT ON multa
FOR EACH ROW
BEGIN
    IF NEW.valor < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'O valor da multa nao pode ser negativo';
    END IF;
END$$

CREATE TRIGGER verificar_valor_multa_update
BEFORE UPDATE ON multa
FOR EACH ROW
BEGIN
    IF NEW.valor < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'O valor da multa nao pode ser negativo';
    END IF;
END$$
DELIMITER ;

-- 9. FUNCTION: somar multas nao pagas, retornando zero quando nao houver nenhuma.
DELIMITER $$
CREATE FUNCTION calcular_total_multas_pendentes()
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT SUM(valor) INTO v_total
    FROM multa
    WHERE paga = 0;
    RETURN IFNULL(v_total, 0);
END$$
DELIMITER ;

-- 10. TESTES DEMONSTRATIVOS (CONSULTAS E CHAMADA DA PROCEDURE)
-- Este CALL gera um novo emprestimo (ID 7) com seu respectivo item.
CALL registrar_emprestimo(2, 2, '2026-11-11');
SELECT * FROM emprestimo WHERE id_emprestimo = 7;
SELECT * FROM item_emprestimo WHERE id_emprestimo = 7;

-- Consulta da View e da Function.
SELECT * FROM vw_livros_autores;
SELECT calcular_total_multas_pendentes() AS total_multas_pendentes;

-- Conferencia do minimo de 5 registros por tabela.
SELECT 'autor' AS tabela, COUNT(*) AS total FROM autor
UNION ALL SELECT 'editora', COUNT(*) FROM editora
UNION ALL SELECT 'usuario', COUNT(*) FROM usuario
UNION ALL SELECT 'livro', COUNT(*) FROM livro
UNION ALL SELECT 'emprestimo', COUNT(*) FROM emprestimo
UNION ALL SELECT 'autoria_livro', COUNT(*) FROM autoria_livro
UNION ALL SELECT 'item_emprestimo', COUNT(*) FROM item_emprestimo
UNION ALL SELECT 'multa', COUNT(*) FROM multa;

-- TESTES NEGATIVOS OPCIONAIS: EXECUTAR UM DE CADA VEZ, EM SEPARADO.
-- As duas operacoes abaixo DEVEM falhar com erro SQLSTATE 45000.
-- INSERT INTO multa (valor, paga, id_emprestimo) VALUES (-5.00, 0, 7);
-- UPDATE multa SET valor = -1.00 WHERE id_emprestimo = 2;
-- Teste de rollback da procedure: ID de livro inexistente deve gerar erro,
-- e nenhuma nova linha deve permanecer em emprestimo.
-- CALL registrar_emprestimo(1, 999999, '2026-11-11');
