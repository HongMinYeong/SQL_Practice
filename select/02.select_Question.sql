/* 
1. 문제풀이
2. 문제 자체의 문제점도 찾아보기-스스로 개선해 보기
	
	답안 도출후 제출
	문제 자체의 검증

*/

/**1.
부서번호가 10번인 부서의 사람 중 사원번호, 이름, 월급을 출력하라
*/   
SELECT empno, ename, sal from emp WHERE deptno = 10;
  

/**2.
사원번호가 7369인 사람 중 이름, 입사일, 부서 번호를 출력하라.
*/
SELECT ename,hiredate,deptno from emp WHERE empno = 7369;


/**3.
이름이 ALLEN인 사람의 모든 정보를 출력하라.
*/
SELECT * from emp WHERE ename=UPPER('allen') ;


/**4.
입사일이 83/01//12인 사원의 이름, 부서번호, 월급을 출력하라.
*/
SELECT ename,deptno,sal from emp WHERE hiredate = '1983-01-12';
-- 데이터 없음 

/**5.
직업이 MANAGER가 아닌 사람의 모든 정보를 출력하라.
*/
SELECT * from emp WHERE job != 'manager';


/**6.
입사일이 81/04/02 이후에 입사한 사원의 정보를 출력하라.
*/
SELECT * FROM emp WHERE hiredate > '81-04-02' ;



/**7.
급여가 800이상인 사람의 이름, 급여, 부서번호를 출력하라
*/
SELECT ename, sal, deptno FROM emp WHERE sal >= 800 ;



/**8.
부서번호가 20번 이상인 사원의 모든 정보를 출력하라.
*/
SELECT * FROM emp WHERE deptno >=20;



/**9.
이름이 K로 시작하는 사람의 모든정보를 출력하라.
*/
SELECT * FROM emp WHERE ename LIKE 'K%';



/**10.
입사일이 81/12/09 보다 먼저 입사한 사람들의 모든 정보를 출력하라.
*/
SELECT * FROM emp WHERE hiredate < '81-12-09';



/**11.
입사번호가 7698보다 작거나 같은 사람들의 입사번호와 이름을 출력하라.
*/

SELECT empno,ename FROM emp WHERE empno <= 7698 ;

/**12.
입사일이 81/04/02보다 늦고  82/12/09보다 빠른 사원의 이름, 월급, 부서번호를 출력하라.
*/
SELECT ename, sal, deptno ,hiredate FROM emp WHERE hiredate > '81-04-02' AND hiredate <'82-12-09';
-- SELECT ename, sal, deptno ,hiredate FROM emp WHERE hiredate BETWEEN '81-04-02' AND '82-12-09';


/**13.
급여가 1600보다 크고[초과] 3000보다 작은[미만] 
사람의 이름, 직업, 급여를 출력하라.
*/
SELECT ename,job,sal FROM emp WHERE sal > 1600 AND sal < 3000;


/**14.
사원번호가 7654와 7782사이 이외의 사원의 모든 정보를 출력하라.
*/
SELECT * FROM emp WHERE empno <= 7654 OR empno >= 7782;


/**15.
직업이 MANAGER와 SALESMAN인 사람의 모든 정보를 출력하라
*/
SELECT * FROM emp WHERE job = 'MANAGER' OR job = 'SALESMAN';



/**16.
부서번호와 20,30번을 제외한 모든 사람의 이름, 사원번호, 부서번호를 출력하라.
*/




/**17.
이름이 S로 시작하는 사원의 사원번호, 이름, 입사일, 부서번호를 출력하라.
*/




/**18.
이름중 S자가 들어가 있는 사람만 모든 정보를 출력하라.
*/



/**19.
이름이 S로 시작하고 마지막 글자가 T인 사람이 정보를 출력하라. 단 이름은 전체 5자리이다.
*/




/**20.
커미션이 null인 사원의 정보를 출력하라.
*/




/**21.
커미션이 null이 아닌 사원의 정보를 출력하라.
*/




/**22.
부서가 30번 부서이고 급여가 1500이상인 사람의 이름, 부서, 월급(sal)을 출력하라.
*/




/**22.
이름의 첫글자가 K로 시작하거나 부서번호가 30인 사람의 사원번호, 이름, 부서번호를 출력하라.
*/




/**23.
급여가 1500이상이고 부서번호가 30번인 사원중 직업이 MANAGER인 사람의 정보를 출력하라.



/**24.
부서번호가 30인 사람중 사원번호 정렬하라.
*/




/**25.
급여가 많은 순으로 정렬하라.
*/



/**26.
부서번호로 오름차순 한 후 급여가 많은 사람 순으로 출력하라.
*/



/**27.
부서번호로 내림차순 하고 급여순으로 내림차순하라.
*/


