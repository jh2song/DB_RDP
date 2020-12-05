-- ID: SYSTEM
DROP USER RDP CASCADE; -- ���� ����� ����(���� ���ӵǾ� ������ ���� �� ��)
	-- CASCADE option : ���� ��Ű�� ��ü�鵵 �Բ� ����.  Default�� No Action
CREATE USER RDP IDENTIFIED BY 1234  -- ����� ID : RDP, ��й�ȣ : 1234
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP;
GRANT connect, resource, dba TO RDP; -- ���� �ο�

-- ID: RDP

-- 0 Layer
CREATE TABLE �а� (
	�а��ڵ�   NUMBER(7)   NOT NULL,
    �а���     NVARCHAR2(20)   NOT NULL,
    PRIMARY KEY(�а��ڵ�)
);
CREATE TABLE å (
	å�ڵ�     NUMBER(7)   NOT NULL,
    å�̸�     NVARCHAR2(50)   NOT NULL,
    PRIMARY KEY(å�ڵ�)
);
CREATE TABLE ����� (
    �����ID   NVARCHAR2(20)   NOT NULL,
    ��й�ȣ    NVARCHAR2(20)   NOT NULL,
    �г���     NVARCHAR2(20)   NOT NULL,
    PRIMARY KEY(�����ID)
);
-- 1 Layer
CREATE TABLE ���� (
    �����ڵ�    NUMBER(7)   NOT NULL,
    ������     NVARCHAR2(20)   NOT NULL,
    �а��ڵ�    NUMBER(7)   NOT NULL,
    PRIMARY KEY(�����ڵ�),
    FOREIGN KEY(�а��ڵ�)   REFERENCES �а�(�а��ڵ�)
);
-- 2 Layer
CREATE TABLE ���� (
    �����ڵ�    NUMBER(7)   NOT NULL,
    ���¸�     NVARCHAR2(50)    NOT NULL,
    ����      NUMBER(4)   NOT NULL,
    �б�      NUMBER(1)   NOT NULL,
    �̼�����    NVARCHAR2(20)   NOT NULL,
    �����ڵ�    NUMBER(7)   NOT NULL,
    ����å�ڵ�   NUMBER(7)   NOT NULL,
    �а��ڵ�    NUMBER(7)   NOT NULL,
    ������     NVARCHAR2(50)   NOT NULL,
    ��ü����    NUMBER(3,2)     NOT NULL,
    PRIMARY KEY(�����ڵ�),
    FOREIGN KEY(�����ڵ�)   REFERENCES ����(�����ڵ�),
    FOREIGN KEY(����å�ڵ�)   REFERENCES å(å�ڵ�),
    FOREIGN KEY(�а��ڵ�)   REFERENCES �а�(�а��ڵ�)
);
-- 3 Layer
CREATE TABLE �����򰡰Խ��� (
    ���ڵ�     NUMBER(7)   NOT NULL,
    �����ڵ�    NUMBER(7)   NOT NULL,
    ����      NUMBER(1)   NOT NULL,
    �����ID   NVARCHAR2(20)   NOT NULL,
    ���      NVARCHAR2(300)  NOT NULL,
    PRIMARY KEY(���ڵ�),
    FOREIGN KEY(�����ڵ�)   REFERENCES ����(�����ڵ�),
    FOREIGN KEY(�����ID)  REFERENCES �����(�����ID)
);


-- �а� INSERT
/*
�а��ڵ�   NUMBER(7)   NOT NULL,
�а���     NVARCHAR2(20)   NOT NULL,
*/
INSERT INTO �а� VALUES ('1','��ǻ�Ͱ��а�');
INSERT INTO �а� VALUES ('2','������а�');
INSERT INTO �а� VALUES ('3','������а�');
INSERT INTO �а� VALUES ('4','�����а�');
INSERT INTO �а� VALUES ('5','���ڰ��а�');
INSERT INTO �а� VALUES ('6','����Ʈ������а�');
SELECT * FROM �а�;


