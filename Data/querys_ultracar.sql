-- 01. Identifique os orçamentos onde o valor total não corresponde ao especificado na ordem de serviço. Calcule a diferença entre os valores.

SELECT
	orc.id_orcamento,
	os.valor_total AS valor_da_os,
	orc.valor_total AS valor_do_orcamento,
	(os.valor_total - orc.valor_total) AS diferenca
FROM
	orcamentos AS orc
INNER JOIN
	ordens_servico AS os ON orc.id_orcamento = os.id_orcamento
WHERE
	os.valor_total != orc.valor_total;


-- 2. Identifique os orçamentos que não possuem uma ordem de serviço associada.

SELECT
	orc.id_orcamento,
	orc.valor_total
FROM
	orcamentos AS orc
LEFT JOIN
	ordens_servico AS os ON orc.id_orcamento = os.id_orcamento
WHERE
	os.id_orcamento IS NULL;


-- 3. Determine o valor médio dos orçamentos dos clientes classificados como VIP.

SELECT
	ROUND(AVG(orc.valor_total), 2) AS valor_medio_clientes_vip
FROM
	orcamentos AS orc
INNER JOIN
	clientes ON orc.id_cliente = clientes.id_cliente
WHERE
	clientes.status_cliente = 'VIP';


-- 4. Localize os veículos que possuem caracteres especiais em suas placas.

SELECT
	id_veiculo,
	placa
FROM
	veiculos
WHERE
	NOT placa ~ '^[A-Za-z0-9]+$';


-- 5. Identifique o produto que registrou o maior número de saídas.

SELECT 
    prod.id_produto,
    prod.nome_produto,
    COUNT(po.id_item) AS total_saidas
FROM 
    produtos_orcamento AS po
JOIN 
    produtos AS prod ON po.id_item = prod.id_produto
WHERE 
    po.tipo_item = 'Produto'
GROUP BY 
    prod.id_produto, prod.nome_produto
ORDER BY 
    total_saidas DESC
LIMIT 1;

-- 6. Identifique os orçamentos com o maior e o menor valor de venda, incluindo a região do cliente (Estado e Cidade)

WITH cte_max_min AS (
    SELECT 
        MAX(valor_total) AS max_valor,
        MIN(valor_total) AS min_valor
    FROM 
        orcamentos
)
SELECT 
    orc.id_orcamento,
    orc.data_orcamento,
    orc.valor_total,
    cli.nome AS cliente_nome,
    cli.cidade,
    cli.estado
FROM 
    orcamentos AS orc
JOIN 
    clientes AS cli
ON 
    orc.id_cliente = cli.id_cliente
WHERE 
    orc.valor_total = (SELECT max_valor FROM cte_max_min)
    OR 
    orc.valor_total = (SELECT min_valor FROM cte_max_min);



-- 7. Identifique o fornecedor que apresenta a maior recorrência de vendas.

SELECT 
    forn.nome_fornecedor, 
    COUNT(pd.id_produto) AS total_vendas
FROM 
    produtos AS pd
JOIN 
    fornecedores AS forn ON pd.id_fornecedor = forn.id_fornecedor
GROUP BY 
    forn.nome_fornecedor
ORDER BY 
    total_vendas DESC
LIMIT 1;


-- 8. Delete os registros dos clientes com id_cliente 14 e 10

DELETE FROM 
    clientes 
WHERE 
    id_cliente IN (14, 10);
