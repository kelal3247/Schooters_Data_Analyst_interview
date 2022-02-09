select 
cust.name
-- , count(tr_m_prod.tipe_produk) as total_transaksi_produk
-- , count(tr_serv.customer) as total_transaksi_service
, (sum(to_number(tr_m_prod.harga_asli,'L0G000g000g000.00')))::float8::numeric::money as jumlah_produk
, (sum(to_number(tr_serv.harga_service,'L0G000g000g000.00')))::float8::numeric::money as jumlah_service
from schoters.transaksi_main_produk tr_m_prod
join schoters.customer cust 
on cust.name = tr_m_prod.customer
join schoters.transaksi_service tr_serv
on cust.name = tr_serv.customer
group by cust.name
order by jumlah_produk desc
fetch first 5 rows only;

select tr_m_prod.customer
, tr_m_prod.harga_asli
, ((to_number(tr_m_prod.harga_asli,'L9G999g999g999.99')))::float8::numeric::money as jumlah_produk
, substring(tr_m_prod.harga_asli, 3, position('.' in tr_m_prod.harga_asli)-3)
, to_number(substring(tr_m_prod.harga_asli, 3, position('.' in tr_m_prod.harga_asli)-3),'L9G999g999g999.99')
, coalesce(to_number(substring(tr_m_prod.harga_asli, 3, position('.' in tr_m_prod.harga_asli)-3),'L9G999g999g999.99'), 0)
, coalesce(to_number(substring(tr_m_prod.harga_asli, 3, position('.' in tr_m_prod.harga_asli)-3),'L9G999g999g999.99'), 0)
from schoters.transaksi_main_produk tr_m_prod
-- where tr_m_prod.customer like 'H%'
-- where tr_m_prod.harga_asli is null
-- group by tr_m_prod.customer
order by jumlah_produk desc
-- fetch first 5 rows only
;