with tot_prod as(
select 
cust.name
, rev_p.rating
, count(tr_m_prod.customer) total_transaksi
, sum(coalesce(to_number(substring(tr_m_prod.harga_asli, 3, position('.' in tr_m_prod.harga_asli)-3),'L9G999g999g999.99'), 0))
::float8::numeric::money jumlah_product
from schoters.customer cust 
join schoters.transaksi_main_produk tr_m_prod
on cust.name = tr_m_prod.customer
join schoters.review_perusahaan rev_p
on cust.name = rev_p.name
where rev_p.rating < 5
group by cust.name, rev_p.rating
order by rev_p.rating
)

, tot_serv as(
select 
cust.name
, rev_p.rating
, count(tr_serv.customer) total_transaksi
, sum(coalesce(to_number(substring(tr_serv.harga_service, 3, position('.' in tr_serv.harga_service)-3),'L9G999g999g999.99'), 0))
::float8::numeric::money jumlah_service
from schoters.customer cust 
join schoters.transaksi_service tr_serv
on cust.name = tr_serv.customer
join schoters.review_perusahaan rev_p
on cust.name = rev_p.name
where rev_p.rating < 5
group by cust.name, rev_p.rating
order by rev_p.rating
)

select
coalesce (tp.name, ts.name) as name
,coalesce (tp.rating, ts.rating) as rating
, coalesce((tp.total_transaksi + ts.total_transaksi),tp.total_transaksi,ts.total_transaksi) as total_transaksi_produk_dan_service
, coalesce((tp.jumlah_product + ts.jumlah_service),tp.jumlah_product,ts.jumlah_service) as jumlah_transaksi_produk_dan_service
from tot_prod tp
full join tot_serv ts
on tp.name = ts.name
order by rating
;