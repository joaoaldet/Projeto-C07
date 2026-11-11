# Projeto de Banco de Dados — Biblioteca

## Integrantes

- Enderson Augusto Rodrigues Santos
- Guilherme Rodrigues Faria
- João Vitor Souza Aldet

## 1. Tema

**Biblioteca**

## 2. Descrição do Projeto

O projeto consiste no desenvolvimento de um banco de dados relacional MySQL para o gerenciamento de uma biblioteca.

O sistema permite cadastrar usuários, livros, autores e editoras, além de registrar empréstimos, devoluções e multas.

Para garantir a integridade dos dados e facilitar as operações, foram implementados relacionamentos 1:1, 1:N e N:M, comandos de manipulação de dados (DML), consultas com JOIN, controle de acesso por ROLE, Stored Procedure, View, Triggers e Function.

### Arquivos do Projeto

- `biblioteca.sql` — Script completo de criação do banco, inserção de dados, consultas, usuários, permissões e objetos SQL.
- `biblioteca.mwb` — Modelo físico do banco de dados desenvolvido no MySQL Workbench.
- `README.md` — Documentação das implementações e justificativas técnicas.

## 3. Estrutura do Banco de Dados

O banco de dados, denominado `biblioteca_db`, contém oito tabelas:

| Tabela | Descrição |
|---|---|
| `usuario` | Armazena os dados dos usuários da biblioteca. |
| `autor` | Armazena as informações dos autores. |
| `editora` | Armazena os dados das editoras. |
| `livro` | Registra os livros e suas respectivas editoras. |
| `emprestimo` | Registra os empréstimos realizados pelos usuários. |
| `autoria_livro` | Relaciona livros aos seus autores. |
| `item_emprestimo` | Relaciona os livros aos empréstimos realizados. |
| `multa` | Armazena as multas associadas aos empréstimos. |

### 3.1. Relacionamentos

**Relacionamento 1:1 — Empréstimo e Multa**

Cada empréstimo pode possuir, no máximo, uma multa, e cada multa pertence obrigatoriamente a um empréstimo.

Esse relacionamento é garantido pela chave estrangeira `id_emprestimo`, definida como `UNIQUE` e `NOT NULL` na tabela `multa`.

**Relacionamento 1:N — Usuário e Empréstimo**

Um usuário pode realizar diversos empréstimos, enquanto cada empréstimo pertence a um único usuário.

O relacionamento é estabelecido pela chave estrangeira `id_usuario` na tabela `emprestimo`.

**Relacionamento 1:N — Editora e Livro**

Uma editora pode publicar diversos livros, enquanto cada livro cadastrado possui uma editora associada.

O relacionamento é estabelecido pela chave estrangeira `id_editora` na tabela `livro`.

**Relacionamento N:M — Livro e Autor**

Um livro pode possuir vários autores, assim como um autor pode escrever diversos livros.

Esse relacionamento é implementado por meio da tabela intermediária `autoria_livro`.

**Relacionamento N:M — Empréstimo e Livro**

Um empréstimo pode conter diversos livros, enquanto um mesmo livro cadastrado pode participar de diferentes empréstimos.

Esse relacionamento é implementado pela tabela intermediária `item_emprestimo`.

As tabelas intermediárias utilizam chaves primárias compostas para impedir a duplicação de associações.

## 4. Criação e Inserção de Dados

O script SQL utiliza comandos DDL para criar o banco de dados e suas respectivas tabelas.

Os principais comandos utilizados são:

- `CREATE DATABASE` — Cria o banco de dados.
- `CREATE TABLE` — Define as tabelas, seus atributos e restrições.
- `DROP DATABASE IF EXISTS` — Remove o banco anteriormente criado, permitindo executar novamente o script em ambiente de testes.

Após a criação da estrutura, são utilizados comandos `INSERT` para inserir, no mínimo, cinco registros em cada tabela.

Esses registros permitem testar os relacionamentos, executar consultas e verificar o funcionamento dos objetos implementados.

## 5. Manipulação de Dados — DML

Foram utilizados os comandos `INSERT`, `UPDATE` e `DELETE` para representar situações reais de gerenciamento de uma biblioteca.

### 5.1. INSERT

**Objetivo:** Adicionar novos registros ao banco de dados.

O comando é utilizado no cadastro de usuários, autores, editoras, livros, empréstimos e multas.

Também foi utilizado para simular a aquisição de um novo livro, denominado *O Hobbit*, e o registro de um novo empréstimo.

**Justificativa:** Permitir a inclusão de informações necessárias para o funcionamento e a atualização do acervo da biblioteca.

### 5.2. UPDATE

**Objetivo:** Modificar informações de registros existentes.

