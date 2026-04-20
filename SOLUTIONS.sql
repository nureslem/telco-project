-- 1.1 Kobİye Destek tarifesindeki müşteriler
SELECT c.*
FROM CUSTOMERS c
JOIN TARIFFS t
ON c.TARIFF_ID = t.TARIFF_ID
WHERE t.NAME = 'Kobiye Destek';

-- 1.2 Bu tarifeye en son katılan müşteri
SELECT *
FROM CUSTOMERS c
JOIN TARIFFS t
ON c.TARIFF_ID = t.TARIFF_ID
WHERE t.NAME = 'Kobiye Destek'
ORDER BY c.SIGNUP_DATE DESC
LIMIT 1;

-- 2.1 Tarifelerin dağılımı
SELECT t.NAME,
       COUNT(*) AS musteri_sayisi
FROM CUSTOMERS c
JOIN TARIFFS t
ON c.TARIFF_ID = t.TARIFF_ID
GROUP BY t.NAME;

-- 3.1 En erken kayıt olan müşteriler
SELECT *
FROM CUSTOMERS
ORDER BY SIGNUP_DATE ASC
LIMIT 10;

-- 3.2 En erken kayıt olan müşterilerin şehir dağılımı
SELECT CITY,
       COUNT(*) AS kisi_sayisi
FROM CUSTOMERS
WHERE SIGNUP_DATE = (
    SELECT MIN(SIGNUP_DATE)
    FROM CUSTOMERS
)
GROUP BY CITY;

-- 4.1 Monthly kaydı eksik müşteriler
SELECT c.CUSTOMER_ID
FROM CUSTOMERS c
LEFT JOIN MONTHLY_STATS m
ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE m.CUSTOMER_ID IS NULL;

-- 4.2 Eksik kayıtların şehir dağılımı
SELECT c.CITY,
       COUNT(*) AS eksik_kisi_sayisi
FROM CUSTOMERS c
LEFT JOIN MONTHLY_STATS m
ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE m.CUSTOMER_ID IS NULL
GROUP BY c.CITY
ORDER BY eksik_kisi_sayisi DESC;

-- 5.1 Data limitinin %75’ini kullanan müşteriler
SELECT c.CUSTOMER_ID,
       c.NAME,
       t.DATA_LIMIT,
       m.DATA_USAGE
FROM CUSTOMERS c
JOIN MONTHLY_STATS m
ON c.CUSTOMER_ID = m.CUSTOMER_ID
JOIN TARIFFS t
ON c.TARIFF_ID = t.TARIFF_ID
WHERE t.DATA_LIMIT > 0
AND m.DATA_USAGE >= 0.75 * t.DATA_LIMIT;

-- 5.2 Paketini tamamen bitiren müşteriler
SELECT c.CUSTOMER_ID,
       c.NAME
FROM CUSTOMERS c
JOIN MONTHLY_STATS m
ON c.CUSTOMER_ID = m.CUSTOMER_ID
JOIN TARIFFS t
ON c.TARIFF_ID = t.TARIFF_ID
WHERE m.DATA_USAGE >= t.DATA_LIMIT
AND m.MINUTE_USAGE >= t.MINUTE_LIMIT
AND m.SMS_USAGE >= t.SMS_LIMIT;

-- 6.1 Ödenmemiş faturası olan müşteriler
SELECT c.CUSTOMER_ID,
       c.NAME
FROM CUSTOMERS c
JOIN MONTHLY_STATS m
ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE m.PAYMENT_STATUS = 'UNPAID';

-- 6.2 Ödeme durumlarının tarifelere göre dağılımı
SELECT t.NAME AS tariff_name,
       m.PAYMENT_STATUS,
       COUNT(*) AS kisi_sayisi
FROM CUSTOMERS c
JOIN MONTHLY_STATS m
ON c.CUSTOMER_ID = m.CUSTOMER_ID
JOIN TARIFFS t
ON c.TARIFF_ID = t.TARIFF_ID
GROUP BY t.NAME, m.PAYMENT_STATUS
ORDER BY t.NAME;