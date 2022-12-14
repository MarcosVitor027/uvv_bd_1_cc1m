psql -U postgres
computacao@raiz

CREATE USER marcosvitor WITH PASSWORD '202203243';
ALTER USER marcosvitor WITH SUPERUSER;

CREATE DATABASE uvv
    WITH 
    OWNER = marcosvitor
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    ALLOW_CONNECTIONS = true;

GRANT TEMPORARY, CONNECT ON DATABASE uvv TO PUBLIC;

GRANT ALL ON DATABASE uvv TO marcosvitor;

ALTER DEFAULT PRIVILEGES
GRANT ALL ON TABLES TO marcosvitor;

exit

psql -U marcosvitor uvv
202203243


CREATE SCHEMA hr
AUTHORIZATION marcosvitor;

SHOW SEARCH_PATH;
SELECT CURRENT_SCHEMA();
SET SEARCH_PATH TO hr, "\$user", public;
ALTER USER marcosvitor SET SEARCH_PATH TO hr, "\$user", public;



CREATE TABLE cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximo NUMERIC(8,2),
                CONSTRAINT id_cargo PRIMARY KEY (id_cargo)
);
COMMENT ON TABLE cargos IS 'Tabela cargos. Armazena informações sobre cada cargo na empresa.';
COMMENT ON COLUMN cargos.id_cargo IS 'Chave primária da tabela. Usada pra identificarcada cargo.';
COMMENT ON COLUMN cargos.cargo IS 'Chave única. Nome de cada cargo.';
COMMENT ON COLUMN cargos.salario_minimo IS 'O menor salário de cada cargo.';
COMMENT ON COLUMN cargos.salario_maximo IS 'O maior salário de cada cargo.';


CREATE UNIQUE INDEX cargos_idx
 ON cargos
 ( cargo );

CREATE TABLE regioes (
                id_regiao INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                CONSTRAINT id_regiao PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE regioes IS 'Tabela regioes. Contém informações necessárias sobre  as regiões para a empresa.';
COMMENT ON COLUMN regioes.id_regiao IS 'Chave primária da tabela regioes. Usada para identificar a região.';
COMMENT ON COLUMN regioes.nome IS 'Chave única. Nome de cada região.';


CREATE UNIQUE INDEX regioes_idx
 ON regioes
 ( nome );

CREATE TABLE paises (
                id_pais CHAR(2) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INTEGER NOT NULL,
                CONSTRAINT id_pais PRIMARY KEY (id_pais)
);
COMMENT ON TABLE paises IS 'Tabela paises. Contém informações necessárias sobre  os países para a empresa.';
COMMENT ON COLUMN paises.id_pais IS 'Chave primária da tabela países. Usada para identificar o país.';
COMMENT ON COLUMN paises.nome IS 'Chave única. Nome do país.';
COMMENT ON COLUMN paises.id_regiao IS 'Chave estrangeira para a tabela de regiões.';


CREATE UNIQUE INDEX paises_idx
 ON paises
 ( nome );

CREATE TABLE localizacoes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                id_pais CHAR(2) NOT NULL,
                CONSTRAINT id_localizacao PRIMARY KEY (id_localizacao)
);
COMMENT ON TABLE localizacoes IS 'Tabela localizacoes. Contém informações necessárias sobre  as localizacoes para a empresa. Como por exemplo a localidade de cada endereço físico da empresa';
COMMENT ON COLUMN localizacoes.id_localizacao IS 'Chave primária para tabela localizacao. Usada para identificar a localizacao.';
COMMENT ON COLUMN localizacoes.endereco IS 'Endereço da empresa física.';
COMMENT ON COLUMN localizacoes.cep IS 'CEP da  localização da empresa física.';
COMMENT ON COLUMN localizacoes.cidade IS 'Cidade em que se localiza a empresa.';
COMMENT ON COLUMN localizacoes.uf IS 'Estado em que se localiza a empresa.';
COMMENT ON COLUMN localizacoes.id_pais IS 'Chave estrangeira para tabela paises.';


