/* [ 제 7 장 ] # 1  - 트리거
<실습1> 트리거 Before, After
<실습2> 트리거 Instead Of
<실습3> 연쇄 트리거

-- 
... by JDK 
*/

----------------------------------------------------------------
------------ < 실습 1 > 트리거 Before, After  ------------ 
----------------------------------------------------------------

---- 사전 작업 : HMart 스키마 Reset (by SYSTEM & HMART)

/* ########  ID : HMART ######## */

SET SERVEROUTPUT ON;  -- 출력 허용

-- Simple Trigger : 데이터 입력 후 동작
CREATE or REPLACE TRIGGER T_Simple1
 AFTER INSERT
 ON 고객
 FOR EACH ROW
BEGIN
 DBMS_OUTPUT.PUT_LINE('After Insert 감지');
END;

-- Simple Trigger : 데이터 삭제 후 동작
CREATE or REPLACE TRIGGER T_Simple2
 AFTER DELETE
 ON 고객
 FOR EACH ROW
BEGIN
 DBMS_OUTPUT.PUT_LINE('After Delete 감지');
END;


INSERT INTO 고객 VALUES ('berry', 'JDK', 50, 'gold', '교수', 5000); -- T_Simple1동작
DELETE FROM 고객 WHERE 고객아이디 = 'berry'; -- T_Simple2동작 

DROP TRIGGER T_Simple1;
DROP TRIGGER T_Simple2;

/* UPDATE OR DELETE 예제
CREATE OR REPLACE TRIGGER T_Simple3 
   AFTER  UPDATE OR DELETE  -- 삭제 또는 수정 후에 실행
   ON 고객
   FOR EACH ROW
DECLARE 
   V_Type NCHAR(2); -- 변경 타입
BEGIN
   IF UPDATING THEN        V_Type := '수정';
   ELSIF DELETING  THEN    V_Type := '삭제';
   END IF;
   DBMS_OUTPUT.PUT_LINE('당신이 수행한 연산은 ' || v_modType);
END T_Simple3;
*/

----//      :OLD, :NEW 개념

--  Before    old & new 기본 개념
CREATE OR REPLACE TRIGGER T_OLDNEW1
   BEFORE INSERT  
   ON 고객 
   FOR EACH ROW 
BEGIN
        DBMS_OUTPUT.PUT_LINE('NEW 이름 ' || :NEW.고객이름);
        DBMS_OUTPUT.PUT_LINE('NEW 직업 ' || :NEW.직업);
        DBMS_OUTPUT.PUT_LINE('OLD 이름 ' ||:OLD.고객이름);
        DBMS_OUTPUT.PUT_LINE('OLD 직업 ' || :OLD.직업);
END;

INSERT INTO 고객 VALUES ('aaa', '도날드', NULL, 'silver', '학생', 300);
  
INSERT INTO 고객 VALUES ('aaa', '도날드', NULL, 'silver', '학생', 300);
  -- 삽입 오류(키중복)이지만, Before insert이므로 트리거는 실행됨
DELETE FROM 고객 WHERE 고객아이디 = 'aaa';

DROP TRIGGER T_OLDNEW1;

-- Before old & new : Insert 전 값을 변경해서 입력해야 하는 경우
  -- 지금부터 입력될 때 고객 이름을 김00 형태로 입력하고자 함.
  -- Real DB에 입력되기 전에 :NEW값을 바꿈
CREATE OR REPLACE TRIGGER T_OLDNEW2
   before INSERT  
   ON 고객 
   FOR EACH ROW 
BEGIN
    :NEW.고객이름 := SUBSTR(:NEW.고객이름, 1, 1) || 'OO';
END;

INSERT INTO 고객 VALUES ('aaa', '도날드', NULL, 'silver', '학생', 300);
DELETE FROM 고객 WHERE 고객아이디 = 'aaa';
DROP TRIGGER T_OLDNEW2;

-- After old & new :  Insert 후 검증 & 입력 취소 
  -- 직업이 신용불량자이면 데이터 삽입 취소
CREATE OR REPLACE TRIGGER T_자격검사
   AFTER INSERT  
   ON 고객 
   FOR EACH ROW 
BEGIN
    IF :NEW.직업 = '신용불량자' THEN
        DBMS_OUTPUT.PUT_LINE('자격이 맞지 않아요.');
        DBMS_OUTPUT.PUT_LINE('입력이 취소되었습니다.');
        RAISE_APPLICATION_ERROR(-20999,'자격검사 위배 입력 시도 발견 !!!'); -- 입력 취소
    END IF;
END;

INSERT INTO 고객 VALUES ('fruits', '신불자', NULL, 'silver', '신용불량자', 300);
DELETE FROM 고객 WHERE 고객아이디 = 'fruits';
DROP TRIGGER T_자격검사;

-- After : Insert 후 검증 & Update
   -- 트리거 오류는 아니지만 삽입 시 오류
