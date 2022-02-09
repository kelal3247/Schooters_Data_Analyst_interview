with tot_prod as(
select 
cust.domisili
, count(tr_m_prod.customer) total_transaksi
, sum(coalesce(to_number(substring(tr_m_prod.harga_asli, 3, position('.' in tr_m_prod.harga_asli)-3),'L9G999g999g999.99'), 0))
::float8::numeric::money jumlah_product
from schoters.customer cust 
join schoters.transaksi_main_produk tr_m_prod
on cust.name = tr_m_prod.customer
group by cust.domisili
order by jumlah_product desc
)

, tot_serv as(
select 
cust.domisili
, count(tr_serv.customer) total_transaksi
, sum(coalesce(to_number(substring(tr_serv.harga_service, 3, position('.' in tr_serv.harga_service)-3),'L9G999g999g999.99'), 0))
::float8::numeric::money jumlah_service
from schoters.customer cust 
join schoters.transaksi_service tr_serv
on cust.name = tr_serv.customer
group by cust.domisili
order by jumlah_service desc
)

select 
coalesce (tp.domisili, ts.domisili) as domisili
, (tp.total_transaksi + ts.total_transaksi) as total_transaksi_produk_dan_service
, (tp.jumlah_product + ts.jumlah_service) as jumlah_transaksi_produk_dan_service
from tot_prod tp
join tot_serv ts
on tp.domisili = ts.domisili
order by jumlah_transaksi_produk_dan_service desc
fetch first 5 rows only
;