-- 3.selectFunction.sql
/*
   내장 함수 종류
      1. 단일행 함수 - 입력한 행수(row) 만큼 결과 반환
      				length() = 입력된 row수만큼 반환
      2. 집계(다중행, 그룹) 함수 - 입력한 행수와 달리 결과값 하나만 반환 
					count() - 반환값이 해당 합계인 하나 
*/  

use fisa;

-- 단일행 함수 : 입력 데이터 수만큼 출력 데이터
/* 
1. db의 함수 종류
	- 내장 함수
		- parameter 로 받고 return 값들도 있음 
		- select count(*) from dual;
	- 사용자 정의 함수
		- 프로시저 학습 추천 
Mysql Db 자체적인 지원 함수 다수 존재
1. 숫자 함수 MySQL Numeric Functions
2. 문자 함수
3. 날짜 함수 

**/


-- *** [숫자함수] ***
-- 1. 절대값 구하는 함수 : abs()
select 3.5, -3.5, +3.5;
select 3.5, ABS(-3.5), +3.5;


-- 2. 반올림 구하는 함수 : round(데이터 [, 반올림자릿수])
-- 반올림자릿수 : 소수점을 기준으로 양수는 소수점 이하 자리수 의미
         -- 음수인 경우 정수자릿수 의미

SELECT 10/3; -- 3.3333
SELECT ROUND(10/3); -- 3 
SELECT ROUND(10/3,2); -- 3.33



-- 3. 지정한 자리수 이하 버리는 함수 : trunc() : oracle
-- 반올림 미적용
-- truncate(데이터, 소수자릿수)
-- 자릿수 : +(소수점 이하), -(정수 의미)
-- 참고 : 존재하는 table의 데이터만 삭제시 방법 : delete[복원]/truncate[복원불가]

SELECT 10/4; -- 2.5
SELECT ROUND(10/4); -- 3
SELECT ROUND(10/4,2); -- 2.5
SELECT TRUNCATE(10/3,1); -- 3.3 
SELECT TRUNCATE(10/4,1); -- 2.5

-- 원본 table 복제 : 제약조건 제외한 구조와 데이터 복제 
CREATE TABLE emp01 AS SELECT * FROM emp; -- emp테이블 복사 
DESC emp01; -- 제약조건은 없음 
SELECT * FROM emp01;
-- 실습전 autocommit 설정 무효화 
DELETE FROM emp01; -- emp01 table 데이터 다 삭제 의미 
SELECT * FROM emp01; -- 검색 불가

ROLLBACK; -- DML (DELETE/INSERT/UPDATE) 에만 적용되는 복원
SELECT * FROM emp01; -- 복구 완 

TRUNCATE emp01; -- 복구 불가 // 빠른 속도로 삭제 가능  
SELECT * FROM emp01;
ROLLBACK; -- 의미 x 
SELECT * FROM emp01;

-- 4. 나누고 난 나머지 값 연산 함수 : mod()
-- 모듈러스 연산자, % 표기로 연산, 오라클에선 mod() 함수명 사용
SELECT 10/2;
SELECT MOD(10,2); -- 0,나머지값

-- 5. ? emp table에서 사번(empno)이 홀수인 사원의 이름(ename), 
-- 사번(empno) 검색 
SELECT empno FROM emp WHERE MOD(empno,2) != 0 ;

-- *** [문자함수] ***
/* tip : 영어 대소문자 의미하는 단어들
대문자 : upper
소문자 : lower
철자 : case 
*/
-- 1. 대문자로 변화시키는 함수
-- upper() : 대문자[uppercase]
-- lower() : 소문자[lowercase]


-- 2. ? manager로 job 칼럼과 뜻이 일치되는 사원의 사원명 검색하기 
-- mysql은 데이터값의 대소문자 구분없이 검색 가능
-- 해결책 1 : binary()  대소문자 구분을 위한 함수
-- 해결책 2 : alter 명령어로 처리

-- ? 해결책 : alter명령어로 처리 
DROP TABLE emp02;
CREATE TABLE emp02 AS SELECT ename,empno,job FROM emp;
SELECT * FROM emp02;

SELECT job FROM emp02;
SELECT job FROM emp02 WHERE job='clerk';
SELECT job FROM emp02 WHERE job='CLERK';

-- 컬럼 타입 확인
DESC emp02;


