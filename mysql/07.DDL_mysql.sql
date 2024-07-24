-- mysql (root/root)
-- 7.DDL.sql
-- table 생성(create)과 삭제(drop), table 구조 수정(alter)
-- DDL(Data Definition Language) : 

/* TCL
 * - 트랜잭선 처리 명령어
 * 	- insert/update/delete(DML) 문장에 한해서만 영향을 줌
 * 	- table create/drop/alter(DDL) 명령어와 무관
 * - commit
 * - rollback 
 * - DDL에 영향 X 
 */

/*   
 DB에 데이터를 CRUD 작업 가능하게 해주는 기본 구성
   
[1] table 생성 명령어
    create table table명(
		칼럼명1 칼럼타입[(사이즈)] [제약조건] ,
		칼럼명2....
    ); 

[2] table 삭제 명령어
	drop table table명;
	- 삭제 시도시 table 미존재시 에러 발생

[3] table 구조 수정 명령어
	alter table table명
*/

use fisa;

-- mysql상에서의 table 목록 검색 
show tables;

-- 1. table삭제 
-- 존재해야만 실행 에러가 없는 drop 문장
drop table test; 

-- 존재 여부 확인 후에 존재할 경우에만 삭제하는 drop 문장
drop table if exists test;


-- 2. table 생성  
-- name(varchar(5), age(int) 칼럼 보유한 people table 생성
-- name은 최대 5개 글자 크기의 문자열 데이터 저장 
drop table if exists people;
CREATE TABLE people (
	name VARCHAR(5),
	age INT
);



CREATE TABLE emp (
    empno                int  NOT NULL  AUTO_INCREMENT,
    ename                varchar(20),
    job                  varchar(20),
    mgr                  smallint ,
    hiredate             date,
    sal                  numeric(7,2),
    comm                 numeric(7,2),
    deptno               int,
    CONSTRAINT pk_emp PRIMARY KEY ( empno )
 );
ALTER TABLE friend ADD CONSTRAINT fk_emp_deptno FOREIGN KEY ( deptno ) 

desc people;
-- 데이터를 존재하는 table 의 모든 컬럼과 컬럼 순서에 맞게 값 저장 
insert into people values('park', 10);
insert into people values('김아무개', 10);

SELECT * FROM people;
-- ? 이름의 길이 검색 
SELECT CHAR_LENGTH(name) FROM people;
SELECT LENGTH(name) FROM people;

-- 3. 서브 쿼리 활용해서 emp01 table 생성(이미 존재하는 table기반으로 생성)
-- 구조와 데이터는 복제 가능하나 제약조건은 적용 불가
-- 주의 : alter 명령어로 제약조건 직접 적용해야 함 
/* dept table의 deptno는 emp table 의 기준데이터 
 * dept deptno - pk
 * emp 의 deptno -fk
 * dept가 emp 의 부모 table .주종 관계 
 * 
 */
-- mysql 사전 table 검색
-- mysql 자체적인 부가 정보를 보유하게 되는 자동 생성되는 read 만 가능한 table 들 

select TABLE_SCHEMA, TABLE_NAME 
from information_schema.TABLES
where TABLE_SCHEMA = 'information_schema';

drop table if exists emp01;

select * from emp01;

-- emp01 table의 emp로부터 복제, 제약조건 추가 

drop table if exists emp01;

CREATE TABLE emp01 AS SELECT empno, ename,deptno FROM emp;
desc emp01;

-- 거짓 조건식 적용시에는 table 구조만 복제


select * from emp01;



-- 4. 서브쿼리 활용해서 특정 칼럼(empno)만으로 emp02 table 생성


select * from emp02;


-- 5. deptno=10 조건문 반영해서 empno, ename, deptno로 emp03 table 생성

select * from emp03;
desc emp03;

-- 6. 데이터 insert없이 table 구조로만 새로운 emp04 table생성시 
-- 사용되는 조건식 : where=거짓



-- 이미 존재하는 table의 구조를 변경하는 sql문장 

-- 7. emp01 table에 job이라는 특정 칼럼 추가(job varchar2(10))
-- 이미 데이터를 보유한 table에 새로운 job칼럼 추가 가능 
-- add  : 컬럼 추가 연산자
drop table if exists emp01;

create table emp01 as select empno, ename from emp;
desc emp01;
select * from emp01;

-- 최대 10byte 문자열 저장 가능한 job 컬럼 생성 및 추가 
alter table emp01 add job varchar(10);

desc emp01;
select * from emp01;


-- 8. 이미 존재하는 칼럼 사이즈 변경 시도해 보기
-- 데이터 미 존재 칼럼의 사이즈 수정(크게/작게 다 수정 가능)
-- modify : 컬럼 변경

drop table if exists emp01;
desc emp01;
create table emp01 as select empno, ename, job from emp;
select * from emp01;

select char_length(job) from emp01;
select job from emp01;

-- job 크기를 10으로 변경
desc emp01;
alter table emp01 modify job varchar(10);
desc emp01; -- 10으로 정상 변경

select * from emp01;  -- 모든 데이터 정상 검색

-- 9. 이미 데이터가 존재할 경우 칼럼 사이즈가 큰 사이즈의 컬럼으로 변경 가능 

-- alter table emp01 modify job varchar(3);  실패 
desc emp01;


-- 10. job 칼럼 삭제 
-- 데이터 존재시에도 자동 삭제 
-- drop 
-- add시 필요 정보(컬럼명 타입(사이즈)) / modify 필요 정보(컬럼명 타입(사이즈)) / drop 필요 정보(컬럼명)

alter table emp01 drop column job;
desc emp01;


-- 11. table 자체가 아닌  순수 데이터만 완벽하게 삭제하는 명령어 
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


-- truncate
select * from emp01;
delete from emp01;
select * from emp01;
rollback;  -- delete 문장 무효화, 데이터 복구
select * from emp01;

truncate table emp01; -- emp01 table의 모든 내용 삭제, 영구 저장 되어 버림(commit 불필요)
select * from emp01; -- 데이터 없음
rollback;  -- insert/update/delete 문장에만 적용
select * from emp01;  -- 데이터 없음






