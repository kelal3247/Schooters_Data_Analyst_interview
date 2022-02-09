with tot_prod as(
select 
tr_m_prod.tanggal_transaksi
, count(tr_m_prod.customer) total_transaksi
, sum(coalesce(to_number(substring(tr_m_prod.harga_asli, 3, position('.' in tr_m_prod.harga_asli)-3),'L9G999g999g999.99'), 0))
::float8::numeric::money jumlah_product
from schoters.customer cust 
join schoters.transaksi_main_produk tr_m_prod
on cust.name = tr_m_prod.customer
group by tr_m_prod.tanggal_transaksi
order by tr_m_prod.tanggal_transaksi
)

, tot_serv as(
select 
tr_serv.tanggal_service
, count(tr_serv.customer) total_transaksi
, sum(coalesce(to_number(substring(tr_serv.harga_service, 3, position('.' in tr_serv.harga_service)-3),'L9G999g999g999.99'), 0))
::float8::numeric::money jumlah_service
from schoters.customer cust 
join schoters.transaksi_service tr_serv
on cust.name = tr_serv.customer
group by tr_serv.tanggal_service
order by tr_serv.tanggal_service
)
select
mc.name
, sum(semua.total_transaksi_produk_dan_service)
, sum(semua.jumlah_transaksi_produk_dan_service)
from (
	select
	coalesce (tp.tanggal_transaksi, ts.tanggal_service) as tanggal
	, coalesce((tp.total_transaksi + ts.total_transaksi),tp.total_transaksi,ts.total_transaksi) total_transaksi_produk_dan_service
	, coalesce((tp.jumlah_product + ts.jumlah_service),tp.jumlah_product,ts.jumlah_service) as jumlah_transaksi_produk_dan_service
	from tot_prod tp
	full join tot_serv ts
	on tp.tanggal_transaksi = ts.tanggal_service
	order by tanggal
	) semua
join schoters.marketing_campaign mc
on semua.tanggal between mc.start_date and mc.end_date
group by mc.name
order by mc.name
;