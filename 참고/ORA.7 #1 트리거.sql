/* [ �� 7 �� ] # 1  - Ʈ����
<�ǽ�1> Ʈ���� Before, After
<�ǽ�2> Ʈ���� Instead Of
<�ǽ�3> ���� Ʈ����

-- 
... by JDK 
*/

----------------------------------------------------------------
------------ < �ǽ� 1 > Ʈ���� Before, After  ------------ 
----------------------------------------------------------------

---- ���� �۾� : HMart ��Ű�� Reset (by SYSTEM & HMART)

/* ########  ID : HMART ######## */

SET SERVEROUTPUT ON;  -- ��� ���

-- Simple Trigger : ������ �Է� �� ����
CREATE or REPLACE TRIGGER T_Simple1
 AFTER INSERT
 ON ��
 FOR EACH ROW
BEGIN
 DBMS_OUTPUT.PUT_LINE('After Insert ����');
END;

-- Simple Trigger : ������ ���� �� ����
CREATE or REPLACE TRIGGER T_Simple2
 AFTER DELETE
 ON ��
 FOR EACH ROW
BEGIN
 DBMS_OUTPUT.PUT_LINE('After Delete ����');
END;


INSERT INTO �� VALUES ('berry', 'JDK', 50, 'gold', '����', 5000); -- T_Simple1����
DELETE FROM �� WHERE �����̵� = 'berry'; -- T_Simple2���� 

DROP TRIGGER T_Simple1;
DROP TRIGGER T_Simple2;

/* UPDATE OR DELETE ����
CREATE OR REPLACE TRIGGER T_Simple3 
   AFTER  UPDATE OR DELETE  -- ���� �Ǵ� ���� �Ŀ� ����
   ON ��
   FOR EACH ROW
DECLARE 
   V_Type NCHAR(2); -- ���� Ÿ��
BEGIN
   IF UPDATING THEN        V_Type := '����';
   ELSIF DELETING  THEN    V_Type := '����';
   END IF;
   DBMS_OUTPUT.PUT_LINE('����� ������ ������ ' || v_modType);
END T_Simple3;
*/

----//      :OLD, :NEW ����

--  Before    old & new �⺻ ����
CREATE OR REPLACE TRIGGER T_OLDNEW1
   BEFORE INSERT  
   ON �� 
   FOR EACH ROW 
BEGIN
        DBMS_OUTPUT.PUT_LINE('NEW �̸� ' || :NEW.���̸�);
        DBMS_OUTPUT.PUT_LINE('NEW ���� ' || :NEW.����);
        DBMS_OUTPUT.PUT_LINE('OLD �̸� ' ||:OLD.���̸�);
        DBMS_OUTPUT.PUT_LINE('OLD ���� ' || :OLD.����);
END;

INSERT INTO �� VALUES ('aaa', '������', NULL, 'silver', '�л�', 300);
  
INSERT INTO �� VALUES ('aaa', '������', NULL, 'silver', '�л�', 300);
  -- ���� ����(Ű�ߺ�)������, Before insert�̹Ƿ� Ʈ���Ŵ� �����
DELETE FROM �� WHERE �����̵� = 'aaa';

DROP TRIGGER T_OLDNEW1;

-- Before old & new : Insert �� ���� �����ؼ� �Է��ؾ� �ϴ� ���
  -- ���ݺ��� �Էµ� �� �� �̸��� ��00 ���·� �Է��ϰ��� ��.
  -- Real DB�� �ԷµǱ� ���� :NEW���� �ٲ�
CREATE OR REPLACE TRIGGER T_OLDNEW2
   before INSERT  
   ON �� 
   FOR EACH ROW 
BEGIN
    :NEW.���̸� := SUBSTR(:NEW.���̸�, 1, 1) || 'OO';
END;

INSERT INTO �� VALUES ('aaa', '������', NULL, 'silver', '�л�', 300);
DELETE FROM �� WHERE �����̵� = 'aaa';
DROP TRIGGER T_OLDNEW2;

-- After old & new :  Insert �� ���� & �Է� ��� 
  -- ������ �ſ�ҷ����̸� ������ ���� ���
CREATE OR REPLACE TRIGGER T_�ڰݰ˻�
   AFTER INSERT  
   ON �� 
   FOR EACH ROW 
BEGIN
    IF :NEW.���� = '�ſ�ҷ���' THEN
        DBMS_OUTPUT.PUT_LINE('�ڰ��� ���� �ʾƿ�.');
        DBMS_OUTPUT.PUT_LINE('�Է��� ��ҵǾ����ϴ�.');
        RAISE_APPLICATION_ERROR(-20999,'�ڰݰ˻� ���� �Է� �õ� �߰� !!!'); -- �Է� ���
    END IF;
END;

INSERT INTO �� VALUES ('fruits', '�ź���', NULL, 'silver', '�ſ�ҷ���', 300);
DELETE FROM �� WHERE �����̵� = 'fruits';
DROP TRIGGER T_�ڰݰ˻�;

