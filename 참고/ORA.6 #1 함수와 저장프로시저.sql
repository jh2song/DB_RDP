/* [ �� 6 �� ] # 1  - �Լ��� �������ν���
<�ǽ�1> ����� ���� �Լ�
<�ǽ�2> ���� ���ν���, ��Ű��
<�ǽ�3> Ŀ��

... by JDK 
*/
----------------------------------------------------------------
------------ < �ǽ� 1 > ����� ���� �Լ� ------------ 
----------------------------------------------------------------
---- ���� �۾� : HMart ��Ű�� Reset (by SYSTEM & HMART)

/* ########  ID : HMART ######## */

-- Simple Function ����
CREATE OR REPLACE FUNCTION F_Add(a number, b number)
    RETURN NUMBER
AS 
    Total NUMBER;
BEGIN
    Total := a + b;
    RETURN Total;
END;  -- sum, add���� ������ �Լ�, ���� �̸����� ����ϸ� �� ��

-- �Լ� ȣ�� 1 : Prompt���� ȣ��
VAR result NUMBER;
EXECUTE :result := F_Add(2020,35);
  -- EXECUTE ���� ������ �������ν����� ���� ��.
  -- �ܺ� ������ ����Ϸ��� ':�����̸�'������ ����ؾ� ��
PRINT result;
-- �Լ� ȣ�� 2 : SQL ������ ȣ��
SELECT F_Add(2020, 35) FROM DUAL;

-- �Լ� ȣ�� 3 : ���ν��� ������ ȣ��
DECLARE
    result1 NUMBER;
BEGIN
    result1 := F_Add(2020,50);
    DBMS_OUTPUT.PUT_LINE(result1);
END;
PRINT result;
PRINT result1;  -- ����. result1�� PL/SQL ���ν��� �������� ��밡��

-- IF, CASE�� �̿��ϴ� �ٿ뵵 �Լ�
CREATE OR REPLACE FUNCTION F_Multi(inValue NCHAR) -- �Ķ���Ͷ� NCHAR�� ũ�� ����
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

SELECT * from UNIV.�л�;
SELECT F_Multi(�й�) AS "�й�", F_Multi(�ֹε�Ϲ�ȣ) AS "�ֹι�ȣ",
       F_Multi(�̸�) AS "����", F_Multi(��ȭ��ȣ) AS "����ó" FROM UNIV.�л�;



----//  Pipelined Table Function
-- Ʃ��Ÿ������
CREATE OR REPLACE TYPE EventType AS OBJECT
( V_Year NUMBER(10), V_Event NCHAR(10) );
-- ���̺�Ÿ�� ����
CREATE OR REPLACE TYPE TableType AS TABLE OF EventType;

-- ���̺��� ��ȯ�ϴ� �Լ� ����
CREATE OR REPLACE FUNCTION ������̺����(�߻��⵵�� NCHAR, ��ǵ� NCHAR)
    RETURN TableType PIPELINED
AS    
    V_Years NVARCHAR2(100) := �߻��⵵��;  -- �Լ��� �Ķ���ʹ� In��. �� ���� �Ұ�
    V_Events NVARCHAR2(100) := ��ǵ�; -- �Լ��� �Ķ���ʹ� In��. �� ���� �Ұ�
    V_EventTuple EventType; -- Ʃ���Ѱ�
    V_YearsPos NUMBER;  -- �⵵ ���ڿ����� ������ ��ġ
    V_EventsPos NUMBER; -- ��� ���ڿ����� ������ ��ġ
    V_Year NUMBER(10); -- ������ 1���� �⵵
    V_Event NCHAR(10);  -- ������ 1���� ���
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
END ������̺����;

-- Pipelined Table Function ȣ��
SELECT * 
FROM TABLE(������̺����('1392,1492,1592,1692,1792',
                       '�����Ǳ�,�ݷҺν�,�����ֶ�,ȣ������,���ƾ'));

------------ </ �ǽ� 1 > ====================


----------------------------------------------------------------
------------ < �ǽ� 2 > ���� ���ν���, ��Ű��  ------------ 
----------------------------------------------------------------

----//  Simple ���� ���ν���
-- ���� ���ν��� ����
CREATE OR REPLACE PROCEDURE SP_Simple   -- �Ķ���� ���� 
AS
    Age NUMBER; -- ���� ����
BEGIN
    -- ����ȭ�� ���̸� ���ν��� ���� 'Age'�� �Ҵ�
    SELECT ���� INTO Age  FROM ��
         WHERE ���̸� = '����ȭ';  
    DBMS_OUTPUT.PUT_LINE ('����ȭ�� ���̴� ' || Age); -- ���� �� ���
