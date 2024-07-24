-- 9.integrity.sql
-- DB 자체적으로 강제적인 제약 사항 설정

/* 설정방식 
1. table 생성시 제약조건을 설정하는 기법 
CREATE TABLE table_name (
    column1 datatype constraint,
    column2 datatype constraint,
    column3 datatype constraint,
    ....
);   

2. Data Dictionary란?
	- 제약 조건등의 정보 확인
	- user_constraints
	- oracle 의 경우 이런 사전용 table에는 대문자명으로 table 들 관리 

3. 제약 조건 종류
	emp와 dept의 관계
		- dept 의 deptno가 원조 / emp 의 deptno는 참조
		- dept : 부모 table / emp : 자식 table(dept를 참조하는 구조)
		- dept의 deptno는 중복 불허(not null) - 기본키(pk, primary key)
		- emp의 deptno - 참조키(fk, foreign key, 외래키)
	
	
	2-1. PK[primary key] - 기본키, 중복불가, null불가, 데이터들 구분을 위한 핵심 데이터
		: not null + unique
		:예시 - 회원가입
			id 중복 불허, null 불허, 이메일 필수로 필요로 함
			..
			이메일로 로그인 .. null 과 중복 불허.. 
			
	2-2. not null - 반드시 데이터 존재
	2-3. unique - 중복 불가, null 허용
	2-4. check - table 생성시 규정한 범위의 데이터만 저장 가능
		if 조건과 흡사  
	2-5. default - insert시에 특별한 데이터 미저장시에도 자동 저장되는 기본 값
				- 자바 관점에는 멤버 변수 선언 후 객체 생성 직후 멤버 변수 기본값으로 초기화
	* 2-6. FK[foreign key] 
		- 외래키[참조키], 다른 table의 pk를 참조하는 데이터 
		- table간의 주종 관계가 형성
		- pk 보유 table이 부모, 참조하는 table이 자식
		
	
4. 제약조건 적용 방식
	4-1. table 생성시 적용
		- create table의 마지막 부분에 설정
			방법1 - 제약조건명 없이 설정
			방법2 - constraints 제약조건명 명식
			
		- 참고 : oracle db는 명확하게 사용자 정의 제약조건명 검색 

	4-2. alter 명령어로 제약조건 추가
	- 이미 존재하는 table의 제약조건 수정(추가, 삭제)명령어
		alter table 테이블명 modify 컬럼명 타입 제약조건;
		
	4-3. 제약조건 삭제(drop)
		- table삭제 
		alter table 테이블명 alter 컬럼명 drop 제약조건;
		
*/

-- 1. table 삭제
drop table emp01;

SELECT * FROM USER_CONSTRAINTS;
-- 2. 사용자 정의 제약 조건명 명시하기
-- 개발자는 sql 문법 ok된 상태로 table + 제약조건 생성
-- db 관점에서 기록
create table emp01(
	empno int not null,
	ename varchar(10)
);

--desc emp01;
-- 사전 table 검색 
SELECT * FROM USER_CONSTRAINTS;


-- 3. emp table의 제약조건 조회
-- table 생성시 컬럼 선언시에 not null ???
-- oracle db 에선 table명은 대문자로 데이터화 해서 저장 

select * from USER_CONSTRAINTS 
WHERE TABLE_NAME ='EMP01';

-- empno : not null / ename : null
insert into emp01 (empno, ename) values (1, '재석');
select * from emp01;

insert into emp01 (empno) values (2);  -- ok
select * from emp01;

-- ? 실행해 보기
insert into emp01 (ename) values ('연아');
select * from emp01;



-- *** not null ***
-- 4. alter 로 ename 컬럼을 not null로 변경
--desc emp01;

-- emp01의 ename엔 null이 없어야 정상 실행
delete from emp01 where ename is null;
select * from emp01;


desc emp01;


-- 5. drop 후 dictionary table 검색
drop table emp01;

-- emp01에 대한 정보가 소멸된 상태 확인을 위한 명령어
-- table 삭제시 제약조건도 자동 삭제
select * from USER_CONSTRAINTS 
WHERE TABLE_NAME ='EMP01';


-- 6. 제약 조건 설정후 insert 
DROP TABLE emp01;

-- table 에 컬럼 선언시 제약조건명 적용 하면서 생성
-- 참고 : 보편적으론 not null 은 제약조건명 꼭 명시하지 않는 빈도가 높기는 함 

create table emp01(
	empno int CONSTRAINTS emp01_empno_nn NOT NULL,
	ename varchar(10)
);

SELECT * FROM USER_CONSTRAINTS;

insert into emp01 values(1, 'tester');
select * from emp01;
insert into emp01 (empno, ename) values(2, 'tester');
insert into emp01 (empno) values(3);
select * from emp01;
-- NOT NULL 은 중복은 허용 
insert into emp01 (empno) values(3);
select * from emp01;




-- *** unique ***
-- 7. unique : 고유한 값만 저장 가능, null 허용
-- ? test 를 위한 문자 구성해 보기 