-- å INSERT
/*
å�ڵ�     NUMBER(7)   NOT NULL,
å�̸�     NVARCHAR2(50)   NOT NULL,
*/
-- �İ�
INSERT INTO å VALUES ('1','C��� ����ġ');
INSERT INTO å VALUES ('2','�����ͺ��̽� ����');
INSERT INTO å VALUES ('3','��ǰ C++');
-- ����
INSERT INTO å VALUES ('4','������б���');
-- ����
INSERT INTO å VALUES ('5','������б���');
-- ���
INSERT INTO å VALUES ('6','�����б���');
-- ����
INSERT INTO å VALUES ('7','���ڰ��б���');
-- ����Ʈ����
INSERT INTO å VALUES ('8','�αٵα����̽�');
INSERT INTO å VALUES ('9','C# ���α׷��� �Թ�');
INSERT INTO å VALUES ('10','�ü�� ����3��');
INSERT INTO å VALUES ('11','Java �����ڸ� ���� XML');
INSERT INTO å VALUES ('12','�αٵα� �ڷᱸ��');
INSERT INTO å VALUES ('13','��ǰ C++ Programming');
INSERT INTO å VALUES ('14','��� ���̽��� ó������');
INSERT INTO å VALUES ('15','���ӻ����� ��ũ��');
INSERT INTO å VALUES ('16','�˱⽬�� ������ȣ ����');
INSERT INTO å VALUES ('17','��ǻ�� ���� �� ����');
INSERT INTO å VALUES ('18','������ ��ȣ ó��');


SELECT * FROM å;


-- ����� INSERT
/*
�����ID   NVARCHAR2(20)   NOT NULL,
��й�ȣ    NVARCHAR2(20)   NOT NULL,
�г���     NVARCHAR2(20)   NOT NULL,
*/
INSERT INTO ����� VALUES ('apple','pw0001','����');
INSERT INTO ����� VALUES ('banana','pw0002','�ٳ����ֽ�');
INSERT INTO ����� VALUES ('java','pw0003','����');
INSERT INTO ����� VALUES ('cplusplus','pw0004','�ҹ�');
INSERT INTO ����� VALUES ('rust','pw0005','������');
INSERT INTO ����� VALUES ('python','pw0006','��Ÿ���θ�');
INSERT INTO ����� VALUES ('nvidia','pw0007','Ȳȸ��');
SELECT * FROM �����;


-- ���� INSERT
/*
�����ڵ�    NUMBER(7)   NOT NULL,
������     NVARCHAR2(20)   NOT NULL,
�а��ڵ�    NUMBER(7)   NOT NULL,
*/
/*
INSERT INTO �а� VALUES ('1','��ǻ�Ͱ��а�');
INSERT INTO �а� VALUES ('2','������а�');
INSERT INTO �а� VALUES ('3','������а�');
INSERT INTO �а� VALUES ('4','�����а�');
INSERT INTO �а� VALUES ('5','���ڰ��а�');
INSERT INTO �а� VALUES ('6','����Ʈ������а�');
*/
INSERT INTO ���� VALUES ('1','��ο�','1');
INSERT INTO ���� VALUES ('2','������','1');
INSERT INTO ���� VALUES ('3','�强��','1');
INSERT INTO ���� VALUES ('4','������','2');
INSERT INTO ���� VALUES ('5','����','3');
INSERT INTO ���� VALUES ('6','���μ�','4');
INSERT INTO ���� VALUES ('7','���ƾ�','5');
INSERT INTO ���� VALUES ('8','����','6');
SELECT * FROM ����;


