/* [ 제 2 장 ] # 2  - 대학학사 DB 구축
<실습1> 대학 학사를 위한 사용자생성
<실습2> 대학 학사 DB의 테이블 생성
<실습3> 대학 학사 DB의 데이터 삽입

... by JDK 
*/

----------------------------------------------------------------
------------ < 실습 1 > 사용자 생성 ------------ 
----------------------------------------------------------------
/* ########  ID : SYSTEM ######## */
/*
대학 학사 DB를 위한 사용자 생성 
생성할 사용자 : UNIV (오라클 12C이상에서는 C##UNIV)
*/

--ALTER session set "_ORACLE_SCRIPT"=true;
DROP USER UNIV CASCADE; -- 기존 사용자 삭제(현재 접속되어 있으면 삭제 안 됨)
	-- CASCADE option : 관련 스키마 개체들도 함께 삭제.  Default는 No Action
CREATE USER UNIV IDENTIFIED BY 1234  -- 사용자 ID : UNIV, 비밀번호 : 1234
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP;
GRANT connect, resource, dba TO UNIV; -- 권한 부여
------------ </ 실습 1 > ====================



-- 실습 사이 준비사항 : 필요하다면, Sql Developer에서 Univ를 위한 접속(세션) 생성

----------------------------------------------------------------
------------ < 실습 2 > 테이블 생성 및 변경 ------------ 
----------------------------------------------------------------
/* ########  ID : UNIV ######## */
/* 
대학 학사 DB를 위한 테이블 생성 
테이블 이름 : 학생, 학과, 교수, 교과목, 강좌, 수강
*/

/* -- 오류 발생 구문
CREATE TABLE 학생 (
	학번	CHAR(9) PRIMARY KEY,
	주민등록번호 CHAR(14) UNIQUE,
	이름	NCHAR(5) NOT NULL,
	학과번호	NUMBER(3),
	주소	NCHAR(5),
	전화번호	CHAR(12),
	학년	NUMBER(1),
	FOREIGN KEY 학과번호 REFERENCES 학과(학과번호)
);  
-- Cause : 아직 학과 테이블이 없기 때문
-- Solution : 외래키 없는 테이블 먼저 생성.
	-- 그래도 해결안될 때는 테이블 생성시 FK지정안하고,
	-- 테이블 생성 후 add constraints로 외래키 추가
*/

CREATE TABLE 학과 (
	학과번호	NUMBER(3) PRIMARY KEY,
	학과명	NCHAR(10) NOT NULL,
	사무실	NCHAR(5),
	전화번호	CHAR(12)
);

CREATE TABLE 학생 (
	학번	CHAR(9) PRIMARY KEY,
	주민등록번호 CHAR(14) UNIQUE,
	이름	NCHAR(5) NOT NULL,
	학과번호	NUMBER(3),
	주소	NCHAR(5),
	전화번호	CHAR(12),
	학년	NUMBER(1),
	FOREIGN KEY (학과번호) REFERENCES 학과(학과번호)
);  
ALTER TABLE 학생 ADD 나이 NUMBER(2);

CREATE TABLE 교수 (
	교수번호	CHAR(7) PRIMARY KEY,
	주민등록번호 CHAR(14) UNIQUE,
	이름	NCHAR(5) NOT NULL,
	학과번호	NUMBER(3),
	주소	NCHAR(5),
	전화번호	CHAR(12),
	직위	NCHAR(4),
	임용년도	NUMBER(4),
	학과장	CHAR(7),
	FOREIGN KEY (학과번호) REFERENCES 학과(학과번호),
	FOREIGN KEY (학과장) REFERENCES 교수(교수번호)
);  

CREATE TABLE 교과목 (
	교과목번호 CHAR(7) PRIMARY KEY,
	교과목명	NCHAR(10) NOT NULL,
	학점수	NUMBER(1)
);

CREATE TABLE 강좌 (
	교과목번호 CHAR(7),
	연도	NUMBER(4),
	학기	NUMBER(1),
	교수번호	CHAR(7),
	강의실	CHAR(6),
	수강인원 NUMBER(4),
	PRIMARY KEY (교과목번호, 연도, 학기),
    FOREIGN KEY (교과목번호) REFERENCES 교과목(교과목번호),
	FOREIGN KEY (교수번호) REFERENCES 교수(교수번호)
);