-- After : Insert �� ���� & Update
   -- Ʈ���� ������ �ƴ����� ���� �� ����
CREATE OR REPLACE TRIGGER T_OLDNEW3
   AFTER INSERT  
   ON �� 
   FOR EACH ROW 
BEGIN
    IF  :NEW.���̸� = '������' THEN
      UPDATE  �� SET ���̸� = '��00' WHERE ���̸� = '������';
    END IF;
END;

INSERT INTO �� VALUES ('aaa', '������', NULL, 'silver', '�л�', 300);
DELETE FROM �� WHERE �����̵� = 'aaa';
DROP TRIGGER T_OLDNEW3;

-- After : Insert �� ���� & �ٸ� ���̺� Update
CREATE OR REPLACE TRIGGER T_OLDNEW4
   AFTER INSERT  
   ON �� 
   FOR EACH ROW 
BEGIN
    IF  :NEW.���̸� = '������' THEN
      UPDATE  �ֹ� SET ���� = 99 WHERE �ֹ���ȣ = 'o08';
      -- Ʈ���� ������ �ٸ� ���̺� ���� SQL�� ���� ����
    END IF;
END;

INSERT INTO �� VALUES ('aaa', '������', NULL, 'silver', '�л�', 300);
DELETE FROM �� WHERE �����̵� = 'aaa';
DROP TRIGGER T_OLDNEW4;

----//  �� ���̺� ����� Ʈ���ŷ� �ٸ� ���̺��� �����ϴ� ���
--  Ż�� �� ��� �ó�����.
CREATE TABLE Ż��� 
(   "�����̵�" VARCHAR2(20 BYTE) , 
	"���̸�" VARCHAR2(10 BYTE), 
	"����" NUMBER(*,0), 
	"���" VARCHAR2(10 BYTE) , 
	"����" VARCHAR2(20 BYTE), 
	"������" NUMBER(*,0) DEFAULT 0, 
    ������ DATE,
    �������� NCHAR(30)
);

CREATE OR REPLACE TRIGGER T_Ż�������
   AFTER DELETE
   ON ��
   FOR EACH ROW
DECLARE
    -- ���� �����
BEGIN
   -- :OLD ? �������� ���̺�
    INSERT INTO Ż��� VALUES( :OLD.�����̵�, :OLD.���̸�, :OLD.����, 
        :OLD.���, :OLD.����, :OLD.������, SYSDATE(), USER( ) );
END T_Ż�������;

DELETE FROM �� WHERE �����̵� = 'peach'; -- Ʈ���� ����. Ż��� ���̺� ����
DELETE FROM �� WHERE �����̵� = 'apple'; -- ���� : �������Ἲ ���� ( on delete no action )

DROP TRIGGER T_Ż�������;


----//  PK-FK On Update CASCADE ����
create trigger T_OnUpdateCascade
  AFTER UPDATE OF �����̵� ON ��
  FOR EACH ROW
BEGIN
  UPDATE �ֹ� SET �ֹ��� = :NEW.�����̵� WHERE �ֹ��� = :OLD.�����̵�;
END;
  -- ����... ���濬���� �ش� Ʈ���ű��� ����� �� FK ���� Constraint ���� ���� Check��

UPDATE �� SET �����̵� = 'samsung' WHERE �����̵� = 'apple';
DROP Trigger T_OnUpdateCascade;

------------ </ �ǽ� 1 > ====================



----------------------------------------------------------------
------------ < �ǽ� 2 > Ʈ���� Instead Of  ------------ 
----------------------------------------------------------------

--########## ���� ID : UNIV

-- ���� �� ����
CREATE or REPLACE VIEW �л��а����� 
AS
	SELECT �й�, �̸�, �л�.��ȭ��ȣ, �ּ�, �а�.�а���ȣ, �а���, �繫�� 
	FROM �л�, �а�
    	WHERE �л�.�а���ȣ = �а�.�а���ȣ;
    
SELECT * FROM �л��а�����;

-- ���� �信 ���� ���� ���� : ���� �߻�
INSERT INTO �л��а����� VALUES ('20301-006', '�ڹ���', '200-2000', '�λ�', 303, '�İ�', '917ȣ');

-- �̿� ���� �ذ�å : Ʈ���� �̿� Instead Of
CREATE OR REPLACE TRIGGER �����
   INSTEAD OF INSERT  -- �����۾� ��ſ� �۵� �۵��ϵ��� ����
   ON �л��а�����  -- �信 ����
   FOR EACH ROW 
BEGIN
   INSERT INTO �а�(�а���ȣ, �а���, �繫��)
     VALUES (:NEW.�а���ȣ, :NEW.�а���, :NEW.�繫��);
   INSERT INTO �л�(�й�, �̸�, �а���ȣ, �ּ�, ��ȭ��ȣ)
     VALUES (:NEW.�й�, :NEW.�̸�, :NEW.�а���ȣ, :NEW.�ּ�, :NEW.��ȭ��ȣ);
END;

