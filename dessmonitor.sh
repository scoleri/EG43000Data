#!/bin/bash

# Load configuration
source config.env

if [ $# -eq 0 ]; then
    DATE=$(date +%Y-%m-%d)
    LOGDATE=$(date +%Y%m%d)
    echo "Getting Today's Reports"
else
    DATE=$(date +%Y-%m-%d -d "$1")
    LOGDATE=$(date +%Y%m%d -d "$1")
    echo "Getting $DATE Reports"
fi

echo $DATE

DESS_ACTION="authSource"
DESS_SALT=$(date +%s%3N)

# Generate authentication signature
SHA1_PASS=$(echo -n "$DESS_PASS" | openssl sha1 | awk '{print $2}')
SIGNATURE_STRING="${DESS_SALT}${SHA1_PASS}&action=${DESS_ACTION}&usr=${DESS_USER}&source=1&company-key=${DESS_COMPANY_KEY}"
SIGNATURE=$(echo -n "$SIGNATURE_STRING" | openssl sha1 | awk '{print $2}')

# Construct base URL
BASE_URL="https://api.dessmonitor.com/public/?sign=${SIGNATURE}&salt=${DESS_SALT}&action=${DESS_ACTION}&usr=${DESS_USER}&source=1&company-key=${DESS_COMPANY_KEY}"

echo $BASE_URL
curl -X GET "$BASE_URL" -H "Accept: application/json" | jq > auth.json

# Query latest device data
i=0
ACTION="&action=queryDeviceLastData&source=1&page=$i&pagesize=100&i18n=en_US&pn=${DEVICE_PN}&devcode=${DEVICE_CODE}&devaddr=${DEVICE_ADDR}&sn=${DEVICE_SN}"
TOKEN=$(cat auth.json | jq -r '.dat.token')
SECRET=$(cat auth.json | jq -r '.dat.secret')

echo "TOKEN: $TOKEN"
echo "SECRET: $SECRET"

SIGNATURE_STRING="${DESS_SALT}${SECRET}${TOKEN}${ACTION}"
SIGNATURE_SHA=$(echo -n "$SIGNATURE_STRING" | openssl sha1 | awk '{print $2}')

QUERY="http://api.dessmonitor.com/public/?sign=${SIGNATURE_SHA}&salt=${DESS_SALT}&token=${TOKEN}&action=queryDeviceLastData&source=1&page=$i&pagesize=100&i18n=en_US&pn=${DEVICE_PN}&devcode=${DEVICE_CODE}&devaddr=${DEVICE_ADDR}&sn=${DEVICE_SN}"

curl -X GET "$QUERY" -H "Accept: application/json" | jq >> "$LOGDATE-now.json"
