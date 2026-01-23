#!/bin/bash

APIC_URL="$1"
USERNAME="admin"
PASSWORD="C1sco12345"

echo "Resetting QoS configuration on $APIC_URL..."

# Sends a login request to the APIC and saves the authentication cookie to apic-cookie.txt for later API calls.

curl -sk -X POST "$APIC_URL/api/aaaLogin.json" \
  -H "Content-Type: application/json" \
  -d "{\"aaaUser\":{\"attributes\":{\"name\":\"$USERNAME\",\"pwd\":\"$PASSWORD\"}}}" \
  -c apic-cookie.txt

# Sends an XML payload to the APIC to reset the QoS class configuration back to its default settings

curl -sk -X POST "$APIC_URL/api/node/mo/uni.xml" \
  -H "Content-Type: application/xml" \
  -d '<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
         <qosCong algo="tail-drop" ecn="disabled"/>
         <qosPfcPol name="default" adminSt="no" noDropCos="" enableScope="fabric"/>
         <qosSched bw="20"/>
       </qosClass>' \
  -b apic-cookie.txt

echo "Reset complete."