CREATE TABLE departamentos (
                id_departamento INTEGER NOT NULL,
                nome VARCHAR(50),
                id_localizacao INTEGER NOT NULL,
                CONSTRAINT id_departamento PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE departamentos IS 'Tabela com informações sobre os departamentos da empresa.';
COMMENT ON COLUMN departamentos.id_departamento IS 'Chave primária da tabela departamentos. Usada pra identificar o departamento.';
COMMENT ON COLUMN departamentos.nome IS 'Chave única. Nome de cada departamento na tabela.';
COMMENT ON COLUMN departamentos.id_localizacao IS 'Chave estrangeira para tabela gerentes.';


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
                id_supervisor INTEGER,
                id_departamento INTEGER,
                CONSTRAINT id_empregado PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE empregados IS 'Tabela que contém informações sobre cada funcionário. Contendo informações para contato se precisar.';
COMMENT ON COLUMN empregados.id_empregado IS 'Chave primária da tabela.';
COMMENT ON COLUMN empregados.nome IS 'Nome completo do funcionário.';
COMMENT ON COLUMN empregados.email IS 'Chave única. Parte inicial do email do funcionário (antes do @).';
COMMENT ON COLUMN empregados.telefone IS 'Telefone com DDD de cada funcionário.';
COMMENT ON COLUMN empregados.data_contratacao IS 'Data em que o funcionário foi contratado.';
COMMENT ON COLUMN empregados.id_cargo IS 'Chave estrangeira para tabela cargos. Mosta qual o cargo de determinado funcionário.';
COMMENT ON COLUMN empregados.salario IS 'Salário de cada funcionário. (Mensal)';
COMMENT ON COLUMN empregados.comissao IS 'Comissão em % que cada funcionário de vendas irá receber.';
COMMENT ON COLUMN empregados.id_supervisor IS 'Chave estrangeira para para tabela empregados.  Indica o supervisor de cada empregado.';
COMMENT ON COLUMN empregados.id_departamento IS 'Chave estrangeira para tabela departamentos. Indica em qual departamento está cada empregado.';


CREATE UNIQUE INDEX empregados_idx
 ON empregados
 ( email );

CREATE TABLE gerentes (
                id_gerente INTEGER NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT gerentes_pk PRIMARY KEY (id_gerente, id_departamento)
);
COMMENT ON COLUMN gerentes.id_gerente IS 'Chave primária da tabela.';
COMMENT ON COLUMN gerentes.id_departamento IS 'Chave primária da tabela.';


CREATE TABLE historico_cargos (
                id_empregado INTEGER NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT data_inicial PRIMARY KEY (id_empregado, data_inicial)
);
COMMENT ON COLUMN historico_cargos.id_empregado IS 'Chave primária da tabela.';
COMMENT ON COLUMN historico_cargos.id_cargo IS 'Chave estrangeira para tabela cargos. Cargo em que o funcionário trabalhou no passado.';
COMMENT ON COLUMN historico_cargos.id_departamento IS 'Chave estrangeira para tabela departamentos. É o departamento que o funcionário trabalhou no passado.';


ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
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

ALTER TABLE empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE gerentes ADD CONSTRAINT departamentos_gerentes_fk
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

ALTER TABLE empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE gerentes ADD CONSTRAINT empregados_gerentes_fk
FOREIGN KEY (id_gerente)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- Regioes
INSERT INTO regioes (id_regiao, nome) VALUES
(1,'Europe');
INSERT INTO regioes (id_regiao, nome) VALUES
(2,'Americas');
INSERT INTO regioes (id_regiao, nome) VALUES
(3,'Asia');
INSERT INTO regioes (id_regiao, nome) VALUES
(4,'Middle East and Africa');



INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('AR','Argentina',2);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('AU','Australia',3);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('BE','Belgium',1);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('BR','Brazil',2);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('CA','Canada',2);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('CH','Switzerland',1);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('CN','China',3);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('DE','Germany',1);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('DK','Denmark',1);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('EG','Egypt',4);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('FR','France',1);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('IL','Israel',4);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('IN','India',3);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('IT','Italy',1);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('JP','Japan',3);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('KW','Kuwait',4);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('ML','Malaysia',3);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('MX','Mexico',2);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('NG','Nigeria',4);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('NL','Netherlands',1);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('SG','Singapore',3);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('UK','United Kingdom',1);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('US','United States of America',2);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('ZM','Zambia',4);
INSERT INTO paises (id_pais, nome, id_regiao) VALUES
('ZW','Zimbabwe',4);



INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(1000,'1297 Via Cola di Rie','00989','Roma','','IT');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(1100,'93091 Calle della Testa','10934','Venice','','IT');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(1200,'2017 Shinjuku-ku','1689','Tokyo','Tokyo Prefecture','JP');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(1300,'9450 Kamiya-cho','6823','Hiroshima','','JP');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(1400,'2014 Jabberwocky Rd','26192','Southlake','Texas','US');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(1500,'2011 Interiors Blvd','99236','South San Francisco','California','US');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(1600,'2007 Zagora St','50090','South Brunswick','New Jersey','US');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(1700,'2004 Charade Rd','98199','Seattle','Washington','US');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(1800,'147 Spadina Ave','M5V 2L7','Toronto','Ontario','CA');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(1900,'6092 Boxwood St','YSW 9T2','Whitehorse','Yukon','CA');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(2000,'40-5-12 Laogianggen','190518','Beijing','','CN');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(2100,'1298 Vileparle (E)','490231','Bombay','Maharashtra','IN');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(2200,'12-98 Victoria Street','2901','Sydney','New South Wales','AU');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(2300,'198 Clementi North','540198','Singapore','','SG');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(2400,'8204 Arthur St','','London','','UK');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(2500,'Magdalen Centre, The Oxford Science Park','OX9 9ZB','Oxford','Oxford','UK');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(2600,'9702 Chester Road','09629850293','Stretford','Manchester','UK');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(2700,'Schwanthalerstr. 7031','80925','Munich','Bavaria','DE');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(2800,'Rua Frei Caneca 1360 ','01307-002','Sao Paulo','Sao Paulo','BR');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(2900,'20 Rue des Corps-Saints','1730','Geneva','Geneve','CH');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(3000,'Murtenstrasse 921','3095','Bern','BE','CH');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(3100,'Pieter Breughelstraat 837','3029SK','Utrecht','Utrecht','NL');
INSERT INTO localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES
(3200,'Mariano Escobedo 9991','11932','Mexico City','Distrito Federal,','MX');


INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(10,'Administration', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(20,'Marketing', 1800);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(30,'Purchasing', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(40,'Human Resources', 2400);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(50,'Shipping', 1500);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(60,'IT', 1400);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(70,'Public Relations', 2700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(80,'Sales', 2500);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(90,'Executive', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(100,'Finance', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(110,'Accounting', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(120,'Treasury', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(130,'Corporate Tax', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(140,'Control And Credit', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(150,'Shareholder Services', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(160,'Benefits', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(170,'Manufacturing', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(180,'Construction', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(190,'Contracting', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(200,'Operations', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(210,'IT Support', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(220,'NOC', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(230,'IT Helpdesk', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(240,'Government Sales', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(250,'Retail Sales', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(260,'Recruiting', 1700);
INSERT INTO departamentos (id_departamento, nome, id_localizacao) VALUES
(270,'Payroll', 1700);



INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('AD_PRES', 'President', '20080', '40000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('AD_VP', 'Administration Vice President', '15000', '30000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('AD_ASST', 'Administration Assistant', '3000', '6000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('FI_MGR', 'Finance Manager', '8200', '16000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('FI_ACCOUNT', 'Accountant', '4200', '9000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('AC_MGR', 'Accounting Manager', '8200', '16000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('AC_ACCOUNT', 'Public Accountant', '4200', '9000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('SA_MAN', 'Sales Manager', '10000', '20080');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('SA_REP', 'Sales Representative', '6000', '12008');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('PU_MAN', 'Purchasing Manager', '8000', '15000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('PU_CLERK', 'Purchasing Clerk', '2500', '5500');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('ST_MAN', 'Stock Manager', '5500', '8500');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('ST_CLERK', 'Stock Clerk', '2008', '5000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('SH_CLERK', 'Shipping Clerk', '2500', '5500');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('IT_PROG', 'Programmer', '4000', '10000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('MK_MAN', 'Marketing Manager', '9000', '15000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('MK_REP', 'Marketing Representative', '4000', '9000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('HR_REP', 'Human Resources Representative', '4000', '9000');
INSERT INTO cargos(id_cargo, cargo, salario_minimo, salario_maximo) VALUES
('PR_REP', 'Public Relations Representative', '4500', '10500');



INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(100, 'Steven King', 'SKING', '515.123.4567', '2003-06-17', 'AD_PRES', 24000, null, null, 90);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(101, 'Neena Kochhar', 'NKOCHHAR', '515.123.4568', '2005-09-21', 'AD_VP', 17000, null, 100, 90);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(102, 'Lex De Haan', 'LDEHAAN', '515.123.4569', '2001-01-13', 'AD_VP', 17000, null, 100, 90);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(103, 'Alexander Hunold', 'AHUNOLD', '590.423.4567', '2006-01-03', 'IT_PROG', 9000, null, 102, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(104, 'Bruce Ernst', 'BERNST', '590.423.4568', '2007-05-21', 'IT_PROG', 6000, null, 103, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(105, 'David Austin', 'DAUSTIN', '590.423.4569', '2005-06-25', 'IT_PROG', 4800, null, 103, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(106, 'Valli Pataballa', 'VPATABAL', '590.423.4560', '2006-02-05', 'IT_PROG', 4800, null, 103, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(107, 'Diana Lorentz', 'DLORENTZ', '590.423.5567', '2007-02-07', 'IT_PROG', 4200, null, 103, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(108, 'Nancy Greenberg', 'NGREENBE', '515.124.4569', '2002-08-17', 'FI_MGR', 12008, null, 101, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(109, 'Daniel Faviet', 'DFAVIET', '515.124.4169', '2002-08-16', 'FI_ACCOUNT', 9000, null, 108, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
(110, 'John Chen', 'JCHEN', '515.124.4269', '2005-09-28', 'FI_ACCOUNT', 8200, null, 108, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
