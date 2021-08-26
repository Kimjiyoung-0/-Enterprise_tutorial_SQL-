create or replace package ddl_get_pkg
IS 
    procedure tab_proc
    (
        f_user      varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_tabname   varchar2 -- user �� ���� �Է¹��� ���̺��̸�
    );
    
    PROCEDURE source_proc
    (
        f_user      varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_objname   varchar2 -- user �� ���� �Է¹��� ������Ʈ�̸�    
    );
    
    procedure ind_proc
    (
        f_user      varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_tabname   varchar2 -- user �� ���� �Է¹��� �ε����̸�
    );
    
    procedure view_proc
    (
        f_user      varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_viewname  varchar2 -- user �� ���� �Է¹��� ���̸�
    );
    
    procedure seq_proc
    (
        f_user      varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_seqname   varchar2 -- user �� ���� �Է¹��� �������̸�
    );
    
    procedure syn_proc
    (
        f_user      varchar2,  -- user �� ���� �Է¹��� �����̸�
        f_synname   varchar2 -- user �� ���� �Է¹��� �ó���̸�
    ); 
    
END ddl_get_pkg;