/* [ 제 2 장 ] # 1  - 한빛마트 DB 구축
<실습1> 한빛마트를 위한 사용자생성
<실습2> 한빛마트 DB의 테이블 생성
<실습3> 한빛마트 DB의 데이터 삽입

... by JDK 
*/

----------------------------------------------------------------
------------ < 실습 1 > 사용자 생성 ------------ 
----------------------------------------------------------------
/* ########  ID : SYSTEM ######## */
/*
한빛마트 DB를 위한 사용자 생성 
생성할 사용자 : HMART (오라클 12C이상에서는 C##HMART)
*/

--ALTER session set "_ORACLE_SCRIPT"=true;
DROP USER HMART CASCADE; -- 기존 사용자 삭제(현재 접속되어 있으면 삭제 안 됨)
	-- CASCADE option : 관련 스키마 개체들도 함께 삭제.  Default는 No Action
CREATE USER HMART IDENTIFIED BY 1234  -- 사용자 ID : hmart, 비밀번호 : 1234
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP;
GRANT connect, resource, dba TO HMART; -- 권한 부여
-- Hint) SQL Script 실행방법 : Ctrl + Enter는 한명령어, F5는 전체 실행, 블럭이 지정되면 두 방법은 동일
------------ </ 실습 1 > ====================
 


-- 실습 사이 준비사항 : 필요하다면, Sql Developer에서 HMART를 위한 접속(세션) 생성

----------------------------------------------------------------
------------ < 실습 2 > 테이블 생성 및 변경 ------------ 
----------------------------------------------------------------
/* ########  ID : HMART ######## */
/* 
한빛마트 DB를 위한 테이블 생성 
테이블 이름 : 고객, 제품, 주문, 배송업체
*/

/* -- 오류 발생 구문
CREATE TABLE  주문 (
	주문번호   CHAR(3) NOT NULL,
	주문고객   VARCHAR(20),
	주문제품   CHAR(3),
	수량        INT,
	배송지     VARCHAR(30),
	주문일자  DATE,
	PRIMARY KEY(주문번호),
	FOREIGN KEY(주문고객)   REFERENCES   고객(고객아이디),
	FOREIGN KEY(주문제품)   REFERENCES   제품(제품번호)
);
  -- Cause : 아직 고객, 제품 테이블이 없기 때문
  -- Solution : 외래키 없는 테이블 먼저 생성.
	-- 그래도 해결안될 때는 테이블 생성시 FK지정안하고,
	-- 테이블 생성 후 add constraints로 외래키 추가
*/

----// 테이블 생성(Create Table...)

--	[예제 7-1]
CREATE TABLE 고객 (
	고객아이디  VARCHAR(20)	 NOT NULL,
	고객이름    VARCHAR(10)	 NOT NULL,
	나이	    INT,
	등급	    VARCHAR(10)	 NOT NULL,
	직업	    VARCHAR(20),
	적립금	    INT   DEFAULT 0,
	PRIMARY KEY(고객아이디)
);

--	[예제 7-2]
CREATE TABLE  제품 (
	제품번호   CHAR(3)   NOT NULL,
	제품명      VARCHAR(20),
	재고량      INT,
	단가         INT,
	제조업체    VARCHAR(20),
	PRIMARY KEY(제품번호),
	CHECK (재고량 >= 0 AND 재고량 <=10000)
);

--	[예제 7-3]
CREATE TABLE  주문 (
	주문번호   CHAR(3) NOT NULL,
	주문고객   VARCHAR(20),
	주문제품   CHAR(3),
	수량        INT,
	배송지     VARCHAR(30),
	주문일자  DATE,
	PRIMARY KEY(주문번호),
	CONSTRAINT FK_고객_주문 FOREIGN KEY(주문고객)   REFERENCES   고객(고객아이디),
	FOREIGN KEY(주문제품)   REFERENCES   제품(제품번호)
);

--	[예제 7-4]
CREATE TABLE  배송업체 (
	업체번호   CHAR(3) NOT NULL,
	업체명   VARCHAR(20),
	주소  VARCHAR(100),
	전화번호  VARCHAR(20),
	PRIMARY KEY(업체번호)
);

----// 테이블 구조변경(Alter Table...)
--	[예제 7-5]
ALTER TABLE 고객 ADD 가입날짜 DATE; 


--	[예제 7-6]
ALTER TABLE 고객 DROP COLUMN 가입날짜;


--	[예제 7-7]
ALTER TABLE 고객 ADD CONSTRAINT CHK_AGE CHECK(나이 >= 20); 

