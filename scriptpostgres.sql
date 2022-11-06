psql -U postgres
computacao@raiz

CREATE USER marcosvitor WITH PASSWORD 'marcos123';
ALTER USER marcosvitor WITH SUPERUSER;

CREATE DATABASE uvv;

GRANT TEMPORARY, CONNECT ON DATABASE uvv TO PUBLIC;

GRANT ALL ON DATABASE uvv TO marcosvitor;

ALTER DEFAULT PRIVILEGES
GRANT ALL ON TABLES TO marcosvitor;

exit
psql -U marcosvitor uvv
marcos123

CREATE TABLE cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximo NUMERIC(8,2),
                CONSTRAINT cargos__pk PRIMARY KEY (id_cargo)
);
COMMENT ON TABLE cargos IS 'Tabela cargos, que armazena os cargos existentes e a faixa salarial (mínimo e máximo) para cada cargo.';
COMMENT ON COLUMN cargos.id_cargo IS 'Chave primária da tabela.';
COMMENT ON COLUMN cargos.cargo IS 'Nome do cargo.';
COMMENT ON COLUMN cargos.salario_minimo IS 'O menor salário admitido para um cargo.';
COMMENT ON COLUMN cargos.salario_maximo IS 'O maior salário admitido para um cargo.';


CREATE UNIQUE INDEX cargos_idx
 ON cargos
 ( cargo );

CREATE TABLE regioes (
                id_regiao INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                CONSTRAINT regioes_pk_ PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE regioes IS 'Tabela regiões. Contém os números e nomes das regiões.';
COMMENT ON COLUMN regioes.id_regiao IS 'Chave primária da tabela regiões.';
COMMENT ON COLUMN regioes.nome IS 'Nomes das regiões.';


CREATE TABLE paises (
                id_pais CHAR NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INTEGER NOT NULL,
                CONSTRAINT paises_pk PRIMARY KEY (id_pais)
);
COMMENT ON TABLE paises IS 'Tabela com as informaçõs dos países.';
COMMENT ON COLUMN paises.id_pais IS 'Chave primária da tabela países.';
COMMENT ON COLUMN paises.nome IS 'Nome do país.';
COMMENT ON COLUMN paises.id_regiao IS 'Chave primária da tabela regiões.';


CREATE UNIQUE INDEX paises_idx
 ON paises
 ( nome );

CREATE TABLE localizacoes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                id_pais CHAR,
                CONSTRAINT localizacoes_pk PRIMARY KEY (id_localizacao)
);
COMMENT ON TABLE localizacoes IS 'Tabela localizaçõs. Contém os endereços de diversos escritórios e facilidades
da empresa. Não armazena endereços de clientes.';
COMMENT ON COLUMN localizacoes.id_localizacao IS 'Chave primária da tabela.';
COMMENT ON COLUMN localizacoes.endereco IS ' da empresa.';
COMMENT ON COLUMN localizacoes.cep IS '.';
COMMENT ON COLUMN localizacoes.cidade IS ' da empresa.';
COMMENT ON COLUMN localizacoes.uf IS 'ritório ou outra
facilidade da empresa.';
COMMENT ON COLUMN localizacoes.id_pais IS 'Chave primária da tabela países.';


CREATE TABLE departamentos (
                id_departamento INTEGER NOT NULL,
                nome VARCHAR(50),
                id_localizacao INTEGER,
                id_gerente INTEGER,
                CONSTRAINT departamentos_pk PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE departamentos IS 'Tabela com as informações sobre os departamentos da empresa.';
COMMENT ON COLUMN departamentos.id_departamento IS 'Chave primária da tabela.';
COMMENT ON COLUMN departamentos.nome IS 'Nome do departamento da tabela.';
COMMENT ON COLUMN departamentos.id_localizacao IS 'Chave primária da tabela.';
COMMENT ON COLUMN departamentos.id_gerente IS 'Chave primária da tabela.';


CREATE UNIQUE INDEX departamentos_idx
 ON departamentos
 ( nome );

CREATE TABLE empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                salario NUMERIC(8,2),
                comissao NUMERIC(4,2),
                id_departamento INTEGER,
                id_supervisor__ INTEGER,
                CONSTRAINT empregados_pk PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE empregados IS 'Tabela que contém as informações dos empregados.';
COMMENT ON COLUMN empregados.id_empregado IS 'Chave primária da tabela.';
COMMENT ON COLUMN empregados.nome IS 'Nome completo do empregado.';
COMMENT ON COLUMN empregados.email IS 'Parte inicial do email do empregado (antes do @).';
COMMENT ON COLUMN empregados.telefone IS 'ado).';
COMMENT ON COLUMN empregados.data_contratacao IS 'Data que o empregado iniciou no cargo atual.';
COMMENT ON COLUMN empregados.id_cargo IS 'Chave primária da tabela.';
COMMENT ON COLUMN empregados.salario IS 'Salário mensal atual do empregado.';
COMMENT ON COLUMN empregados.comissao IS 'o departamento de vendas são elegíveis para comissões.';
COMMENT ON COLUMN empregados.id_departamento IS 'Chave primária da tabela.';
COMMENT ON COLUMN empregados.id_supervisor__ IS 'Chave primária da tabela.';


CREATE UNIQUE INDEX empregados_idx
 ON empregados
 ( email );

CREATE TABLE historico_cargos (
                data_inicial DATE NOT NULL,
                id_empregado INTEGER NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INTEGER,
                CONSTRAINT historico_cargos_pk PRIMARY KEY (data_inicial, id_empregado)
);
COMMENT ON TABLE historico_cargos IS 'Tabela que armazena o histórico de cargos de um empregado. Se um empregado mudar de departamento dentro de um cargo ou mudar de cargo dentro de um
departamento, novas linhas devem ser inseridas nesta tabela com a informação antiga do empregado.';
COMMENT ON COLUMN historico_cargos.data_inicial IS 'cargo. Deve ser menor do que a data_final.';
COMMENT ON COLUMN historico_cargos.id_empregado IS 'Chave primária da tabela.';
COMMENT ON COLUMN historico_cargos.data_final IS 'e a data inicial.';
COMMENT ON COLUMN historico_cargos.id_cargo IS 'Chave primária da tabela.';
COMMENT ON COLUMN historico_cargos.id_departamento IS 'Chave primária da tabela.';


ALTER TABLE historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE departamentos ADD CONSTRAINT empregados_departamentos_fk
FOREIGN KEY (id_gerente)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor__)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
