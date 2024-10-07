create database casaoliveiradb;
use casaoliveiradb;

DROP TABLE IF EXISTS `contato`;
CREATE TABLE `contato` (
  `idcontato` int(11) NOT NULL AUTO_INCREMENT,
  `telefone_residencial` varchar(15) DEFAULT NULL,
  `telefone_comercial` varchar(15) DEFAULT NULL,
  `celular` varchar(15) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `redesocial` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`idcontato`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `endereco`;
CREATE TABLE `endereco` (
  `idendereco` int(11) NOT NULL AUTO_INCREMENT,
  `tipologradouro` enum('Rua','Avenida','Viela','Praça','Alameda','Vila','Rodovia','Estrada','Travessa') NOT NULL,
  `logradouro` varchar(50) NOT NULL,
  `numero` varchar(10) NOT NULL,
  `complemento` varchar(20) DEFAULT NULL,
  `cep` varchar(9) NOT NULL,
  `bairro` varchar(30) NOT NULL,
  `cidade` varchar(30) NOT NULL,
  `estado` varchar(20) NOT NULL,
  `pais` varchar(20) NOT NULL DEFAULT 'Brasil',
  PRIMARY KEY (`idendereco`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `cliente`;
CREATE TABLE `cliente` (
  `idcliente` int(11) NOT NULL AUTO_INCREMENT,
  `nome_cliente` varchar(50) NOT NULL,
  `cpf` varchar(14) NOT NULL,
  `data_nascimento` date NOT NULL,
  `nome_social` varchar(50) DEFAULT NULL,
  `genero` varchar(20) DEFAULT NULL,
  `idendereco` int(11) DEFAULT NULL,
  `idcontato` int(11) DEFAULT NULL,
  PRIMARY KEY (`idcliente`),
  UNIQUE KEY `cpf` (`cpf`),
  KEY `fk_cliente_pk_endereco` (`idendereco`),
  KEY `fk_funcionario_pk_contato` (`idcontato`),
  CONSTRAINT `fk_cliente_pk_contato` FOREIGN KEY (`idcontato`) REFERENCES `contato` (`idcontato`),
  CONSTRAINT `fk_cliente_pk_endereco` FOREIGN KEY (`idendereco`) REFERENCES `endereco` (`idendereco`),
  CONSTRAINT `fk_funcionario_pk_contato` FOREIGN KEY (`idcontato`) REFERENCES `contato` (`idcontato`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `funcionario`;
CREATE TABLE `funcionario` (
  `idfuncionario` int(11) NOT NULL AUTO_INCREMENT,
  `nome_funcionario` varchar(50) NOT NULL,
  `cargo` varchar(30) NOT NULL,
  `salario` decimal(7,2) NOT NULL,
  `matricula` varchar(10) NOT NULL,
  `idendereco` int(11) DEFAULT NULL,
  `idcontato` int(11) DEFAULT NULL,
  `nome_social` varchar(50) DEFAULT NULL,
  `pcd` tinyint(1) NOT NULL,
  PRIMARY KEY (`idfuncionario`),
  UNIQUE KEY `matricula` (`matricula`),
  KEY `fk_funcionario_pK_endereco` (`idendereco`),
  CONSTRAINT `fk_funcionario_pK_endereco` FOREIGN KEY (`idendereco`) REFERENCES `endereco` (`idendereco`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `lote`;
CREATE TABLE `lote` (
  `idlote` int(11) NOT NULL AUTO_INCREMENT,
  `numero_lote` varchar(15) DEFAULT NULL,
  `data_fabricacao` date NOT NULL,
  `validade` date NOT NULL,
  `fabricante` varchar(50) NOT NULL,
  `peso` decimal(7,3) NOT NULL,
  `quantidade` int(11) NOT NULL,
  PRIMARY KEY (`idlote`),
  UNIQUE KEY `numero_lote` (`numero_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `produto`;
CREATE TABLE `produto` (
  `idproduto` int(11) NOT NULL AUTO_INCREMENT,
  `nome_produto` varchar(40) NOT NULL,
  `descricao` text NOT NULL,
  `marca` varchar(15) NOT NULL,
  `preco` decimal(6,2) NOT NULL,
  `idlote` int(11) DEFAULT NULL,
  PRIMARY KEY (`idproduto`),
  KEY `fk_produto_pk_lote` (`idlote`),
  CONSTRAINT `fk_produto_pk_lote` FOREIGN KEY (`idlote`) REFERENCES `lote` (`idlote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `estoque`;
CREATE TABLE `estoque` (
  `idestoque` int(11) NOT NULL AUTO_INCREMENT,
  `idproduto` int(11) DEFAULT NULL,
  `quantidade` int(11) NOT NULL,
  `quantidade_minima` int(11) NOT NULL,
  `quantidade_maxima` int(11) NOT NULL,
  `excesso` int(11) NOT NULL,
  `setor` varchar(15) NOT NULL,
  PRIMARY KEY (`idestoque`),
  KEY `fk_estoque_pk_produto` (`idproduto`),
  CONSTRAINT `fk_estoque_pk_produto` FOREIGN KEY (`idproduto`) REFERENCES `produto` (`idproduto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `venda`;
CREATE TABLE `venda` (
  `idvenda` int(11) NOT NULL AUTO_INCREMENT,
  `idcliente` int(11) DEFAULT NULL,
  `data_hota` datetime NOT NULL DEFAULT current_timestamp(),
  `total_venda` decimal(6,2) NOT NULL,
  PRIMARY KEY (`idvenda`),
  KEY `fk_venda_pk_cliente` (`idcliente`),
  CONSTRAINT `fk_venda_pk_cliente` FOREIGN KEY (`idcliente`) REFERENCES `cliente` (`idcliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `pagamento`;
CREATE TABLE `pagamento` (
  `idpagamento` int(11) NOT NULL AUTO_INCREMENT,
  `idvenda` int(11) DEFAULT NULL,
  `forma_pagamento` enum('Dinheiro','Débito','Crédito','Pix','Vale Alimentação','Vale Refeição','Voucher','Cartão Loja','Gift Card') NOT NULL,
  `parcelamento` int(11) NOT NULL DEFAULT 1,
  `valor_pagamento` decimal(6,2) NOT NULL,
  PRIMARY KEY (`idpagamento`),
  KEY `fk_pagamento_pk_venda` (`idvenda`),
  CONSTRAINT `fk_pagamento_pk_venda` FOREIGN KEY (`idvenda`) REFERENCES `venda` (`idvenda`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `detalhevenda`;
CREATE TABLE `detalhevenda` (
  `iddetalhevenda` int(11) NOT NULL AUTO_INCREMENT,
  `idvenda` int(11) DEFAULT NULL,
  `idproduto` int(11) DEFAULT NULL,
  `quantidade` decimal(5,3) NOT NULL,
  `preco` decimal(6,2) NOT NULL,
  PRIMARY KEY (`iddetalhevenda`),
  KEY `fk_detalhevenda_pk_venda` (`idvenda`),
  KEY `fk_detalhevenda_pk_produto` (`idproduto`),
  CONSTRAINT `fk_detalhevenda_pk_produto` FOREIGN KEY (`idproduto`) REFERENCES `produto` (`idproduto`),
  CONSTRAINT `fk_detalhevenda_pk_venda` FOREIGN KEY (`idvenda`) REFERENCES `venda` (`idvenda`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
