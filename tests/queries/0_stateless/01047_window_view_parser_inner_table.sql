-- Tags: no-parallel

SET allow_experimental_window_view = 1;
DROP DATABASE IF EXISTS test_01047;
CREATE DATABASE test_01047 ENGINE=Ordinary;

DROP TABLE IF EXISTS test_01047.mt;

CREATE TABLE test_01047.mt(a Int32, b Int32, timestamp DateTime) ENGINE=MergeTree ORDER BY tuple();

SELECT '---TUMBLE---';
SELECT '||---WINDOW COLUMN NAME---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY tumble(timestamp, INTERVAL '1' SECOND) AS SELECT count(a), tumbleEnd(wid) AS count FROM test_01047.mt GROUP BY tumble(timestamp, INTERVAL '1' SECOND) as wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---WINDOW COLUMN ALIAS---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY wid AS SELECT count(a) AS count, tumble(timestamp, INTERVAL '1' SECOND) AS wid FROM test_01047.mt GROUP BY wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---IDENTIFIER---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY (tumble(timestamp, INTERVAL '1' SECOND), b) PRIMARY KEY tumble(timestamp, INTERVAL '1' SECOND) AS SELECT count(a) AS count FROM test_01047.mt GROUP BY b, tumble(timestamp, INTERVAL '1' SECOND) AS wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---FUNCTION---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY (tumble(timestamp, INTERVAL '1' SECOND), plus(a, b)) PRIMARY KEY tumble(timestamp, INTERVAL '1' SECOND) AS SELECT count(a) AS count FROM test_01047.mt GROUP BY plus(a, b) as _type, tumble(timestamp, INTERVAL '1' SECOND) AS wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---PARTITION---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY wid PARTITION BY wid AS SELECT count(a) AS count, tumble(now(), INTERVAL '1' SECOND) AS wid FROM test_01047.mt GROUP BY wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;


SELECT '---HOP---';
SELECT '||---WINDOW COLUMN NAME---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY hop(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) AS SELECT count(a) AS count, hopEnd(wid) FROM test_01047.mt GROUP BY hop(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) as wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---WINDOW COLUMN ALIAS---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY wid AS SELECT count(a) AS count, hop(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) AS wid FROM test_01047.mt GROUP BY wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---IDENTIFIER---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY (hop(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND), b) PRIMARY KEY hop(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) AS SELECT count(a) AS count FROM test_01047.mt GROUP BY b, hop(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) AS wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---FUNCTION---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY (hop(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND), plus(a, b)) PRIMARY KEY hop(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) AS SELECT count(a) AS count FROM test_01047.mt GROUP BY plus(a, b) as _type, hop(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) AS wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---PARTITION---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY wid PARTITION BY wid AS SELECT count(a) AS count, hopEnd(wid) FROM test_01047.mt GROUP BY hop(now(), INTERVAL '1' SECOND, INTERVAL '3' SECOND) as wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

DROP TABLE test_01047.wv;
DROP TABLE test_01047.mt;
