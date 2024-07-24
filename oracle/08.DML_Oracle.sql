-- 8.DML.sql

-- *** insert ****
-- 1. 칼럼명 기술없이 데이터 입력
-- table 자체가 생성시에 컬럼 순으로 데이터 값들도 설정해서 저장
drop table emp01;
drop table emp02;

-- 데이터 구조만 복제해서 새로 생성
CREATE TABLE emp01 AS SELECT empno, ename, deptno FROM emp WHERE 1=0;

DESC emp01;
SELECT * FROM emp01;


-- 2. 칼럼명 기술후 데이터 입력 
-- 저장하고자 하는 데이터의 순서를 컬럼명 명시하면서 변경 가능
-- null을 허용하는 컬럼에 값 미저장시 특정 컬럼만 명시해서 값 저장 가능
INSERT INTO emp01 VALUES (10,'재석',10);
select * from emp01;
-- deptno 값 제외하고 insert 시도시 에러 왜  ? 컬럼명 명시 필요한 문법
-- INSERT INTO emp01 VALUES (10,'재석2'); 
INSERT INTO emp01 (empno,ename) VALUES (10,'재석2');

select * from emp01;

-- 0으로 검색하는 현 sql문장은 사번이 0인 사람은 없기 때문에 가치없는 문장
select * from emp01 where empno=0;

insert into emp01 (empno, ename, deptno ) values (5, '재석2', 70);
select * from emp01;


-- 3. 하나의 table에 한번에 데이터 insert하기 
-- , 구분자로 () 표현을 적용해서 저장
drop table emp01;
drop table emp02;
create table emp01 as select empno, ename, deptno from emp where 1=0;
create table emp02 as select empno, ename, deptno from emp where 1=0;
select * from emp01;
select * from emp02;
desc emp01;

INSERT INTO emp01 VALUES (1,'재석',10),(1,'재석2',20);


select * from emp01;


COMMIT;


-- 4. 데이터만 삭제 - rollback으로 복구 불가능한 데이터 삭제 명령어
truncate table emp01;
truncate table emp02;

rollback;  -- 의미 없음
select * from emp01;

-- dept 의 10 번 부서 삭제 시도 
/* 
 dept 의 deptno 는 emp의 deptno가 참조 
 40번 부서 정보는 미활용 / 10번 부서 정보는 활용  
*/
-- 자식 table 에서 사용되는 데이터인 경우 삭제 금지 -> 에러뜸 
-- DELETE FROM dept WHERE deptno = 10;
DELETE FROM dept WHERE deptno = 40; -- 삭제 됨 



-- *** update ***
-- 1. 테이블의 모든 행 변경
drop table emp01;
create table emp01 as select * from emp;
select deptno from emp01;

-- deptno값을 50으로 변경
UPDATE emp01 SET deptno=50;
SELECT deptno = FROM emp01;
rollback; 



select deptno from emp01;
rollback;

-- 10번 부서 번호를 50으로 변경
UPDATE emp01 SET deptno=50 WHERE deptno = 10;

select * from emp01;
commit;

-- ? emp table 의 10 번 부서도 50 으로 변경 가능 ? 
-- UPDATE emp SET deptno=50 WHERE deptno = 10;
-- FK 여서 안돼용 ><, 부모 테이블에 deptno = 50 인 row가 없당
desc emp;
desc dept;
 


-- 2. ? emp01 table의 모든 사원의 급여를 10%(sal*1.1) 인상하기
-- ? emp table로 부터 empno, sal, hiredate, ename 순으로 table 생성
desc emp01;
drop table emp01;

create table emp01 as select empno, sal, hiredate, ename from emp;
desc emp01;
select * from emp01;

-- *** oracle 에서 잉여 table (더미)
-- 문법적으로 구색 맞추기용으로 주로 사용 
SELECT 1*2 FROM dual;
SELECT SYSDATE FROM dual;

UPDATE emp01 SET sal = sal*1.1;

select sal from emp01;



select sal from emp01;
commit;



-- ? 3. emp01의 모든 사원의 입사일을 오늘로 바꿔주세요
select now();

select * from emp01;

UPDATE emp01 SET hiredate=SUBSTR(NOW(),1,10);




select * from emp01;
commit;



-- ? 4. 급여가 3000이상(where sal >= 3000)인 사원의 급여만 10%인상
select sal from emp01;


UPDATE emp01 SET sal=sal*1.1 WHERE sal >=3000;



select sal from emp01;
commit;


-- 5. ?emp01 table 사원의 급여가 1000이상인 사원들의 급여만 500원씩 삭감 
-- insert/update/delete 문장에 한해서만 commit과 rollback 영향을 받음
select sal from emp01;

UPDATE emp01 SET sal=sal-500 WHERE sal >= 1000;




select sal from emp01;
commit;



-- 6. ? emp01 table에 DALLAS(dept의 loc)에 위치한 부서의 소속 사원들의 급여를 1000인상
-- 서브쿼리 사용
drop table emp01;
create table emp01 as select * from emp;
select * from emp01;

select * from dept;
select deptno from dept where loc='DALLAS'; -- 20 번 부서 

select sal from emp01;


select sal from emp01;
commit;


-- 7. ? emp01 table의 SMITH 사원의 부서 번호를 30으로, 직급은 MANAGER 수정
-- 두개 이상의 칼럼값 동시 수정
select deptno, job from emp01 where ename='SMITH';



select deptno, job from emp01 where ename='SMITH';
commit;


-- *** delete ***
-- 8. 하나의 table의 모든 데이터 삭제
select * from emp01;


select * from emp01;
rollback;
select * from emp01;


-- 9. 특정 row 삭제(where 조건식 기준)
-- deptno가 30번 부서의 모든 사원들 사제
delete from emp01 where deptno=30;
select * from emp01;

rollback;

-- 10. emp01 table에서 comm 존재 자체가 없는(null) 사원 모두 삭제
select sal, comm from emp01;



select sal, comm from emp01;
rollback;

-- 11. emp01 table에서 comm이 null이 아닌 사원 모두 삭제
select * from emp01;



select * from emp01;
rollback;


-- 12. emp01 table에서 부서명이 RESEARCH 부서(dept table의 dname)에 소속된 사원 삭제 
-- 서브쿼리 활용
select * from emp01;

select * from dept;
select deptno from dept where dname='RESEARCH';


select * from emp01;
rollback;



-- 13. table 전체 내용 삭제
select * from emp01;


select * from emp01;

rollback;
select * from emp01;