--	[예제 7-8]
ALTER TABLE 고객 DROP CONSTRAINT CHK_AGE; 

----// 테이블 삭제
--	[예제 7-9]
DROP TABLE 배송업체; --defalut가 restrict : 연관된 테이블이 있으면 삭제안됨
  -- DROP TABLE 테이블명 cascade contraints : 연관된 테이블의  constraints까지 삭제


----// 유도 속성

/*
ALTER TABLE 제품
    ADD 재고금액 GENERATED ALWAYS AS (재고량 * 단가) ;

SELECT * FROM 제품;
*/

------------ </ 실습 2 > ====================



----------------------------------------------------------------
------------ < 실습 3 > 데이터 입력 ------------ 
----------------------------------------------------------------

/* 
한빛마트 DB를 위한 데이터 입력 
*/

/* -- 오류 발생 구문
INSERT INTO 주문 VALUES ('o01', 'apple', 'p03', 10, '서울시 마포구', '19/01/01');
-- Cause : 참조무결성제약조건때문에 외래키인 주문고객과 주문제품에 값을 입력할 수 없음
	-- 아직 고객과 제품테이블의 데이터가 입력되지 않았음
-- 해결책 : 고객과 제품테이블을 먼저 입력.(외래키를 고려하여 입력 순서를 조정) 
*/

-- [고객 테이블에 튜플 삽입]
INSERT INTO 고객 VALUES ('apple', '정소화', 20, 'gold', '학생', 1000);
INSERT INTO 고객 VALUES ('banana', '김선우', 25, 'vip', '간호사', 2500);
INSERT INTO 고객 VALUES ('carrot', '고명석', 28, 'gold', '교사', 4500);
INSERT INTO 고객 VALUES ('orange', '김용욱', 22, 'silver', '학생', 0);
INSERT INTO 고객 VALUES ('melon', '성원용', 35, 'gold', '회사원', 5000);
INSERT INTO 고객 VALUES ('peach', '오형준', NULL, 'silver', '의사', 300);
INSERT INTO 고객 VALUES ('pear', '채광주', 31, 'silver', '회사원', 500);

-- [제품 테이블에 튜플 삽입]
INSERT INTO 제품 VALUES ('p01', '그냥만두', 5000, 4500, '대한식품');
INSERT INTO 제품 VALUES ('p02', '매운쫄면', 2500, 5500, '민국푸드');
INSERT INTO 제품 VALUES ('p03', '쿵떡파이', 3600, 2600, '한빛제과');
INSERT INTO 제품 VALUES ('p04', '맛난초콜릿', 1250, 2500, '한빛제과');
INSERT INTO 제품 VALUES ('p05', '얼큰라면', 2200, 1200, '대한식품');
INSERT INTO 제품 VALUES ('p06', '통통우동', 1000, 1550, '민국푸드');
INSERT INTO 제품 VALUES ('p07', '달콤비스킷', 1650, 1500, '한빛제과');

-- [주문 테이블에 튜플 삽입]
INSERT INTO 주문 VALUES ('o01', 'apple', 'p03', 10, '서울시 마포구', '19/01/01');
INSERT INTO 주문 VALUES ('o02', 'melon', 'p01', 5, '인천시 계양구', '19/01/10');
INSERT INTO 주문 VALUES ('o03', 'banana', 'p06', 45, '경기도 부천시', '19/01/11');
INSERT INTO 주문 VALUES ('o04', 'carrot', 'p02', 8, '부산시 금정구', '19/02/01');
INSERT INTO 주문 VALUES ('o05', 'melon', 'p06', 36, '경기도 용인시', '19/02/20');
INSERT INTO 주문 VALUES ('o06', 'banana', 'p01', 19, '충청북도 보은군', '19/03/02');
INSERT INTO 주문 VALUES ('o07', 'apple', 'p03', 22, '서울시 영등포구', '19/03/15');
INSERT INTO 주문 VALUES ('o08', 'pear', 'p02', 50, '강원도 춘천시', '19/04/10');
INSERT INTO 주문 VALUES ('o09', 'banana', 'p04', 15, '전라남도 목포시', '19/04/11');
INSERT INTO 주문 VALUES ('o10', 'carrot', 'p03', 20, '경기도 안양시', '19/05/22');


-- 입력한 내용을  DB에 반영
COMMIT; 

-- 테이블 내용 확인
select * from 고객;
select * from 제품;
select * from 주문;

------------ </ 실습 3 > ====================