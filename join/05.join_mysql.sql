-- 5.join.sql
-- mysql용

USE fisa;

DROP TABLE IF EXISTS salgrade;

CREATE TABLE salgrade
 ( 
	GRADE INT,
	LOSAL numeric(7,2),
	HISAL numeric(7,2) 
);
  
INSERT INTO salgrade VALUES (1,700,1200);
INSERT INTO salgrade VALUES (2,1201,1400);
INSERT INTO salgrade VALUES (3,1401,2000);
INSERT INTO salgrade VALUES (4,2001,3000);
INSERT INTO salgrade VALUES (5,3001,9999);

COMMIT;

SELECT * FROM salgrade;



/*
1. 조인이란?
	다수의 table간에  공통된 데이터를 기준으로 검색하는 명령어
	- 트렌드 
		: 데이터가 굉장히 많은 시대, join 은 실행속도가 저하  
		가급적 개별 table 로 설계 권장
		꼭 table 분산해야 할 경우에만 다수 table 로 설계
		결론 : join 꼭 필요한 시점에만 적용 권장 
		
	
	다수의 table이란?
		동일한 table을 논리적으로 다수의 table로 간주
			- self join
			- emp의 mgr 즉 상사의 사번으로 이름(ename) 검색
				: emp 하나의 table의 사원 table과 상사 table로 간주

		물리적으로 다른 table간의 조인
			- emp의 deptno라는 부서번호 dept의 부서번호를 기준으로 부서의 이름/위치 정보 검색
  
2. 사용 table 
	1. emp & dept 
	  : deptno 컬럼을 기준으로 연관되어 있음

	 2. emp & salgrade
	  : sal 컬럼을 기준으로 연관되어 있음

  
3. table에 별칭 사용 
	검색시 다중 table의 컬럼명이 다를 경우 table별칭 사용 불필요, 
	서로 다른 table간의 컬럼명이 중복된 경우,
	컬럼 구분을 위해 오라클 엔진에게 정확한 table 소속명을 알려줘야 함

	- table명 또는 table별칭
	- 주의사항 : 컬럼별칭 as[옵션], table별칭 as 사용 불가


4. 조인 종류 
	1. 동등 조인
		 = 동등비교 연산자 사용
		 : 사용 빈도 가장 높음
		 : 테이블에서 같은 조건이 존재할 경우의 값 검색 

	2. not-equi 조인
		: 100% 일치하지 않고 특정 범위내의 데이터 조인시에 사용
		: between ~ and(비교 연산자)

	3. self 조인 
		: 동일 테이블 내에서 진행되는 조인
		: 동일 테이블 내에서 상이한 칼럼 참조
			emp의 empno[사번]과 mgr[사번] 관계

	4. outer 조인 
		: 조인시 조인 조건이 불충분해도 검색 가능하게 하는 조인 
		: 두개 이상의 테이블이 조인될때 특정 데이터가 모든 테이블에 존재하지 않고 컬럼은 존재하나 
		  null값을 보유한 경우
		  검색되지 않는 문제를 해결하기 위해 사용되는 조인
*/		


use fisa;

-- 1. dept table의 구조 검색
show tables;

-- dept, emp, salgrade table의 모든 데이터 검색
select * from dept;
select * from emp;
select * from salgrade;



-- *** 1. 동등 조인 ***
-- = 동등 비교연산자 사용해서 검색


-- 2. SMITH 의 이름(ename), 사번(empno), 근무지역(부서위치)(loc) 정보를 검색
-- emp/dept : deptno 가 공통 데이터 
-- 비교 기준 데이터를 검색조건에 적용해서 검색
-- table명이 너무 복잡한 경우 별칭 권장
select ename, empno, deptno from emp where ename='SMITH';

select loc, deptno from dept;
select loc, deptno from dept where deptno=20;

-- 모범답안 
SELECT ename,empno,loc
FROM emp,dept
WHERE emp.deptno =dept.deptno;
-- 실행 순서 고민 .....
SELECT ename,empno,loc
FROM emp,dept
WHERE emp.deptno =dept.deptno AND ename='SMITH';

SELECT ename,empno,loc
FROM emp,dept
WHERE ename='SMITH' AND emp.deptno =dept.deptno;

-- table 별칭 부여
/*	이슈 ???
 * 	1. mysql- table 별칭 절대 권장 
 * 	2. oracle - table 별칭 선언 후 사용 안해도 이슈 없음
 * 		oracle 버전에 따른 차이 확인 예정  
 * */

SELECT e.deptno 
FROM emp e,dept d
WHERE ename='SMITH' AND e.deptno =d.deptno;


