# DESS Monitor Data Export Script

This script interacts with the [DESS Monitor API](https://api.dessmonitor.com/chapter5/queryDeviceLastData.html) to authenticate and fetch the latest device data, exporting the results as JSON.

## Features

- Securely loads authentication credentials from a separate configuration file.
- Fetches the latest data for a specified device.
- Supports command-line arguments for querying past data.
- Outputs results in JSON format for further processing.
- Implements SHA-1-based authentication as required by the API.

## Installation

### Prerequisites

Ensure you have the following installed:

- `` (default on Linux/macOS)
- `` (for making API requests)
- `` (for processing JSON data)
- `` (for hashing operations)

To install missing dependencies:

```sh
# Debian/Ubuntu
sudo apt install jq openssl

# macOS (via Homebrew)
brew install jq openssl
```

### Clone the Repository

```sh
git clone https://github.com/yourusername/dessmonitor-export.git
cd dessmonitor-export
```

### Configure Authentication

1. Copy the example config file and edit it:

   ```sh
   cp config.env.example config.env
   nano config.env
   ```

2. Update the following fields in `config.env`:

   ```ini
   # User credentials
   DESS_USER="your_email@example.com"
   DESS_PASS="YourSecurePassword"
   DESS_COMPANY_KEY="YourCompanyKey"

   # Device-specific details
   DEVICE_PN="YourDevicePN"
   DEVICE_CODE="YourDeviceCode"
   DEVICE_ADDR="YourDeviceAddress"
   DEVICE_SN="YourDeviceSerialNumber"
   ```

3. **Important:** Prevent accidental leaks by adding `config.env` to `.gitignore`:

   ```sh
   echo "config.env" >> .gitignore
   ```

4. **Ensure secure file permissions** to prevent unauthorized access:

   ```sh
   chmod 600 config.env
   ```

## Usage

### Fetch today's data:

```sh
./dessmonitor.sh
```

### Fetch data for a specific date:

```sh
./dessmonitor.sh YYYY-MM-DD
```

Example:

```sh
./dessmonitor.sh 2024-03-10
```

### Expected Output

- **Authentication token is retrieved and stored in **``
- **Device data is fetched and saved to **``
- **The script logs the results, which can be processed further**

## API References

This script relies on endpoints from **DESS Monitor API**, documented at:

- [**Query Device Last Data**](https://api.dessmonitor.com/chapter5/queryDeviceLastData.html)\
  Fetches the latest available data for a specific device.

## Related Projects

For **Home Assistant** integration, check out:\
[SilverFire/dessmonitor-homeassistant](https://github.com/SilverFire/dessmonitor-homeassistant)

## Security Considerations

### 🔒 **Storing Credentials Securely**

- **DO NOT** hardcode secrets in the script. Instead, use `config.env` as demonstrated.
- Use **environment variables** instead of storing credentials in a file if deploying on a server.

### 🚫 **Preventing Accidental Leaks**

- **Ensure **``** is added to **`` so it is not accidentally committed.
- If working on a shared system, **restrict file access** using:
  ```sh
  chmod 600 config.env
  ```

### ✅ **Encryption & Secure API Calls**

- The script **hashes passwords** using SHA-1 before transmission.
- Communication with the API uses `HTTPS` for encryption.

## License

This script is provided as-is. Feel free to modify and improve it.

## Acknowledgments

- **DESS Monitor API Documentation** ([https://api.dessmonitor.com/chapter5/queryDeviceLastData.html](https://api.dessmonitor.com/chapter5/queryDeviceLastData.html)) for detailed API specifications.
- [**SilverFire/dessmonitor-homeassistant**](https://github.com/SilverFire/dessmonitor-homeassistant) for inspiration on integrating DESS Monitor with Home Assistant.


