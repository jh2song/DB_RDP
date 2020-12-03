/* [ 제 6 장 ] # 1  - 함수와 저장프로시저
<실습1> 사용자 정의 함수
<실습2> 저장 프로시저, 패키지
<실습3> 커서

... by JDK 
*/
----------------------------------------------------------------
------------ < 실습 1 > 사용자 정의 함수 ------------ 
----------------------------------------------------------------
---- 사전 작업 : HMart 스키마 Reset (by SYSTEM & HMART)

/* ########  ID : HMART ######## */

-- Simple Function 정의
CREATE OR REPLACE FUNCTION F_Add(a number, b number)
    RETURN NUMBER
AS 
    Total NUMBER;
BEGIN
    Total := a + b;
    RETURN Total;
END;  -- sum, add등은 예약어로 함수, 변수 이름으로 사용하면 안 됨

-- 함수 호출 1 : Prompt에서 호출
VAR result NUMBER;
EXECUTE :result := F_Add(2020,35);
  -- EXECUTE 뒤의 문장은 무명프로시저로 봐야 함.
  -- 외부 변수를 사용하려면 ':변수이름'형식을 사용해야 함
PRINT result;
-- 함수 호출 2 : SQL 내에서 호출
SELECT F_Add(2020, 35) FROM DUAL;

-- 함수 호출 3 : 프로시저 내에서 호출
DECLARE
    result1 NUMBER;
BEGIN
    result1 := F_Add(2020,50);
    DBMS_OUTPUT.PUT_LINE(result1);
END;
PRINT result;
PRINT result1;  -- 오류. result1은 PL/SQL 프로시저 내에서만 사용가능

-- IF, CASE를 이용하는 다용도 함수
CREATE OR REPLACE FUNCTION F_Multi(inValue NCHAR) -- 파라미터라서 NCHAR의 크기 생략
    RETURN NCHAR
AS    
    V_output NCHAR(20);
BEGIN
  CASE
    WHEN inValue IS NULL THEN
        V_output := ' ';
    WHEN SUBSTR(inValue, 1, 1) BETWEEN '0' and '9' THEN
      BEGIN
        IF SUBSTR(inValue, 6, 1) = '-' THEN
           V_output := CONCAT(SUBSTR(inValue, 1, 7), '??');
        ELSIF SUBSTR(inValue, 7, 1) = '-' THEN
           V_output := CONCAT(SUBSTR(inValue, 1, 8), '******');
        ELSE
           V_output := CONCAT(SUBSTR(inValue, 1, 4), '####'); 
        END IF;
       END;
    ELSE  V_output := CONCAT( SUBSTR(inValue, 1, 1), 'OO');
    END CASE;
    RETURN  V_output;
END F_Multi;

SELECT * from UNIV.학생;
SELECT F_Multi(학번) AS "학번", F_Multi(주민등록번호) AS "주민번호",
       F_Multi(이름) AS "성명", F_Multi(전화번호) AS "연락처" FROM UNIV.학생;



----//  Pipelined Table Function
-- 튜플타입정의
CREATE OR REPLACE TYPE EventType AS OBJECT
( V_Year NUMBER(10), V_Event NCHAR(10) );
-- 테이블타입 정의
CREATE OR REPLACE TYPE TableType AS TABLE OF EventType;

-- 테이블을 반환하는 함수 정의
CREATE OR REPLACE FUNCTION 사건테이블생성(발생년도들 NCHAR, 사건들 NCHAR)
    RETURN TableType PIPELINED
AS    
    V_Years NVARCHAR2(100) := 발생년도들;  -- 함수의 파라미터는 In용. 값 변경 불가
    V_Events NVARCHAR2(100) := 사건들; -- 함수의 파라미터는 In용. 값 변경 불가
    V_EventTuple EventType; -- 튜플한개
    V_YearsPos NUMBER;  -- 년도 문자열에서 추출할 위치
    V_EventsPos NUMBER; -- 사건 문자열에서 추출할 위치
    V_Year NUMBER(10); -- 추출한 1개의 년도
    V_Event NCHAR(10);  -- 추출한 1개의 사건