-- 3. deptno가 동일한 모든 데이터(*) 검색
-- emp & dept 
SELECT *
FROM emp, dept;

-- 1차 정제 

SELECT *
FROM emp e,dept d 
WHERE e.deptno = d.deptno ;  -- deptno 필드가 두개 검색됨

-- 2차 정제 - 중복된 컬럼 제거 
-- 해결점 : 검색 컬럼명 일일히 명시
SELECT ename,empno,sal,comm,e.deptno,loc
FROM emp e, dept d 
WHERE e.deptno = d.deptno ;




-- 4. 2+3 번 항목 결합해서 SMITH에 대한
--  모든 정보(ename, empno, sal, comm, deptno, loc) 검색하기
SELECT ename,empno,sal,comm,e.deptno,loc
FROM emp e, dept d 
WHERE e.ename = 'SMITH' AND e.deptno = d.deptno ;



-- 5.  SMITH에 대한 이름(ename)과 부서번호(deptno), 
-- 부서명(dept의 dname) 검색하기

SELECT ename,e.deptno
FROM emp e,dept d
WHERE e.ename ='SMITH' AND e.deptno=d.deptno;

-- 모든 db에 동일한 표준 sql
SELECT ename, e.deptno, dname
FROM emp e inner join dept d
on ename = 'SMITH' and e.deptno =d.deptno ;

-- 6. 조인을 사용해서 뉴욕('NEW YORK')에 근무하는 사원의 이름(ename)과 급여(sal)를 검색 
select ename, loc 
from dept d, emp e
WHERE d.loc='NEW YORK' AND e.deptno =d.deptno ;

select ename, loc 
from dept d inner join emp e
ON d.loc='NEW YORK' AND e.deptno =d.deptno ;



-- 7. 조인 사용해서 ACCOUNTING 부서(dname)에 소속된 사원의
-- 이름과 입사일 검색
select deptno, dname from dept;

select ename,hiredate
from dept d,emp e
WHERE d.dname='ACCOUNTING' AND d.deptno=e.deptno;





-- 8. 직급(job)이 MANAGER인 사원의 이름(ename), 부서명(dname) 검색
-- 단, 데이터 값은 대문자여야만 함
-- 함수로 늘 변환? 대소문자 구분? 

SELECT ename,dname
FROM emp e,dept d
WHERE e.job='MANAGER' AND e.deptno =d.deptno ;



-- *** 2. not-equi 조인 ***

-- salgrade table(급여 등급 관련 table)
select * from salgrade s;

-- 9. 사원의 급여가 몇 등급인지 검색
-- between ~ and : 포함 
SELECT sal FROM emp;
desc emp;

SELECT ename,sal,grade
FROM salgrade s,emp e
WHERE e.sal BETWEEN s.losal AND s.hisal;

SELECT ename,sal,grade
FROM salgrade,emp
WHERE sal BETWEEN losal AND hisal;

-- 참고 : 추후 다른 db사용시 미만, 초과 또는 이하, 이상 여부 검증 후 사용
-- ? BETWEEN ~ and
SELECT ename
from emp, salgrade 
WHERE sal = 800 AND sal BETWEEN losal and hisal ;

-- 동등조인 review
-- 10. 사원(emp) 테이블의 부서 번호(deptno)로 
-- 부서 테이블(dept)을 참조하여 사원명(ename), 부서번호(deptno),
-- 부서의 이름(dname) 검색
select ename, e.deptno, dname
from emp e, dept d
where e.deptno=d.deptno;




-- *** 3. self 조인 ***
-- 하나의 table 을 다수의 table로 논리적으로 구분한 조인 
-- 11. SMITH 직원의 메니저 이름 검색
/* 하나의 table 에 직원 이름
 * 이름으로 상사 사번으로 통해서 상사 이름(직원명)을 검색 
 * */
-- emp e : 사원 table로 간주 / emp m : 상사 table로 간주

SELECT e.ename,m.ename as 상사 
FROM emp e, emp m
WHERE e.ename='SMITH' AND e.mgr=m.empno;


-- 12. 메니저 이름이 KING(m ename='KING')인 
-- 사원들의 이름(e ename)과 직무(e job) 검색
SELECT * from emp;

SELECT e.ename, e.job ,e.mgr
FROM emp e, emp m
WHERE e.mgr=m.empno AND m.ename = 'KING';


