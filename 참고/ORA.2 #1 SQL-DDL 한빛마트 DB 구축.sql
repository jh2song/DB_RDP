/* [ �� 2 �� ] # 1  - �Ѻ���Ʈ DB ����
<�ǽ�1> �Ѻ���Ʈ�� ���� ����ڻ���
<�ǽ�2> �Ѻ���Ʈ DB�� ���̺� ����
<�ǽ�3> �Ѻ���Ʈ DB�� ������ ����

... by JDK 
*/

----------------------------------------------------------------
------------ < �ǽ� 1 > ����� ���� ------------ 
----------------------------------------------------------------
/* ########  ID : SYSTEM ######## */
/*
�Ѻ���Ʈ DB�� ���� ����� ���� 
������ ����� : HMART (����Ŭ 12C�̻󿡼��� C##HMART)
*/

--ALTER session set "_ORACLE_SCRIPT"=true;
DROP USER HMART CASCADE; -- ���� ����� ����(���� ���ӵǾ� ������ ���� �� ��)
	-- CASCADE option : ���� ��Ű�� ��ü�鵵 �Բ� ����.  Default�� No Action
CREATE USER HMART IDENTIFIED BY 1234  -- ����� ID : hmart, ��й�ȣ : 1234
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP;
GRANT connect, resource, dba TO HMART; -- ���� �ο�
-- Hint) SQL Script ������ : Ctrl + Enter�� �Ѹ�ɾ�, F5�� ��ü ����, ���� �����Ǹ� �� ����� ����
------------ </ �ǽ� 1 > ====================
 


-- �ǽ� ���� �غ���� : �ʿ��ϴٸ�, Sql Developer���� HMART�� ���� ����(����) ����

----------------------------------------------------------------
------------ < �ǽ� 2 > ���̺� ���� �� ���� ------------ 
----------------------------------------------------------------
/* ########  ID : HMART ######## */
/* 
�Ѻ���Ʈ DB�� ���� ���̺� ���� 
���̺� �̸� : ��, ��ǰ, �ֹ�, ��۾�ü
*/

/* -- ���� �߻� ����
CREATE TABLE  �ֹ� (
	�ֹ���ȣ   CHAR(3) NOT NULL,
	�ֹ���   VARCHAR(20),
	�ֹ���ǰ   CHAR(3),
	����        INT,
	�����     VARCHAR(30),
	�ֹ�����  DATE,
	PRIMARY KEY(�ֹ���ȣ),
	FOREIGN KEY(�ֹ���)   REFERENCES   ��(�����̵�),
	FOREIGN KEY(�ֹ���ǰ)   REFERENCES   ��ǰ(��ǰ��ȣ)
);
  -- Cause : ���� ��, ��ǰ ���̺��� ���� ����
  -- Solution : �ܷ�Ű ���� ���̺� ���� ����.
	-- �׷��� �ذ�ȵ� ���� ���̺� ������ FK�������ϰ�,
	-- ���̺� ���� �� add constraints�� �ܷ�Ű �߰�
*/

----// ���̺� ����(Create Table...)

--	[���� 7-1]
CREATE TABLE �� (
	�����̵�  VARCHAR(20)	 NOT NULL,
	���̸�    VARCHAR(10)	 NOT NULL,
	����	    INT,
	���	    VARCHAR(10)	 NOT NULL,
	����	    VARCHAR(20),
	������	    INT   DEFAULT 0,
	PRIMARY KEY(�����̵�)
);

--	[���� 7-2]
CREATE TABLE  ��ǰ (
	��ǰ��ȣ   CHAR(3)   NOT NULL,
	��ǰ��      VARCHAR(20),
	���      INT,
	�ܰ�         INT,
	������ü    VARCHAR(20),
	PRIMARY KEY(��ǰ��ȣ),
	CHECK (��� >= 0 AND ��� <=10000)
);

--	[���� 7-3]
CREATE TABLE  �ֹ� (
	�ֹ���ȣ   CHAR(3) NOT NULL,
	�ֹ���   VARCHAR(20),
	�ֹ���ǰ   CHAR(3),
	����        INT,
	�����     VARCHAR(30),
	�ֹ�����  DATE,
	PRIMARY KEY(�ֹ���ȣ),
	CONSTRAINT FK_��_�ֹ� FOREIGN KEY(�ֹ���)   REFERENCES   ��(�����̵�),
	FOREIGN KEY(�ֹ���ǰ)   REFERENCES   ��ǰ(��ǰ��ȣ)
);

--	[���� 7-4]
CREATE TABLE  ��۾�ü (
	��ü��ȣ   CHAR(3) NOT NULL,
	��ü��   VARCHAR(20),
	�ּ�  VARCHAR(100),
	��ȭ��ȣ  VARCHAR(20),
	PRIMARY KEY(��ü��ȣ)
);

----// ���̺� ��������(Alter Table...)
--	[���� 7-5]
ALTER TABLE �� ADD ���Գ�¥ DATE; 


