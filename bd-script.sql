-- -----------------------------------------------------
-- BANCO DE DADOS VOLTIX
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS voltix;
USE voltix;

-- -----------------------------------------------------
-- EMPRESA
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS empresa (
  id CHAR(36) NOT NULL,
  cnpj CHAR(14) NOT NULL,
  razao_social VARCHAR(90),
  nome_fantasia VARCHAR(60),
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME,
  deletado_em DATETIME,

  PRIMARY KEY (id),
  UNIQUE (cnpj)
);

CREATE INDEX idx_empresa_id ON empresa(id);
CREATE INDEX idx_empresa_cnpj ON empresa(cnpj);

-- -----------------------------------------------------
-- INSTANCIA
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS instancia (
  id CHAR(36) NOT NULL,
  endereco_mac CHAR(12) NOT NULL,
  descricao TEXT NOT NULL,
  empresa_id CHAR(36) NOT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_instancia BOOLEAN NOT NULL DEFAULT 1,
  deletado_em DATETIME,

  PRIMARY KEY (id),
  UNIQUE (endereco_mac),

  FOREIGN KEY (empresa_id)
    REFERENCES empresa (id)
);

CREATE INDEX idx_instancia_id ON instancia(id);
CREATE INDEX idx_instancia_empresa_id ON instancia(empresa_id);

-- -----------------------------------------------------
-- COMPONENTE
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS componente (
  id CHAR(36) NOT NULL,
  tipo VARCHAR(100) NOT NULL,

  PRIMARY KEY (id)
);

CREATE INDEX idx_componente_id ON componente(id);

-- -----------------------------------------------------
-- ESPECIFICACAO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS especificacao (
  id CHAR(36) NOT NULL,
  componente_id CHAR(36) NOT NULL,
  nome VARCHAR(120) NOT NULL,

  PRIMARY KEY (id),

  FOREIGN KEY (componente_id)
    REFERENCES componente (id)
);

CREATE INDEX idx_especificacao_id ON especificacao(id);
CREATE INDEX idx_especificacao_componente_id ON especificacao(componente_id);

