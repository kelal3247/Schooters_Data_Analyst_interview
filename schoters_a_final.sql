select tr_m_prod.customer
, sum(
	coalesce(to_number(substring(tr_m_prod.harga_asli, 3, position('.' in tr_m_prod.harga_asli)-3),'L9G999g999g999.99'), 0)
)
::float8::numeric::money jumlah_produk
from schoters.transaksi_main_produk tr_m_prod
group by tr_m_prod.customer
order by jumlah_produk desc
-- fetch first 5 rows only
;

select tr_serv.customer
, sum(
	coalesce(to_number(substring(tr_serv.harga_service, 3, position('.' in tr_serv.harga_service)-3),'L9G999g999g999.99'), 0)
)
::float8::numeric::money jumlah_produk
from schoters.transaksi_service tr_serv
group by tr_serv.customer
order by jumlah_produk desc
-- fetch first 5 rows only
;

-- , sum(coalesce(to_number(substring(tr_serv.harga_service, 3, position('.' in tr_serv.harga_service)-3),'L9G999g999g999.99'), 0))
-- ::float8::numeric::money jumlah_service

----------------------------------------------------------------------


with tot_prod as(
select 
cust.name
, count(tr_m_prod.customer) total_transaksi
, sum(coalesce(to_number(substring(tr_m_prod.harga_asli, 3, position('.' in tr_m_prod.harga_asli)-3),'L9G999g999g999.99'), 0))
::float8::numeric::money jumlah_product
from schoters.customer cust 
join schoters.transaksi_main_produk tr_m_prod
on cust.name = tr_m_prod.customer
group by cust.name
order by jumlah_product desc
)

, tot_serv as(
select 
cust.name
, count(tr_serv.customer) total_transaksi
, sum(coalesce(to_number(substring(tr_serv.harga_service, 3, position('.' in tr_serv.harga_service)-3),'L9G999g999g999.99'), 0))
::float8::numeric::money jumlah_service
from schoters.customer cust 
join schoters.transaksi_service tr_serv
on cust.name = tr_serv.customer
group by cust.name
order by jumlah_service desc
)

select 
coalesce (tp.name, ts.name) as name
, (tp.total_transaksi + ts.total_transaksi) as total_transaksi_produk_dan_service
, (tp.jumlah_product + ts.jumlah_service) as jumlah_transaksi_produk_dan_service
from tot_prod tp
join tot_serv ts
on tp.name = ts.name
order by jumlah_transaksi_produk_dan_service desc
fetch first 5 rows only
;

