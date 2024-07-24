
-- oracle상에서의 table 목록 검색 
SELECT * FROM tab;

-- 1. table삭제 
-- 존재해야만 실행 에러가 없는 drop 문장
drop table test; 


-- 2. table 생성  
-- name(varchar(5), age(int) 칼럼 보유한 people table 생성
-- name은 최대 5개 글자 크기의 문자열 데이터 저장 
drop TABLE people;

/* 참고
 * oracle 설치시 기본 db 접속 프로그램 자동 설치 : sqlplus
 * oracle 접속시 $sqlplus id/pw 로 접속
 * 순수 tool 등에선 실행 가능 DBeaver 에선 실행 불가 
 */


-- desc people;

-- 3. 서브 쿼리 활용해서 emp01 table 생성(이미 존재하는 table기반으로 생성)
-- 구조와 데이터는 복제 가능하나 제약조건은 적용 불가
-- 09 제약조건 설정의 13번 항목 참조 

drop TABLE emp01;

select * from emp01;
-- emp01 table의 emp로부터 복제, 제약조건 추가 

CREATE TABLE emp01 AS SELECT empno, ename,deptno FROM emp;
select * from emp01;

drop table emp01;


-- 거짓 조건식 적용시에는 table 구조만 복제


select * from emp01;

-- 필요항목
-- 제약조건에 이름 부여 
-- emp01 의 empno 먼저 기본키(중복 불허, null 불허) : 데이터 구분 
ALTER TABLE emp01 ADD CONSTRAINT pk_emp01_empno PRIMARY KEY(empno);

-- ? pk 라는 기본키가 설정된 empno값을 중복해서 저장 시도 
SELECT * FROM emp01;



-- 부모 table 의 컬럼(dept deptno),자식table의 컬럼 (emp01 deptno)
ALTER TABLE emp01 ADD FOREIGN KEY (deptno) REFERENCES dept (deptno);


--? oracle 에 제약조건을 확인 가능한 사전 table명 확인 후 검색해서
-- 제약조건명 확인 :user_constraints
/* user_contraints
 * 	- table 의 제약조건 확인 사전 table
 * 	- p : primary key / R : reference key 
 * 	- table 명 저장시 대문자로만 구분해서 저장 및 관리
 * 	- select 문장 등 수행시에는 oracle에서는 대소문자 중요치 않음 
 * 	- 단, mysql table 대소문자 중요 
 * 	- emp01 인식 안되는 현상 발생 
 * 
 */

SELECT * FROM USER_CONSTRAINTS;

-- 4. 서브쿼리 활용해서 특정 칼럼(empno)만으로 emp02 table 생성


select * from emp02;
CREATE TABLE emp02 AS SELECT empno FROM emp;
SELECT * FROM emp02;


-- 5. deptno=10 조건문 반영해서 empno, ename, deptno로 emp03 table 생성
DROP TABLE emp03;
CREATE TABLE EMP03 
	AS SELECT empno, ename, deptno
		FROM emp WHERE deptno = 10;
	
	
select * from emp03;

desc emp03;

-- 6. 데이터 insert없이 table 구조로만 새로운 emp04 table생성시 
-- 사용되는 조건식 : where=거짓
DROP TABLE emp04;

-- 데이터는 없고 구조만 복제 
CREATE TABLE emp04
	AS SELECT * FROM emp WHERE 1=0;

SELECT * FROM emp04;


-- 이미 존재하는 table의 구조를 변경하는 sql문장 
-- 존재하는 컬럼 삭제, 수정 
/* 고려사항
 * 1. 데이터가 있다. 
 * 	1-1. 컬럼을 삭제
 *  1-2. 컬럼 크기 조정
 * 		1-2-1. 데이터들 크기보다 크게 수정
 * 		1-2-2. 존재하는 데이터들 크기보다 작게 수정
 * 	1-3. 타입 변경
 * 		1-3-1. 데이터가 없는 상태에서 상태 변경
 * 		1-3-2. 데이터가 있는 상태에서 상태 변경
 * */

-- 7. emp01 table에 job이라는 특정 칼럼 추가(job varchar2(10))
-- 이미 데이터를 보유한 table에 새로운 job칼럼 추가 가능 
-- add  : 컬럼 추가 연산자
drop table emp01;

create table emp01 as select empno, ename from emp;
--desc emp01;
select * from emp01;

-- 최대 10byte 문자열 저장 가능한 job 컬럼 생성 및 추가 
alter table emp01 add job varchar(10);

--desc emp01;
select * from emp01;


-- 8. 이미 존재하는 칼럼 사이즈 변경 시도해 보기
-- 데이터 미 존재 칼럼의 사이즈 수정(크게/작게 다 수정 가능)
-- modify : 컬럼 변경

drop TABLE emp01;
--desc emp01;
create table emp01 as select empno, ename from emp;
select * from emp01;

select job,length(job) from emp01;

select job from emp01;

-- job 크기를 10으로 변경
-- desc emp01;
/* oracle 과 mysql 문자열 타입 - varchar
 * 	oracle 8 버전이후 - varchar2
 * 		table 생성시 varchar 표현할 경우에 oracle 엔진이varchar2로 변환 
 * 	mysql - varchar 
 * */
alter table emp01 add job varchar2(10);
desc emp01; -- 10으로 정상 변경

select * from emp01;  -- 모든 데이터 정상 검색

-- 9. 이미 데이터가 존재할 경우 칼럼 사이즈가 큰 사이즈의 컬럼으로 변경 가능 

-- alter table emp01 modify job varchar(3);  실패 
desc emp01;
alter table emp01 modify job varchar2(3);

ALTER TABLE emp01 DROP COLUMN job ;
-- 10. job 칼럼 삭제 
-- 데이터 존재시에도 자동 삭제 !!
-- drop 
-- add시 필요 정보(컬럼명 타입(사이즈)) / modify 필요 정보(컬럼명 타입(사이즈)) / drop 필요 정보(컬럼명)
/* 데이터 크기보다 적게 수정은 불가능 
 * 데이터가 존재할 경우 해당 컬럼은 삭제 
 * 권장 : table 생성 후 제약 조건 추가는 빈번
 * 		컬럼 삭제는 극히 드문일로 처리 
 * */
alter table emp01 drop column job;
desc emp01;


-- 11. table 자체가 아닌  순수 데이터만 완벽하게 삭제하는 명령어 
-- 트랜잭션 처리 필수 : commit 영구저장, rollback 복원
/* insert -> commit : 영구저장된 사용 가능한 데이터 
 * 	: 트랜잭션 
 * */
-- 주의사항 : tool 사용시 tool 기능 auto commit 즉 삭제시 영구 삭제하는지 반드시 확인
-- commit 불필요
-- DELETE  or TRUNCATE 

-- delete 
select * from emp01;
-- emp01의 SMITH 삭제
delete from emp01 where ename='SMITH';
select * from emp01;
rollback;   -- 복원(임시 메모리에 저장되었던 작업을 무효화), 삭제 작업 무효화
select * from emp01; -- SMITH 검색

delete from emp01 where ename='SMITH';
select * from emp01;
commit;  -- 수정된 작업들 영구 저장

select * from emp01;
rollback; -- commit 이후에 작업된 내용에 한해서만 복원
select * from emp01;


select * from people;
insert into people values ('김연아', 30);
select * from people;

commit;

insert into people values ('신동엽', 10);
select * from people;
rollback;
select * from people;


-- truncate : commit 과 rollback 무관  
-- 모든 데이터를 삭제해야 할 경우 실행 속도 고려시 : truncate 추천  
select * from emp01;
delete from emp01;
select * from emp01;
rollback;  -- delete 문장 무효화, 데이터 복구
select * from emp01;

truncate table emp01; -- emp01 table의 모든 내용 삭제, 영구 저장 되어 버림(commit 불필요)
select * from emp01; -- 데이터 없음
rollback;  -- insert/update/delete 문장에만 적용
select * from emp01;  -- 데이터 없음






