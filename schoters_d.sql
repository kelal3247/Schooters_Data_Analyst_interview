select 
count(tr_m_prod.customer) total_wanita
, tr_m_prod.tipe_produk
from schoters.customer cust 
join schoters.transaksi_main_produk tr_m_prod
on cust.name = tr_m_prod.customer
where lower(cust.gender) = 'wanita'
and cust.usia between 20 and 29
group by tr_m_prod.tipe_produk
order by total_wanita desc
-- fetch first 3 rows only
;