SELECT ename FROM emp02 WHERE job='manager';
SELECT ename FROM emp02 WHERE job='MANAGER';

ALTER TABLE emp02 CHANGE job job VARCHAR(20) binary;



-- 3. 문자열 길이 체크함수 : length()
-- 문자열의 길이를 byte 단위로 반환 
/* 영어, 숫자 - byte(8bit)
 * 한글 한글자 - 16bit 2byte
 * 현 mysql 한글 두글자 - 3byte ..
 * */
CREATE TABLE dept01 AS SELECT dname FROM dept;
DESC dept01; -- VARCHAR(20)
SELECT * FROM dept01;
SELECT LENGTH(dname),dname FROM dept01;

INSERT INTO dept01 VALUES('상암'); -- 한글





-- 4. 문자열 일부 추출 함수 : substr()
-- 서브스트링 : 하나의 문자열에서 일부 언어 발췌하는 로직의 표현

-- substr(데이터, 시작위치, 추출할 개수)
-- 시작위치 : 1부터 시작
SELECT dname FROM dept;
SELECT SUBSTR(dname,1,2) FROM dept; -- dname에서 처음부터 2글자 추출

-- 문자열 길이 카운팅 함수 
SELECT CHAR_LENGTH(dname) FROM dept01;

-- 5. ? 년도 구분없이 2월에 입사한 사원(mm = 02)이름, 입사일 검색
-- date 타입에도 substr() 함수 사용 가능
-- 문자열 index 시작 - 1 
SELECT hiredate from emp;
SELECT SUBSTR(hiredate,1,5) from emp; 
select ename,hiredate from emp WHERE hiredate LIKE '%%-02-%';
select ename,hiredate from emp WHERE SUBSTR(hiredate,6,2)='02';

-- 년도만 검색
SELECT SUBSTR(hiredate,1,4) from emp;
-- 월만 검색
SELECT SUBSTR(hiredate,6,2) from emp;
-- 일만 검색
SELECT SUBSTR(hiredate,9,2) from emp;



-- --7. 문자열 앞뒤의 잉여 여백 제거 함수 : trim()
/*length(trim(' abc ')) 실행 순서
   ' abc ' 문자열에 디비에 생성
   trim() 호출해서 잉여 여백제거
   trim() 결과값으로 length() 실행 */
SELECT ' abc ',CHAR_LENGTH(' abc '), LENGTH(' abc'),LENGTH(trim(' abc '));
-- 5 4 3




-- *** [날짜 함수] ***
-- 1. ?어제, 오늘, 내일 날짜 검색 
-- 현재 시스템 날짜에 대한 정보 제공 함수
-- sysdate() & now(): 날짜 시분 초
-- curdate() : 날짜
SELECT SYSDATE(),NOW(), CURDATE();
-- oracle : select sysdate from dual;



-- 2.?emp table에서 근무일수 계산하기, 사번과 근무일수 검색
SELECT CURDATE() - hiredate
FROM emp;

-- 3. ? 교육시작 경과일수
-- 순수 문자열을 날짜 형식으로 변환해서 검색
/* 
	yy/mm/dd 포멧으로 연산시에는 반드시 to_date() 라는 날짜 포멧으로
	변경하는 함수 필수 
	단순 숫자 형식으로 문자 데이터 연산시 정상 연산 
*/
 -- 20240708

-- SELECT CURDATE() -  to_date(2024/07/08);
--  SELECT CURDATE() - str_to_date'2024 07 08','%Y %m %d');
-- SELECT CURDATE() - str_to_date('2024/07/08','%Y - %m-%d');

-- 파라미터로 부터 지난 날 
-- 일자간 차이일수 검색 
SELECT DATEDIFF(NOW(),'20240708'); 


-- 4. 문자열 날짜로 변경
-- str_to_date() : mysql
-- to_date() : oracle
SELECT SYSDATE(),NOW(),CURDATE();
-- curdate() -> 날짜만
-- 나머지는 시간까지 
SELECT str_to_date('20240722','%Y %m %d');


-- 5. 특정 일수 및 개월수 더하는 함수 : ADDATE()
-- 10일 이후 검색
-- 10 숫자는 단순 일수로 간주 
SELECT now(); 
SELECT ADDDATE('20240708',10); -- 10 일 이후 

SELECT hiredate FROM emp;

