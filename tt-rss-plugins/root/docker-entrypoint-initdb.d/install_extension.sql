-- Install zhparser

CREATE EXTENSION zhparser;
CREATE TEXT SEARCH CONFIGURATION chinese_simplified (PARSER = zhparser);
ALTER TEXT SEARCH CONFIGURATION chinese_simplified ADD MAPPING FOR n,v,a,i,e,l WITH simple;
ALTER ROLE ALL SET zhparser.multi_short=on;
