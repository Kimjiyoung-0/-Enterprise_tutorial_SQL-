create or replace package restore_package
IS 

    procedure tab_procedure
    (
        f_user varchar2,  -- user 로 부터 입력받을 유저이름
        f_tabname varchar2 -- user 로 부터 입력받을 테이블이름
    );
    
    PROCEDURE source_procedure
    (
        f_user varchar2,  -- user 로 부터 입력받을 유저이름
        f_objname varchar2 -- user 로 부터 입력받을 오브젝트이름    
    );
    
    procedure ind_procedure
    (
        f_user varchar2,  -- user 로 부터 입력받을 유저이름
        f_tabname varchar2 -- user 로 부터 입력받을 인덱스이름
    );
END restore_package;