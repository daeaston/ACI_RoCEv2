#!/bin/bash
set -e

APIC_URL="$1"
USERNAME="admin"
PASSWORD="C1sco12345"
COOKIE_FILE="/tmp/apic-cookie-$$.txt"

echo "Resetting QoS configuration on $APIC_URL..."

# Logging In to APIC: The script authenticates to the APIC using the AAA login API and stores the session token in the unique cookie file:

curl -sk -X POST "$APIC_URL/api/aaaLogin.json" \
  -H "Content-Type: application/json" \
  -d "{\"aaaUser\":{\"attributes\":{\"name\":\"$USERNAME\",\"pwd\":\"$PASSWORD\"}}}" \
  -c "$COOKIE_FILE"

# Reset QoS Class Level2 config (Tail-drop + PFC disabled)

curl -sk -X POST "$APIC_URL/api/node/mo/uni.xml" \
  -H "Content-Type: application/xml" \
  -d '<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
         <qosCong algo="tail-drop" ecn="disabled"/>
         <qosPfcPol name="default" adminSt="no" noDropCos=""/>
       </qosClass>' \
  -b "$COOKIE_FILE"


# Reset QoS Class Level2 Bandwidth allocated to 20%

curl -sk -X POST "$APIC_URL/api/node/mo/uni/infra/qosinst-default/class-level2/sched.json" \
  -H "Content-Type: application/json" \
  -d '{"qosSched":{"attributes":{"dn":"uni/infra/qosinst-default/class-level2/sched","bw":"20"},"children":[]}}' \
  -b "$COOKIE_FILE"

rm -f "$COOKIE_FILE"

echo "Reset complete."