CREATE TABLE 수강 (
	학번	CHAR(9),
	교과목번호 CHAR(7),
	연도	NUMBER(4),
	학기	NUMBER(1),
	성적	CHAR(2),
	PRIMARY KEY (학번, 교과목번호, 연도, 학기),
    FOREIGN KEY (학번) REFERENCES 학생(학번),
	FOREIGN KEY (교과목번호, 연도, 학기) REFERENCES 강좌(교과목번호, 연도, 학기)
	-- 이런 경우 외래키를 한 속성씩 따로 지정하면 안됨
);

------------ </ 실습 2 > ====================



----------------------------------------------------------------
------------ < 실습 3 > 데이터 입력 ------------ 
----------------------------------------------------------------

/* 
대학 학사 DB를 위한 데이터 입력 
*/

/* -- 오류 발생 구문
INSERT INTO 학생 VALUES('01302-001', '780424-1825409', '김광식', 302, '서울', '123-4567', 2, 21);
-- Cause : 참조무결성제약조건때문에 외래키인 학과번호에 값을 입력할 수 없음
	-- 아직 학과테이블의 학과번호가 입력되지 않았음
-- 해결책 : 학과테이블을 먼저 입력.(외래키를 고려하여 입력 순서를 조정) 
	-- 또는 학생테이블의 학과번호를 NULL로 입력한 다음 나중에 입력
	-- 또는 외래키 선언을 나중에 하기
*/


-- 학과테이블 입력
INSERT INTO 학과 VALUES(302, '전산과', '201호', '880-6583');
INSERT INTO 학과 VALUES(301, '수학과', '207호', '880-2201');

-- 학생테이블 입력
INSERT INTO 학생 VALUES('01302-001', '780424-1825409', '김광식', 302, '서울', '123-4567', 2, 21);
INSERT INTO 학생 VALUES('01302-002', '960305-1730021', '김정현', 302, '대구', '234-5678', 2, 25);
INSERT INTO 학생 VALUES('01302-004', '981021-2308302', '김현정', 302, '광주', '213-4567', 2, 22);
INSERT INTO 학생 VALUES('01302-005', '940902-2704012', '김현정', 302, '대전', '145-6234', 3, 27);
INSERT INTO 학생 VALUES('02302-006', '000715-3524390', '박광수', 302, '부산', '425-3323', 1, 20);
INSERT INTO 학생 VALUES('01301-001', '971011-1809003', '김형석', 301, '서울', '152-7468', 2, 24);
INSERT INTO 학생 VALUES('02301-002', '010825-3506390', '박철수', 301, '제주', '164-5520', 1, 19);
INSERT INTO 학생 VALUES('01301-004', '970711-1359003', '백태성', 301, '대전', '152-5429', 2, 24);

-- 교수테이블 입력(1진 관계 - 데이터 입력 순서 중요. 학과장부터 먼저 입력해야 함)
-- 오류 INSERT INTO 교수 VALUES('302-101', '590327-1839240', '이태규', 302, '서울', '351-8801', '교수', 1983, '302-201');
INSERT INTO 교수 VALUES('302-201', '650702-1350026', '고희석', 302, '부산', '140-5501', '부교수', 1990, '302-201');
INSERT INTO 교수 VALUES('302-101', '590327-1839240', '이태규', 302, '서울', '351-8801', '교수', 1983, '302-201');
INSERT INTO 교수 VALUES('302-202', '661011-2765501', '최성희', 302, '서울', '440-6221', '부교수', 1991, '302-201');
INSERT INTO 교수 VALUES('301-101', '550728-1102458', '김태석', 301, '대전', '195-6548', '부교수', 1984, '301-101');
INSERT INTO 교수 VALUES('301-201', '640505-1200546', '박철재', 301, '광주', '213-8562', '조교수', 1989, '301-101');

