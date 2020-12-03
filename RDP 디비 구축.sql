-- ID: SYSTEM
DROP USER RDP CASCADE; -- 기존 사용자 삭제(현재 접속되어 있으면 삭제 안 됨)
	-- CASCADE option : 관련 스키마 개체들도 함께 삭제.  Default는 No Action
CREATE USER RDP IDENTIFIED BY 1234  -- 사용자 ID : RDP, 비밀번호 : 1234
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP;
GRANT connect, resource, dba TO RDP; -- 권한 부여

-- ID: RDP

-- 0 Layer
CREATE TABLE 학과 (
	학과코드   NUMBER(7)   NOT NULL,
    학과명     NVARCHAR2(20)   NOT NULL,
    PRIMARY KEY(학과코드)
);
CREATE TABLE 책 (
	책코드     NUMBER(7)   NOT NULL,
    책이름     NVARCHAR2(50)   NOT NULL,
    PRIMARY KEY(책코드)
);
CREATE TABLE 사용자 (
    사용자ID   NVARCHAR2(20)   NOT NULL,
    비밀번호    NVARCHAR2(20)   NOT NULL,
    닉네임     NVARCHAR2(20)   NOT NULL,
    PRIMARY KEY(사용자ID)
);
-- 1 Layer
CREATE TABLE 교수 (
    교수코드    NUMBER(7)   NOT NULL,
    교수명     NVARCHAR2(20)   NOT NULL,
    학과코드    NUMBER(7)   NOT NULL,
    PRIMARY KEY(교수코드),
    FOREIGN KEY(학과코드)   REFERENCES 학과(학과코드)
);
-- 2 Layer
CREATE TABLE 강좌 (
    강좌코드    NUMBER(7)   NOT NULL,
    강좌명     NVARCHAR2(50)    NOT NULL,
    연도      NUMBER(4)   NOT NULL,
    학기      NUMBER(1)   NOT NULL,
    이수구분    NVARCHAR2(20)   NOT NULL,
    교수코드    NUMBER(7)   NOT NULL,
    수업책코드   NUMBER(7)   NOT NULL,
    학과코드    NUMBER(7)   NOT NULL,
    수업일     NVARCHAR2(50)   NOT NULL,
    전체평점    NUMBER(3,2)     NOT NULL,
    PRIMARY KEY(강좌코드),
    FOREIGN KEY(교수코드)   REFERENCES 교수(교수코드),
    FOREIGN KEY(수업책코드)   REFERENCES 책(책코드),
    FOREIGN KEY(학과코드)   REFERENCES 학과(학과코드)
);
-- 3 Layer
CREATE TABLE 수강평가게시판 (
    글코드     NUMBER(7)   NOT NULL,
    강좌코드    NUMBER(7)   NOT NULL,
    평점      NUMBER(1)   NOT NULL,
    사용자ID   NVARCHAR2(20)   NOT NULL,
    댓글      NVARCHAR2(300)  NOT NULL,
    PRIMARY KEY(글코드),
    FOREIGN KEY(강좌코드)   REFERENCES 강좌(강좌코드),
    FOREIGN KEY(사용자ID)  REFERENCES 사용자(사용자ID)
);


-- 학과 INSERT
/*
학과코드   NUMBER(7)   NOT NULL,
학과명     NVARCHAR2(20)   NOT NULL,
*/
INSERT INTO 학과 VALUES ('1','컴퓨터공학과');
INSERT INTO 학과 VALUES ('2','전기공학과');
INSERT INTO 학과 VALUES ('3','건축공학과');
INSERT INTO 학과 VALUES ('4','토목공학과');
INSERT INTO 학과 VALUES ('5','전자공학과');
INSERT INTO 학과 VALUES ('6','소프트웨어공학과');
SELECT * FROM 학과;


-- 책 INSERT
/*
책코드     NUMBER(7)   NOT NULL,
책이름     NVARCHAR2(50)   NOT NULL,
*/
-- 컴공
INSERT INTO 책 VALUES ('1','C언어 스케치');
INSERT INTO 책 VALUES ('2','데이터베이스 개론');
INSERT INTO 책 VALUES ('3','명품 C++');
-- 전기
INSERT INTO 책 VALUES ('4','전기공학기초');
-- 건축
INSERT INTO 책 VALUES ('5','건축공학기초');
-- 토목
INSERT INTO 책 VALUES ('6','토목공학기초');
-- 전자
INSERT INTO 책 VALUES ('7','전자공학기초');
-- 소프트웨어
INSERT INTO 책 VALUES ('8','두근두근파이썬');
INSERT INTO 책 VALUES ('9','C# 프로그래밍 입문');
INSERT INTO 책 VALUES ('10','운영체제 개정3판');
INSERT INTO 책 VALUES ('11','Java 개발자를 위한 XML');
INSERT INTO 책 VALUES ('12','두근두근 자료구조');
INSERT INTO 책 VALUES ('13','명품 C++ Programming');
INSERT INTO 책 VALUES ('14','어서와 파이썬은 처음이지');
INSERT INTO 책 VALUES ('15','게임샐러드 워크북');
INSERT INTO 책 VALUES ('16','알기쉬운 정보보호 개론');
INSERT INTO 책 VALUES ('17','컴퓨터 구조 및 설계');
INSERT INTO 책 VALUES ('18','디지털 신호 처리');