drop table emp02;

--CONSTRAINTS emp01_empno_nn unique

create table emp02(
	empno int,
	ename varchar(10),
	CONSTRAINTS emp01_empno_nn UNIQUE (empno)
);

SELECT * FROM USER_CONSTRAINTS;
DROP TABLE emp02;


select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp02';

insert into emp02 values(1, 'tester');
select * from emp02;

insert into emp02 (ename) values('master');  -- ok 즉 null 허용
select * from emp02;


insert into emp02 (empno) values(2);  -- ok 즉 null 허용
select * from emp02;

-- ?
insert into emp02 (empno) values(2);  
select * from emp02;

/* 참고 : 하단 table 생성 문장에 new line 반영 
 * 이 문장은 정상 실행 가능한 버전이 있고 비정상 실행 버전이 있음
 * 가급적 컬럼 선언과 제약 조건 사이에 blank line 사용 비추 
 */

CREATE TABLE emp02(
	empno int UNIQUE,
	ename varchar(10)
);
SELECT * FROM USER_CONSTRAINTS;

-- 8. alter 명령어로 ename에 unique 적용
desc emp02;
DROP TABLE emp02;
select * from emp02;

CREATE TABLE emp02(
	empno int,
	ename varchar(10)
);

-- alter 명령어로 제약 조건 추가 
ALTER TABLE emp02 ADD UNIQUE(empno);

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='EMP02';


-- ename이 null인 사람 삭제
delete from emp02 where ename is null;
desc emp02;
select * from emp02;

-- ? ename 컬럼에 unique 설정 추가


desc emp02;

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp02';


-- *** Primary key ***
/* 현 시점 상황
 * 1. pk값을 데이터의 무한 증가하는 양 - 숫자로 하는 케이스 다수 
 * 	- 자동 증가 기법 : insert 시 자동 증가분이 반영
 * 	- oracle : sequence (객체)
 * 				별도로 생성후 insert 문장 작성시 적용 문법 필수 반영
 * 	- mysql : auto_increment
 * 				table 생성시 컬럼에 명시만으로 끝 
 * 2. table 명, 컬럼명을 한글로 하기도 함 
 * 	-db는 유니코드 지원 : 한글, 특수기호, 숫자, 영어,
 * 		다국어 모든 언어의 컴퓨터 기호 표준 체계
 * 	- 아스키코드 : 숫자, 특수기호, 영어의 표준기호 체계  
 * 
 */
-- 9. pk설정 : 데이터 구분을 위한 기준 컬럼, 중복과 null 불허
-- primary key
-- ? 컬럼에 제약조건명 없이 적용 -> table 하단에 제약조건명 명시해 보기 
-- -> alter 명령어로 직접 추가 

-- step02

DROP TABLE emp03;

CREATE TABLE emp03 (
	empno int,
	ename varchar(5),
	CONSTRAINT pk_emp03_empno PRIMARY KEY (empno)
);

-- step 03
DROP TABLE emp03;

CREATE TABLE emp03 (
	empno int,
	ename varchar(5)
);
ALTER TABLE emp03 ADD CONSTRAINT pk_emp03_empno PRIMARY KEY (empno);

select * from USER_CONSTRAINTS
where TABLE_NAME='EMP03';

drop table emp03;

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';


-- ?
insert into emp03 values (1, 'tester');
insert into emp03 values (1, 'master'); 

select * from emp03;


-- 12. 제약 조건 삭제
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE table_name='EMP03';

ALTER TABLE emp03 DROP PRIMARY KEY;

ALTER TABLE emp03 ADD CONSTRAINT pk_emp03_empno PRIMARY KEY;

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS WHERE TABLE_NAME='EMP03';






desc emp03;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp03';

alter table emp03 add constraint pk_empno_emp03 primary key(empno);

desc emp03;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp03';


-- *** foreign key ***

-- 13. 외래키[참조키]
-- emp table 기반으로 emp04 복제 단 제약조건은 적용되지 않음
-- alter 명령어로 table의 제약조건 추가 

drop table emp04;
create table emp04 as select * from emp;


-- dept table의 deptno를 emp04의 deptno에 참조 관계 형성
-- 생성시 fk 설정
drop table emp04;


-- empno PK, deptno fk 
CREATE TABLE emp04(
	empno NUMBER(4),
	ename VARCHAR(20) NOT NULL,
	deptno NUMBER(4),
	CONSTRAINT emp04_empno_pk PRIMARY KEY (empno),
	CONSTRAINT emp04_deptno_fk FOREIGN KEY (deptno) REFERENCES dept(deptno)
);

-- 이름으로 제약조건 삭제 
ALTER TABLE emp04 DROP PRIMARY KEY EMP04_EMPNO_PK; -- 에러
ALTER TABLE emp04 DROP FOREIGN KEY EMP04_EMPNO_FK; -- 에러
ALTER TABLE emp04 DROP CONSTRAINT EMP04_EMPNO_FK; -- 제약조건명으로 제약조건 
ALTER TABLE emp04 DROP PRIMARY KEY; -- 성공 
ALTER TABLE emp04 DROP FOREIGN KEY; -- 오류 

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS WHERE TABLE_NAME='EMP04';