BEGIN
    LOOP
        V_YearsPos := INSTR(V_Years, ',');
        V_EventsPos := INSTR(V_Events, ',');
        IF V_YearsPos > 0 AND V_EventsPos > 0 THEN
            V_Year := TO_NUMBER( SUBSTR(V_Years, 1, V_YearsPos-1) );
            V_Event := SUBSTR(V_Events, 1, V_EventsPos-1);
            V_EventTuple := EventType(V_Year, V_Event);
            PIPE ROW(V_EventTuple);
            V_Years := SUBSTR(V_Years, V_YearsPos+1);
            V_Events := SUBSTR(V_Events, V_EventsPos+1);
        ELSE
            V_EventTuple := EventType(V_Years, V_Events); -- Last Data Insertion
            PIPE ROW(V_EventTuple);
            EXIT;
        END IF;
    END LOOP;
    RETURN;
END 사건테이블생성;

-- Pipelined Table Function 호출
SELECT * 
FROM TABLE(사건테이블생성('1392,1492,1592,1692,1792',
                       '조선건국,콜롬부스,임진왜란,호접지몽,기요틴'));

------------ </ 실습 1 > ====================


----------------------------------------------------------------
------------ < 실습 2 > 저장 프로시저, 패키지  ------------ 
----------------------------------------------------------------

----//  Simple 저장 프로시저
-- 저장 프로시저 정의
CREATE OR REPLACE PROCEDURE SP_Simple   -- 파라미터 없음 
AS
    Age NUMBER; -- 변수 선언
BEGIN
    -- 정소화의 나이를 프로시저 변수 'Age'에 할당
    SELECT 나이 INTO Age  FROM 고객
         WHERE 고객이름 = '정소화';  
    DBMS_OUTPUT.PUT_LINE ('정소화의 나이는 ' || Age); -- 변수 값 출력
END SP_Simple ;


-- 저장 프로시저 실행
SET SERVEROUTPUT ON; 
EXECUTE SP_Simple( );
EXECUTE SP_Simple( );
EXECUTE SP_Simple( );  -- 여러번 실행 가능

-- 오류 예제 1 : 수정을 원한다면 Create or Replace Procedure
CREATE PROCEDURE SP_Simple    -- 이미 SP_Simple이 존재하는 경우 오류
AS
    Age NUMBER; -- 변수 선언
BEGIN
    -- 정소화의 나이를 프로시저 변수 'Age'에 할당
    SELECT 나이 INTO Age  FROM 고객
         WHERE 고객이름 = '정소화';  
    DBMS_OUTPUT.PUT_LINE ('정소화의 나이는 ' || Age); -- 변수 값 출력
END SP_Simple ;

-- 오류 예제 2 : SQL결과값이 여러개. 커서가 필요한 경우
CREATE OR REPLACE PROCEDURE SP_Simple   -- 파라미터 없음 
AS
    Age NUMBER; -- 변수 선언
BEGIN
    -- 정소화의 나이를 프로시저 변수 'Age'에 할당
    SELECT 나이 INTO Age  FROM 고객;
    DBMS_OUTPUT.PUT_LINE ('정소화의 나이는 ' || Age); -- 변수 값 출력
END SP_Simple ;   -- 컴파일 오류는 없음

-- 오류 발생. RunTime오류
EXECUTE SP_Simple( );  

-- 저장 프로시저 삭제
DROP PROCEDURE SP_Simple;



----//  파라미터가 있는 저장 프로시저
-- 입력 파라미터 이용
CREATE OR REPLACE PROCEDURE SP_In (
  U_ID IN 고객.고객아이디%TYPE
  -- 아래 문장도 유효
  -- U_ID IN CHAR  -->  ';' & 크기 입력 불가
) 
AS
    U_Name VARCHAR(18);  --  ';' & 크기 입력해야 함
BEGIN
    SELECT 고객이름 INTO U_Name FROM 고객 
         WHERE 고객아이디 = U_ID;
    DBMS_OUTPUT.PUT_LINE (U_Name);
END ;

