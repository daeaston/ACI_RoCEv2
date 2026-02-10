import requests

# ---------------------------------------------------------------------------
# Basic configuration
# ---------------------------------------------------------------------------

# Credentials used to authenticate to each Cisco ACI APIC.
# In production, avoid hard-coding these and consider using environment
# variables, a secrets manager, or a config file instead.
USERNAME = "admin"
PASSWORD = "C1sco12345"

# List of APIC URLs that this script will operate on.
# The script will log in and apply/destroy QoS config on *each* APIC in turn.
APIC_URLS = [
    "https://apic1-a.corp.pseudoco.com",
    "https://apic1-b.corp.pseudoco.com"
]

# ---------------------------------------------------------------------------
# APIC login helper
# ---------------------------------------------------------------------------

def login(apic_url):
    """
    Log into the APIC and return the APIC session cookie.

    The APIC uses a token-based session cookie (\"APIC-cookie\") that must be
    sent with subsequent API calls in order to authenticate those requests.
    """
    print(f"Logging in to {apic_url}...")

    url = f"{apic_url}/api/aaaLogin.json"

    payload = {
        "aaaUser": {
            "attributes": {
                "name": USERNAME,
                "pwd": PASSWORD
            }
        }
    }

    response = requests.post(url, json=payload, verify=False)
    response.raise_for_status()

    cookie = response.cookies.get("APIC-cookie")
    print("Login successful.")
    return cookie

# ---------------------------------------------------------------------------
# Apply RoCEv2 QoS policy
# ---------------------------------------------------------------------------

def apply_rocev2_qos(apic_url, cookie):
    """
    Apply a RoCEv2-oriented QoS configuration on the APIC.
    """
    print(f"Applying RoCEv2 QoS configuration on {apic_url}...")

    url = f"{apic_url}/api/node/mo/uni.xml"
    headers = {"Content-Type": "application/xml"}

    data = """<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
  <qosCong algo="wred" wredMaxThreshold="60" wredMinThreshold="40" wredProbability="10" ecn="enabled" forwardNonEcn="enabled"/>
  <qosPfcPol name="default" noDropCos="cos3" adminSt="yes" enableScope="fabric"/>
  <qosSched bw="60"/>
</qosClass>"""

    response = requests.post(
        url,
        headers=headers,
        data=data,
        cookies={"APIC-cookie": cookie},
        verify=False
    )

    print("Response:", response.text)
    response.raise_for_status()

    print("QoS configuration applied successfully.")

# ---------------------------------------------------------------------------
# Destroy / reset RoCEv2 QoS policy
# ---------------------------------------------------------------------------

def destroy_rocev2_qos(apic_url, cookie):
    """
    Reset the QoS configuration for the RoCEv2 class.
    """
    print(f"Tearing down RoCEv2 QoS configuration on {apic_url}...")

    url = f"{apic_url}/api/node/mo/uni.xml"
    headers = {"Content-Type": "application/xml"}

    data = """<qosClass admin="enabled" dn="uni/infra/qosinst-default/class-level2" prio="level2">
  <qosCong algo="tail-drop" ecn="disabled" forwardNonEcn="disabled"/>
  <qosPfcPol name="default" adminSt="no" noDropCos="" enableScope="fabric"/>
  <qosSched bw="20"/>
</qosClass>"""

    response = requests.post(
        url,
        headers=headers,
        data=data,
        cookies={"APIC-cookie": cookie},
        verify=False
    )

    print("Response:", response.text)
    response.raise_for_status()

    print("QoS configuration removed successfully.")

# ---------------------------------------------------------------------------
# Script entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    import sys

    if len(sys.argv) != 2 or sys.argv[1] not in {"apply", "destroy"}:
        print("Usage: python rocev2_qos.py apply|destroy")
        exit(1)

    action = sys.argv[1]

    for apic_url in APIC_URLS:
        try:
            session_cookie = login(apic_url)

            if action == "apply":
                apply_rocev2_qos(apic_url, session_cookie)
            else:
                destroy_rocev2_qos(apic_url, session_cookie)
        except Exception as e:
            print(f"Error on {apic_url}: {e}")