-- 교과목테이블 입력
INSERT INTO 교과목 VALUES('302.551', '전산개론', 3);
INSERT INTO 교과목 VALUES('302.553', '자료구조', 3);
INSERT INTO 교과목 VALUES('302.562', '화일처리', 3);
INSERT INTO 교과목 VALUES('302.571', '프로그래밍언어론', 3);
INSERT INTO 교과목 VALUES('301.501', '미적분학', 3);
INSERT INTO 교과목 VALUES('301.502', '고급해석학', 3);
INSERT INTO 교과목 VALUES('302.661', '운영체제', 3);
INSERT INTO 교과목 VALUES('302.109', '인공지능', 3);

-- 강좌 테이블 입력
INSERT INTO 강좌 VALUES('302.551', 2019, 2, '302-101', '56-101', 40);
INSERT INTO 강좌 VALUES('302.553', 2019, 2, '302-201', '56-218', 10);
INSERT INTO 강좌 VALUES('301.501', 2019, 2, '301-101', '31-201', 30);
INSERT INTO 강좌 VALUES('301.502', 2019, 2, '301-201', '31-201', 10);
INSERT INTO 강좌 VALUES('302.551', 2020, 1, '302-101', '56-101', 20);
INSERT INTO 강좌 VALUES('302.553', 2020, 1, '302-201', '56-218', 40);
INSERT INTO 강좌 VALUES('302.562', 2020, 1, '302-202', '56-218', 10);
INSERT INTO 강좌 VALUES('302.571', 2020, 1, '302-202', '56-201', 40);
INSERT INTO 강좌 VALUES('301.501', 2020, 1, '301-101', '31-201', 10);
INSERT INTO 강좌 VALUES('301.502', 2020, 1, '301-201', '31-201', 20);

-- 수강 테이블 입력
INSERT INTO 수강 VALUES('01302-001', '302.551', 2019, 2, 'A+');
INSERT INTO 수강 VALUES('01302-001', '302.553', 2020, 1, 'A+');
INSERT INTO 수강 VALUES('01302-001', '302.571', 2020, 1, 'C+');
INSERT INTO 수강 VALUES('01302-002', '302.551', 2019, 2, 'A+');
INSERT INTO 수강 VALUES('01302-002', '302.553', 2019, 2, 'A0');
INSERT INTO 수강 VALUES('01302-002', '302.562', 2020, 1, 'B0');
INSERT INTO 수강 VALUES('01302-002', '302.571', 2020, 1, 'C0');
INSERT INTO 수강 VALUES('01302-004', '302.551', 2019, 2, 'A0');
INSERT INTO 수강 VALUES('01302-004', '301.501', 2019, 2, 'A0');
INSERT INTO 수강 VALUES('01302-004', '302.571', 2020, 1, 'B+');
INSERT INTO 수강 VALUES('01302-004', '302.553', 2020, 1, 'A0');
INSERT INTO 수강 VALUES('01302-005', '302.551', 2019, 2, 'B-');
INSERT INTO 수강 VALUES('01302-005', '302.553', 2020, 1, 'C0');
INSERT INTO 수강 VALUES('01302-005', '302.571', 2020, 1, 'B+');
INSERT INTO 수강 VALUES('02302-006', '302.551', 2020, 1, 'A+');
INSERT INTO 수강 VALUES('02302-006', '302.553', 2020, 1, 'B+');
INSERT INTO 수강 VALUES('01301-001', '301.501', 2019, 2, 'A-');
INSERT INTO 수강 VALUES('01301-001', '301.502', 2019, 2, 'B+');
INSERT INTO 수강 VALUES('01301-001', '302.551', 2020, 1, 'B+');
INSERT INTO 수강 VALUES('02301-002', '301.501', 2020, 1, 'B0');
INSERT INTO 수강 VALUES('02301-002', '301.502', 2020, 1, 'A+');
INSERT INTO 수강 VALUES('01301-004', '301.501', 2019, 2, 'B0');
INSERT INTO 수강 VALUES('01301-004', '301.502', 2020, 1, 'C0');

-- 입력한 내용을  DB에 반영
COMMIT; 

-- 테이블 내용 확인
select * from 학생;
select * from 학과;
select * from 교수;
select * from 교과목;
select * from 강좌;
select * from 수강;

------------ </ 실습 3 > ====================