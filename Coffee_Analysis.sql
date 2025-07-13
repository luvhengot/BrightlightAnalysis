SELECT  product_category,
        product_detail,
        product_type,
        store_location,
        
        SUM(transaction_qty) AS number_of_units_sold,
        SUM(transaction_qty*unit_price) AS total_revenue,
        COUNT(transaction_id)AS number_of_sales,
        MAX (transaction_time),
        MIN (transaction_time),
        
    TO_CHAR(TRANSACTION_DATE, 'YYYY/MM') AS month_id,
    MONTHNAME(TRANSACTION_DATE) AS month_name,
    DAYNAME(TRANSACTION_DATE) AS day_name,

CASE
    WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'morning'
    WHEN transaction_time BETWEEN '12:00:00' AND '15:59:59' THEN 'afternoon'
    WHEN transaction_time BETWEEN '16:00:00' AND '20:00:00' THEN 'evening'
    ELSE 'night'
    END AS time_bucket,
CASE
    WHEN SUM (transaction_qty*unit_price) BETWEEN 0 AND 20 THEN 'low'
    WHEN SUM (transaction_qty*unit_price) BETWEEN 21 AND 40 THEN 'med'
    WHEN SUM (transaction_qty*unit_price) BETWEEN 41 AND 60 THEN 'high'
    ELSE 'very high'
    END AS spend_bands,
    
FROM COFFEE_SHOP.PUBLIC.ANALYSIS
GROUP BY time_bucket,
        product_category,
        product_detail,
        product_type,
        store_location,
        month_id,
        month_name,
        day_name
        ORDER BY total_revenue DESC;