SET SERVEROUTPUT ON; 
EXECUTE userProc1('apple');

-- 입력, 출력 파라미터
CREATE OR REPLACE PROCEDURE SP_InOut1 (
  Pi_ID IN CHAR,
  Pi_Name IN CHAR,
  Po_적립금 OUT NUMBER
) AS
    --v_count VARCHAR(10);
BEGIN
  INSERT INTO 고객(고객아이디, 고객이름, 등급) VALUES(Pi_ID, Pi_Name, 'Silver');
  SELECT MAX(적립금) INTO Po_적립금 FROM 고객; 
END ;

SET SERVEROUTPUT ON; 

-- 무명 프로시저를 선언. 
  -- 내부에서 저장 프로시저 호출( EXECUTE  불필요)
DECLARE
    Out적립 NUMBER;
BEGIN
    SP_InOut1('fruits', '홍길동', Out적립);
    DBMS_OUTPUT.PUT_LINE (Out적립);
END;


-- PL/SQL 문장을 포함한 저장 프로시저
CREATE OR REPLACE PROCEDURE SP_IF (
  Pi_고객이름 고객.고객이름%type
) AS
    V_적립금 NUMBER; -- 출생년도를 저장할 변수
BEGIN
    SELECT 적립금 INTO V_적립금 FROM 고객
        WHERE 고객이름 = Pi_고객이름;
    IF V_적립금 >= 4000 THEN
        DBMS_OUTPUT.PUT_LINE ('단골 고객이네요');
    ELSE
        DBMS_OUTPUT.PUT_LINE ('많이 이용하면 더 많은 혜택이 있어요');
    END IF;
END ;    

SET SERVEROUTPUT ON; 
EXECUTE SP_IF ('정소화');

-- 오류를 포함하고 있는  저장 프로시저

CREATE OR REPLACE PROCEDURE SP_Error (
  Pi_고객이름 IN 고객.고객이름%TYPE,
  Po_고객아이디 OUT 고객.고객아이디%TYPE
) 
AS

BEGIN
   SELECT 고객아이디 INTO Po_고객아이디 FROM 고객 
          WHERE 고객이름 = Pi_고객이름;
   IF Po_고객아이디 = NULL THEN
      Po_고객아이디 := 'Anonymous';  
   END IF;
END ;

DECLARE
    비회원여부 NCHAR(10);
BEGIN
    SP_Error('정소화', 비회원여부);
    DBMS_OUTPUT.PUT_LINE (비회원여부);
END;

DECLARE
    비회원여부 NCHAR(10);
BEGIN
    SP_Error('트럼프', 비회원여부);
    DBMS_OUTPUT.PUT_LINE (비회원여부);  -- 오류 발생 No Data Found
END;


-- 예외 처리를 한 저장 프로시저

CREATE OR REPLACE PROCEDURE SP_Error (
  Pi_고객이름 IN 고객.고객이름%TYPE,
  Po_고객아이디 OUT 고객.고객아이디%TYPE
) 
AS
BEGIN
   SELECT 고객아이디 INTO Po_고객아이디 FROM 고객 
          WHERE 고객이름 = Pi_고객이름;
     EXCEPTION  WHEN NO_DATA_FOUND THEN
        Po_고객아이디 := 'Anonymous';  
END ;

DECLARE
    비회원여부 NCHAR(10);
BEGIN
    SP_Error('정소화', 비회원여부);
    DBMS_OUTPUT.PUT_LINE (비회원여부);
END;

DECLARE
    비회원여부 NCHAR(10);
BEGIN
    SP_Error('트럼프', 비회원여부);    
    DBMS_OUTPUT.PUT_LINE (비회원여부);
END;



-- 파라미터 IN OUT : 입출력 겸용 파라미터
CREATE OR REPLACE PROCEDURE SP_InOut (
  Pio_고객이름 IN OUT 고객.고객이름%TYPE
) 
AS
  V_등급 고객.등급%TYPE;
BEGIN
   SELECT 등급 into V_등급 FROM 고객 
          WHERE 고객이름 = Pio_고객이름;
     EXCEPTION  WHEN NO_DATA_FOUND THEN
        Pio_고객이름 := (Pio_고객이름||'-');  
        
