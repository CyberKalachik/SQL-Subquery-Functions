/* ==============================================================================
   SQL Subquery Functions
-------------------------------------------------------------------------------
   This script demonstrates various subquery techniques in SQL.
   It covers result types, subqueries in the FROM clause, in SELECT, 
   with comparison operators, IN, ANY, correlated subqueries, and EXISTS.
   
   Table of Contents:
     1. SUBQUERY - RESULT TYPES
     2. SUBQUERY - FROM CLAUSE
     3. SUBQUERY - SELECT
     4. SUBQUERY - COMPARISON OPERATORS 
     5. SUBQUERY - IN OPERATOR
     6. SUBQUERY - ANY OPERATOR
     7. SUBQUERY - EXISTS OPERATOR
===============================================================================
*/

/* ==============================================================================
   1. SUBQUERY | RESULT TYPES
===============================================================================*/

/* Scalar Query */
SELECT
    AVG(Sales)
FROM Sales.Orders;

/* Row Query */
SELECT
    CustomerID
FROM Sales.Orders;

/* Table Query */
SELECT
    OrderID,
    OrderDate
FROM Sales.Orders;

/* ==============================================================================
  2. SUBQUERY | FROM CLAUSE
===============================================================================*/

/* TASK 1:
   Find the products that have a price higher than the average price of all products.
*/

-- Main Query
SELECT
*
FROM (
    -- Subquery
    SELECT
        ProductID,
        Price,
        AVG(Price) OVER () AS AvgPrice
    FROM Sales.Products
) AS t
WHERE Price > AvgPrice;

/* TASK 1:
   Rank Managers based on their total cost.
*/
-- Main Query
SELECT
    *,
    RANK() OVER (ORDER BY TotalCost DESC) AS CustomerRank
FROM (
    -- Subquery
    SELECT
        Manager,
        SUM(Cost) AS TotalCost
    FROM Sales
    GROUP BY Manager
) AS t;


/* ==============================================================================
   3. SUBQUERY | SELECT
===============================================================================*/

/* TASK 1:
   Show the order IDs, product names, prices, and the total number of orders.
*/
-- Main Query
SELECT
    OrderID,
    Product,
    Price,
    (SELECT COUNT(*) FROM Sales) AS TotalOrders -- Subquery
FROM Sales;

/* TASK 2:
   Find the products that have a price higher than the average price of all products*/

-- Main Query

SELECT
    OrderID,
    Product,
    Price,
    ROUND((SELECT AVG(Price) FROM Sales), 2) AvgPrice
FROM Sales
WHERE Price > (SELECT AVG(Price) FROM Sales);


/* ==============================================================================
   4. SUBQUERY | COMPARISON OPERATORS
===============================================================================*/

/* ==============================================================================
  5. SUBQUERY | IN OPERATOR
===============================================================================*/

/* TASK 1:
   Show the details of orders made by customers in Paris.
*/
-- Main Query
SELECT
    *
FROM Sales
WHERE OrderID IN (
    -- Subquery
    SELECT
        OrderID
    FROM Sales
    WHERE City = 'Paris'
);

/* TASK 2:
   Show the details of orders made by customers not in Paris.
*/
-- Main Query
SELECT
    *
FROM Sales
WHERE OrderID NOT IN (
    -- Subquery
    SELECT
        OrderID
    FROM Sales
    WHERE City = 'Paris'
);

/* ==============================================================================
   6. SUBQUERY | ANY OPERATOR
===============================================================================*/

/* TASK 1:
   Find products purchased Online which cost is greater than the cost of products purchased of any In-store.
*/
SELECT
    OrderID, 
    Product,
    Cost
FROM Sales
WHERE PurchaseType = 'Online'
  AND Cost > ANY (
      SELECT Cost
      FROM Sales
      WHERE PurchaseType = 'In-store'
  );

  /* TASK 2:
   Find products purchased Online which cost is greater than the cost of all products purchased of In-store.
*/
SELECT
    OrderID, 
    Product,
    Cost
FROM Sales
WHERE PurchaseType = 'Online'
  AND Cost > ALL (
      SELECT Cost
      FROM Sales
      WHERE PurchaseType = 'In-store'
  );

/* ==============================================================================
   7. SUBQUERY | EXISTS OPERATOR
===============================================================================*/

/* TASK 1:
   Show the details of orders made by customers in Paris.
*/
SELECT
    *
FROM Sales AS s
WHERE EXISTS (
    SELECT 1
    FROM City_restaurant AS c
    WHERE City = 'Paris'
      AND s.OrderID = c.OrderID
);

/* TASK 2:
   Show the details of orders made by customers not in Paris.
*/
SELECT
    *
FROM Sales AS s
WHERE NOT EXISTS (
    SELECT 1
    FROM City_restaurant AS c
    WHERE City = 'Paris'
      AND s.OrderID = c.OrderID
)