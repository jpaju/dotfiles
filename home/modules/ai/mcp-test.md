# MCP configuration check

Verify that MCP servers are configured in this harness and that authentication works. Do not change any configuration.

Expected servers: context7, javadoc, atlassian-doordash, atlassian-wolt, datadog, linear, observability, rootly, slack.

## Steps

1. List the MCP servers available to you in this session, with their state (connected, disabled, needs authentication, failed).
2. For each connected server, call one read-only tool with a minimal input, e.g. a search, list, or "who am I" style call.
3. Do not call tools that create, modify, or delete anything. Do not start OAuth flows yourself.

## Report

A table with one row per expected server:

| Server | Visible | State | Test call | Result |
| ------ | ------- | ----- | --------- | ------ |

- Result: works, auth error (quote the error), other error (quote it), or not tested (why).
- List any servers you see that are not in the expected list.
