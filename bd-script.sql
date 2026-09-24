-- -----------------------------------------------------
-- BANCO DE DADOS VOLTIX
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS voltix;

USE voltix;


-- -----------------------------------------------------
-- EMPRESA
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS empresa (
    id INT NOT NULL AUTO_INCREMENT,
    cnpj CHAR(14) NOT NULL,
    razao_social VARCHAR(90),
    nome_fantasia VARCHAR(60),
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME,
    deletado_em DATETIME,

    PRIMARY KEY (id),
    UNIQUE (cnpj)
);


-- -----------------------------------------------------
-- INSTANCIA
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS instancia (
    id INT NOT NULL AUTO_INCREMENT,
    endereco_mac CHAR(12) NOT NULL,
    descricao TEXT NOT NULL,
    empresa_id INT NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deletado_em DATETIME,

    PRIMARY KEY (id),
    UNIQUE (endereco_mac),

    FOREIGN KEY (empresa_id)
        REFERENCES empresa (id)
);


-- -----------------------------------------------------
-- COMPONENTE
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS componente (
    id INT NOT NULL AUTO_INCREMENT,
    tipo VARCHAR(100) NOT NULL,

    PRIMARY KEY (id)
);


-- -----------------------------------------------------
-- ESPECIFICACAO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS especificacao (
    id INT NOT NULL AUTO_INCREMENT,
    componente_id INT NOT NULL,
    nome VARCHAR(120) NOT NULL,

    PRIMARY KEY (id),

    FOREIGN KEY (componente_id)
        REFERENCES componente (id)
);


-- -----------------------------------------------------
-- METRICA
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS metrica (
    id INT NOT NULL AUTO_INCREMENT,
    instancia_id INT NOT NULL,
    especificacao_id INT NOT NULL,
    maximo DOUBLE(8,2) NOT NULL,
    minimo DOUBLE(8,2) NOT NULL,
    unidade_medida VARCHAR(20) NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME,
    deletado_em DATETIME,

    PRIMARY KEY (id),

    FOREIGN KEY (instancia_id)
        REFERENCES instancia (id),

    FOREIGN KEY (especificacao_id)
        REFERENCES especificacao (id)
);


-- -----------------------------------------------------
-- ALERTA
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS alerta (
    id INT NOT NULL AUTO_INCREMENT,
    metrica_id INT NOT NULL,
    prioridade TINYINT NOT NULL,
    tipo VARCHAR(45),
    descricao TEXT,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enviado_em DATETIME,

    PRIMARY KEY (id),

    FOREIGN KEY (metrica_id)
        REFERENCES metrica (id)
);


-- -----------------------------------------------------
-- CODIGO DE ATIVACAO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS codigo_ativacao (
    id INT NOT NULL AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    codigo CHAR(6) NOT NULL,
    cargo TINYINT NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expira_em DATETIME NOT NULL,
    usado_em DATETIME,
    atualizado_em DATETIME,
    deletado_em DATETIME,

    PRIMARY KEY (id),
    UNIQUE (codigo),

    FOREIGN KEY (empresa_id)
        REFERENCES empresa (id)
);


-- -----------------------------------------------------
-- USUARIO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS usuario (
    id INT NOT NULL AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    nome VARCHAR(120) NOT NULL,
    cargo TINYINT NOT NULL,
    email VARCHAR(120) NOT NULL,
    senha BLOB NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME,
    deletado_em DATETIME,

    PRIMARY KEY (id),
    UNIQUE (email),

    FOREIGN KEY (empresa_id)
        REFERENCES empresa (id)
);


-- -----------------------------------------------------
-- CONTATO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS contato (
    id INT NOT NULL AUTO_INCREMENT,
    email VARCHAR(45) NOT NULL,
    usuario_id INT NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME,
    deletado_em DATETIME,

    PRIMARY KEY (id),

    FOREIGN KEY (usuario_id)
        REFERENCES usuario (id)
);

INSERT INTO empresa (id, cnpj, nome_fantasia, razao_social) 
VALUES (1, '11111111111111', 'Voltix Energy', 'Voltix Energy Solucoes em Energia LTDA');

INSERT INTO usuario (id, nome, email, cargo, senha, empresa_id) 
VALUES (1, 'Administrador', 'adm@voltix.com', 0, SHA2('teste123', 256), 1);