END SP_Simple ;


-- ���� ���ν��� ����
SET SERVEROUTPUT ON; 
EXECUTE SP_Simple( );
EXECUTE SP_Simple( );
EXECUTE SP_Simple( );  -- ������ ���� ����

-- ���� ���� 1 : ������ ���Ѵٸ� Create or Replace Procedure
CREATE PROCEDURE SP_Simple    -- �̹� SP_Simple�� �����ϴ� ��� ����
AS
    Age NUMBER; -- ���� ����
BEGIN
    -- ����ȭ�� ���̸� ���ν��� ���� 'Age'�� �Ҵ�
    SELECT ���� INTO Age  FROM ��
         WHERE ���̸� = '����ȭ';  
    DBMS_OUTPUT.PUT_LINE ('����ȭ�� ���̴� ' || Age); -- ���� �� ���
END SP_Simple ;

-- ���� ���� 2 : SQL������� ������. Ŀ���� �ʿ��� ���
CREATE OR REPLACE PROCEDURE SP_Simple   -- �Ķ���� ���� 
AS
    Age NUMBER; -- ���� ����
BEGIN
    -- ����ȭ�� ���̸� ���ν��� ���� 'Age'�� �Ҵ�
    SELECT ���� INTO Age  FROM ��;
    DBMS_OUTPUT.PUT_LINE ('����ȭ�� ���̴� ' || Age); -- ���� �� ���
END SP_Simple ;   -- ������ ������ ����

-- ���� �߻�. RunTime����
EXECUTE SP_Simple( );  

-- ���� ���ν��� ����
DROP PROCEDURE SP_Simple;



----//  �Ķ���Ͱ� �ִ� ���� ���ν���
-- �Է� �Ķ���� �̿�
CREATE OR REPLACE PROCEDURE SP_In (
  U_ID IN ��.�����̵�%TYPE
  -- �Ʒ� ���嵵 ��ȿ
  -- U_ID IN CHAR  -->  ';' & ũ�� �Է� �Ұ�
) 
AS
    U_Name VARCHAR(18);  --  ';' & ũ�� �Է��ؾ� ��
BEGIN
    SELECT ���̸� INTO U_Name FROM �� 
         WHERE �����̵� = U_ID;
    DBMS_OUTPUT.PUT_LINE (U_Name);
END ;

SET SERVEROUTPUT ON; 
EXECUTE userProc1('apple');

-- �Է�, ��� �Ķ����
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

SET SERVEROUTPUT ON; 

-- ���� ���ν����� ����. 
  -- ���ο��� ���� ���ν��� ȣ��( EXECUTE  ���ʿ�)
DECLARE
    Out���� NUMBER;
BEGIN
    SP_InOut1('fruits', 'ȫ�浿', Out����);
    DBMS_OUTPUT.PUT_LINE (Out����);
END;


-- PL/SQL ������ ������ ���� ���ν���
CREATE OR REPLACE PROCEDURE SP_IF (
  Pi_���̸� ��.���̸�%type
) AS
    V_������ NUMBER; -- ����⵵�� ������ ����
BEGIN
    SELECT ������ INTO V_������ FROM ��
        WHERE ���̸� = Pi_���̸�;
    IF V_������ >= 4000 THEN
        DBMS_OUTPUT.PUT_LINE ('�ܰ� ���̳׿�');
    ELSE
        DBMS_OUTPUT.PUT_LINE ('���� �̿��ϸ� �� ���� ������ �־��');
    END IF;
END ;    

SET SERVEROUTPUT ON; 
EXECUTE SP_IF ('����ȭ');

-- ������ �����ϰ� �ִ�  ���� ���ν���

CREATE OR REPLACE PROCEDURE SP_Error (
  Pi_���̸� IN ��.���̸�%TYPE,
  Po_�����̵� OUT ��.�����̵�%TYPE
) 
AS

BEGIN
   SELECT �����̵� INTO Po_�����̵� FROM �� 
          WHERE ���̸� = Pi_���̸�;
   IF Po_�����̵� = NULL THEN
      Po_�����̵� := 'Anonymous';  
   END IF;
END ;

DECLARE
    ��ȸ������ NCHAR(10);
BEGIN
    SP_Error('����ȭ', ��ȸ������);
    DBMS_OUTPUT.PUT_LINE (��ȸ������);
END;

DECLARE
    ��ȸ������ NCHAR(10);
BEGIN
    SP_Error('Ʈ����', ��ȸ������);
    DBMS_OUTPUT.PUT_LINE (��ȸ������);  -- ���� �߻� No Data Found
END;


