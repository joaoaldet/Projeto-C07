-- criacao do banco de dados
drop database if exists biblioteca_db;
create database biblioteca_db;
use biblioteca_db;

-- tabela autor
create table autor 
(
	id_autor int primary key not null auto_increment,
    nome varchar(100) not null,
    nacionalidade varchar(50) default null
);

-- tabela editora
create table editora 
(
	id_editora int primary key not null auto_increment,
    nome varchar(100) not null,
    cidade varchar(50) default null
);

-- tabela usuario
create table usuario 
(
    id_usuario int primary key not null auto_increment,
    nome varchar(100) not null,
    email varchar(100) default null unique -- define como nulo quando o usuario não preenche um email
);

-- tabela livro
create table livro 
(
	id_livro int primary key not null auto_increment,
    titulo varchar(150) not null,
    ano_publicacao int default null,
    id_editora int default null,

    constraint fk_livro_editora foreign key (id_editora) references editora(id_editora)
);

-- tabela emprestimo
create table emprestimo 
(
	id_emprestimo int primary key not null auto_increment,
    data_emprestimo date not null,
    data_devolucao date default null,
    id_usuario int default null,

    constraint fk_emprestimo_usuario foreign key (id_usuario) references usuario(id_usuario)
);

-- tabela autoria_livro
-- tabela N:M entre autor e livro
create table autoria_livro 
(
    id_livro int not null,
    id_autor int not null,
    
    primary key (id_livro, id_autor),

    constraint fk_autoria_livro_livro foreign key (id_livro) references livro(id_livro),
    constraint fk_autoria_livro_autor foreign key (id_autor) references autor(id_autor)
);

-- tabela item_emprestimo
-- tabela N:M entre emprestimo e livro
create table item_emprestimo (
    id_emprestimo int not null,
    id_livro int not null,
    
    primary key (id_emprestimo, id_livro),

    constraint fk_item_emprestimo_emprestimo foreign key (id_emprestimo) references emprestimo(id_emprestimo),
    constraint fk_item_emprestimo_livro foreign key (id_livro) references livro(id_livro)
);

-- tabela multa
create table multa 
(
    id_multa int primary key not null auto_increment,
    valor decimal(10,2) default null,
    paga tinyint default null,
    id_emprestimo int default NULL unique,

    constraint fk_multa_emprestimo foreign key (id_emprestimo) references emprestimo(id_emprestimo)
);

insert into autor (nome, nacionalidade) values
('Machado de Assis', 'Brasileira'),
('J. K. Rowling', 'Britânica'),
('George Orwell', 'Britânica'),
('Clarice Lispector', 'Ucraniana'),
('J. R. R. Tolkien', 'Britânica');

insert into editora (nome, cidade) values
('Companhia das Letras', 'São Paulo'),
('Rocco', 'Rio de Janeiro'),
('Intrínseca', 'Rio de Janeiro'),
('Editora Record', 'Rio de Janeiro'),
('HarperCollins', 'São Paulo');

insert into usuario (nome, email) values
('João Silva', 'joao@gmail.com'),
('Maria Oliveira', 'maria@gmail.com'),
('Pedro Santos', 'pedro@gmail.com'),
('Ana Costa', 'ana@gmail.com'),
('Lucas Ferreira', 'lucas@gmail.com');

insert into livro (titulo, ano_publicacao, id_editora) values
('Dom Casmurro', 1899, 1),
('Harry Potter e a Pedra Filosofal', 1997, 2),
('1984', 1949, 3),
('A Hora da Estrela', 1977, 4),
('O Senhor dos Anéis', 1954, 5);

insert into emprestimo (data_emprestimo, data_devolucao, id_usuario) values
('2026-10-01', '2026-10-15', 1),
('2026-10-03', '2026-10-17', 2),
('2026-10-05', NULL, 3),
('2026-10-07', '2026-10-21', 4),
('2026-10-10', NULL, 5);

insert into autoria_livro (id_livro, id_autor) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

insert into item_emprestimo (id_emprestimo, id_livro) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

insert into multa (valor, paga, id_emprestimo) values
(15.00, 1, 1),
(25.50, 0, 2),
(10.00, 0, 3),
(30.00, 1, 4),
(12.50, 0, 5);

-- a biblioteca adquiriu um novo livro (insert para adicionar o livro na tabela)
insert into livro (titulo, ano_publicacao, id_editora)
values ('O Hobbit', 1937, 5);

-- registrando emprestimo realizado pelo usuario
insert into emprestimo (data_emprestimo, data_devolucao, id_usuario)
values ('2026-11-10', NULL, 1);