END ;

DECLARE
    세부고객이름 고객.고객이름%TYPE := '정소화';
BEGIN
    SP_INOUT(세부고객이름);
    DBMS_OUTPUT.PUT_LINE (세부고객이름);
END;

DECLARE
    세부고객이름 고객.고객이름%TYPE := '조나단';
BEGIN
    SP_INOUT(세부고객이름);
    DBMS_OUTPUT.PUT_LINE (세부고객이름);
END;  -- 예외 처리 됨. 비회원이라 이름 옆에 '-' 추가



-- 고객이름으로 고객 아이디 일부분만 검색
CREATE OR REPLACE PROCEDURE SP_PartialID (
    Pi_고객이름 IN 고객.고객이름%TYPE,
    Po_부분아이디 OUT CHAR
) 
AS
BEGIN  
    SELECT RPAD( SUBSTR(고객아이디,1,3), LENGTH(고객아이디), '*') INTO Po_부분아이디
       FROM  고객 WHERE 고객이름 = Pi_고객이름;
    EXCEPTION  WHEN NO_DATA_FOUND THEN
        Po_부분아이디 := '비회원';  
END;

DECLARE
    V_고객아이디 CHAR(15);
BEGIN
    SP_PartialID('정소화', V_고객아이디);
    DBMS_OUTPUT.PUT_LINE (V_고객아이디);
END;

DECLARE
    V_고객아이디 CHAR(15);
BEGIN
    SP_PartialID('트럼프', V_고객아이디);
    DBMS_OUTPUT.PUT_LINE (V_고객아이디);
END;


----//  저장 프로시저 본문 암호화
-- 간단한 예제
DECLARE
  Hidden_Source  VARCHAR2(32767);
BEGIN
  Hidden_Source := 'create or replace PROCEDURE a as begin null; end;';
EXECUTE IMMEDIATE DBMS_DDL.WRAP(Hidden_Source);
END;  -- GUI로 본문 확인하면 암호화 되어 있음
  
-- 암호화 실제 예제.
  -- VARCHAR2에 저장 프로시저를 생성하는 DDL구문 기록
    -- 주의점 : 문자열을 표현할 때는 작은 따음표 두개(' ')로 감싸야 함
    -- 결합연산(||) 이므로 한 줄을 마칠 때는 공백을 한칸씩 둘 것 
  -- 그 뒤 DBMS_DDL.WRAP 기능활용


DROP PROCEDURE SP_ENCR;

DECLARE
  Hidden_Source  VARCHAR2(32767);
BEGIN
  Hidden_Source := 
   'CREATE OR REPLACE PROCEDURE SP_ENCR  ( ' ||
   'Pi_고객이름 IN 고객.고객이름%TYPE, ' ||
   'Po_부분아이디 OUT CHAR ) ' ||
   'AS ' ||
   'BEGIN   ' ||
      'SELECT RPAD( SUBSTR(고객아이디,1,3), LENGTH(고객아이디), ''*'') INTO Po_부분아이디 ' ||
      'FROM  고객 WHERE 고객이름 = Pi_고객이름; '||
      'EXCEPTION  WHEN NO_DATA_FOUND THEN  Po_부분아이디 := ''비회원''; ' ||
      'END;'     ;
EXECUTE IMMEDIATE DBMS_DDL.WRAP(DDL => Hidden_Source);
END;

DECLARE
    V_고객아이디 CHAR(15);
BEGIN
    SP_ENCR('정소화', V_고객아이디);
    DBMS_OUTPUT.PUT_LINE (V_고객아이디);
END;

DECLARE
    V_고객아이디 CHAR(15);
BEGIN
    SP_ENCR('트럼프', V_고객아이디);
    DBMS_OUTPUT.PUT_LINE (V_고객아이디);
END;


-- 테이블 이름을 In 파라미터로 전달
CREATE OR REPLACE PROCEDURE SP_TableName (
  Pi_TableName IN CHAR 
)
AS
  V_차수 NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_차수 FROM Pi_TableName;
    DBMS_OUTPUT.PUT_LINE (v_차수);
