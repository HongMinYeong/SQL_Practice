-- oracle 전용속성
-- mysql의 경우 limit 로 처리 

/* rownum
 * 1. table에 자동 생성되는 컬럼 
 * 
 */
SELECT * FROM dept;
SELECT deptno,dname,loc FROM dept;
SELECT rownum,deptno,dname,loc FROM dept;

SELECT rownum,deptno,dname,loc FROM dept ORDER BY deptno DESC;

SELECT rownum,deptno,dname,loc FROM dept ORDER BY deptno ASC;

-- deptno 를 내림차순 정렬 후 deptno값이 높은 순으로 2개의 부서만 검색 
--SELECT rownum,deptno,dname,loc 
--FROM dept 
--WHERE deptno >= 30 AND rownum=1
--ORDER BY deptno DESC;
 
-- 정상 실행 - 문법 불안정 (비추)
-- 실행 순서 : from -> where -> select -> order by 
-- ? 결과를 본후 실행 순서 : from -> order by -> rownum -> select 절
/* 결과와 실행 순서의 이견이 생기는 속성 
 * 주의사항
 * 
 순서 보장 : 	ROWNUM은 쿼리 결과에 순서를 보장하지 않는다. 
 			그래서 먼저 정렬한 후 ROWNUM을 사용하는 것이 좋다. 
 			방법론적 해결책) 
 				- inline view || 버전업된 오라클에선 ROW_NUMBER() 함수 사용 권장 
 			
  
 * 
 */

SELECT rownum,deptno,dname,loc 
FROM dept 
WHERE rownum < 3
ORDER BY deptno DESC ;

-- 숫자가 1부터 반영이 되기 때문에 ROWNUM의 중간의 값으로 시작되는 조건의 레코드를 검색할 수 없다.
-- rownum은 1부터 시작되어야 하기 때문 
SELECT rownum,deptno,dname,loc 
FROM dept 
WHERE rownum > 3
ORDER BY deptno DESC ;


SELECT * FROM dept;
--WHERE rownum < 3;

/* view 
 * - 원본을 기반으로 파생되는 논리적인 가짜 table
 * - view 위치에 따른 구분
 * 		- from 절에 적용되는 뷰 -> 인라인 뷰 (가짜라는 뜻)
 * 
 * 
 */
SELECT rownum,deptno,dname,loc 
FROM (
		SELECT rownum,deptno,dname,loc
		FROM dept
		ORDER BY deptno DESC
		) 
WHERE rownum < 3 ;





---------------------------------------------------------------




-- ? emp 의 deptno 의 값이 오름차순으로 정렬된 상태로 상위 3개의 데이터
-- 인라인 뷰 사용 (from 절에 적용되는 select)
SELECT *
FROM (
		SELECT *
		FROM emp
		ORDER BY deptno ASC
		) 
WHERE rownum < 4 ; -- 7839 7934 7782

-- 부서 오름차순 한다음 
-- empno순으로 내림차순  
SELECT *
FROM (SELECT *
		FROM emp
		ORDER BY deptno ASC
		) 
WHERE rownum < 4 
ORDER BY empno DESC;

-- 제대로 안나옴 
-- 논리적으로 부적합하게 검색 , 인라인뷰도 꼼꼼!!!! 
SELECT *
FROM (SELECT *
		FROM emp
		WHERE rownum < 4 
		ORDER BY deptno ASC
		) 
ORDER BY empno DESC;


SELECT rownum,deptno,dname,loc 
FROM (
		SELECT deptno,dname,loc
		FROM dept
		ORDER BY deptno ASC
		) 
WHERE rownum < 4 ;

SELECT * FROM dept;
------------------------------------------------------------------------------\
-- FROM 절의 INLINE VIEW ROWNUM에 대해 별칭 부여
-- ROWNUM -> 정렬후 rownum
-- RNUM -> 정렬 전 rownum
SELECT ROWNUM, RNUM,dname, deptno , loc FROM
									(SELECT ROWNUM RNUM, dname,deptno, loc FROM 																		(SELECT * 
																		FROM dept 
																		ORDER BY deptno DESC)
)
WHERE RNUM BETWEEN 2 AND 3;


