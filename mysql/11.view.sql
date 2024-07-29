-- 11.view.sql
/*
*
*emp 의 comm 컬럼은 영업직원제외하고는 존재자체를 몰라야 함.
*개발자도 직원 
*	- comm 컬럼 제외한 table 정보를 개발자에게 제공 
*	- 방식
*		원본 table 에서 comm 제외하고 가상의 복제본 
*		crud 로 복제본에 반영시 원본 table 데이터 동기화 
* 
*
1. view 에 대한 학습
	- 물리적으로는 미 존재, 단 논리적으로 존재
	- 하나 이상의 테이블을 조회한 결과 집합의 독립적인 데이터베이스 객체
	- 논리적(존재하는 table들에 종속적인 가상 table)

2. 개념
	- 보안을 고려해야 하는 table의 특정 컬럼값 은닉
	또는 여러개의 table의 조인된 데이터를 다수 활용을 해야 할 경우
	특정 컬럼 은닉, 다수 table 조인된 결과의 새로운 테이블 자체를 
	가상으로 db내에 생성시킬수 있는 기법 

3. 문법   
	- create와 drop : create view/drop view
	- crud는 table과 동일
	
	CREATE VIEW view_name AS
	SELECT column1, column2, ...
	FROM table_name
	WHERE condition;
*/

use fisa;

select sal, comm from emp;


-- 1. emp table과 dept table 기반으로 empno, ename, deptno, dname으로 view 생성
drop view if exists emp_dept;

-- join 문장으로 table 생성 및 view 생성

-- 물리적으로 존재하는 새로운 table 생성 
-- 주의사항 : 데이터 갱신시 실제 emp,dept 에는 영향을 주지않음 

-- join 이슈 발생  
create table emp_dept as 
	select empno, ename, e.deptno, dname from emp e, dept d;
desc emp_dept;


-- view 생성
CREATE VIEW emp_dept_v AS SELECT * FROM emp_dept;
desc emp_dept_v;

select * from emp_dept_v;
-- dept table의 SALES라는 데이터를 영업으로 변경 후 view 검색
-- view는 dept table의 가변적인 상황을 그대로 인지 따라서 변경된 내용으로 검색 완료
SELECT * FROM dept;
update dept set dname='영업' where dname='SALES';
select * from dept;  -- 영업으로 검색
select * from emp_dept_v; -- emp_dept_v는 변경 x (영향 x)

-- view와 원본 table의 동기화 확인 
DROP TABLE emp_dept;
DROP VIEW emp_dept_v;
  
create table emp_dept as 
	select empno, ename, e.deptno, dname 
	from emp e, dept d
	WHERE e.deptno=d.deptno;



CREATE VIEW emp_dept_v AS SELECT * FROM emp_dept;

SELECT * FROM emp_dept_v; -- table 로 부터 파생된 논리적인 가상 table
SELECT * FROM emp_dept; -- view  원본 table

-- view 의 데이터 수정 : 7369 의 부서번호를 10번으로 수정
UPDATE emp_dept_v SET deptno = 10 WHERE empno= 7369;

-- view 수정시 원본 table 데이터 동시 수정 확인 
SELECT * FROM emp_dept_v; 
SELECT * FROM emp_dept; 

-- 원본 table 데이터 삭제
DELETE FROM emp_dept WHERE empno = 7369;
SELECT * FROM emp_dept_v; 
SELECT * FROM emp_dept; 



	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


