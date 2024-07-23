/* 주의 사항
 * 단일 line 주석 작성시 -- 와 내용 사이에 blank 필수
 */
use fisa;

SELECT  * FROM  emp;
SELECT  * FROM  dept;
desc emp;
desc dept;


-- 1. 해당 계정이 사용 가능한 모든 table 검색
SHOW TABLES;


-- 2. emp table의 모든 내용(모든 사원(row), 속성(컬럼)) 검색
SELECT  * FROM  emp;

-- 3. emp의 구조 검색
DESC emp;

-- 4. emp의 사번(empno)만 검색
SELECT empno from emp;

-- 5. emp의 사번(empno), 이름(ename)만 검색
SELECT empno,ename from emp;

-- 6. emp의 사번(empno), 이름(ename)만 검색(별칭 적용)
SELECT empno '사번',ename '사원명' from emp;
-- SELECT empno as '사번',ename as '사원명' from emp;

-- 7. 부서 번호(deptno) 검색
SELECT deptno from emp;


-- 8. 중복 제거된 부서 번호 검색
SELECT DISTINCT deptno from emp;

-- 9. 8 + 오름차순 정렬(order by)해서 검색
-- 오름 차순 : asc  / 내림차순 : desc
SELECT DISTINCT deptno 
from emp 
order by deptno desc;



-- 10. ? 사번(empno)과 이름(ename) 검색 단 사번은 내림차순(order by desc) 정렬
SELECT empno,ename FROM emp ORDER BY empno DESC;
-- 11. ? dept table의 deptno 값만 검색 단 오름차순(asc)으로 검색
SELECT deptno FROM dept ORDER BY deptno ASC;

-- 12. ? 입사일(hiredate) 검색, 
-- 입사일이 오래된 직원부터 검색되게 해 주세요
-- 고려사항 : date 타입도 정렬(order by) 가능 여부 확인
SELECT hiredate FROM emp ORDER BY hiredate ASC;

-- 13. ?모든 사원의 이름과 월 급여(sal)와 연봉 검색
SELECT 1+2;

-- mysql : from 절 생략 가능 / 
-- oracle : select 1 + 2 from dual; //더미테이블이라도 넣어줌  
SELECT ename,sal FROM emp;
-- 14. ?모든 사원의 이름과 월급여(sal)와 연봉(sal*12) 검색
-- 단 comm 도 고려(+comm) = 연봉(sal*12) + comm
-- null값과 연산시에는 모든 데이터가 null
-- 해결책 : null을 0값으로 대체
-- 모든 db는 지원하는 내장 함수 
-- null -> 숫자값으로 대체하는 함수 : IFNULL(null보유컬럼명, 대체값)
SELECT ename,sal '월 급여',sal*12+IFNULL(comm,0)'연봉'
FROM emp;

-- 모든 사원의 이름과 월급여(sal)와 연봉(sal*12)+comm 검색
SELECT COUNT(*) FROM emp;
SELECT COUNT(comm) FROM emp;

SELECT empno, comm, comm+1 from emp;
SELECT empno, comm, sal+comm+1 from emp; -- 데이터 유실 

-- null 값을 수치연산에 어떻게 적용할 것인가? 0으로 대체
SELECT sal , comm, IFNULL(comm,0)+1 from emp;


-- *** 조건식 ***
-- 15. comm이 null인 사원들의 이름과 comm만 검색
-- where 절 : 조건식 의미
SELECT ename, comm 
from emp
WHERE comm IS NULL;


-- 16. comm이 null이 아닌 사원들의 이름과 comm만 검색
-- where 절 : 조건식 의미
-- 아니다 라는 부정 연산자 : not 
SELECT ename, comm 
from emp
WHERE comm IS NOT NULL;

-- ? 모든 직원명, comm 으로 내림차순정렬
-- null값 제일 작은값 취급 
SELECT ename from emp order by comm DESC;


-- 17. ? 사원명이 스미스인 사원의 이름과 사번만 검색
-- = : db에선 동등비교 연산자
-- 참고 : 자바에선  == 동등비교 연산자 / = 대입연산자
SELECT ename,empno
from emp
WHERE ename = 'SMITH'; -- 대소문자 구분 