-- 13. SMITH와 동일한 부서에서 근무하는 사원의 이름 검색
-- 단, SMITH 이름은 제외하면서 검색 : 부정연산자 사용 != 
SELECT e.ename as 스미스칭긔
FROM emp e, emp s
WHERE s.ename='SMITH' 
	AND s.deptno =e.deptno 
		AND e.ename != 'SMITH'; -- 아 스미스빼고요 
		


-- *** 4. outer join ***
select * from dept; -- deptno, dname, loc
select empno, deptno from emp;  -- 40번 부서에 근무하는 직원들도 없음
select distinct deptno from emp;  -- 40번 부서에 근무하는 직원들도 없음

select ename, mgr from emp;   -- KING의 mgr은 null 


-- 14. 모든 사원명(KING포함), 메니저 명 검색, 단 메니저가 없는 사원(KING)도 검색되어야 함
-- step01 : 사원명에 KING 검색 누락 / 상사 자체가 없는 (NULL) 인 데이터는 검색 불가 

SELECT e.ename as 사원명, m.ename as 상사명
FROM emp e, emp m
WHERE e.mgr = m.empno ; 

-- step02 : ANSI 표준 sql 문장으로 변환
SELECT e.ename as 사원명, m.ename as 상사명
FROM emp e inner join emp m
ON e.mgr = m.empno;

-- step03 : KING 사원명 검색
/* ANSI 조인 문장으로 이해하기
 * 왼쪽 table - 사원테이블 / 오른쪽 table - 상사테이블 
 * null 값을 보유한 table 은 사원? 상사?
 * 
 */

-- 상사 null 값 포함 
SELECT e.ename as 사원명, m.ename as 상사명
FROM emp e left join emp m
ON e.mgr = m.empno;

-- 사원 null 값 포함 
SELECT e.ename as 사원명, m.ename as 상사명
FROM emp e right join emp m
ON e.mgr = m.empno;

SELECT e.ename as 사원명, m.ename as 상사명
FROM emp e right join emp m
ON m.mgr = e.empno;

-- right join 모든 사원명과 상사명 출력 (null 포함)
-- 상사번호가 null 인 사원의 사원명까지 검색 
-- 사용되는 컬럼에 null 값 보유한 table 을 기준으로 검색
-- 사원 table 의 mgr 에는 null 포함
-- 상사 table 의 empno 는 null 자체가 존재하지 않음 

SELECT e.ename as 사원명, m.ename as 상사명
FROM emp m right join emp e
ON e.mgr = m.empno;


-- 15. 모든 직원명(ename), 부서번호(deptno), 부서명(dname) 검색
-- 부서 테이블의 40번 부서와 조인할 사원 테이블의 부서 번호가 없지만,
-- outer join이용해서 40번 부서의 부서 이름도 검색하기 
-- KING 값 보유 : 사원 테이블 
SELECT ename, d.deptno, d.dname
FROM emp e right outer join dept d
	ON e.deptno=d.deptno;
-- WHERE ename='KING';




-- 미션? 모든 부서번호가 검색(40)이 되어야 하며 
-- 급여가 3000이상(sal >= 3000)인 사원의 정보 검색
-- 특정 부서에 소속된 직원이 없을 경우 사원 정보는 검색되지 않아도 됨
-- 검색 컬럼 : deptno, dname, loc, empno, ename, job, mgr, hiredate, sal, comm
/*

검색 결과 예시

+--------+------------+----------+-------+-------+-----------+------+------------+---------+------+
| deptno | dname      | loc      | empno | ename | job       | mgr  | hiredate   | sal     | comm |
+--------+------------+----------+-------+-------+-----------+------+------------+---------+------+
|     10 | ACCOUNTING | NEW YORK |  7839 | KING  | PRESIDENT | NULL | 1981-11-17 | 5000.00 | NULL |
|     20 | RESEARCH   | DALLAS   |  7788 | SCOTT | ANALYST   | 7566 | 1987-04-19 | 3000.00 | NULL |
|     20 | RESEARCH   | DALLAS   |  7902 | FORD  | ANALYST   | 7566 | 1981-12-03 | 3000.00 | NULL |
|     30 | SALES      | CHICAGO  |  NULL | NULL  | NULL      | NULL | NULL       |    NULL | NULL |
|     40 | OPERATIONS | BOSTON   |  NULL | NULL  | NULL      | NULL | NULL       |    NULL | NULL |
+--------+------------+----------+-------+-------+-----------+------+------------+---------+------+
*/
SELECT d.deptno,dname,loc,empno,ename,job,mgr,hiredate,sal,comm
FROM emp e right join dept d
	ON e.deptno = d.deptno AND sal >=3000
ORDER BY deptno;
