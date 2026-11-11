# Projeto de Banco de Dados — Biblioteca

## Integrantes

- Enderson Augusto Rodrigues Santos
- Guilherme Rodrigues Faria
- João Vitor Souza Aldet

## 1. Tema

**Biblioteca**

## 2. Descrição do Projeto

O projeto consiste no desenvolvimento de um banco de dados para o gerenciamento de uma biblioteca.

O sistema permite cadastrar usuários, carteirinhas, livros, categorias e autores, além de registrar os empréstimos realizados pelos usuários.

Para facilitar a execução de operações e garantir a integridade dos dados, foram implementadas uma *Stored Procedure*, uma *View*, uma *Trigger* e uma *Function*.

## 3. Funcionalidades Implementadas

### 3.1. Stored Procedure — `registrar_emprestimo`

**Objetivo:** Automatizar o registro de empréstimos na biblioteca.

Como o registro de um empréstimo exige a inserção de informações em duas tabelas diferentes (`emprestimo` e `item_emprestimo`), a *Stored Procedure* realiza essas operações automaticamente.

Dessa forma, o funcionário precisa informar apenas o usuário, o livro e a data do empréstimo, facilitando o processo de cadastro e eliminando a necessidade de executar dois comandos `INSERT` separadamente.

### 3.2. View — `vw_livros_autores`

**Objetivo:** Facilitar a consulta das informações dos livros cadastrados.

A *View* reúne informações de quatro tabelas:

- `livro`
- `autoria_livro`
- `autor`
- `editora`

Por meio dela, é possível consultar o título do livro, seu ano de publicação, o nome do autor e a editora responsável.

Assim, não é necessário escrever novamente os comandos `JOIN` sempre que essas informações forem consultadas.

### 3.3. Trigger — `verificar_valor_multa`

**Objetivo:** Impedir o cadastro de multas com valores negativos.

Sempre que uma nova multa é inserida na tabela `multa`, a *Trigger* verifica se o valor informado é menor que zero.

Caso seja identificado um valor negativo, a operação é interrompida e uma mensagem de erro é apresentada.

Esse mecanismo contribui para a integridade dos dados, impedindo o registro de valores inválidos.

### 3.4. Function — `calcular_total_multas_pendentes`

**Objetivo:** Calcular o valor total das multas pendentes de pagamento.

A *Function* consulta a tabela `multa` e seleciona os registros em que o campo `paga` possui valor igual a `0`, indicando que a multa ainda não foi paga.

Em seguida, realiza a soma dos valores dessas multas e retorna o total pendente.

Dessa forma, a biblioteca consegue consultar facilmente o valor que ainda tem a receber, sem a necessidade de realizar esse cálculo manualmente.