END ;   -- 오류가 발생함

-- 테이블 이름을 In 파라미터로 전달. 동적 질의로 수행
CREATE OR REPLACE PROCEDURE SP_TableName_Dynamic (
  Pi_표이름 IN CHAR )
AS
  V_수 NUMBER;
  동적질의 VARCHAR2(300);
BEGIN
    동적질의 := 'SELECT COUNT(*) FROM ' || Pi_표이름;
    EXECUTE IMMEDIATE 동적질의 INTO V_수;
    DBMS_OUTPUT.PUT_LINE (Pi_표이름 || '수는 ' || V_수 || '입니다');
END ;

EXEC SP_TableName_Dynamic('고객');
EXEC SP_TableName_Dynamic('제품');
EXEC SP_TableName_Dynamic('주문');


----//  함수, 저장프로시저의 패키지 예제
CREATE OR REPLACE PACKAGE Pack1 AS
    Total NUMBER; -- global variable
    FUNCTION F_Add(a number, b number) RETURN NUMBER;
    PROCEDURE SP_Simple;
END Pack1;

CREATE OR REPLACE PACKAGE BODY Pack1 AS
    FUNCTION F_Add(a number, b number)
        RETURN NUMBER    AS 
    BEGIN
        Total := a + b;
        RETURN Total;
    END F_Add;
    PROCEDURE SP_Simple    
    AS
        Age NUMBER; -- local variable
    BEGIN
        SELECT 나이 INTO Age  FROM 고객 WHERE 고객이름 = '정소화';  
        DBMS_OUTPUT.PUT_LINE ('정소화의 나이는 ' || Age); -- 변수 값 출력
    END SP_Simple;    
END Pack1;    

SET SERVEROUTPUT ON; 
SELECT Pack1.F_Add(10,20) from dual;
EXECUTE Pack1.SP_Simple;


------------ </ 실습 2 > ====================



----------------------------------------------------------------
------------ < 실습 3 > 커서  ------------ 
----------------------------------------------------------------


-- '고객의 적립금 중 2000이상 적립금 평균값과 2000미만 적립금 평균값의 차이를 구하라.
   그리고 2000미만 고객의 등급을 BASIC으로 바꿔라'
CREATE OR REPLACE PROCEDURE SP_Cursor AS
  V_High NUMBER := 0;  -- 2000이상 적립금 합계
  V_Low NUMBER := 0;  -- 2000미만 적립금 합계
  V_H_Num NUMBER := 0 ; -- 2000이상 고객의 수
  V_L_Num NUMBER := 0 ; -- 2000미만 고객의 수
  V_ID VARCHAR2(20); -- 고객 고객아이디
  V_적립금 NUMBER; -- 고객 적립금
  CURSOR C IS  
        SELECT 고객아이디, 적립금 FROM 고객; -- 커서 정의
BEGIN
  OPEN C;  -- 커서 열기
  -- 데이터 인출 및 처리
    LOOP 
        FETCH  C INTO V_ID, V_적립금;
        EXIT WHEN C%NOTFOUND; -- 데이터가 없으면 LOOP 종료
        IF V_적립금 >= 2000 THEN
          BEGIN V_High := V_High + V_적립금; V_H_Num := V_H_Num + 1; END;
        ELSE
          BEGIN 
                V_Low := V_Low + V_적립금; 
                V_L_Num := V_L_Num + 1; 
                UPDATE 고객 SET 등급 = 'BASIC' WHERE 고객아이디 = V_ID; 
                -- 고객아이디와 VID가 데이터타입이 완전 일치해야 함
                DBMS_OUTPUT.PUT_LINE(V_ID);
          END;
        END IF;
    END LOOP;
    CLOSE C;  -- 커서 닫기
    DBMS_OUTPUT.PUT_LINE('결과 : ' || TO_CHAR((V_High/V_H_Num)-(V_Low/V_L_Num)) );
END ;

SET SERVEROUTPUT ON;
EXECUTE SP_Cursor();

--------------- </ 실습 3> ---------------------