-- ���� ó���� �� ���� ���ν���

CREATE OR REPLACE PROCEDURE SP_Error (
  Pi_���̸� IN ��.���̸�%TYPE,
  Po_�����̵� OUT ��.�����̵�%TYPE
) 
AS
BEGIN
   SELECT �����̵� INTO Po_�����̵� FROM �� 
          WHERE ���̸� = Pi_���̸�;
     EXCEPTION  WHEN NO_DATA_FOUND THEN
        Po_�����̵� := 'Anonymous';  
END ;

DECLARE
    ��ȸ������ NCHAR(10);
BEGIN
    SP_Error('����ȭ', ��ȸ������);
    DBMS_OUTPUT.PUT_LINE (��ȸ������);
END;

DECLARE
    ��ȸ������ NCHAR(10);
BEGIN
    SP_Error('Ʈ����', ��ȸ������);    
    DBMS_OUTPUT.PUT_LINE (��ȸ������);
END;



-- �Ķ���� IN OUT : ����� ��� �Ķ����
CREATE OR REPLACE PROCEDURE SP_InOut (
  Pio_���̸� IN OUT ��.���̸�%TYPE
) 
AS
  V_��� ��.���%TYPE;
BEGIN
   SELECT ��� into V_��� FROM �� 
          WHERE ���̸� = Pio_���̸�;
     EXCEPTION  WHEN NO_DATA_FOUND THEN
        Pio_���̸� := (Pio_���̸�||'-');  
        
END ;

DECLARE
    ���ΰ��̸� ��.���̸�%TYPE := '����ȭ';
BEGIN
    SP_INOUT(���ΰ��̸�);
    DBMS_OUTPUT.PUT_LINE (���ΰ��̸�);
END;

DECLARE
    ���ΰ��̸� ��.���̸�%TYPE := '������';
BEGIN
    SP_INOUT(���ΰ��̸�);
    DBMS_OUTPUT.PUT_LINE (���ΰ��̸�);
END;  -- ���� ó�� ��. ��ȸ���̶� �̸� ���� '-' �߰�



-- ���̸����� �� ���̵� �Ϻκи� �˻�
CREATE OR REPLACE PROCEDURE SP_PartialID (
    Pi_���̸� IN ��.���̸�%TYPE,
    Po_�κо��̵� OUT CHAR
) 
AS
BEGIN  
    SELECT RPAD( SUBSTR(�����̵�,1,3), LENGTH(�����̵�), '*') INTO Po_�κо��̵�
       FROM  �� WHERE ���̸� = Pi_���̸�;
    EXCEPTION  WHEN NO_DATA_FOUND THEN
        Po_�κо��̵� := '��ȸ��';  
END;

DECLARE
    V_�����̵� CHAR(15);
BEGIN
    SP_PartialID('����ȭ', V_�����̵�);
    DBMS_OUTPUT.PUT_LINE (V_�����̵�);
END;

DECLARE
    V_�����̵� CHAR(15);
BEGIN
    SP_PartialID('Ʈ����', V_�����̵�);
    DBMS_OUTPUT.PUT_LINE (V_�����̵�);
END;


----//  ���� ���ν��� ���� ��ȣȭ
-- ������ ����
DECLARE
  Hidden_Source  VARCHAR2(32767);
BEGIN
  Hidden_Source := 'create or replace PROCEDURE a as begin null; end;';
EXECUTE IMMEDIATE DBMS_DDL.WRAP(Hidden_Source);
END;  -- GUI�� ���� Ȯ���ϸ� ��ȣȭ �Ǿ� ����
  
-- ��ȣȭ ���� ����.
  -- VARCHAR2�� ���� ���ν����� �����ϴ� DDL���� ���
    -- ������ : ���ڿ��� ǥ���� ���� ���� ����ǥ �ΰ�(' ')�� ���ξ� ��
    -- ���տ���(||) �̹Ƿ� �� ���� ��ĥ ���� ������ ��ĭ�� �� �� 
  -- �� �� DBMS_DDL.WRAP ���Ȱ��


DROP PROCEDURE SP_ENCR;

DECLARE
  Hidden_Source  VARCHAR2(32767);
BEGIN
  Hidden_Source := 
   'CREATE OR REPLACE PROCEDURE SP_ENCR  ( ' ||
   'Pi_���̸� IN ��.���̸�%TYPE, ' ||
   'Po_�κо��̵� OUT CHAR ) ' ||
   'AS ' ||
   'BEGIN   ' ||
      'SELECT RPAD( SUBSTR(�����̵�,1,3), LENGTH(�����̵�), ''*'') INTO Po_�κо��̵� ' ||
      'FROM  �� WHERE ���̸� = Pi_���̸�; '||
      'EXCEPTION  WHEN NO_DATA_FOUND THEN  Po_�κо��̵� := ''��ȸ��''; ' ||
      'END;'     ;