-- 18. 부서번호가 10번 부서의 직원들 이름, 사번, 부서번호 검색
-- 단, 사번은 내림차순 검색
SELECT  ename, empno, deptno
FROM emp
WHERE deptno = 10
ORDER BY empno DESC ;


-- 19. ? 기본 syntax를 기반으로 
-- emp  table 사용하면서 문제 만들기

-- ? 상사사번이 7698인 사원들 이름 
SELECT ename
FROM emp
WHERE mgr = 7698;

-- ? 
SELECT ename, empno,deptno from emp order by empno desc;
-- 부서 번호는 오름차순, 단 해당 부서에 속한 직원번호도 오름차순
SELECT ename, empno,deptno from emp 
order by deptno asc,empno asc;

-- 결과가 맞는 문장인지의 여부 확인을 위한 추가 문장 개발해보기 
SELECT ename, empno,deptno from emp 
order by deptno DESC ,empno desc;

SELECT ename, empno,deptno from emp 
order by deptno desc,empno asc;

-- 20. 급여가 900이상인 사원들 이름, 사번, 급여 검색 
SELECT ename,empno,sal
FROM emp
WHERE sal >= 900;

-- 21. deptno 10, job 은 
-- manager(대문자로) 이름, 사번, deptno, job 검색

-- 소문자 manager는 미존재 따라서 검색 안됨
SELECT ename,empno,deptno,job
from emp
WHERE deptno=10 AND job='MANAGER';

-- ename은 대소문자 구분 설정을 alter 명령어로 사전 셋팅
-- 대소문자 구분

-- 대소문자 구분 없이 검색을 위한 해결책(대소문자 호환 함수)
-- upper() : 소문자 -> 대문자 / lower() : 대문자 -> 소문자
-- uppercase() : 대문자 ,lowercase() : 소문자 

-- smith 소문자를 대문자로 변경해서 비교
SELECT ename from emp WHERE ename=UPPER('smith'); 
SELECT ename from emp where lower(ename) = 'smith';

SELECT ename,empno,deptno,job
from emp
WHERE deptno=10 AND job=UPPER('manaGer');

-- 22.? deptno가 10 아닌 직원들 사번, 부서번호만 검색
-- 부정연산자 not / != / <>
SELECT empno,deptno from emp WHERE deptno !=10;
SELECT empno,deptno from emp WHERE deptno <> 10;


-- 23. sal이 2000이하(sal <= 2000) 이거나(or) 
-- 3000이상(sal >= 3000)인 사원명, 급여 검색
SELECT ename,sal
from emp
WHERE sal <= 2000 OR sal >= 3000;



-- 24.  comm이 300 or 500 or 1400인
SELECT ename,comm from emp WHERE comm=300 OR comm=500 OR comm=1400;

-- in 연산식 사용해서 좀더 개선된 코드
SELECT ename,comm from emp WHERE comm IN (300,500,1400);
-- 25. ?  comm이 300 or 500 or 1400이 아닌 사원명 검색
SELECT ename,comm from emp WHERE comm NOT IN (300,500,1400);

-- 26. 81/09/28 날 입사한 사원 이름.사번 검색
-- date 타입 비교 학습
-- date 타입은 '' 표현식 가능
-- yy/mm/dd 포멧은 차후에 변경 예정(함수)
SELECT ename,empno,hiredate from emp WHERE hiredate = '1981-09-28';
SELECT ename,empno,hiredate from emp WHERE hiredate = '81/09/28';
-- / 비추
SELECT ename,empno,hiredate from emp WHERE hiredate = '81-09-28';
-- - 권장

-- 27. 날짜 타입의 범위를 기준으로 검색
-- 범위비교시 연산자 : between~and 1980-12-17 ~ 1981-09-28
SELECT ename,empno,hiredate from emp WHERE hiredate BETWEEN '1980-12-17' AND '1981-09-28';

-- 28. 검색시 포함된 모든 데이터 검색하는 기술
-- like 연산자 사용
-- % : 철자 개수 무관하게 검색 / _ : 철자 개수 의미 하나를 의미 



-- 29. 두번째 음절의 단어가 M인 모든 사원명 검색 
SELECT ename FROM emp WHERE ename LIKE '_M%';

-- 30. 단어가 M을 포함한 모든 사원명 검색
SELECT ename FROM emp WHERE ename LIKE '%M%'; 