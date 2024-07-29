-- 12.autoincrement.sql
-- mysql 
/* db 엔진이 자동증가시키는 고유한 데이터를 특정 컬럼에 반영하는 기술 
 * 
 * 
 * 1.mysql - autoincrement
 * 		table 생성시 컬럼에 설정 
 * 2.oracle - sequence
 * 		독립적으로 생성 후 insert 시에 sequence 속성과 함께 적용
 * 
 * - table 에 pk타입 고려시 무궁무진하게 증가 가능한 pk에 적용하는 사례가 많음 
 * 
 * 
 * - 여행사이트 여행 예약 :pk
 * 		- 플랫폼에 서비스 등록해서 예약 ?
 * 			예약번호 또는 예약시킨 순번??
 * 		- 자체 사이트에서 예약?
 * 			예약번호, 회원 아이디..?
 * 			이미 회원 -> 여행을 갈 수도, 안갈수도, 가예약만 걸어 둘수도...
 * - 은행의 고객 가입 : pk
 * 		id || 계좌번호 || email || 연락처..
 * 		id 하나가 여러명의 계좌 관리  
 * 		
 *  
1. 개요
	- 새 데이터 저장시 고유 번호가 자동 생성 및 적용하게 하는 기술
	
2. 대표적인 활용 영역
	- 게시물 글번호에 주로 사용
		:생각하기?
			500게시글 작성자가 추후 삭제
			1. 기존 게시글들이 다시 재정렬 후 500번 게시글이 존재 -> x 
			2. 500번은 삭제된 상태로 유지 -> o , 자원 낭비 
			
	- 가입된 회원수 카운팅
	
	

3. 문법
	- auto_increment 키워드 적용
		- 별도의 설정이 없을 경우 시작 순번은 1부터임
		
	- 생성
		- 컬럼명 타입 auto_increment
		
	- 시작 값을 100으로 하려 할 경우
		- alter table table명 auto_increment = 100;
	
*/	
	     

use fisa;

-- 1. 사번에 적용. 1씩 증가

DROP TABLE IF EXISTS emp01;

-- empno를 auto_increment로 자동 증가치 적용시 pk로 미등록시 에러 발생
create table emp01(
	empno int auto_increment,
	ename varchar(10) not null,
	primary key (empno)
);

desc emp01;

-- insert 
insert into emp01 (ename) values ('연아');
select * from emp01;
select * from emp01 limit 10; -- 검색된 결과의 row 수 제약  

-- empno내림차순 검색
SELECT * FROM emp01 ORDER BY empno DESC;
-- ? 내림차순 후 3명의 직원만 검색 
-- FROM -> SELECT -> ORDER BY -> LIMIT 순으로 실행  
SELECT * FROM emp01 ORDER BY empno DESC LIMIT 3;


-- 2. 수정 : 자동 증가분 시작값을 100으로 설정해 보기 
-- 사용 빈도 낮음  
alter table emp01 auto_increment = 100;

insert into emp01 (ename) values ('연아');
select * from emp01; 


