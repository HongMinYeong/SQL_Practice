/*
 1. 개요
	- 새 데이터 저장시 고유 번호가 자동 생성 및 적용하게 하는 기술
	
	
주의사항
1. sequence 적용 속성  - nextval 
2. 다중 table 이 공유는 문법적으로는 가능, 논리적으로는 부적합  
	가급적 하나의 table별로 관리 및 적용  
 */

DROP TABLE dept01;

CREATE TABLE dept01 AS SELECT * FROM dept WHERE 1=0;
SELECT * FROM dept01;

-- deptno 1씩 자동증가 시키는 설정
DROP SEQUENCE dept01_deptno_sq;
CREATE SEQUENCE dept01_deptno_sq;

-- insert시에 반드시 sequence 명으로 명시 
INSERT INTO dept01 VALUES (dept01_deptno_sq.nextval,'교육부','상암');


SELECT * FROM dept01;

-- 현재 시퀀스 번호 확인 명령어 
-- from 절 생략불가 따라서 dummy table 명으로 활용 
SELECT dept01_deptno_sq.currval FROM dual;

