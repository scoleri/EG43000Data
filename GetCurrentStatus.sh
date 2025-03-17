#!/bin/bash
#
if [ $# -eq 0 ]
  then
    DATE=`date +%Y-%m-%d`
    LOGDATE=`date +%Y%m%d`
    echo "Getting Today's Reports"
  else
    DATE=`date +%Y-%m-%d -d $1`
    LOGDATE=`date +%Y%m%d -d $1`
    echo "Getting $DATE Reports"
fi

echo $DATE
DESS_ACTION="authSource"
DESS_SALT=`date +%s%3N`
DESS_USER="fakeuser@example.com"
DESS_PASS="FakePassword123"
DESS_COMPANY_KEY="fakeCompanyKey"
#
SHA1_PASS=$(echo -n "$DESS_PASS" | openssl sha1 | awk '{print $2}')
SIGNATURE_STRING="${DESS_SALT}${SHA1_PASS}&action=${DESS_ACTION}&usr=${DESS_USER}&source=1&company-key=${DESS_COMPANY_KEY}"
SIGNATURE=$(echo -n "$SIGNATURE_STRING" | openssl sha1 | awk '{print $2}')
#
BASE_URL="https://api.dessmonitor.com/public/?sign=${SIGNATURE}&salt=${DESS_SALT}&action=${DESS_ACTION}&usr=${DESS_USER}&source=1&company-key=${DESS_COMPANY_KEY}"
#
#
echo $BASE_URL
curl -X GET "$BASE_URL" -H "Accept: application/json" |jq > /tmp/auth.json

for i in `seq 0 2`; do
ACTION="&action=queryDeviceDataOneDayPaging&source=1&page=$i&pagesize=100&i18n=en_US&pn=FAKE_PN&devcode=1234&devaddr=1&sn=FAKE_SN&date=$DATE"
TOKEN=$(cat /tmp/auth.json | jq -r '.dat.token')
SECRET=$(cat /tmp/auth.json | jq -r '.dat.secret')
echo TOKEN: $TOKEN
echo SECRET: $SECRET

SIGNATURE_STRING="${DESS_SALT}${SECRET}${TOKEN}${ACTION}"
SIGNATURE_SHA=$(echo -n "$SIGNATURE_STRING" | openssl sha1 | awk '{print $2}')

QUERY="http://api.dessmonitor.com/public/?sign=${SIGNATURE_SHA}&salt=${DESS_SALT}&token=${TOKEN}&action=queryDeviceDataOneDayPaging&source=1&page=$i&pagesize=100&i18n=en_US&pn=FAKE_PN&devcode=1234&devaddr=1&sn=FAKE_SN&date=$DATE"
curl -X GET "$QUERY" -H "Accept: application/json" |jq >> $LOGDATE-logs.json
done

cat header.csv > $LOGDATE-logs.csv
cat $LOGDATE-logs.json | jq -r '.dat.row[]?.field?|@csv' >> $LOGDATE-logs.csv