-- ���� INSERT
/*
�����ڵ�    NUMBER(7)   NOT NULL,
���¸�     NVARCHAR2(50)    NOT NULL,
����      NUMBER(4)   NOT NULL,
�б�      NUMBER(1)   NOT NULL,
�̼�����    NVARCHAR2(20)   NOT NULL,
�����ڵ�    NUMBER(7)   NOT NULL,
����å�ڵ�   NUMBER(7)   NOT NULL,
�а��ڵ�    NUMBER(7)   NOT NULL,
������     NVARCHAR2(50)   NOT NULL,
��ü����    NUMBER(3,2)     NOT NULL,
*/
INSERT INTO ���� VALUES ('1','�������α׷���1','2020','1','�����ʼ�','1','1','1','��23��12',0);
INSERT INTO ���� VALUES ('2','�����ͺ��̽�����','2020','2','��������','2','2','1','��45��34',0);
INSERT INTO ���� VALUES ('3','�˱⽬�� ���⼼��','2020','1','��������','4','4','2','ȭ67',0);
INSERT INTO ���� VALUES ('4','���α׷����Թ�','2020','2','���뱳��','8','8','6','��67',0);
INSERT INTO ���� VALUES ('5','���־����α׷���','2020','2','�����ʼ�','3','9','1','��12',0);
INSERT INTO ���� VALUES ('6','�ü��','2020','2','��������','5','10','1','ȭ12',0);
INSERT INTO ���� VALUES ('7','�����α׷���','2020','2','��������','6','11','1','ȭ34',0);
INSERT INTO ���� VALUES ('8','�ڷᱸ��','2020','2','�����ʼ�','7','12','1','ȭ56',0);
INSERT INTO ���� VALUES ('9','��ü�������α׷���','2020','1','�����ʼ�','8','13','1','��12',0);
INSERT INTO ���� VALUES ('10','���б�����α׷���','2020','1','��������','3','14','1','��34',0);
INSERT INTO ���� VALUES ('11','�ε���� â��','2020','1','��������','4','15','1','��56',0);
INSERT INTO ���� VALUES ('12','������ȣ','2020','1','��������','5','16','1','��56',0);
INSERT INTO ���� VALUES ('13','��ǻ�ͽý��ۼ���','2020','1','��������','6','17','1','��23',0);
INSERT INTO ���� VALUES ('14','�����н�ȣó��','2020','1','��������','7','18','1','��34',0);


SELECT * FROM ����;

-- �����򰡰Խ��� INSERT

COMMIT;


--------------------------------------------------------
-- ���� ���ν��� �����

/* ���� ��
CREATE OR REPLACE PROCEDURE SP_InOut1 (
  Pi_ID IN CHAR,
  Pi_Name IN CHAR,
  Po_������ OUT NUMBER
) AS
    --v_count VARCHAR(10);
BEGIN
  INSERT INTO ��(�����̵�, ���̸�, ���) VALUES(Pi_ID, Pi_Name, 'Silver');
  SELECT MAX(������) INTO Po_������ FROM ��; 
END ;
*/

CREATE OR REPLACE PROCEDURE SP_allRateSession (
    PI_���¸� IN ����.���¸�%TYPE,
    PI_�а��� IN �а�.�а���%TYPE,
    PO_���� OUT ����.������%TYPE,
    PI_���� IN ����.����%TYPE,
    PI_�б� IN ����.�б�%TYPE,
    PO_���� OUT å.å�̸�%TYPE,
    PO_��ü���� OUT ����.��ü����%TYPE,
    PO_�����ڵ� OUT ����.�����ڵ�%TYPE
) AS

BEGIN
    SELECT ����.������, å.å�̸�, ����.��ü����, ����.�����ڵ� INTO PO_����, PO_����, PO_��ü����, PO_�����ڵ� 
    FROM ����,�а�,å,����
    WHERE ����.�а��ڵ�=�а�.�а��ڵ� AND ����.����å�ڵ�=å.å�ڵ� AND ����.�����ڵ�=����.�����ڵ�-- ����
    AND ����.���¸�=PI_���¸� AND �а�.�а���=PI_�а��� AND ����.����=PI_���� AND ����.�б�=PI_�б�;
