select 
    tablespace_name,
    maxsize as "allocatable_file_maxsize(M)",
    file_size as "real_allocated_file_size(M)",
    seg_size as "real_allocated_seg_size(M)",
    round((maxsize - seg_size)/maxsize*100) as"free_percent(%)"
from ( 
    select 
        a.tablespace_name, 
        round(sum(decode(a.maxbytes,0,a.bytes,a.maxbytes))/1024/1024) as maxsize,
        round(sum(a.bytes)/1024/1024) as file_size,
        round((sum(a.bytes) - sum(b.bytes))/1024/1024) as seg_size
    from dba_data_files a ,dba_free_space b
    where a.TABLESPACE_NAME =b.TABLESPACE_NAME 
    group by a.tablespace_name --���̺� �����̽����� ����
) 
order by "free_percent(%)"
;

/* 
tablespace_name, 
-- table space �� name

allocatable_file_maxsize(M), 
-- dba_data_files ���� ������ ���ϵ��� ���� �� 
��� ������ ������ ���̺����̽��� �Ҵ�Ǿ��ִ���(�������� �پ������� ������)
MAXBYTES�� ���ϵ�, �̹� �������� ������ ������ üũ�Ұ�
(MAXBYTES �� 0 �̸� ������� �� BYTES�� �����´�.)

real_allocated_file_size(M), 
-- dba_data_files ���� ��Ÿ���� �������� BYTES(������� �����ͷ�)�� ������ �� 

real_allocated_seg_size(M),  --
--dba_data_files ���� ��Ÿ�� ������ ���� ������ ���� �������� üũ�Ѵ�.
�׷��� ����ü�� ����ִ� ���� üũ�ؾ��ϴµ�, �ΰ��� ����� �ִ�. 
real_allocated_file_size(M)-(dba_free_space ���� BYTES�� ���� ���� ��)


free_percent(%) -- ������ ����ִ� ������ ���� %



*/