EXECUTE IMMEDIATE DBMS_DDL.WRAP(DDL => Hidden_Source);
END;

DECLARE
    V_�����̵� CHAR(15);
BEGIN
    SP_ENCR('����ȭ', V_�����̵�);
    DBMS_OUTPUT.PUT_LINE (V_�����̵�);
END;

DECLARE
    V_�����̵� CHAR(15);
BEGIN
    SP_ENCR('Ʈ����', V_�����̵�);
    DBMS_OUTPUT.PUT_LINE (V_�����̵�);
END;


-- ���̺� �̸��� In �Ķ���ͷ� ����
CREATE OR REPLACE PROCEDURE SP_TableName (
  Pi_TableName IN CHAR 
)
AS
  V_���� NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_���� FROM Pi_TableName;
    DBMS_OUTPUT.PUT_LINE (v_����);
END ;   -- ������ �߻���

-- ���̺� �̸��� In �Ķ���ͷ� ����. ���� ���Ƿ� ����
CREATE OR REPLACE PROCEDURE SP_TableName_Dynamic (
  Pi_ǥ�̸� IN CHAR )
AS
  V_�� NUMBER;
  �������� VARCHAR2(300);
BEGIN
    �������� := 'SELECT COUNT(*) FROM ' || Pi_ǥ�̸�;
    EXECUTE IMMEDIATE �������� INTO V_��;
    DBMS_OUTPUT.PUT_LINE (Pi_ǥ�̸� || '���� ' || V_�� || '�Դϴ�');
END ;

EXEC SP_TableName_Dynamic('��');
EXEC SP_TableName_Dynamic('��ǰ');
EXEC SP_TableName_Dynamic('�ֹ�');


----//  �Լ�, �������ν����� ��Ű�� ����
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
        SELECT ���� INTO Age  FROM �� WHERE ���̸� = '����ȭ';  
        DBMS_OUTPUT.PUT_LINE ('����ȭ�� ���̴� ' || Age); -- ���� �� ���
    END SP_Simple;    
END Pack1;    

SET SERVEROUTPUT ON; 
SELECT Pack1.F_Add(10,20) from dual;
EXECUTE Pack1.SP_Simple;


------------ </ �ǽ� 2 > ====================



----------------------------------------------------------------
------------ < �ǽ� 3 > Ŀ��  ------------ 
----------------------------------------------------------------


-- '���� ������ �� 2000�̻� ������ ��հ��� 2000�̸� ������ ��հ��� ���̸� ���϶�.
   �׸��� 2000�̸� ���� ����� BASIC���� �ٲ��'
CREATE OR REPLACE PROCEDURE SP_Cursor AS
  V_High NUMBER := 0;  -- 2000�̻� ������ �հ�
  V_Low NUMBER := 0;  -- 2000�̸� ������ �հ�
  V_H_Num NUMBER := 0 ; -- 2000�̻� ���� ��
  V_L_Num NUMBER := 0 ; -- 2000�̸� ���� ��
  V_ID VARCHAR2(20); -- �� �����̵�
  V_������ NUMBER; -- �� ������
  CURSOR C IS  
        SELECT �����̵�, ������ FROM ��; -- Ŀ�� ����
BEGIN
  OPEN C;  -- Ŀ�� ����
  -- ������ ���� �� ó��
    LOOP 
        FETCH  C INTO V_ID, V_������;
        EXIT WHEN C%NOTFOUND; -- �����Ͱ� ������ LOOP ����
        IF V_������ >= 2000 THEN
          BEGIN V_High := V_High + V_������; V_H_Num := V_H_Num + 1; END;
        ELSE
          BEGIN 
                V_Low := V_Low + V_������; 
                V_L_Num := V_L_Num + 1; 
                UPDATE �� SET ��� = 'BASIC' WHERE �����̵� = V_ID; 
                -- �����̵�� VID�� ������Ÿ���� ���� ��ġ�ؾ� ��
                DBMS_OUTPUT.PUT_LINE(V_ID);
          END;
        END IF;
    END LOOP;
    CLOSE C;  -- Ŀ�� �ݱ�
    DBMS_OUTPUT.PUT_LINE('��� : ' || TO_CHAR((V_High/V_H_Num)-(V_Low/V_L_Num)) );
END ;

SET SERVEROUTPUT ON;
EXECUTE SP_Cursor();

--------------- </ �ǽ� 3> ---------------------

