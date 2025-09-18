# BFGminer Technical Documentation

## Architecture
BFGminer is modular, with drivers for different devices (ASIC, FPGA, etc.). Core components: device detection, work management, API server.

## Device Drivers
- **ASIC**: Supports Antminer, Avalon, etc.
- **FPGA**: BitForce, Icarus, ZTEX.
- **GPU**: OpenCL-based.
- **CPU**: SHA256d and scrypt.

## Protocols
- **Stratum**: Efficient for pools.
- **GBT**: For solo mining.
- **Getwork**: Legacy support.

## API Details
JSON-RPC interface for control.

Commands:
- `summary`: Mining stats.
- `devs`: Device list.
- `pools`: Pool info.

Authentication: Use `--api-allow` for access control.

## Configuration Options
Full list in `bfgminer --help`.

Key: `--config file`, `--debug`, `--verbose`.

## Security
- No secrets in logs.
- API access restricted by default.
- Use HTTPS for remote access.

## Performance Tuning
- Adjust queue size with `-Q`.
- Use `--scan-time` for work scanning.
- Monitor with `--per-device-stats`.

## Code Structure
- `miner.c`: Main loop.
- `deviceapi.c`: Device abstraction.
- `api.c`: RPC server.

Contribute via GitHub.