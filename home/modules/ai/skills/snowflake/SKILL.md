---
name: snowflake
description: How to run queries against Snowflake. Load this skill whenever you need to query/interact with Snowflake.
---

# Snowflake

The `snow` binary is available. Use the default connection: do not pass `--connection` unless there is a real, specific reason to target a non-default connection.

Run queries with:

```
snow sql --query "<query>"
```

## Output formats

`snow sql` supports four output formats via `--format`: `table` (default), `csv`, `json`, and `json_ext`.

Prefer `--format csv`: it is the most compact and readable. The default `table` format wraps columns to terminal width and becomes unreadable, so avoid it.

Use `--format json` only when results contain nested or multiline values (e.g. `VARIANT` columns) where csv is ambiguous.

## Check schema before querying

If a table's columns/types aren't already known, check the schema before writing a query against it rather than guessing:

```
snow sql --query "DESCRIBE TABLE <db.schema.table>"
```

## READ-ONLY ONLY

Only run read-only queries: `SELECT`, `SHOW`, `DESCRIBE`, `EXPLAIN`.

Never run any query that mutates state or objects, including but not limited to: `INSERT`, `UPDATE`, `DELETE`, `MERGE`, `CREATE`, `DROP`, `ALTER`, `TRUNCATE`, `COPY INTO`, `GRANT`, `REVOKE`, `CALL`, or any DDL/DCL statement.

If a task appears to require a write, stop and ask the user instead of running it.
