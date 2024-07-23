-- 6.subQueryOracle.sql
-- Oracle vs MySql
/* Oracle : 
 * 	- table 명 대소문자 혼용 가능 
 * 	- 데이터 값 대소문자 명확히 구분 
 * 	- insert / update / delete 실행 후 commit or rollback 필수 
 * 
 * Mysql : 
 * 	- table 명 대소문자 중요 
 * 	- 데이터 값 대소문자 구분하지 않기 때문에 alter 명령어로 추가 설정 또는 
 * 		select 시마다 binary 관련 함수 사용 
 * 	- insert / update / delete 실행 후 자동 commit ; 
 * */

CREATE table emp03 as select * from emp where 1=0; -- 뻥이지로홍
--desc emp03;
SELECT * from emp03;


-- 1. SMITH라는 직원 부서명 (dept.dname) 검색

-- mysql 의 table 명 대소문자 중요  
-- oracle은 데이터 대소문자만 중요 table명은 상관 x

-- inner join
SELECT d.DNAME 
FROM emp e INNER JOIN dept d
ON e.ENAME = 'SMITH' AND e.DEPTNO = d.DEPTNO;
  

-- sub query
SELECT deptno FROM emp WHERE ename='SMITH'; -- 20
SELECT dname FROM dept WHERE deptno=20;-- RESEARCH

SELECT dname
FROM dept
WHERE deptno = (SELECT deptno
				FROM emp 
				WHERE ename = 'SMITH'
				);


-- 2. SMITH와 동일한 직급(job)을 가진 사원들의 모든 정보 검색(SMITH 포함)
SELECT *
FROM emp e
WHERE job = (SELECT job
				FROM emp
				WHERE ename = 'SMITH' 
				);


-- 3. SMITH와 급여가 동일하거나 더 많은(>=) 사원명과 급여 검색
-- SMITH 가 포함된 검색 후에 SMITH 제외된 검색해 보기 

SELECT *
FROM emp e
WHERE job = (SELECT job
				FROM emp
				WHERE ename = 'SMITH' 
				) AND ename != 'SMITH';

-- from select 사용해 보기

SELECT empno, ename, sal from emp;

-- empno, ename, sal 로만 구성된 table 실제존재한다 가정 후 작업해보기

-- SELECT empno, sal*12
-- FROM (select empno, ename,sal from emp);
-- 별칭 필수 ***
SELECT empno, sal*12
FROM (select empno, ename,sal from emp) as e;

-- table에 comm 미존재 검색 불가 에러 발생 
-- SELECT empno, sal*12,comm
-- FROM (select empno, ename,sal from emp) as e;

-- 4. DALLAS에 근무하는 사원의 이름, 부서 번호 검색
select loc from dept where loc='DALLAS';

SELECT ename, deptno
FROM emp
WHERE deptno = (SELECT deptno
				FROM dept
				WHERE loc = 'DALLAS');


-- 5. 평균 급여(avg(sal))보다 더 많이 받는(>) 사원만 검색
SELECT ename,sal
FROM emp e
WHERE sal > (SELECT AVG(sal) 
					FROM emp);	



-- 다중행 서브 쿼리(sub query의 결과값이 하나 이상)
-- 6.급여가 3000이상 사원이 소속된 부서에 속한  사원이름, 급여 검색
	-- 급여가 3000이상 사원의 부서 번호
	-- in
SELECT sal, deptno FROM emp WHERE sal >= 3000;

SELECT ename, sal FROM emp WHERE deptno IN (10, 20);

-- sub query

SELECT ename,sal,deptno 
FROM emp
WHERE deptno IN (SELECT deptno
			FROM emp
			WHERE sal >= 3000
			);
		
SELECT ename,sal,deptno 
FROM emp
WHERE (sal, deptno) IN (SELECT sal, deptno
			FROM emp
			WHERE sal >= 3000
			);

-- sub + order by
-- 이름 오름차순 정렬 
SELECT ename,sal,deptno 
FROM emp
WHERE (sal, deptno) IN (SELECT sal, deptno
			FROM emp
			WHERE sal >= 3000
			)
ORDER BY ename ASC;

-- 부서번호 내림 차순, 이름 오름차순 
SELECT ename,sal,deptno 
FROM emp
WHERE (sal, deptno) IN (SELECT sal, deptno
			FROM emp
			WHERE sal >= 3000
			)
ORDER BY deptno DESC,ename ASC;


-- 7. in 연산자를 이용하여 부서별(group by)로 가장 급여(max())를 많이 
-- 받는 사원의 정보(사번, 사원명, 급여, 부서번호) 검색
SELECT deptno, max(sal)
FROM emp e 
GROUP BY deptno;

SELECT empno,ename,sal,deptno
FROM emp 
WHERE sal IN (SELECT max(sal)
				FROM emp 
				group by deptno);


	

-- 8. 직급(job)이 MANAGER인 사람이 속한 부서의 부서 번호와 부서명(dname)과 지역검색(loc)
SELECT count(job) FROM emp WHERE job='MANAGER';
SELECT deptno, job FROM emp WHERE job='MANAGER';

SELECT deptno, dname, loc 
FROM DEPT d 
WHERE deptno IN (10, 20, 30);

select * from dept;
SELECT * from emp;

SELECT deptno, dname,loc
FROM emp e 
WHERE e.job = 'MANAGER' IN (SELECT deptno
							from dept d
							WHERE 


SELECT ename,sal,deptno 
FROM emp
WHERE (sal, deptno) IN (SELECT sal, deptno
			FROM emp
			WHERE sal >= 3000
			)
ORDER BY ename ASC;