END;

-----------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_isRated (
    PI_�����ڵ� IN �����򰡰Խ���.�����ڵ�%TYPE,
    PI_�����ID IN �����򰡰Խ���.�����ID%TYPE,
    PO_���迩�� OUT NUMBER
) AS
    V_�� NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_�� FROM �����򰡰Խ��� WHERE �����ڵ�=PI_�����ڵ� AND �����ID=PI_�����ID;
    IF V_�� >= 1 THEN
        PO_���迩�� := 1;
    ELSE
        PO_���迩�� := 0;
    END IF;
END;

---------------------------------------------------------
-- �����򰡰Խ��� �� �ڵ� ������ ����
CREATE SEQUENCE SEQ_POST INCREMENT BY 1 START WITH 1;

-------------------------------------------------
-- Ʈ����
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER TRI_rateUpdate
    BEFORE INSERT OR DELETE OR UPDATE
    ON �����򰡰Խ���
    FOR EACH ROW
DECLARE
    T_�򰡼� NUMBER(5,0);
BEGIN
    IF INSERTING THEN
        UPDATE ���� SET ���ο�=���ο�+1 WHERE �����ڵ�=:NEW.�����ڵ�;
        UPDATE ���� SET ��ü����=((���ο�-1)*��ü����+:NEW.����)/(���ο�) WHERE �����ڵ�=:NEW.�����ڵ�;
    ELSIF DELETING THEN
        UPDATE ���� SET ���ο�=���ο�-1 WHERE �����ڵ�=:OLD.�����ڵ�;
        SELECT ���ο� INTO T_�򰡼� FROM ���� WHERE �����ڵ�=:OLD.�����ڵ�;
        IF T_�򰡼�=0 THEN
            UPDATE ���� SET ��ü����=0 WHERE �����ڵ�=:OLD.�����ڵ�;
        ELSE
            UPDATE ���� SET ��ü����=((���ο�+1)*��ü����-:OLD.����)/(���ο�) WHERE �����ڵ�=:OLD.�����ڵ�;
        END IF;
    ELSIF UPDATING THEN
        UPDATE ���� SET ��ü����=(���ο�*��ü����-:OLD.����+:NEW.����)/���ο� WHERE �����ڵ�=:NEW.�����ڵ�;
    END IF;
END;

-- Ʈ���� �ȿ��� ���� �ο��� ���ϴٺ��� Mutating ������ ���� ���� Į���� ����
ALTER TABLE ���� ADD ���ο� NUMBER(5,0) DEFAULT 0; 

SELECT * FROM ����;
SELECT * FROM �����򰡰Խ���;
DELETE FROM �����򰡰Խ��� WHERE ���ڵ�=8;
UPDATE ���� SET ��ü����=0,���ο�=0 WHERE �����ڵ�=1 OR �����ڵ�=2;

COMMIT;


SET SERVEROUTPUT ON;
DECLARE
    v1 ����.������%TYPE;
    v2 å.å�̸�%TYPE;
    v3 ����.��ü����%TYPE;
    v4 ����.�����ڵ�%TYPE;
BEGIN
    SP_ALLRATESESSION('�������α׷���1','��ǻ�Ͱ��а�',v1,'2020','1',v2,v3,v4);
    DBMS_OUTPUT.PUT_LINE(v1 || ':' || v2 || ':' || v3 || ':' || v4);
END;

SET SERVEROUTPUT ON;
DECLARE
    v1 NUMBER;
BEGIN
    SP_ISRATED('1','apple',v1);
    DBMS_OUTPUT.PUT_LINE(v1);
END;

SELECT * FROM ���� WHERE �����ڵ�='1';

SELECT * FROM �����򰡰Խ��� WHERE �����ڵ�='1';

UPDATE �����򰡰Խ��� SET ����='1' WHERE �����ڵ�='1' AND �����ID='banana';