SELECT * FROM 책;


-- 사용자 INSERT
/*
사용자ID   NVARCHAR2(20)   NOT NULL,
비밀번호    NVARCHAR2(20)   NOT NULL,
닉네임     NVARCHAR2(20)   NOT NULL,
*/
INSERT INTO 사용자 VALUES ('apple','pw0001','팀쿡');
INSERT INTO 사용자 VALUES ('banana','pw0002','바나나주스');
INSERT INTO 사용자 VALUES ('java','pw0003','땔깜');
INSERT INTO 사용자 VALUES ('cplusplus','pw0004','할배');
INSERT INTO 사용자 VALUES ('rust','pw0005','힙스터');
INSERT INTO 사용자 VALUES ('python','pw0006','스타국민맵');
INSERT INTO 사용자 VALUES ('nvidia','pw0007','황회장');
SELECT * FROM 사용자;


-- 교수 INSERT
/*
교수코드    NUMBER(7)   NOT NULL,
교수명     NVARCHAR2(20)   NOT NULL,
학과코드    NUMBER(7)   NOT NULL,
*/
/*
INSERT INTO 학과 VALUES ('1','컴퓨터공학과');
INSERT INTO 학과 VALUES ('2','전기공학과');
INSERT INTO 학과 VALUES ('3','건축공학과');
INSERT INTO 학과 VALUES ('4','토목공학과');
INSERT INTO 학과 VALUES ('5','전자공학과');
INSERT INTO 학과 VALUES ('6','소프트웨어공학과');
*/
INSERT INTO 교수 VALUES ('1','김민영','1');
INSERT INTO 교수 VALUES ('2','김진덕','1');
INSERT INTO 교수 VALUES ('3','장성진','1');
INSERT INTO 교수 VALUES ('4','아이유','2');
INSERT INTO 교수 VALUES ('5','원빈','3');
INSERT INTO 교수 VALUES ('6','조인성','4');
INSERT INTO 교수 VALUES ('7','나훈아','5');
INSERT INTO 교수 VALUES ('8','현아','6');
SELECT * FROM 교수;


-- 강좌 INSERT
/*
강좌코드    NUMBER(7)   NOT NULL,
강좌명     NVARCHAR2(50)    NOT NULL,
연도      NUMBER(4)   NOT NULL,
학기      NUMBER(1)   NOT NULL,
이수구분    NVARCHAR2(20)   NOT NULL,
교수코드    NUMBER(7)   NOT NULL,
수업책코드   NUMBER(7)   NOT NULL,
학과코드    NUMBER(7)   NOT NULL,
수업일     NVARCHAR2(50)   NOT NULL,
전체평점    NUMBER(3,2)     NOT NULL,
*/
INSERT INTO 강좌 VALUES ('1','기초프로그래밍1','2020','1','전공필수','1','1','1','월23수12','0');
INSERT INTO 강좌 VALUES ('2','데이터베이스응용','2020','2','전공선택','2','2','1','월45수34','0');
INSERT INTO 강좌 VALUES ('3','알기쉬운 전기세계','2020','1','자유교양','4','4','2','화67','0');
INSERT INTO 강좌 VALUES ('4','프로그래밍입문','2020','2','공통교양','8','8','6','목67','0');
INSERT INTO 강좌 VALUES ('5','비주얼프로그래밍','2020','2','전공필수','3','9','1','월12','0');
INSERT INTO 강좌 VALUES ('6','운영체제','2020','2','전공선택','5','10','1','화12','0');
INSERT INTO 강좌 VALUES ('7','웹프로그래밍','2020','2','전공선택','6','11','1','화34','0');
INSERT INTO 강좌 VALUES ('8','자료구조','2020','2','전공필수','7','12','1','화56','0');
INSERT INTO 강좌 VALUES ('9','객체지향프로그래밍','2020','1','전공필수','8','13','1','월12','0');
INSERT INTO 강좌 VALUES ('10','공학기술프로그래밍','2020','1','전공선택','3','14','1','월34','0');
INSERT INTO 강좌 VALUES ('11','인디게임 창업','2020','1','자유교양','4','15','1','월56','0');
INSERT INTO 강좌 VALUES ('12','정보보호','2020','1','전공선택','5','16','1','수56','0');
INSERT INTO 강좌 VALUES ('13','컴퓨터시스템설계','2020','1','전공선택','6','17','1','금23','0');
INSERT INTO 강좌 VALUES ('14','디지털신호처리','2020','1','전공선택','7','18','1','목34','0');


SELECT * FROM 강좌;

-- 수강평가게시판 INSERT

COMMIT;

------------------------------------------------------
-- Additional Commit By Jongseok

INSERT INTO 책 VALUES ('9','디지털 신호 처리');
INSERT INTO 책 VALUES ('10','C++ 프로그래밍');
INSERT INTO 책 VALUES ('11', 'JAVA 개발자를 위한 XML');
INSERT INTO 책 VALUES ('12','C#프로그래밍 입문');

COMMIT;