show tables;
SELECT * FROM emp;
SELECT SYSDATE(); -- date 타입도 substr() 함수 사용 확인 
SELECT SUBSTR(SYSDATE(),1,10) ; -- 날짜만

SELECT SUBSTR(SYSDATE(),1,4); -- 년도만 
SELECT SUBSTR(hiredate ,1,4) from emp; 

-- 월만 
SELECT SUBSTR(SYSDATE(),6,2);

-- 15분 이후
SELECT NOW(); 
SELECT ADDDATE(NOW(),INTERVAL 15 MINUTE);
SELECT ADDDATE(NOW(),INTERVAL 15 DAY);

-- 6. ? emp table에서 입사일 이후 3개월 지난 일자 검색
SELECT hiredate FROM emp 
WHERE CURDATE()-hiredate >=3; 

SELECT hiredate,ADDDATE(hiredate,INTERVAL 3 MONTH)
FROM emp;

/* 데이터 crud 장애 발생 
 * 1. log 파일
 * 2. mysql rdbms 리스타트
 * 	- $ linux 일반 계정 
 * 	- # linux super 계정
 * 	- > wind
 * - ubuntu 에서 mysql 관리 
 * >sudo systemctl status mysql
 * >sudo systemctl stop mysql
 * >sudo systemctl restart mysql
 * 3. 시스템 재부팅 
 * */



-- 7. 두 날짜 사이의 개월수 검색 : months_between() : oracle
-- 오늘(sysdate) 기준으로 2021-09-19
-- SELECT MONTH_between(SYSDATE(),'20210919'); :mysql sql error
-- dayofyear() : 해당 년의 지난 일 수 
-- dayofmonth() : 해당 달의 지난 일 수
SELECT NOW(),DAYOFYEAR(NOW());
SELECT NOW(),DAYOFMONTH(NOW());
 


-- 특정 기준일로 오늘은 며칠차?(기준일 포함할 경우 +1)
-- 오늘 부터 100 일자 검색
-- INTERVAL 2 day : 내일부터 2일을 의미 
-- 주의사항 : 100일 검색 시 99일로 검색해야 함 / 2개월차 검색시 1개월차로 검색해야함 

SELECT NOW(), ADDDATE(NOW(),INTERVAL 99 DAY);

-- 8. 오늘을 기준으로 100일은?(오늘이 1일로 계산할 경우 기준일 포함)

SELECT NOW(), ADDDATE(NOW(),INTERVAL 99 DAY);


-- emp 직원들의 입사일 기준으로 5개월 후의 일자는?
-- 입사 기준이니까 입사월 포함 
SELECT hiredate, ADDDATE(hiredate,INTERVAL 4 MONTH) FROM emp;


-- 9. ?근무 연차(입사하자마자 1년 차로 계산될 경우)
SELECT hiredate, ADDDATE(hiredate,INTERVAL 2 year)
 FROM emp;

SELECT hiredate,NOW(hiredate,'20240722')
FROM emp;
SELECT CURDATE(),CURDATE() - '20230722';
SELECT '20240722' - hiredate from emp;
SELECT '19801217' - hiredate from emp;
SELECT hiredate from emp;
SELECT '19801217' - hiredate, hiredate from emp;

SELECT ABS('19801217' - hiredate),hiredate from emp;

-- 10. 1년 365일중 오늘은 몇일차?
SELECT timestampdiff(day,'2024-07-22',NOW()) + 1 as 경과일수,
CURDATE() as 오늘;

-- 10. 1년 365일중 오늘은 몇일차?
/*
timestamp : 1970년 1월 1일 0시 0분 0초부터 결과된 초단위의 수
타임스탬프 또는 시간 표기는 특정한 시각을 나타내거나 기록하는 문자열 
둘 이상의 시각을 비교하거나 기간을 계산할 때 편리하게 사용하기 위해 고안되었으며, 
일관성 있는 형식으로 표현 
실제 정보를 타임스탬프 형식에 따라 기록하는 행위를 타임스탬핑
주의사항 : 연산은 0값부터 시작 따라서 최종 결과값에 + 1로 유효한 범위 표현
 */


-- 11. 주어진 날짜를 기준으로 해당 달의 가장 마지막 날짜 : last_day()
SELECT last_day(NOW());
SELECT last_day('20240601');
SELECT last_day(SYSDATE());
SELECT last_day(CURDATE());

-- 12.? 2020년 2월의 마지막 날짜는?
SELECT last_day('20240211');



