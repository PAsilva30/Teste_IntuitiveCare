##############################################################################################################################
# Teste 3 - Banco de dados
# <> Objetivos:
# 1) => Criar queries para criar tabelas com as colunas necessárias para o arquivo csv.
# 2) => Queries de load: criar as queries para carregar o conteúdo dos arquivos obtidos nas tarefas de preparação
#---------------------- Atenção ao encoding dos arquivos no momento da importação! ------------------------------
# 3) => Montar uma query analítica que traga a resposta para as seguintes perguntas:
#----------Quais as 10 operadoras que mais tiveram despesas com 
#----------"EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre?
#
#----------Quais as 10 operadoras que mais tiveram despesas com 
#----------"EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último ano?
##############################################################################################################################
# Criando o banco de dados:
CREATE DATABASE IF NOT EXISTS Teste3_Pedro;
use Teste3_Pedro; #Selecionando o banco de dados recém criado

#####################################
# QUERIE DE LOAD (Relatório Cadop): #
#####################################
CREATE TABLE IF NOT exists relatorio (
`Registro` varchar(50),
`CNPJ` varchar(255),
`Razão Social` varchar(255),
`Nome Fantasia` varchar(255),
`Modalidade` varchar(255),
`Logradouro` varchar(255),
`Número` varchar(50),
`Complemento` varchar(255),
`Bairro` varchar(255),
`Cidade` varchar(50),
`UF` varchar(2),
`CEP` varchar(255),
`DDD` varchar(5),
`Telefone` varchar(50),
`FAX` varchar(255),
`Endereco Eletronico` varchar(255),
`Representante` varchar(255),
`Cargo Representante` varchar(255),
`Data Registro ANS` varchar(50),
PRIMARY KEY(registro)
);	# Criando tabela para receber os dados

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Teste_IntuitiveCare/Relatorio_cadop(1) (2).csv"
INTO TABLE relatorio
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' #
IGNORE 2 ROWS; #Ignora as duas primeiras linhas (sem informações relevantes)
#Recebendo os dados do csv

select count(*) from relatorio; #Contando todas as linhas da tabela relatório

###############################################
# QUERIE DE LOAD 2 (Demonstrações Contabeis): #
###############################################
CREATE TABLE IF NOT EXISTS demonstrativos (
`DATA` varchar(50),
`REG_ANS` varchar(50) NOT NULL,
`CD_CONTA_CONTABIL` varchar(150),
`DESCRICAO` varchar(255),
`VL_SALDO_FINAL` varchar(50)
); # Criando tabela para receber os dados

## 1T2021 => 688.887 linhas
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Teste_IntuitiveCare/1T2021.csv"
INTO TABLE demonstrativos
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

## 2T2021 => 723.536 linhas
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Teste_IntuitiveCare/2T2021.csv"
INTO TABLE demonstrativos
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

## 3T2021 => 742.529 linhas
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Teste_IntuitiveCare/3T2021.csv"
INTO TABLE demonstrativos
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

## 4T2021 => 907.099 linhas
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Teste_IntuitiveCare/4T2021.csv"
INTO TABLE demonstrativos
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

## 1T2022 => 728.891 linhas
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Teste_IntuitiveCare/1T2022.csv"
INTO TABLE demonstrativos
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

## 2T2022 => 755.972 linhas
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Teste_IntuitiveCare/2T2022.csv"
INTO TABLE demonstrativos
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

####################
# QUERIE ANALÍTICA #
####################

# 1°) 10 operadoras que mais tiveram despesas com "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre

SELECT demonstrativos.`REG_ANS`, relatorio.`Razão Social` as `Operadoras`, demonstrativos.`VL_SALDO_FINAL` as `VALOR_TOTAL_TRIM`, demonstrativos.descricao 
FROM demonstrativos 
JOIN relatorio 
ON demonstrativos.`REG_ANS` = relatorio.Registro
WHERE `DESCRICAO` = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR ' and `DATA` = "01/04/2022"
ORDER BY CAST(REPLACE(`VL_SALDO_FINAL`, ',', '.') AS DOUBLE) #Trocando vírgulas por pontos no saldo final depois transformando eles em double
LIMIT 10;

# 2°) 10 operadoras que mais tiveram despesas com "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último ano?
SELECT demonstrativos.`REG_ANS`, relatorio.`Razão Social` as `Operadoras`, demonstrativos.`VL_SALDO_FINAL` as `VALOR_TOTAL_TRIM`, demonstrativos.descricao 
FROM demonstrativos
JOIN relatorio 
ON demonstrativos.`REG_ANS` = relatorio.Registro
WHERE `DESCRICAO` = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR ' and `DATA` LIKE "%2021"
ORDER BY CAST(REPLACE(`VL_SALDO_FINAL`, ',', '.') AS DOUBLE)
LIMIT 10;