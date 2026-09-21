-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema voltix
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `voltix` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `voltix`;

-- -----------------------------------------------------
-- Table `voltix`.`empresa`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `voltix`.`empresa` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cnpj` CHAR(14) NOT NULL,
  `razao_social` VARCHAR(90) NULL DEFAULT NULL,
  `nome_fantasia` VARCHAR(60) NULL DEFAULT NULL,
  `criado_em` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` DATETIME NULL DEFAULT NULL,
  `deletado_em` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `cnpj_unique` (`cnpj` ASC) VISIBLE
)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `voltix`.`instancia`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `voltix`.`instancia` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `aplicacao_id` INT NOT NULL,
  `endereco_mac` CHAR(12) NOT NULL,
  `descricao` TEXT NOT NULL,
  `criado_em` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deletado_em` DATETIME NULL DEFAULT NULL,
  `empresa_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `endereco_mac_unique` (`endereco_mac` ASC) VISIBLE,
  INDEX `fk_instancia_empresa1_idx` (`empresa_id` ASC) VISIBLE,
  CONSTRAINT `fk_instancia_empresa1`
    FOREIGN KEY (`empresa_id`)
    REFERENCES `voltix`.`empresa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `voltix`.`alerta`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `voltix`.`alerta` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `prioridade` TINYINT NOT NULL COMMENT 'definir tipos',
  `tipo` VARCHAR(45) NULL DEFAULT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `instancia_id` INT NOT NULL,
  `criado_em` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `enviado_em` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `instancia_id`),
  INDEX `fk_alerta_instancia_idx` (`instancia_id` ASC) VISIBLE,
  CONSTRAINT `fk_alerta_instancia`
    FOREIGN KEY (`instancia_id`)
    REFERENCES `voltix`.`instancia` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `voltix`.`codigo_ativacao`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `voltix`.`codigo_ativacao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `empresa_id` INT NOT NULL,
  `codigo` CHAR(6) NOT NULL,
  `cargo` TINYINT NOT NULL COMMENT 'definir cargos',
  `criado_em` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expira_em` DATETIME NOT NULL,
  `usado_em` DATETIME NULL DEFAULT NULL,
  `atualizado_em` DATETIME NULL DEFAULT NULL,
  `deletado_em` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `empresa_id`),
  UNIQUE INDEX `codigo_unique` (`codigo` ASC) VISIBLE,
  INDEX `fk_codigo_empresa_idx` (`empresa_id` ASC) VISIBLE,
  CONSTRAINT `fk_codigo_empresa`
    FOREIGN KEY (`empresa_id`)
    REFERENCES `voltix`.`empresa` (`id`)
)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `voltix`.`componente`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `voltix`.`componente` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tipo` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `voltix`.`usuario`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `voltix`.`usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `empresa_id` INT NOT NULL,
  `nome` VARCHAR(120) NOT NULL,
  `cargo` TINYINT NOT NULL COMMENT 'definir tipos',
  `email` VARCHAR(120) NOT NULL,
  `senha` BLOB NOT NULL,
  `criado_em` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` DATETIME NULL DEFAULT NULL,
  `deletado_em` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `empresa_id`),
  UNIQUE INDEX `email_unique` (`email` ASC) VISIBLE,
  INDEX `fk_usuario_empresa_idx` (`empresa_id` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_empresa`
    FOREIGN KEY (`empresa_id`)
    REFERENCES `voltix`.`empresa` (`id`)
)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `voltix`.`contato`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `voltix`.`contato` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NOT NULL,
  `usuario_id` INT NOT NULL,
  `criado_em` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` DATETIME NULL DEFAULT NULL,
  `deletado_em` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `usuario_id`),
  INDEX `fk_contato_usuario_idx` (`usuario_id` ASC) VISIBLE,
  CONSTRAINT `fk_contato_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `voltix`.`usuario` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `voltix`.`especificacao`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `voltix`.`especificacao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `componente_id` INT NOT NULL,
  `nome` VARCHAR(120) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_expecificacao` (`componente_id` ASC) VISIBLE,
  CONSTRAINT `fk_expecificacao`
    FOREIGN KEY (`componente_id`)
    REFERENCES `voltix`.`componente` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `voltix`.`metrica`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `voltix`.`metrica` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `instancia_id` INT NOT NULL,
  `especificacao_id` INT NOT NULL,
  `componente_id` INT NOT NULL,
  `maximo` DOUBLE(8,2) NOT NULL,
  `minimo` DOUBLE(8,2) NOT NULL,
  `unidade_medida` VARCHAR(20) NOT NULL,
  `criado_em` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` DATETIME NULL DEFAULT NULL,
  `deletado_em` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_instancia_metrica` (`instancia_id` ASC) VISIBLE,
  INDEX `fk_componente_metrica` (`especificacao_id` ASC) VISIBLE,
  CONSTRAINT `fk_componente_metrica`
    FOREIGN KEY (`especificacao_id`)
    REFERENCES `voltix`.`especificacao` (`id`),
  CONSTRAINT `fk_instancia_metrica`
    FOREIGN KEY (`instancia_id`)
    REFERENCES `voltix`.`instancia` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;