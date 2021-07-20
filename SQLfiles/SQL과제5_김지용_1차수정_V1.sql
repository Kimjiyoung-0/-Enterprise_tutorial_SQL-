/*
1. �Ʒ��� ���� emp table�� �� �ο찡 2���� ��ȸ�ǵ��� �ϵ� gubun �÷��� �ξ� empno �÷����� �����ϵ��� �Ѵ�. �� 28�� ��ȸ�Ǹ� ������ empno �÷������� ��ȸ�ǵ��� ��. 
(join���� 1��,compound operator ����Ͽ� 1��)
*/
/*join*/

select e.*
from 
    (
    select level
    from dual 
    connect by level <= 2
    )  
cross join 
    (
    select rownum gunbun, emp.*
    from 
        (
        select *
        from emp 
        order by empno
        )emp
    ) e
order by gunbun,empno  ;

==> Analytic Function ������� �� ��.;

/*union*/
select rownum gunbun,emp.*
from emp
union all
select rownum gunbun,emp.*
from emp
order by gunbun;

==> Analytic Function ������� �� ��.;
/*
2. �Ʒ��� ���� emp table�� 
�� �ο찡 2���� ��ȸ�ǵ��� �ϵ� 
gubun �÷��� �ξ� ù��° �ο�� �ι�° 
�ο츦 �����ϴ� �÷��� �д�. �� 28�� ��ȸ�Ǹ� ������ empno �� gubun �÷������� ��ȸ�ǵ��� ��. 
*/
/*union*/
select *
from
(
    (
    select 1 gunbun, e.*
    from emp e
    )
    union all
    (
    select 2 gunbun, e2.*
    from emp e2
    )
)
order by empno, gunbun;

/*join*/
select * from
    (
    select level gunbun
    from dual 
    connect by level <= 2
    ) 
natural join 
    (
    select * 
    from emp
    )
order by empno, gunbun;

/*
3. �Ʒ��� ���� emp table�� �����Ͽ� 
�ݳ� �ſ� 1�Ͽ� �ش��ϴ�  sal_date �÷���
��ȸ�ǵ��� �Ͽ� 2020�⵵ ���� �� 14*12 ���� ��ȸ�ǵ��� ��. 
*/

select empno,ename,job,hiredate,saldate,sal
from emp
natural join
    (
    select 
    TO_CHAR(ADD_MONTHS(TRUNC(sysdate,'yyyy'), level-1),'yyyy/mm/dd') as saldate
    from dual 
    connect by level <= 12
    );
    
  ==>    to_char(sysdate,'yyyy/')|| to_char(lpad(level, 2, '0'))||'/01' as saldate �κ� date ���� �״�� �ΰ� �ٽ� �ۼ��� ��.;

/*
4. 3�� ���� ����Ͽ� �Ʒ��� 
���� ���� sal sum�� �������� �Ͽ� 
�� 14*12 ���� ��ȸ�ǵ��� ��. 
rollup ������� ����..
*/
select empno,ename,job,saldate,sal
from ( 
    select empno,ename,job,sal
    from emp
    union all
    select null,null,null,sum(sal)
    from emp
    )
natural join
    (
    select to_char(ADD_MONTHS(TRUNC(sysdate,'yyyy'), level-1),'yyyy/mm/dd') as saldate
    from dual 
    connect by level <= 12
    );