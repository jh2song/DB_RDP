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
INSERT INTO ���� VALUES ('1','�������α׷���1','2020','1','�����ʼ�','1','1','1','��23��12','0');
INSERT INTO ���� VALUES ('2','�����ͺ��̽�����','2020','2','��������','2','2','1','��45��34','0');
INSERT INTO ���� VALUES ('3','�˱⽬�� ���⼼��','2020','1','��������','4','4','2','ȭ67','0');
INSERT INTO ���� VALUES ('4','���α׷����Թ�','2020','2','���뱳��','8','8','6','��67','0');
SELECT * FROM ����;

-- �����򰡰Խ��� INSERT

COMMIT;
