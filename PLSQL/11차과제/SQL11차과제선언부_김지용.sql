create or replace package restore_package
IS 

    procedure tab_procedure
    (
        f_user varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_tabname varchar2 -- user �� ���� �Է¹��� ���̺��̸�
    );
    
    PROCEDURE source_procedure
    (
        f_user varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_objname varchar2 -- user �� ���� �Է¹��� ������Ʈ�̸�    
    );
    
    procedure ind_procedure
    (
        f_user varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_tabname varchar2 -- user �� ���� �Է¹��� �ε����̸�
    );
END restore_package;