insert into emp04 values (1, '연아', 10);
insert into emp04 values (2, '재석', 10);
insert into emp04 values (3, '구씨', 70);  


select * from emp04;


-- *** check ***	
-- 15. check : if 조건식과 같이 저장 직전의 데이터의 유효 유무 검증하는 제약조건 
-- Y or M / 학년 표현등 고정 소량의 데이터 처리시 절대 권장 
drop table emp05;

-- 0초과 데이터만 저장 가능한 check
CREATE TABLE emp05(
	empno NUMBER(4),
	ename VARCHAR(20) NOT NULL,
	age int,
	CHECK (age BETWEEN 1 AND 150)
);

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS WHERE TABLE_NAME='EMP05';

desc emp05;


SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS WHERE TABLE_NAME='EMP05';
-- ?
insert into emp05 values(1, 'master', 10);
insert into emp05 values(2, 'master', -10); -- 에러 

select * from emp05;


-- ? age값이 1~100까지만 DB에 저장
drop table emp05;

create table emp05(
	empno int primary key,
	ename varchar(10) not null,
	age int,
	?
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';
desc emp05;

-- ?
insert into emp05 values(1, 'master', 10);
insert into emp05 values(2, 'master', 200);
select * from emp05;


-- 16. alter & check
drop table emp05;

create table emp05(
	empno int,
	ename varchar(10) not null,
	age int
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';




desc emp05;

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';

insert into emp05 values(1, 'master', 10);
insert into emp05 values(2, 'master', -10); 

select * from emp05;


-- 17. drop a check : 제약조건명 검색 후에 이름으로 삭제
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';

alter table emp05 drop check emp05_chk_1; 

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';



-- 18. ? gender라는 컬럼에는 데이터가 M 또는(or) F만 저장되어야 함
drop table emp06;

create table emp06(
	empno int,
	ename varchar(10) not null,
	gender char(1),
	
	?
);


select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';
 
insert into emp06 values(1, 'master', 'F');
insert into emp01 values(2, 'master', 'T'); 
select * from emp06;




-- 19. alter & check

drop table emp06;

-- char(3) -  무조건 3byte 메모리 점유(고정 문자열 크기 타입)
-- varchar(10) - 가변적인 문자열 메모리 즉 최대 10byte 의미 (가변적 문자열 크기 타입)
create table emp06(
	empno int,
	ename varchar(10) not null,
	gender char(1)
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';

alter table emp06 add check ( gender in ('F', 'M') );

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';

-- ?
insert into emp06 values(1, 'master', 'F');
insert into emp01 values(2, 'master', 'T'); 
select * from emp06;


-- *** default ***
-- 20. 컬럼에 기본값 설정
-- insert시에 데이터를 저장하지 않아도 자동으로 기본값으로 초기화(저장)
-- 자바는 멤버 변수 선언 후 객체 생성 시점에 자동 초기화와 같은 원리
-- 자바는 타입별 기본 값이 자동 대입 / RDBMS 는 사용자가 기본값 직접 지정 

drop table emp06;

create table emp06(
	empno int,
	ename varchar(10) not null,
	age int DEFAULT 1
);

desc emp06;
select CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME
FROM USER_CONSTRAINTS
WHERE table_name='EMP06';


insert into emp06 values(1, 'master', 10);
select * from emp06;

-- age 컬럼에 데이터 저장 생략임에도 1이라는 값 자동 저장
insert into emp06 (empno, ename) values(2, 'master');  
select * from emp06;


-- 21. alter & default

drop table emp06;

create table emp06(
	empno int,
	ename varchar(10) not null,
	age int
);

select CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME
FROM USER_CONSTRAINTS
WHERE table_name='EMP06';


insert into emp06 values(1, 'master', 10);
select * from emp06;

insert into emp06 (empno, ename) values(2, 'use02');
select * from emp06;


select CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME
FROM USER_CONSTRAINTS
WHERE table_name='EMP06';

-- oracle
ALTER TABLE emp06 MODIFY (age DEFAULT 1);
--mysql
--ALTER TABLE emp06 ALTER age SET DEFAULT 1;

-- 22. default drop 
-- defalut 제약조건 삭제
-- age 컬럼은 존재만 하는 상황

-- mysql용 
alter table emp06 alter age drop default;

-- oracle용
alter table emp06 MODIFY (age DEFAULT NULL);

select CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME
FROM USER_CONSTRAINTS
WHERE table_name='EMP06';

-- ?
insert into emp06 (empno, ename) values(3, 'use03');  
insert into emp06 (empno, ename, age) values(4, 'use04', 10);  
insert into emp06 (ename, age) values('use05', 50);  

select * from emp06;