--	[���� 7-6]
ALTER TABLE �� DROP COLUMN ���Գ�¥;


--	[���� 7-7]
ALTER TABLE �� ADD CONSTRAINT CHK_AGE CHECK(���� >= 20); 

--	[���� 7-8]
ALTER TABLE �� DROP CONSTRAINT CHK_AGE; 

----// ���̺� ����
--	[���� 7-9]
DROP TABLE ��۾�ü; --defalut�� restrict : ������ ���̺��� ������ �����ȵ�
  -- DROP TABLE ���̺�� cascade contraints : ������ ���̺���  constraints���� ����


----// ���� �Ӽ�

/*
ALTER TABLE ��ǰ
    ADD ���ݾ� GENERATED ALWAYS AS (��� * �ܰ�) ;

SELECT * FROM ��ǰ;
*/

------------ </ �ǽ� 2 > ====================



----------------------------------------------------------------
------------ < �ǽ� 3 > ������ �Է� ------------ 
----------------------------------------------------------------

/* 
�Ѻ���Ʈ DB�� ���� ������ �Է� 
*/

/* -- ���� �߻� ����
INSERT INTO �ֹ� VALUES ('o01', 'apple', 'p03', 10, '����� ������', '19/01/01');
-- Cause : �������Ἲ�������Ƕ����� �ܷ�Ű�� �ֹ����� �ֹ���ǰ�� ���� �Է��� �� ����
	-- ���� ���� ��ǰ���̺��� �����Ͱ� �Էµ��� �ʾ���
-- �ذ�å : ���� ��ǰ���̺��� ���� �Է�.(�ܷ�Ű�� ����Ͽ� �Է� ������ ����) 
*/

-- [�� ���̺� Ʃ�� ����]
INSERT INTO �� VALUES ('apple', '����ȭ', 20, 'gold', '�л�', 1000);
INSERT INTO �� VALUES ('banana', '�輱��', 25, 'vip', '��ȣ��', 2500);
INSERT INTO �� VALUES ('carrot', '���', 28, 'gold', '����', 4500);
INSERT INTO �� VALUES ('orange', '����', 22, 'silver', '�л�', 0);
INSERT INTO �� VALUES ('melon', '������', 35, 'gold', 'ȸ���', 5000);
INSERT INTO �� VALUES ('peach', '������', NULL, 'silver', '�ǻ�', 300);
INSERT INTO �� VALUES ('pear', 'ä����', 31, 'silver', 'ȸ���', 500);

-- [��ǰ ���̺� Ʃ�� ����]
INSERT INTO ��ǰ VALUES ('p01', '�׳ɸ���', 5000, 4500, '���ѽ�ǰ');
INSERT INTO ��ǰ VALUES ('p02', '�ſ��̸�', 2500, 5500, '�α�Ǫ��');
INSERT INTO ��ǰ VALUES ('p03', '��������', 3600, 2600, '�Ѻ�����');
INSERT INTO ��ǰ VALUES ('p04', '�������ݸ�', 1250, 2500, '�Ѻ�����');
INSERT INTO ��ǰ VALUES ('p05', '��ū���', 2200, 1200, '���ѽ�ǰ');
INSERT INTO ��ǰ VALUES ('p06', '����쵿', 1000, 1550, '�α�Ǫ��');
INSERT INTO ��ǰ VALUES ('p07', '���޺�Ŷ', 1650, 1500, '�Ѻ�����');

-- [�ֹ� ���̺� Ʃ�� ����]
INSERT INTO �ֹ� VALUES ('o01', 'apple', 'p03', 10, '����� ������', '19/01/01');
INSERT INTO �ֹ� VALUES ('o02', 'melon', 'p01', 5, '��õ�� ��籸', '19/01/10');
INSERT INTO �ֹ� VALUES ('o03', 'banana', 'p06', 45, '��⵵ ��õ��', '19/01/11');
INSERT INTO �ֹ� VALUES ('o04', 'carrot', 'p02', 8, '�λ�� ������', '19/02/01');
INSERT INTO �ֹ� VALUES ('o05', 'melon', 'p06', 36, '��⵵ ���ν�', '19/02/20');
INSERT INTO �ֹ� VALUES ('o06', 'banana', 'p01', 19, '��û�ϵ� ������', '19/03/02');
INSERT INTO �ֹ� VALUES ('o07', 'apple', 'p03', 22, '����� ��������', '19/03/15');
INSERT INTO �ֹ� VALUES ('o08', 'pear', 'p02', 50, '������ ��õ��', '19/04/10');
INSERT INTO �ֹ� VALUES ('o09', 'banana', 'p04', 15, '���󳲵� ������', '19/04/11');
INSERT INTO �ֹ� VALUES ('o10', 'carrot', 'p03', 20, '��⵵ �Ⱦ��', '19/05/22');


-- �Է��� ������  DB�� �ݿ�
COMMIT; 

-- ���̺� ���� Ȯ��
select * from ��;
select * from ��ǰ;
select * from �ֹ�;

------------ </ �ǽ� 3 > ====================