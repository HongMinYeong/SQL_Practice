/* 학습내용
 * 1. 그룹 함수 
 * 	- null 값을 자동으로 필터링 
 * 2. 예시 
 * 	- 단일 행 함수 : 이름 길이 counting 이름 수 만큼 직원 수 만큼 검색
 * 	- 값이 하나인 함수: 전체 직원 수 검색
 * 
 * 3. 실행순서
 * 	- from -> where -> select -> order by 
 * 	select절
 * 	from 절
 * 	where 절
 * 	order by 절
 * */

SELECT CHAR_LENGTH(ename) from emp; -- 단일행 함수  
SELECT COUNT(*) from emp; -- 그룹함수 

-- 1. 모든 직원의 월 급여 합 (comm 배제)
SELECT SUM(sal) as '모든 직원 월 급여' 
FROM emp;
-- group by ename;

-- 2. comm 합
desc emp;
SELECT SUM(comm) from emp;

-- 3. 부서번호 종류검색
SELECT DISTINCT deptno from emp;
SELECT COUNT(DISTINCT deptno) from emp;

-- 검색된 deptno의 내림차순 적용 
SELECT DISTINCT deptno 
from emp
ORDER BY deptno desc;

-- 4. 최저 급여 검색
SELECT min(sal) as '최저 급여' from emp;

-- *** 그루핑 : group by 절
-- 1. 부서별로 comm 받는 직원 수
	-- 부서별 그룹, comm받는 직원은 counting
-- SELECT deptno,comm from emp;  -- 10,20번 무, 30번 부서에 4명

SELECT deptno,COUNT(comm) 
from emp 
group by deptno;

-- 2. 검색된 결과에 부서 내림차순 
-- from -> group by-> select -> order by 순 
SELECT deptno,COUNT(comm) 
FROM emp 
GROUP BY deptno
ORDER BY deptno desc;


-- 3. 문법 오류 및 논리적으로도 오류 
-- SELECT ename,deptno,COUNT(comm) 
-- from emp 
-- group by deptno;

-- 4. 부서별 급여 합
SELECT SUM(sal),ROUND(AVG(sal),2) 
FROM emp
GROUP BY deptno;

-- 5. 소속 부서별 최대 급여와 최소 급여 
-- 6. 단, 최대 급여 오름차순 정렬 
-- 7. 최대 급여를 order by 절에서 사용했다는 것 select절 후 order by 실행 입증 
SELECT deptno,MAX(sal) as 최대급여, MIN(sal) as 최소급여 
FROM emp
GROUP BY deptno 
ORDER BY 최대급여 ASC;



-- *** having 절 
-- 	그룹화 문장의 조건식 
-- 8. 7번 결과에서 검색 시 
-- 최대 급여가 5000인 부서 정보 제외하면서 검색 

SELECT deptno,MAX(sal) as 최대급여, MIN(sal) as 최소급여 
FROM emp
GROUP BY deptno 
HAVING MAX(sal) < 5000;

-- 9. 8번 문제의 결과에서 부서번호를 내림차순으로 요청
SELECT deptno,MAX(sal) as 최대급여, MIN(sal) as 최소급여 
FROM emp
GROUP BY deptno 
HAVING MAX(sal) < 5000
ORDER BY deptno DESC;

-- oracle 에선 실행 불가 -> 별칭 
/* mysql 실행 
 * 	일반적인 db실행 엔진이 
 * 	인식하는 process
 * 	from -> group by -> having -> select 
 * mysql 에선 일반적인 실행 순서 대비 마킹등으로
 * select절 별칭을 having 절에서도 사용 가능하게 함   
 * */
SELECT deptno,MAX(sal) as 최대급여, MIN(sal) as 최소급여 
FROM emp
GROUP BY deptno 
HAVING 최대급여 < 5000;

-- ? 한문제 제출 + 답안
desc emp;
SELECT * 
FROM emp
WHERE deptno = 10;

-- 부서별 막내입사일
SELECT deptno ,MAX(hiredate) as 막내입사일
FROM emp
group by deptno;
-- 