O comando foi utilizado para representar três situações:

- Atualização do endereço de e-mail de um usuário.
- Registro da data de devolução de um livro.
- Atualização da situação de pagamento de uma multa.

**Justificativa:** Manter as informações do banco de dados atualizadas sem precisar excluir e cadastrar novamente os registros.

### 5.3. DELETE

**Objetivo:** Remover registros ou associações incorretas.

O comando foi utilizado para simular a correção de um erro no cadastro de um empréstimo, no qual um livro foi associado indevidamente.

A associação incorreta é removida da tabela `item_emprestimo`, preservando o empréstimo e seu vínculo com o livro correto.

**Justificativa:** Permitir a correção de informações equivocadas sem comprometer os demais registros do banco de dados.

## 6. Controle de Acesso — Usuários e ROLE

Foram criados dois usuários MySQL:

- `bibliotecario1`
- `bibliotecario2`

Também foi criada uma ROLE denominada `bibliotecario`.

A ROLE recebeu as seguintes permissões sobre o banco `biblioteca_db`:

| Permissão | Finalidade |
|---|---|
| `SELECT` | Consultar informações cadastradas. |
| `INSERT` | Adicionar novos registros. |
| `UPDATE` | Atualizar informações existentes. |
| `DELETE` | Remover registros quando necessário. |

Posteriormente, a ROLE foi associada aos dois usuários por meio do comando `GRANT`.

O comando `SET DEFAULT ROLE` foi utilizado para ativar automaticamente as permissões em novas conexões.

**Justificativa:** Centralizar o gerenciamento das permissões, evitando atribuí-las individualmente a cada usuário. Dessa forma, o controle de acesso torna-se mais organizado e facilita futuras alterações.

As senhas definidas no script são apenas demonstrativas e devem ser substituídas por credenciais seguras em ambientes reais.

## 7. Consultas Complexas com JOIN

Foram desenvolvidas três consultas para demonstrar os tipos de relacionamento exigidos.

### 7.1. Relacionamento 1:1

A consulta utiliza `INNER JOIN` entre as tabelas `emprestimo`, `multa` e `usuario`.

Ela permite visualizar:

- Identificador do empréstimo.
- Nome do usuário.
- Datas do empréstimo e da devolução.
- Identificador da multa.
- Valor da multa.
- Situação de pagamento.

**Justificativa:** Facilitar a identificação das multas vinculadas aos empréstimos e dos usuários responsáveis.

### 7.2. Relacionamento 1:N

A consulta utiliza `LEFT JOIN` entre as tabelas `usuario` e `emprestimo`.

Também são utilizados `COUNT` e `GROUP BY` para contabilizar a quantidade de empréstimos realizados por cada usuário.

**Justificativa:** Permitir que a biblioteca acompanhe a utilização de seus serviços, incluindo usuários que ainda não realizaram empréstimos.

### 7.3. Relacionamento N:M

A consulta utiliza `INNER JOIN` entre quatro tabelas:

- `livro`
- `autoria_livro`
- `autor`
- `editora`

Ela permite visualizar o título dos livros, os autores, suas nacionalidades e as respectivas editoras.

**Justificativa:** Reunir informações distribuídas em diferentes tabelas e facilitar a consulta dos dados bibliográficos.

## 8. Objetos Implementados

### 8.1. Stored Procedure — `registrar_emprestimo`

**Objetivo:** Automatizar o registro de empréstimos na biblioteca.

Como o cadastro de um empréstimo exige a inserção de informações em duas tabelas diferentes (`emprestimo` e `item_emprestimo`), a Stored Procedure realiza essas operações automaticamente.

Dessa forma, o funcionário precisa informar apenas o usuário, o livro e a data do empréstimo.

A Procedure utiliza `LAST_INSERT_ID()` para recuperar o identificador do empréstimo recém-cadastrado.

Também utiliza controle de transações com `START TRANSACTION`, `COMMIT` e `ROLLBACK`, além de tratamento de exceções SQL.

Caso ocorra algum erro durante o processo, as alterações realizadas na transação são desfeitas.

**Justificativa:** Simplificar o cadastro, reduzir a necessidade de executar comandos separados e impedir que falhas deixem registros incompletos.

**Exemplo de utilização:**

```sql
CALL registrar_emprestimo(2, 2, '2026-11-11');
```

### 8.2. View — `vw_livros_autores`

**Objetivo:** Facilitar a consulta das informações dos livros cadastrados na biblioteca.

A View reúne informações de quatro tabelas:

- `livro`
- `autoria_livro`
- `autor`
- `editora`

Por meio dela, é possível consultar o título do livro, seu ano de publicação, o nome do autor e a editora responsável.

