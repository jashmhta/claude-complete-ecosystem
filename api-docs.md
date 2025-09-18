# BFGminer API Documentation

## Overview
BFGminer’s API allows remote monitoring and control via JSON-RPC over HTTP.

## Enabling API
Start with `--api-listen` and optionally `--api-port 4028`.

## Authentication
Use `--api-allow W:127.0.0.1` for privileged access.

## Commands
- `summary`: Returns mining summary.
- `devs`: Device details.
- `pools`: Pool status.
- `switchpool|N`: Switch to pool N.
- `gpu|N`: GPU info.

## Request Format
POST with JSON: `{"command": "summary"}`

## Response
`{"STATUS": [{"STATUS": "S", "Msg": "Summary"}], "SUMMARY": {...}}`

## Examples
- Get summary: `curl -d '{"command":"summary"}' http://localhost:4028`
- List devices: `{"command":"devs"}`

## Error Handling
Check STATUS for errors.

Full API in README.RPC.