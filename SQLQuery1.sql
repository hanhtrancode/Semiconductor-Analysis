
--Doanh thu theo tung nam
select [year], sum([B3]) as [Doanh_thu]
from dbo.IC
group by [year]
order by [year]

--Tổng chi phí theo từng năm
select [year], sum([B3]) + sum([B6]) + sum([B13]) - sum([B16])
from dbo.IC
group by [year]
order by [year]

--Toc do phat trien


-- Tính CAGR

print ((@2022/@2018@)^1/4)-1


declare @2018 decimal
set @2018= (select sum([Total(B3)]) as [Doanh_thu]
from dbo.IC
where year=2018
group by year)

declare @2022 decimal
set @2022= (select sum([Total(B3)]) as [Doanh_thu]
from dbo.IC
where year=2022
group by year)

print @2018
print @2022

--Thi phan
-- Luôn có 2 công ty chiếm thị trường lớn 

select top 10 [Công ty], [Thi Phan] *100 as [Thị phần]
from

(select [Công ty],  sum([B3])/ (select sum([B3]) from dbo.IC ) as [Thi Phan]
from dbo.IC
group by [Công ty]
 ) as PVT1

order by [Thi Phan] *100 desc

-- thị phần vào 2018
select top 10 [Công ty], [Thi Phan] *100
from

(select [Công ty], [B3],  [B3]/ (select sum([B3]) from dbo.IC where year=2018) as [Thi Phan]
from dbo.IC
where year=2018) as PVT1

order by [Thi Phan] *100 desc

--THị phần vào 2022
select top 10 [Công ty], [Thi Phan] *100
from

(select [Công ty], [B3],  [B3]/ (select sum([B3]) from dbo.IC where year=2022) as [Thi Phan]
from dbo.IC
where year=2022) as PVT1

order by [Thi Phan] *100 desc


--Bien loi nhuan TB

select [year], (sum([B16]) - sum([B8])) / sum([B3])
from dbo.ic
group by [year]
order by [year] 


--ROA--------------------------------------------------

select i.[year],sum(B16)/sum(A14) from dbo.BC b
join dbo.IC i
on b.[Công ty]=i.[Công ty] and b.[year]=i.[year]
group by i.[year]
order by i.[year]


---ROE----------------------------------------
-- TRung binhROE

select i.[year],sum(B16)/sum(A18) from dbo.BC b
join dbo.IC i
on b.[Công ty]=i.[Công ty] and b.[year]=i.[year]
group by i.[year]
order by i.[year]



--Capex

select [year], sum([Tong dau tu]) as [Tong dau tu] from

(select [Công ty],  [year], ([A9]+ [A10]+ [A11]) as [Tong dau tu]
from dbo.[BC]) as PVT1

group by [year]

order by  [year]


--Doanh thu theo từng năm

select [year], sum([B3]), sum([B6]), sum([B13]), ( sum([B3])+sum([B6])+ sum([B13]))
from dbo.IC
where [year]=2018
group by [year]


select [year], sum([B3]), sum([B6]), sum([B13]), ( sum([B3])+sum([B6])+ sum([B13]))
from dbo.IC
where [year]=2019
group by [year]

select [year], sum([B3]), sum([B6]), sum([B13]), ( sum([B3])+sum([B6])+ sum([B13]))
from dbo.IC
where [year]=2020
group by [year]

select [year], sum([B3]), sum([B6]), sum([B13]), ( sum([B3])+sum([B6])+ sum([B13]))
from dbo.IC
where [year]=2021
group by [year]

select [year], sum([B3]), sum([B6]), sum([B13]), ( sum([B3])+sum([B6])+ sum([B13]))
from dbo.IC
where [year]=2022
group by [year]


--CASH FLOW-----

select i.[Công ty],i.[year],  sum(C1)- (sum(B10)+sum(B11) +sum(B4)+sum(B14))
from dbo.IC i
join dbo.CF c
on i.[Công ty]=c.[Công ty] and i.[year]=c.[year]
where i.[Công ty]=1 and i.[year]=2018
group by i.[Công ty],i.[year]

select [Công ty], [B16]
from dbo.IC 
where [year]=2018 and [Công ty]=1

--BEP

select [Công ty], [B8],[B16], [B16]+[B8]
from dbo.IC
order by [B16]+[B8] desc


--Liquidity--------

--short

select [year], sum([A1]) /sum([A16])
from dbo.BC
group by [year]
order by [year]

----Các công ty có current ratio dưới TB
select * from 

(select [Công ty],[year],sum([A1]) /sum([A16]) as [Current Ratio]
from dbo.BC
having[A16]) is not null
group by [Công ty],[year]

) as PVT

where [year]=2018 and [Current Ratio]<1.0250

--Phân loại các Công ty với current ratio khác nhau
select [year], [Danh gia], count (*)
from
(
select *,
	 case when [Current Ratio] <1 then 'Bad'
	 when [Current Ratio]>1 and [Current Ratio]<2 then 'Good'
	 when [Current Ratio]>2 then 'Little Much'
	 when [Current Ratio]>10 then 'Weird'
	 end as  [Danh gia]

from(
select [Công ty], [year], [Total_asset]/ [Total_liability] as [Current Ratio]
from
(
select * from
(
select [Công ty],[year],sum([A1]) as [Total_asset], sum([A16]) as [Total_liability]

from dbo.BC
where [A16] is not null
group by [Công ty],[year]) as PVT

where [Total_liability]!=0) as PVT2) as PVT3
) as PVT4
group by [year], [Danh gia]
order by [year], [Danh gia]


--Debt Ratio

select [year], sum([A15])/sum ([A14])
from dbo.BC
group by [year]
order by [year]



---THành phần chi phí

select sum([B4])/sum([B3]) + sum([B6]) + sum([B13]) - sum([B16]) as [Chi phí giá vốn], 
		sum([B7])/ sum([B3]) + sum([B6]) + sum([B13]) - sum([B16]) as [Chi phí tài chính], 
		sum([B10])/sum([B3]) + sum([B6]) + sum([B13]) - sum([B16]) as [Chi phí quản lý doanh nghiệp], 
		sum([B11])/sum([B3]) + sum([B6]) + sum([B13]) - sum([B16]) as [Chi phí tài chính], 
		sum([B14])/sum([B3]) + sum([B6]) + sum([B13]) - sum([B16]) as [Chi phí khác]
from dbo.IC

select sum([B4]), sum([B3]) + sum([B6]) + sum([B13]) - sum([B16])
from dbo.IC

--chi phí giá voons

select [year], sum([B4])
from dbo.IC
group by [year]
order by [year]

--tổng nợ

select [year], sum([A15])
from dbo.BC
group by [year]
order by [year]