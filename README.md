# Procurement & Inventory Analysis (MySQL)

A small SQL project where I analyse the purchasing data of a fictional manufacturing company: suppliers, products, stock levels, purchase orders and deliveries for 2026.

The goal was to answer practical business questions a purchasing or supply chain team would ask, using only SQL.

## Files

- `procurement_db.sql` creates the database and fills it with sample data
- `queries.sql` contains the 12 queries, each with a short comment

## Database structure

| Table | What it holds |
|---|---|
| suppliers | supplier name, country, promised lead time (days) |
| products | product name, category, list price, minimum stock level |
| inventory | current quantity on hand for each product |
| purchase_orders | order date, supplier, status (DELIVERED / OPEN / CANCELLED) |
| po_items | products, quantities and unit cost on each order |
| deliveries | delivery date for each delivered order |

## Questions answered

| # | Question | SQL used |
|---|---|---|
| Q1 | Suppliers from Germany, sorted by promised lead time | WHERE, ORDER BY |
| Q2 | Electrical products priced above 50 | WHERE with AND |
| Q3 | Products below minimum stock and how much is missing | JOIN, calculated column |
| Q4 | Number of orders per supplier | JOIN, GROUP BY, COUNT |
| Q5 | Total value of each purchase order | SUM, GROUP BY |
| Q6 | Spend per product category (delivered orders only) | 3-table JOIN, SUM |
| Q7 | Lead time between order and delivery | DATEDIFF |
| Q8 | Average delivery delay per supplier | AVG, DATEDIFF |
| Q9 | Monthly purchasing spend | DATE_FORMAT, GROUP BY |
| Q10 | Suppliers with more than 15 orders | HAVING |
| Q11 | Top 3 products by purchased value in each category | CTE, RANK() OVER (PARTITION BY) |
| Q12 | Cumulative monthly spend | CTE, SUM() OVER (ORDER BY) |

## What I found

- **Stock:** four products are below their minimum level. The 100 m cable and the 5 L lubricant are the most urgent, with 88 and 70 units missing.
- **Supplier delays:** Anatolia Parts and Polska Bearings deliver later than promised much more often than the others. They would be the first suppliers to talk to.
- **Where the money goes:** the gearbox (about 262,000) and the PLC module (about 166,000) are by far the biggest costs, so they are the best place to start negotiating prices.
- **Main supplier:** Metalica SRL has the most orders (22).
- **Over the year:** total spend was about 865,000. June and April were the busiest months. November looks very low only because the data stops at the start of the month.

## How to run

1. Open MySQL (command line or Workbench).
2. Run `SOURCE path/to/procurement_db.sql;`
3. Run `SOURCE path/to/queries.sql;` or each query on its own.

## Note

The data is generated for practice and does not belong to a real company.
