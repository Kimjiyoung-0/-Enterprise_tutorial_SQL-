create or replace package ddl_get_pkg
IS 
    procedure tab_proc
    (
        f_user      varchar2,  -- user 로 부터 입력받을 유저이름
        f_tabname   varchar2 -- user 로 부터 입력받을 테이블이름
    );
    
    PROCEDURE source_proc
    (
        f_user      varchar2,  -- user 로 부터 입력받을 유저이름
        f_objname   varchar2 -- user 로 부터 입력받을 오브젝트이름    
    );
    
    procedure ind_proc
    (
        f_user      varchar2,  -- user 로 부터 입력받을 유저이름
        f_tabname   varchar2 -- user 로 부터 입력받을 인덱스이름
    );
    
    procedure view_proc
    (
        f_user      varchar2,  -- user 로 부터 입력받을 유저이름
        f_viewname  varchar2 -- user 로 부터 입력받을 뷰이름
    );
    
    procedure seq_proc
    (
        f_user      varchar2,  -- user 로 부터 입력받을 유저이름
        f_seqname   varchar2 -- user 로 부터 입력받을 시퀸스이름
    );
    
    procedure syn_proc
    (
        f_user      varchar2,  -- user 로 부터 입력받을 유저이름
        f_synname   varchar2 -- user 로 부터 입력받을 시노님이름
    ); 
    
END ddl_get_pkg;