# BFGminer Documentation

## Overview
BFGminer is a multi-threaded, multi-pool ASIC, FPGA, GPU, and CPU miner written in C. It features dynamic clocking, monitoring, fan speed control, and remote interface capabilities.

## Installation

### Dependencies
- autoconf, automake, libtool, pkg-config
- libcurl4-gnutls-dev, libjansson-dev, uthash-dev
- libncursesw5-dev, libudev-dev, libusb-1.0-0-dev
- libevent-dev, libmicrohttpd-dev, libhidapi-dev

### Build Instructions
1. Clone the repository: `git clone https://github.com/luke-jr/bfgminer.git`
2. Navigate to the directory: `cd bfgminer`
3. Run: `./autogen.sh`
4. Configure: `./configure`
5. Build: `make`
6. Install: `sudo make install`

For detailed build options, see the README.

## Configuration

### Command Line Options
- `-o <url>`: Pool URL
- `-u <user>`: Username
- `-p <pass>`: Password
- `--api-listen`: Enable API
- `--device|-d <pattern>`: Select devices

### Configuration File
Create a JSON config file (e.g., `bfgminer.conf`):

```json
{
  "pools": [
    {
      "url": "stratum+tcp://pool.example.com:3333",
      "user": "username",
      "pass": "password"
    }
  ],
  "api-listen": true,
  "api-port": "4028"
}
```

Load with: `bfgminer -c bfgminer.conf`

## Usage

### Basic Mining
`bfgminer -o http://pool:port -u username -p password`

### Multi-Pool
`bfgminer -o pool1 -u user1 -p pass1 -o pool2 -u user2 -p pass2`

### Device Selection
`bfgminer -S opencl:auto -o pool -u user -p pass`

## API Reference
BFGminer provides a JSON-RPC API for remote control.

### Endpoints
- `summary`: Get mining summary
- `pools`: List pools
- `devs`: List devices

Example request:
```json
{"command": "summary"}
```

## Troubleshooting
- **Device not detected**: Check permissions and drivers.
- **Low hash rate**: Adjust overclocking and ensure proper cooling.
- **Connection issues**: Verify pool URLs and network settings.

## Advanced Features
- **Overclocking**: Use `--set-device` to adjust frequencies.
- **Monitoring**: Enable API for real-time stats.
- **Failover**: Configure backup pools for reliability.

For more, visit our [GitHub repository](https://github.com/luke-jr/bfgminer).