-- *** [형변환 함수] ***
-- Data type
-- DATETIME : 'YYYY-MM-DD HH:MM:SS'
-- DATE : 'YYYY-MM-DD'
-- TIME : 'HH:MM:SS'
-- CHAR : String
-- SIGNED : Integer(64bit), 부호 사용 가능
-- UNSIGNED : Integer(64bit), 부호 사용 불가
-- BINARY : binary String[mysql 기본 기질 - 대소문자 구분 안함]
	-- 특정 컬럼읨 대소문자 구분을 위한 추가 기본 설정
	-- alter table emp change ename ename varchar(20) binary;


/* cast - 형변환 (casting) 
 * 	- 자바 관점 : 타입에 따른 형변환
 * 	기본 타입 - 사지으가 기본 / 참조 타입 - 부모, 자식 관계가 기본 
 * */
-- 1. cast() - 특정 type으로 형변환
-- ? 함수 이해를 위한 간단한 예제 구성해보기 , SIGNED 키워드 사용해 보기 
SELECT '1'-1; -- mysql 연산, 
SELECT '2'-1;
SELECT CAST('1' as SIGNED); -- mysql 고유 특징, 안해도 연산 가능하나
-- 견고한 db 에선 가공필수 
SELECT '10' - 10;
SELECT '10' - '10';
SELECT cast('10' as signed) - cast('10' as signed);

-- Truncated incorrect INTEGER value: '10,100'
-- '' 문자열 끼리의 연산 진행시 cast() 사용
-- 주의사항 : , 표시 제거 

SELECT '10,001' - 10,000;
SELECT CAST('10200' as signed) - CAST('10100' as signed);


-- 숫자를 문자로 변환


-- 문자를 숫자로 변환





-- 2. STR_TO_DATE() : 날짜로 변경 시키는 함수

--  올해 며칠이 지났는지 검색(포멧 yyyy/mm/dd)
-- select sysdate - 20200719; 오류
-- select sysdate - '20200719'; 오류



-- 3. 문자열로 date타입 검색 가능[데이터값 표현이 유연함]
-- 1980년 12월 17일 입사한 직원명 검색
SELECT ename ,hiredate as '입사일' 
FROM emp
WHERE hiredate = '19801217' ;

SELECT ename ,hiredate as '입사일' 
FROM emp
WHERE hiredate = '1980-12-17' ;



-- 4. to_number(문자열, 변환포멧) : 문자열을 숫자로 변환 - oracle db
-- mysql 은 cast() 로 사용 
-- 어떤 숫자 형식으로 변환가능한지에 대한 명확성 필요한 함수 
-- 1. '20,000'의 데이터에서 '10,000' 산술 연산하기 
-- 힌트 - 9 : 실제 데이터의 유효한 자릿수 숫자 의미(자릿수 채우지 않음)
-- ?



-- *** 조건식 함수 ***
-- decode()-if or switch문과 같은 함수 ***
-- decode(조건칼럼, 조건값1,  출력데이터1,
--			   조건값2,  출력데이터2,
--				...,
--			   default값) from table명;

-- 1. deptno 에 따른 출력 데이터
-- 10번 부서는 A로 검색/20번 부서는 B로 검색/그외 무로 검색

SELECT ename, job,sal,
	CASE 
		when deptno = 10 then 'A부서'
		when deptno = 20 then 'B부서'
		else '무'
	END as level
FROM emp;


-- 2. emp table의 연봉(sal) 인상계산
-- job이 ANALYST 5%인상(sal*1.05), SALESMAN 은 10%(sal*1.1) 인상, 
-- MANAGER는 15%(sal*1.15), CLERK 20%(sal*1.2) 인상
 SELECT ename,job,sal,
 	CASE 
	 	when job = 'ANALYST' then sal*1.05
	 	when job = 'SALESMAN' then sal*1.01
	 	when job = 'MANAGER' then sal*1.15
	 	when job = 'CLERK' then sal*1.2
	 	else sal
 	END as '연봉인상'
 FROM emp;


-- 3. 'MANAGER'인 직군은 '갑', 'ANALYST' 직군은 '을', 
-- 나머지는 '병'으로 검색
SELECT ename,job,sal,
	CASE 
		when job = 'MANAGER' then '갑'
		when job = 'ANALYST' then '을'
		else '병'
	END as '신분?'
FROM emp;




