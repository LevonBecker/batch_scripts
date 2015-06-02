# Reset Windows Update Agent Batch Script

## Tasks Summary

1. Stops Windows Update, BITS, Application Identity, Cryptographic Services and SMS Host Agent (SCCM client) services
2. Cleans up AU cache folder and log file
3. Re-registers *.dll files
4. Removes WSUS Client registration Id
5. Reset Winsock and WinHTTP Proxy
6. Deletes all BITS jobs
7. Restart services
8. Forces AU discovery

## Usage

http://www.bonusbits.com/wiki/HowTo:Use_Batch_Script_to_Kickstart_WSUS_Client

## Disclaimer

Use at your own risk.