CREATE OR REPLACE TRIGGER T_OLDNEW3
   AFTER INSERT  
   ON 고객 
   FOR EACH ROW 
BEGIN
    IF  :NEW.고객이름 = '도날드' THEN
      UPDATE  고객 SET 고객이름 = '도00' WHERE 고객이름 = '도날드';
    END IF;
END;

INSERT INTO 고객 VALUES ('aaa', '도날드', NULL, 'silver', '학생', 300);
DELETE FROM 고객 WHERE 고객아이디 = 'aaa';
DROP TRIGGER T_OLDNEW3;

-- After : Insert 후 검증 & 다른 테이블 Update
CREATE OR REPLACE TRIGGER T_OLDNEW4
   AFTER INSERT  
   ON 고객 
   FOR EACH ROW 
BEGIN
    IF  :NEW.고객이름 = '도날드' THEN
      UPDATE  주문 SET 수량 = 99 WHERE 주문번호 = 'o08';
      -- 트리거 내에서 다른 테이블에 대한 SQL은 적용 가능
    END IF;
END;

INSERT INTO 고객 VALUES ('aaa', '도날드', NULL, 'silver', '학생', 300);
DELETE FROM 고객 WHERE 고객아이디 = 'aaa';
DROP TRIGGER T_OLDNEW4;

----//  한 테이블에 적용된 트리거로 다른 테이블을 변경하는 경우
--  탈퇴 고객 백업 시나리오.
CREATE TABLE 탈퇴고객 
(   "고객아이디" VARCHAR2(20 BYTE) , 
	"고객이름" VARCHAR2(10 BYTE), 
	"나이" NUMBER(*,0), 
	"등급" VARCHAR2(10 BYTE) , 
	"직업" VARCHAR2(20 BYTE), 
	"적립금" NUMBER(*,0) DEFAULT 0, 
    변경일 DATE,
    변경담당자 NCHAR(30)
);

CREATE OR REPLACE TRIGGER T_탈퇴고객관리
   AFTER DELETE
   ON 고객
   FOR EACH ROW
DECLARE
    -- 변수 선언부
BEGIN
   -- :OLD ? 변경전의 테이블
    INSERT INTO 탈퇴고객 VALUES( :OLD.고객아이디, :OLD.고객이름, :OLD.나이, 
        :OLD.등급, :OLD.직업, :OLD.적립금, SYSDATE(), USER( ) );
END T_탈퇴고객관리;

DELETE FROM 고객 WHERE 고객아이디 = 'peach'; -- 트리거 실행. 탈퇴고객 테이블에 삽입
DELETE FROM 고객 WHERE 고객아이디 = 'apple'; -- 오류 : 참조무결성 위배 ( on delete no action )

DROP TRIGGER T_탈퇴고객관리;


----//  PK-FK On Update CASCADE 구현
create trigger T_OnUpdateCascade
  AFTER UPDATE OF 고객아이디 ON 고객
  FOR EACH ROW
BEGIN
  UPDATE 주문 SET 주문고객 = :NEW.고객아이디 WHERE 주문고객 = :OLD.고객아이디;
END;
  -- 실제... 변경연산은 해당 트리거까지 실행된 후 FK 등의 Constraint 위배 여부 Check함

UPDATE 고객 SET 고객아이디 = 'samsung' WHERE 고객아이디 = 'apple';
DROP Trigger T_OnUpdateCascade;

------------ </ 실습 1 > ====================



----------------------------------------------------------------
------------ < 실습 2 > 트리거 Instead Of  ------------ 
----------------------------------------------------------------

--########## 수행 ID : UNIV

-- 조인 뷰 생성
CREATE or REPLACE VIEW 학생학과정보 
AS
	SELECT 학번, 이름, 학생.전화번호, 주소, 학과.학과번호, 학과명, 사무실 
	FROM 학생, 학과
    	WHERE 학생.학과번호 = 학과.학과번호;
    
SELECT * FROM 학생학과정보;

-- 조인 뷰에 대한 삽입 연산 : 오류 발생
INSERT INTO 학생학과정보 VALUES ('20301-006', '박문수', '200-2000', '부산', 303, '컴공', '917호');

-- 이에 대한 해결책 : 트리거 이용 Instead Of
CREATE OR REPLACE TRIGGER 뷰삽입
   INSTEAD OF INSERT  -- 삽입작업 대신에 작동 작동하도록 지정
   ON 학생학과정보  -- 뷰에 장착
   FOR EACH ROW 
BEGIN
   INSERT INTO 학과(학과번호, 학과명, 사무실)
     VALUES (:NEW.학과번호, :NEW.학과명, :NEW.사무실);
   INSERT INTO 학생(학번, 이름, 학과번호, 주소, 전화번호)
     VALUES (:NEW.학번, :NEW.이름, :NEW.학과번호, :NEW.주소, :NEW.전화번호);
