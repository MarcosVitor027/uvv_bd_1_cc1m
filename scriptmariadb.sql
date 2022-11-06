
mysql -u root -p
computacao@raiz
CREATE USER marcosvitor IDENTIFIED BY 'marcos123';

CREATE DATABASE uvv;

GRANT ALL ON *.* TO marcosvitor;

EXIT

mysql -u marcosvitor -p
marcos123

USE uvv; 
CREATE TABLE cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo DECIMAL(8,2),
                salario_maximo DECIMAL(8,2),
                PRIMARY KEY (id_cargo)
);

ALTER TABLE cargos COMMENT 'Tabela cargos, que armazena os cargos existentes e a faixa salarial (mínimo e máximo) para cada cargo.';

ALTER TABLE cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Chave primária da tabela.';

ALTER TABLE cargos MODIFY COLUMN cargo VARCHAR(35) COMMENT 'Nome do cargo.';

ALTER TABLE cargos MODIFY COLUMN salario_minimo DECIMAL(8, 2) COMMENT 'O menor salário admitido para um cargo.';

ALTER TABLE cargos MODIFY COLUMN salario_maximo DECIMAL(8, 2) COMMENT 'O maior salário admitido para um cargo.';


CREATE UNIQUE INDEX cargos_idx
 ON cargos
 ( cargo );

CREATE TABLE regioes (
                id_regiao INT NOT NULL,
                nome VARCHAR(25) NOT NULL,
                PRIMARY KEY (id_regiao)
);

ALTER TABLE regioes COMMENT 'Tabela regiões. Contém os números e nomes das regiões.';

ALTER TABLE regioes MODIFY COLUMN id_regiao INTEGER COMMENT 'Chave primária da tabela regiões.';

ALTER TABLE regioes MODIFY COLUMN nome VARCHAR(25) COMMENT 'Nomes das regiões.';


CREATE TABLE paises (
                id_pais CHAR NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INT NOT NULL,
                PRIMARY KEY (id_pais)
);

ALTER TABLE paises COMMENT 'Tabela com as informaçõs dos países.';

ALTER TABLE paises MODIFY COLUMN id_pais CHAR COMMENT 'Chave primária da tabela países.';

ALTER TABLE paises MODIFY COLUMN nome VARCHAR(50) COMMENT 'Nome do país.';

ALTER TABLE paises MODIFY COLUMN id_regiao INTEGER COMMENT 'Chave primária da tabela regiões.';


CREATE UNIQUE INDEX paises_idx
 ON paises
 ( nome );

CREATE TABLE localizacoes (
                id_localizacao INT NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                id_pais CHAR,
                PRIMARY KEY (id_localizacao)
);

ALTER TABLE localizacoes COMMENT 'Tabela localizaçõs. Contém os endereços de diversos escritórios e facilidades
da empresa. Não armazena endereços de clientes.';

ALTER TABLE localizacoes MODIFY COLUMN id_localizacao INTEGER COMMENT 'Chave primária da tabela.';

ALTER TABLE localizacoes MODIFY COLUMN endereco VARCHAR(50) COMMENT ' da empresa.';

ALTER TABLE localizacoes MODIFY COLUMN cep VARCHAR(12) COMMENT '.';

ALTER TABLE localizacoes MODIFY COLUMN cidade VARCHAR(50) COMMENT ' da empresa.';

ALTER TABLE localizacoes MODIFY COLUMN uf VARCHAR(25) COMMENT 'ritório ou outra
facilidade da empresa.';

ALTER TABLE localizacoes MODIFY COLUMN id_pais CHAR COMMENT 'Chave primária da tabela países.';


CREATE TABLE departamentos (
                id_departamento INT NOT NULL,
                nome VARCHAR(50),
                id_localizacao INT,
                id_gerente INT,
                PRIMARY KEY (id_departamento)
);

ALTER TABLE departamentos COMMENT 'Tabela com as informações sobre os departamentos da empresa.';

ALTER TABLE departamentos MODIFY COLUMN id_departamento INTEGER COMMENT 'Chave primária da tabela.';

ALTER TABLE departamentos MODIFY COLUMN nome VARCHAR(50) COMMENT 'Nome do departamento da tabela.';

ALTER TABLE departamentos MODIFY COLUMN id_localizacao INTEGER COMMENT 'Chave primária da tabela.';

ALTER TABLE departamentos MODIFY COLUMN id_gerente INTEGER COMMENT 'Chave primária da tabela.';


CREATE UNIQUE INDEX departamentos_idx
 ON departamentos
 ( nome );

CREATE TABLE empregados (
                id_empregado INT NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                salario DECIMAL(8,2),
                comissao DECIMAL(4,2),
                id_departamento INT,
                id_supervisor__ INT,
                PRIMARY KEY (id_empregado)
);

ALTER TABLE empregados COMMENT 'Tabela que contém as informações dos empregados.';

ALTER TABLE empregados MODIFY COLUMN id_empregado INTEGER COMMENT 'Chave primária da tabela.';

ALTER TABLE empregados MODIFY COLUMN nome VARCHAR(75) COMMENT 'Nome completo do empregado.';

ALTER TABLE empregados MODIFY COLUMN email VARCHAR(35) COMMENT 'Parte inicial do email do empregado (antes do @).';

ALTER TABLE empregados MODIFY COLUMN telefone VARCHAR(20) COMMENT 'ado).';

ALTER TABLE empregados MODIFY COLUMN data_contratacao DATE COMMENT 'Data que o empregado iniciou no cargo atual.';

ALTER TABLE empregados MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Chave primária da tabela.';

ALTER TABLE empregados MODIFY COLUMN salario DECIMAL(8, 2) COMMENT 'Salário mensal atual do empregado.';

ALTER TABLE empregados MODIFY COLUMN comissao DECIMAL(4, 2) COMMENT 'o departamento de vendas são elegíveis para comissões.';

ALTER TABLE empregados MODIFY COLUMN id_departamento INTEGER COMMENT 'Chave primária da tabela.';

ALTER TABLE empregados MODIFY COLUMN id_supervisor__ INTEGER COMMENT 'Chave primária da tabela.';


CREATE UNIQUE INDEX empregados_idx
 ON empregados
 ( email );

CREATE TABLE historico_cargos (
                data_inicial DATE NOT NULL,
                id_empregado INT NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INT,
                PRIMARY KEY (data_inicial, id_empregado)
);

ALTER TABLE historico_cargos COMMENT 'Tabela que armazena o histórico de cargos de um empregado. Se um empregado mudar de departamento dentro de um cargo ou mudar de cargo dentro de um
departamento, novas linhas devem ser inseridas nesta tabela com a informação antiga do empregado.';

ALTER TABLE historico_cargos MODIFY COLUMN data_inicial DATE COMMENT 'cargo. Deve ser menor do que a data_final.';

ALTER TABLE historico_cargos MODIFY COLUMN id_empregado INTEGER COMMENT 'Chave primária da tabela.';

ALTER TABLE historico_cargos MODIFY COLUMN data_final DATE COMMENT 'e a data inicial.';

ALTER TABLE historico_cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Chave primária da tabela.';

ALTER TABLE historico_cargos MODIFY COLUMN id_departamento INTEGER COMMENT 'Chave primária da tabela.';


ALTER TABLE historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamentos ADD CONSTRAINT empregados_departamentos_fk
FOREIGN KEY (id_gerente)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor__)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
