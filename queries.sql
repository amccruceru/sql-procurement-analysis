-- Project 1: Procurement & Inventory Analysis
USE procurement;

-- Q1: Suppliers based in Germany, sorted by promised lead time
SELECT * FROM suppliers WHERE country = 'Germany' ORDER BY promised_lead_days;


-- Q2: Electrical products priced above 50, most expensive first
SELECT * FROM products WHERE category = 'Electrical' AND unit_price > 50 ORDER BY unit_price DESC;


-- Q3: Products below minimum stock level, with the missing quantity
SELECT p.name, p.min_stock, i.qty_on_hand, p.min_stock - i.qty_on_hand AS shortage FROM products p JOIN inventory i  ON p.product_id = i.product_id WHERE i.qty_on_hand < p.min_stock ORDER by shortage DESC;


-- Q4: Number of purchase orders per supplier
SELECT s.name, COUNT(*) AS nr_orders FROM purchase_orders po JOIN suppliers s ON po.supplier_id = s.supplier_id GROUP BY s.name ORDER BY nr_orders DESC;


-- Q5: Total value of each purchase order
SELECT pi.po_id, ROUND(SUM(pi.quantity * pi.unit_cost), 2) AS order_value FROM po_items pi GROUP BY pi.po_id ORDER BY order_value DESC;


-- Q6: Total spend per product category (delivered orders only)
SELECT p.category, SUM(pi.quantity * pi.unit_cost) AS total_spend FROM po_items pi JOIN products p ON p.product_id = pi.product_id JOIN purchase_orders po ON  po.po_id = pi.po_id WHERE po.status = 'DELIVERED' GROUP BY p.category ORDER BY total_spend DESC;


-- Q7: Lead time (days) between order and delivery for each delivered PO
SELECT po.po_id, po.order_date, d.delivery_date, DATEDIFF(d.delivery_date, po.order_date) AS lead_days FROM purchase_orders po JOIN deliveries d ON d.po_id = po.po_id ORDER BY lead_days DESC;


-- Q8: Average delivery delay per supplier (actual lead time minus promised lead time)
SELECT s.name, ROUND(AVG( DATEDIFF(d.delivery_date, po.order_date) - s.promised_lead_days), 1) AS avg_delay_days FROM purchase_orders po
JOIN deliveries d ON d.po_id = po.po_id JOIN suppliers s ON s.supplier_id = po.supplier_id GROUP BY s.name ORDER BY avg_delay_days DESC;


-- Q9: Monthly purchasing spend in 2026
SELECT DATE_FORMAT(po.order_date, '%Y-%m') AS month, ROUND(SUM(pi.quantity * pi.unit_cost), 2) AS monthly_spend FROM po_items pi JOIN purchase_orders po ON po.po_id = pi.po_id GROUP BY month ORDER BY month;


-- Q10: Suppliers with more than 15 purchase orders
SELECT s.name, COUNT(*) AS nr_orders FROM purchase_orders po JOIN suppliers s ON po.supplier_id = s.supplier_id GROUP BY s.name HAVING COUNT(s.supplier_id) >15;



-- Q11: Top 3 products by purchased value within each category
WITH ranked AS (
    SELECT p.category, p.name,
       SUM(pi.quantity * pi.unit_cost) AS purchased_value,
       RANK() OVER (PARTITION BY p.category ORDER BY SUM(pi.quantity * pi.unit_cost) DESC) AS      rnk
     FROM po_items pi
    JOIN products p ON p.product_id = pi.product_id
    GROUP BY p.category, p.name
)
SELECT * FROM ranked
WHERE rnk <= 3;


-- Q12: Cumulative monthly purchasing spend
WITH monthly AS (
    SELECT DATE_FORMAT(po.order_date, '%Y-%m') AS month,
           ROUND(SUM(pi.quantity * pi.unit_cost), 2) AS monthly_spend
    FROM po_items pi
    JOIN purchase_orders po ON po.po_id = pi.po_id
    GROUP BY month
)  
SELECT month, monthly_spend,  SUM(monthly_spend) OVER (ORDER BY month) AS cumulative_spend FROM monthly ORDER BY month;
