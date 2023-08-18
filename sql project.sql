SELECT * FROM sales_data.sales;

select distinct status, year_id, productline, country, deal_size, territory from sales_data.sales;

select productline, sum(sales) as revenue
from sales_data.sales
group by productline
order by revenue desc;
-- classic cars has got highest revenue

select YEAR_ID, sum(sales) as revenue
from sales_data.sales
group by YEAR_ID
order by revenue desc;
-- 2004 has best sales

select DEALSIZE, sum(sales) as revenue
from sales_data.sales
group by DEALSIZE
order by revenue desc;
-- medium sized works good

-- what was the best month for sales for the specific year? how much was earned that month
select MONTH_ID, sum(sales) as revenue, count(ORDERNUMBER) as frequency
from sales_data.sales 
where YEAR_ID = 2004
group by MONTH_ID
order by revenue desc;
-- november is the best month

-- who is our best customer?
-- using RFM analysis-- 
with rfm as(
select  CUSTOMERNAME, max(ORDERDATE) as last_order_date, sum(SALES) as monetary_value, avg(SALES) as avg_monetary_value, (ORDERNUMBER) as frequency
-- (select max(ORDERDATE) from sales_data.sales) as max_order_date,
-- datediff(dy, max(ORDERDATE), max_order_date) as recency
from sales_data.sales 
group by CUSTOMERNAME
),

rfm_calc as (
select *,
ntile(4) over (order by monetary_value desc) as rfm_monetary,
ntile(4) over (order by frequency) as rfm_frequency,
ntile(4) over (order by last_order_date) as rfm_recency

from rfm)

select customername,
rfm_monetary + rfm_frequency + rfm_recency as rfm_cell,
-- cast(rfm_monetary as char(3))+ cast(rfm_monetary as char(3))+cast(rfm_monetary as char(3)) as rfm_string,
concat(rfm_recency,rfm_frequency,rfm_monetary)as rfm_string
from rfm_calc;

select customername,rfm_recency,rfm_frequency,rfm_monetary,
case 
when rfm_string in (111,112,121,122,123,132,211,212,114,141) then 'lost_customers'
when rfm_string in (133,134,143,244,334,343,344) then 'slipping_away, cant_lose'
when rfm_string in (311,411,331) then 'new_customers'
when rfm_string in (222,223,233,322) then 'potential_customers'
when rfm_string in (323, 333,321,422,332,432) then 'active'
when rfm_string in (433,434,443,444) then 'loyal'
end rfm_segment
from rfm;

-- which products are most often sold together?
select ordernumber, count(*)as rn
from sales_data.sales 
where status = 'shipped'and count(*)=2
group by ORDERNUMBER;





   