**Justificativa:** Evitar a necessidade de escrever novamente os comandos `JOIN` sempre que essas informações forem consultadas.

**Exemplo de utilização:**

```sql
SELECT * FROM vw_livros_autores;
```

### 8.3. Trigger — `verificar_valor_multa`

**Objetivo:** Impedir o cadastro de multas com valores negativos.

Sempre que uma nova multa é inserida na tabela `multa`, a Trigger verifica se o valor informado é menor que zero.

Caso seja identificado um valor negativo, a operação é interrompida e uma mensagem de erro é apresentada por meio de `SIGNAL SQLSTATE '45000'`.

**Justificativa:** Garantir a integridade dos dados, impedindo o registro de multas com valores inválidos.

### 8.4. Trigger — `verificar_valor_multa_update`

**Objetivo:** Impedir a atualização de multas para valores negativos.

A Trigger é executada antes de operações `UPDATE` na tabela `multa`.

Caso o novo valor seja negativo, a atualização é rejeitada.

**Justificativa:** Complementar a validação realizada no cadastro, garantindo que uma multa não receba um valor inválido posteriormente.

Essa implementação representa uma funcionalidade adicional ao mínimo exigido no projeto.

### 8.5. Function — `calcular_total_multas_pendentes`

**Objetivo:** Calcular o valor total das multas pendentes de pagamento.

A Function consulta a tabela `multa` e seleciona os registros em que o campo `paga` possui valor igual a `0`, indicando que a multa ainda não foi paga.

Em seguida, realiza a soma dos valores dessas multas utilizando `SUM`.

O comando `IFNULL` garante que o retorno seja zero quando não existirem multas pendentes.

**Justificativa:** Permitir que a biblioteca consulte facilmente o valor total a receber, sem a necessidade de realizar o cálculo manualmente.

**Exemplo de utilização:**

```sql
SELECT calcular_total_multas_pendentes()
AS total_multas_pendentes;
```

## 9. Implementações Extras

Além dos requisitos obrigatórios, foram adicionados mecanismos para melhorar a integridade e a confiabilidade do banco de dados.

### 9.1. Controle de Transações

A Stored Procedure utiliza transações para garantir que todas as operações necessárias ao registro de um empréstimo sejam concluídas corretamente.

Em caso de falha, as alterações são desfeitas por meio de `ROLLBACK`.

### 9.2. Validação em Atualizações

Foi implementada uma Trigger adicional para impedir a atualização de multas para valores negativos.

Isso complementa a validação realizada durante a inserção.

### 9.3. Restrições de Integridade

Foram utilizadas restrições `CHECK` para garantir que:

- O valor das multas não seja negativo.
- A situação de pagamento utilize apenas os valores `0` e `1`.

Também foram aplicadas restrições `NOT NULL` aos campos obrigatórios da tabela `multa`.

### 9.4. Chaves Primárias Compostas

As tabelas `autoria_livro` e `item_emprestimo` utilizam chaves primárias compostas.

Isso impede que associações idênticas sejam cadastradas repetidamente.

### 9.5. Testes e Verificação de Dados

O script contém consultas destinadas a verificar:

- A quantidade de registros cadastrados.
- O funcionamento da Stored Procedure.
- Os resultados da View.
- O retorno da Function.
- A integridade das associações entre tabelas.

Também foram incluídos exemplos de testes de falha que podem ser executados separadamente.

## 10. Instruções de Execução

### Requisitos

- MySQL 8.0 ou superior.
- MySQL Workbench.
- Usuário MySQL com permissões para criar bancos de dados, usuários e ROLE.

### Procedimento

1. Abrir o MySQL Workbench.
2. Conectar-se ao servidor MySQL.
3. Abrir o arquivo `biblioteca.sql`.
4. Executar o script completo.
5. Verificar a criação das tabelas e a inserção dos registros.
6. Analisar os resultados das consultas com JOIN.
7. Executar os exemplos da Procedure, View e Function.
8. Conferir os resultados dos testes de integridade.

**Observação:** O script utiliza `DROP DATABASE IF EXISTS biblioteca_db` para recriar o banco de dados. Portanto, sua execução remove os dados anteriormente armazenados nesse banco.

Os testes que provocam erros intencionais devem ser executados separadamente.

## 11. Considerações Finais

O projeto demonstra a implementação de um banco de dados relacional para o gerenciamento de uma biblioteca, contemplando os principais conceitos estudados na disciplina.

Foram aplicados conceitos de modelagem de dados, relacionamentos, integridade referencial, manipulação de registros, consultas complexas, controle de acesso e programação SQL.

As implementações adicionais contribuem para tornar o banco de dados mais consistente, seguro e organizado, facilitando sua manutenção e utilização.
