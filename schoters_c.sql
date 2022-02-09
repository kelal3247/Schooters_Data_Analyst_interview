with tot_prod as(
select 
to_char(tr_m_prod.tanggal_transaksi, 'Month') as bulan
, to_char(tr_m_prod.tanggal_transaksi, 'mm-yyyy') as tgl_bulan
, count(tr_m_prod.customer) total_transaksi
, sum(coalesce(to_number(substring(tr_m_prod.harga_asli, 3, position('.' in tr_m_prod.harga_asli)-3),'L9G999g999g999.99'), 0))
::float8::numeric::money jumlah_product
from schoters.customer cust 
join schoters.transaksi_main_produk tr_m_prod
on cust.name = tr_m_prod.customer
group by bulan, tgl_bulan
order by tgl_bulan
)

, tot_serv as(
select 
to_char(tr_serv.tanggal_service, 'Month') as bulan
, to_char(tr_serv.tanggal_service, 'mm-yyyy') as tgl_bulan
, count(tr_serv.customer) total_transaksi
, sum(coalesce(to_number(substring(tr_serv.harga_service, 3, position('.' in tr_serv.harga_service)-3),'L9G999g999g999.99'), 0))
::float8::numeric::money jumlah_service
from schoters.customer cust 
join schoters.transaksi_service tr_serv
on cust.name = tr_serv.customer
group by bulan, tgl_bulan
order by tgl_bulan
)

select
coalesce (tp.bulan, ts.bulan) as bulan
, coalesce (tp.tgl_bulan, ts.tgl_bulan) as tgl_bulan
, coalesce((tp.total_transaksi + ts.total_transaksi),tp.total_transaksi,ts.total_transaksi) as total_transaksi_produk_dan_service
, coalesce((tp.jumlah_product + ts.jumlah_service),tp.jumlah_product,ts.jumlah_service) as jumlah_transaksi_produk_dan_service
from tot_prod tp
full join tot_serv ts
on tp.bulan = ts.bulan and tp.tgl_bulan = ts.tgl_bulan
order by tgl_bulan
;