-- -----------------------------------------------------
-- METRICA
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS metrica (
  id CHAR(36) NOT NULL,
  instancia_id CHAR(36) NOT NULL,
  especificacao_id CHAR(36) NOT NULL,
  maximo DOUBLE(8,2) NULL,
  minimo DOUBLE(8,2) NULL,
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

CREATE INDEX idx_metrica_id ON metrica(id);
CREATE INDEX idx_metrica_instancia_id ON metrica(instancia_id);
CREATE INDEX idx_metrica_especificacao_id ON metrica(especificacao_id);

-- -----------------------------------------------------
-- ALERTA
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS alerta (
  id CHAR(36) NOT NULL,
  metrica_id CHAR(36) NOT NULL,
  prioridade TINYINT NOT NULL,
  tipo VARCHAR(45),
  descricao TEXT,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enviado_em DATETIME,

  PRIMARY KEY (id),

  FOREIGN KEY (metrica_id)
    REFERENCES metrica (id)
);

CREATE INDEX idx_alerta_id ON alerta(id);
CREATE INDEX idx_alerta_metrica_id ON alerta(metrica_id);

-- -----------------------------------------------------
-- CODIGO DE ATIVACAO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS codigo_ativacao (
  id CHAR(36) NOT NULL,
  empresa_id CHAR(36) NOT NULL,
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

CREATE INDEX idx_codigo_ativacao_id ON codigo_ativacao(id);
CREATE INDEX idx_codigo_ativacao_empresa_id ON codigo_ativacao(empresa_id);

-- -----------------------------------------------------
-- USUARIO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS usuario (
  id CHAR(36) NOT NULL,
  empresa_id CHAR(36) NOT NULL,
  nome VARCHAR(120) NOT NULL,
  cargo TINYINT NOT NULL,
  email VARCHAR(120) NOT NULL,
  senha CHAR(60) NOT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME,
  deletado_em DATETIME,

  PRIMARY KEY (id),
  UNIQUE (email),

  FOREIGN KEY (empresa_id)
    REFERENCES empresa (id)
);

CREATE INDEX idx_usuario_id ON usuario(id);
CREATE INDEX idx_usuario_empresa_id ON usuario(empresa_id);

-- -----------------------------------------------------
-- CONTATO
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS contato (
  id CHAR(36) NOT NULL,
  url TEXT NULL,
  email VARCHAR(100) NULL,
  empresa_id CHAR(36) NOT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME,
  deletado_em DATETIME,

  PRIMARY KEY (id),

  FOREIGN KEY (empresa_id)
    REFERENCES empresa (id)
);

CREATE INDEX idx_contato_id ON contato(id);
CREATE INDEX idx_contato_empresa_id ON contato(empresa_id);

INSERT INTO empresa (id, cnpj, nome_fantasia, razao_social) 
VALUES ("f5ae3d95-02da-49f6-ba72-4a3913bb6c67", '11111111111111', 'Voltix Energy', 'Voltix Energy Solucoes em Energia LTDA');


INSERT INTO usuario (id, nome, email, cargo, senha, empresa_id) 
VALUES ("f5ae3d95-02da-49f6-ba72-4a3913bjoiu7", 'Administrador', 'adm@voltix.com', 1, "$2b$10$IBoCzR2boWD5D0XyP267t..iooiGUDrKw6FWnRe.BPPktduDgBxT.", "f5ae3d95-02da-49f6-ba72-4a3913bb6c67"); -- senha do usuário é teste123
-- -----------------------------------------------------
-- INSERINDO COMPONENTES
-- -----------------------------------------------------
INSERT INTO componente (id, tipo) VALUES
("f5ae3d95-02da-49f6-ba72-4a3913bb6c67", 'CPU'),
("f5ae3d95-02da-49f6-ba72-4a3913bb6c68", 'Memória RAM'),
("f5ae3d95-02da-49f6-ba72-4a3913bb6c69", 'Disco Rigido'),
("f5ae3d95-02da-49f6-ba72-4a3913bb6c70", 'Rede');

select * from componente;
-- -----------------------------------------------------
-- INSERINDO ESPECIFICAÇÕES DAS MÉTRICAS
-- -----------------------------------------------------
INSERT INTO especificacao (id, componente_id, nome) VALUES
("f5ae3d95-02da-49f6-ba72-4a3913bb6c67", "f5ae3d95-02da-49f6-ba72-4a3913bb6c67", 'cpu_use_percent'),
("f5ae3d95-02da-49f6-ba72-4a3913bb6c68", "f5ae3d95-02da-49f6-ba72-4a3913bb6c68", 'ram_total_gb'),
("f5ae3d95-02da-49f6-ba72-4a3913bb6c69", "f5ae3d95-02da-49f6-ba72-4a3913bb6c69", 'ram_free_gb'),
("f5ae3d95-02da-49f6-ba72-4a3913bb6c70", "f5ae3d95-02da-49f6-ba72-4a3913bb6c70", 'disk_free_percent'),
("f5ae3d95-02da-49f6-ba72-4a3913bb6c71", "f5ae3d95-02da-49f6-ba72-4a3913bb6c70", 'network_sent'),
("f5ae3d95-02da-49f6-ba72-4a3913bb6c72", "f5ae3d95-02da-49f6-ba72-4a3913bb6c70", 'network_received'),
("f5ae3d95-02da-49f6-ba72-4a3913bb6c73", "f5ae3d95-02da-49f6-ba72-4a3913bb6c70", 'package_drop_total');



ALTER TABLE instancia
ADD COLUMN cenario VARCHAR(30);

INSERT INTO instancia (
    id,
    endereco_mac,
    descricao,
    empresa_id,
    cenario
)
VALUES (
    'f5ae3d95-02da-49f6-ba72-4a3913bb6c67',
    '6432A89CD6CD',
    'Minha Maquina de Desenvolvimento',
    'f5ae3d95-02da-49f6-ba72-4a3913bb6c67',
    'NORMAL'
);

select * from instancia;

INSERT INTO metrica (id, instancia_id, especificacao_id, maximo, minimo, unidade_medida) VALUES
("f5ae3d95-02da-49f6-ba72-4a3913bb6c67", "f5ae3d95-02da-49f6-ba72-4a3913bb6c67", "f5ae3d95-02da-49f6-ba72-4a3913bb6c67", 100.00, 0.00, '%'),     -- cpu_use_percent
("f5ae3d95-02da-49f6-ba72-4a3913bb6c68", "f5ae3d95-02da-49f6-ba72-4a3913bb6c67", "f5ae3d95-02da-49f6-ba72-4a3913bb6c68", 64.00, 0.00, 'GB'),     -- ram_total_gb
("f5ae3d95-02da-49f6-ba72-4a3913bb6c69", "f5ae3d95-02da-49f6-ba72-4a3913bb6c67", "f5ae3d95-02da-49f6-ba72-4a3913bb6c69", 64.00, 0.00, 'GB'),     -- ram_free_gb
("f5ae3d95-02da-49f6-ba72-4a3913bb6c70", "f5ae3d95-02da-49f6-ba72-4a3913bb6c67", "f5ae3d95-02da-49f6-ba72-4a3913bb6c70", 100.00, 0.00, '%'),     -- disk_free_percent
("f5ae3d95-02da-49f6-ba72-4a3913bb6c71", "f5ae3d95-02da-49f6-ba72-4a3913bb6c67", "f5ae3d95-02da-49f6-ba72-4a3913bb6c71", 1000.00, 0.00, 'MB'),   -- network_sent
("f5ae3d95-02da-49f6-ba72-4a3913bb6c72", "f5ae3d95-02da-49f6-ba72-4a3913bb6c67", "f5ae3d95-02da-49f6-ba72-4a3913bb6c72", 1000.00, 0.00, 'MB'),   -- network_received
("f5ae3d95-02da-49f6-ba72-4a3913bb6c73", "f5ae3d95-02da-49f6-ba72-4a3913bb6c67", "f5ae3d95-02da-49f6-ba72-4a3913bb6c73", 100.00, 0.00, 'un');    -- package_drop_total


SELECT
    m.id AS metrica_id,
    i.id AS instancia_id,
    e.id AS especificacao_id,
    e.nome AS metrica_nome
FROM metrica m
JOIN especificacao e ON m.especificacao_id = e.id
JOIN instancia i ON m.instancia_id = i.id
WHERE i.id = 1
  AND i.deletado_em IS NULL
  AND m.deletado_em IS NULL;
  
  
  UPDATE instancia
SET
    cenario = 'ALTA_DEMANDA'
WHERE id = 1;	