END;

-- 아래 삽입 명령 대신 트리거가 실행됨
INSERT INTO 학생학과정보 VALUES ('20301-006', '박문수', '200-2000', '부산', 303, '컴공', '917호');
-- 결과 확인
SELECT * FROM 학생;
SELECT * FROM 학과;

-- 트리거 오류 사례1
CREATE OR REPLACE TRIGGER 뷰삽입
   INSTEAD OF INSERT  -- 삽입작업 대신에 작동 작동하도록 지정
   ON 학생학과정보  -- 뷰에 장착
   FOR EACH ROW 
BEGIN
   INSERT INTO 학생(학번, 이름, 학과번호, 주소, 전화번호)
     VALUES (:NEW.학번, :NEW.이름, :NEW.학과번호, :NEW.주소, :NEW.전화번호);
   INSERT INTO 학과(학과번호, 학과명, 사무실)
     VALUES (:NEW.학과번호, :NEW.학과명, :NEW.사무실);
END;

INSERT INTO 학생학과정보 VALUES ('20301-006', '박문수', '200-2000', '부산', 303, '컴공', '917호');
  -- 오류 발생 : 참조무결성 위배. Parent를 먼저 삽입해야 함.


-- 트리거 오류 사례2
  -- 뷰를 새롭게 생성. 단, 학과의 PK인 학과번호를 포함하지 않음
CREATE or REPLACE VIEW 학생학과정보 
AS
	SELECT 학번, 이름, 학생.전화번호, 주소, 학과명, 사무실 
	FROM 학생, 학과
    	WHERE 학생.학과번호 = 학과.학과번호;
    
SELECT * FROM 학생학과정보;

-- 조인 뷰에 대한 삽입 연산 : 오류 발생
INSERT INTO 학생학과정보 VALUES ('20301-006', '박문수', '200-2000', '부산', '컴공', '917호');

-- 이에 대한 해결책으로 트리거 이용하지만
CREATE OR REPLACE TRIGGER 뷰삽입
   INSTEAD OF INSERT  
   ON 학생학과정보  
   FOR EACH ROW 
BEGIN
   INSERT INTO 학과(학과명, 사무실)
     VALUES (:NEW.학과명, :NEW.사무실);
   INSERT INTO 학생(학번, 이름, 주소, 전화번호)
     VALUES (:NEW.학번, :NEW.이름, :NEW.주소, :NEW.전화번호);
END;

-- 아래 삽입 명령 대신 트리거가 실행됨
INSERT INTO 학생학과정보 VALUES ('20301-006', '박문수', '200-2000', '부산', '컴공', '917호');
  -- 트리거 실행 오류. 학과테이블에 PK없이 입력을 시도함. 개체 무결성 위배

DROP TRIGGER 뷰삽입;
DROP VIEW 학생학과정보;

------------ </ 실습 2 > ====================




----------------------------------------------------------------
------------ < 실습 3 > 연쇄 트리거  ------------ 
----------------------------------------------------------------

--########## 수행 ID : HMART

SET SERVEROUTPUT ON;
CREATE SEQUENCE 입고SEQ;
CREATE TABLE 입고요청 
   ("입고요청번호" NUMBER, 
	"제품번호" CHAR(3 BYTE), 
	"제조업체" VARCHAR2(20 BYTE), 
	"요청일" DATE, 
	"요청자" NCHAR(15), 
	 PRIMARY KEY ("입고요청번호")
    );
create or replace TRIGGER T_주문처리
  AFTER INSERT ON 주문
  FOR EACH ROW
BEGIN
  UPDATE 제품 SET 재고량 = 재고량 - :NEW.수량 WHERE 제품번호 = :NEW.주문제품;
END;

create or replace TRIGGER T_입고요청
  AFTER UPDATE ON 제품
  FOR EACH ROW
DECLARE
   V_주문량 NUMBER;
   V_재고량 NUMBER;
BEGIN
  SELECT :OLD.재고량 - :NEW.재고량, :NEW.재고량
         INTO V_주문량, V_재고량 FROM DUAL;
   DBMS_OUTPUT.PUT_LINE('주문량 : ' || V_주문량 || ', 재고량 : ' || V_재고량 );
   IF V_재고량 < 1000 THEN
    INSERT INTO 입고요청 VALUES(입고SEQ.NEXTVAL, :NEW.제품번호, :NEW.제조업체, SYSDATE, USER() );
   END IF;
END;

INSERT INTO 주문 VALUES ('o11', 'apple', 'p01', 50, '동의대', SYSDATE);
INSERT INTO 주문 VALUES ('o12', 'banana', 'p06', 90, '부산시 진구', SYSDATE);


DROP TRIGGER T_주문처리;
DROP TRIGGER T_입고요청;


------------ </ 실습 3 > ====================

