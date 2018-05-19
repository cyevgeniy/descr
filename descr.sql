set feedback off
column comments format a56
column data_default format a12
column data_type format a20
column column_name format a20
column nullable format a8
var tt varchar2(30);

exec :tt := '&1';

select a.column_name, decode(a.nullable, 'Y', '', 'N', 'NOT NULL') NULLABLE,
a.data_type || case
when a.data_precision is not null and nvl(a.data_scale,0)>0 then '('||a.data_precision||','||a.data_scale||')'
when a.data_precision is not null and nvl(a.data_scale,0)=0 then '('||a.data_precision||')'
when a.data_precision is null and a.data_scale is not null then '(*,'||a.data_scale||')'
when a.char_length>0 then '('||a.char_length|| case a.char_used
when 'B' then ' Byte'
when 'C' then ' Char'
else null
end ||')' end data_type,
       a.data_default,
       b.comments
from all_tab_cols a,
all_col_comments b
where a.column_name = b.column_name
and a.table_name = b.table_name
and a.owner = nvl((SELECT upper(substr(:tt, 1, INSTR(:tt, '.') - 1)) FROM dual), a.owner)
AND a.TABLE_NAME = (SELECT upper(substr(:tt, instr(:tt, '.') + 1)) FROM dual)
AND b.OWNER = a.OWNER
order by a.internal_column_id ASC;
set feedback on