-- associando o livro ao emprestimo e adicionando na tabela
insert into item_emprestimo (id_emprestimo, id_livro)
values (6, 6);

-- um usuario informou que mudou o endereco de email e precisa atualizar o cadastro (update para atualizar as informacoes da tabela)
update usuario
set email = 'joao.silva@gmail.com'
where id_usuario = 1;

-- usuario devolveu um livro com atraso e a biblioteca precisa registrar uma multa
insert into multa (valor, paga, id_emprestimo)
values (20.00, 0, 6);

-- devolução de um livro (update para atualizar a data de devolução)
update emprestimo
set data_devolucao = '2026-12-17'
where id_emprestimo = 6;

-- usuario realizou o pagamento de uma multa (atualizando "paga" para 1 para indicar que a multa foi paga)
update multa
set paga = 1
where id_emprestimo = 6;

-- durante o cadastro de um emprestimo um funcionario associou um livro incorreto ao registro (delete para remover a associacao)
delete from item_emprestimo
where id_emprestimo = 1
and id_livro = 1;

-- removendo usuarios e role caso ja existam
drop role if exists 'bibliotecario';

drop user if exists
'bibliotecario1'@'localhost',
'bibliotecario2'@'localhost';

-- criando usuarios
create user 'bibliotecario1'@'localhost' identified by 'senha123';
create user 'bibliotecario2'@'localhost' identified by 'senha456';

-- criando uma nova role
create role 'bibliotecario';

-- adicionando permissoes a role
grant select, insert, update, delete
ON biblioteca_db.*
TO 'bibliotecario';

-- associando usuario as roles
grant 'bibliotecario' to 'bibliotecario1'@'localhost';
grant 'bibliotecario' to 'bibliotecario2'@'localhost';

set default role 'bibliotecario'
TO 'bibliotecario1'@'localhost';

set default role 'bibliotecario'
TO 'bibliotecario2'@'localhost';

-- relacionamento 1:1
select
    e.id_emprestimo,
    u.nome as nome_usuario,
    e.data_emprestimo,
    e.data_devolucao,
    m.id_multa,
    m.valor as valor_multa,
    m.paga
from emprestimo e
inner join usuario u
    on e.id_usuario = u.id_usuario
inner join multa m
    on e.id_emprestimo = m.id_emprestimo;
    
    -- relacionamento 1:N
    select
    u.id_usuario,
    u.nome as nome_usuario,
    count(e.id_emprestimo) as quantidade_emprestimos
from usuario u
left join emprestimo e
    on u.id_usuario = e.id_usuario
group by
    u.id_usuario,
    u.nome;

-- relacionamento N:M
    select
    l.id_livro,
    l.titulo,
    a.nome as nome_autor,
    a.nacionalidade,
    ed.nome as nome_editora
from livro l
inner join autoria_livro al
    on l.id_livro = al.id_livro
inner join autor a
    on al.id_autor = a.id_autor
inner join editora ed
    on l.id_editora = ed.id_editora;
    
    
    DELIMITER $$

create procedure registrar_emprestimo
(
    in p_id_usuario int,
    in p_id_livro int,
    in p_data_emprestimo date
)
begin
    declare v_id_emprestimo int;

    -- cadastrando o emprestimo
    insert into emprestimo (data_emprestimo, data_devolucao, id_usuario)
    values (p_data_emprestimo, null, p_id_usuario);

    -- recuperando o id do emprestimo cadastrado
    set v_id_emprestimo = LAST_INSERT_ID();

    -- associando o livro ao emprestimo
    insert into item_emprestimo (id_emprestimo, id_livro)
    values (v_id_emprestimo, p_id_livro);

end$$


DELIMITER ;

create view vw_livros_autores as
select
    l.id_livro,
    l.titulo,
    l.ano_publicacao,
    a.nome as nome_autor,
    ed.nome as nome_editora
from livro l
inner join autoria_livro al
    on l.id_livro = al.id_livro
inner join autor a
    on al.id_autor = a.id_autor
inner join editora ed
    on l.id_editora = ed.id_editora;
    
    
    DELIMITER $$

create trigger verificar_valor_multa
before insert on multa
for each row
begin
    if new.valor < 0 then
        signal sqlstate '45000'
        set message_text = 'O valor da multa nao pode ser negativo';
    end if;
end$$

DELIMITER ;


DELIMITER $$

create function calcular_total_multas_pendentes()
returns decimal(10,2)
reads sql data
begin
    declare v_total decimal(10,2);

    select SUM(valor)
    into v_total
    from multa
    where paga = 0;

    return IFNULL(v_total, 0);
end$$

DELIMITER ;