-- �Ʒ� ���� ��� ��� Ʈ���Ű� �����
INSERT INTO �л��а����� VALUES ('20301-006', '�ڹ���', '200-2000', '�λ�', 303, '�İ�', '917ȣ');
-- ��� Ȯ��
SELECT * FROM �л�;
SELECT * FROM �а�;

-- Ʈ���� ���� ���1
CREATE OR REPLACE TRIGGER �����
   INSTEAD OF INSERT  -- �����۾� ��ſ� �۵� �۵��ϵ��� ����
   ON �л��а�����  -- �信 ����
   FOR EACH ROW 
BEGIN
   INSERT INTO �л�(�й�, �̸�, �а���ȣ, �ּ�, ��ȭ��ȣ)
     VALUES (:NEW.�й�, :NEW.�̸�, :NEW.�а���ȣ, :NEW.�ּ�, :NEW.��ȭ��ȣ);
   INSERT INTO �а�(�а���ȣ, �а���, �繫��)
     VALUES (:NEW.�а���ȣ, :NEW.�а���, :NEW.�繫��);
END;

INSERT INTO �л��а����� VALUES ('20301-006', '�ڹ���', '200-2000', '�λ�', 303, '�İ�', '917ȣ');
  -- ���� �߻� : �������Ἲ ����. Parent�� ���� �����ؾ� ��.


-- Ʈ���� ���� ���2
  -- �並 ���Ӱ� ����. ��, �а��� PK�� �а���ȣ�� �������� ����
CREATE or REPLACE VIEW �л��а����� 
AS
	SELECT �й�, �̸�, �л�.��ȭ��ȣ, �ּ�, �а���, �繫�� 
	FROM �л�, �а�
    	WHERE �л�.�а���ȣ = �а�.�а���ȣ;
    
SELECT * FROM �л��а�����;

-- ���� �信 ���� ���� ���� : ���� �߻�
INSERT INTO �л��а����� VALUES ('20301-006', '�ڹ���', '200-2000', '�λ�', '�İ�', '917ȣ');

-- �̿� ���� �ذ�å���� Ʈ���� �̿�������
CREATE OR REPLACE TRIGGER �����
   INSTEAD OF INSERT  
   ON �л��а�����  
   FOR EACH ROW 
BEGIN
   INSERT INTO �а�(�а���, �繫��)
     VALUES (:NEW.�а���, :NEW.�繫��);
   INSERT INTO �л�(�й�, �̸�, �ּ�, ��ȭ��ȣ)
     VALUES (:NEW.�й�, :NEW.�̸�, :NEW.�ּ�, :NEW.��ȭ��ȣ);
END;

-- �Ʒ� ���� ��� ��� Ʈ���Ű� �����
INSERT INTO �л��а����� VALUES ('20301-006', '�ڹ���', '200-2000', '�λ�', '�İ�', '917ȣ');
  -- Ʈ���� ���� ����. �а����̺� PK���� �Է��� �õ���. ��ü ���Ἲ ����

DROP TRIGGER �����;
DROP VIEW �л��а�����;

------------ </ �ǽ� 2 > ====================




----------------------------------------------------------------
------------ < �ǽ� 3 > ���� Ʈ����  ------------ 
----------------------------------------------------------------

--########## ���� ID : HMART

SET SERVEROUTPUT ON;
CREATE SEQUENCE �԰�SEQ;
CREATE TABLE �԰��û 
   ("�԰��û��ȣ" NUMBER, 
	"��ǰ��ȣ" CHAR(3 BYTE), 
	"������ü" VARCHAR2(20 BYTE), 
	"��û��" DATE, 
	"��û��" NCHAR(15), 
	 PRIMARY KEY ("�԰��û��ȣ")
    );
create or replace TRIGGER T_�ֹ�ó��
  AFTER INSERT ON �ֹ�
  FOR EACH ROW
BEGIN
  UPDATE ��ǰ SET ��� = ��� - :NEW.���� WHERE ��ǰ��ȣ = :NEW.�ֹ���ǰ;
END;

create or replace TRIGGER T_�԰��û
  AFTER UPDATE ON ��ǰ
  FOR EACH ROW
DECLARE
   V_�ֹ��� NUMBER;
   V_��� NUMBER;
BEGIN
  SELECT :OLD.��� - :NEW.���, :NEW.���
         INTO V_�ֹ���, V_��� FROM DUAL;
   DBMS_OUTPUT.PUT_LINE('�ֹ��� : ' || V_�ֹ��� || ', ��� : ' || V_��� );
   IF V_��� < 1000 THEN
    INSERT INTO �԰��û VALUES(�԰�SEQ.NEXTVAL, :NEW.��ǰ��ȣ, :NEW.������ü, SYSDATE, USER() );
   END IF;
END;

INSERT INTO �ֹ� VALUES ('o11', 'apple', 'p01', 50, '���Ǵ�', SYSDATE);
INSERT INTO �ֹ� VALUES ('o12', 'banana', 'p06', 90, '�λ�� ����', SYSDATE);


DROP TRIGGER T_�ֹ�ó��;
DROP TRIGGER T_�԰��û;


------------ </ �ǽ� 3 > ====================

