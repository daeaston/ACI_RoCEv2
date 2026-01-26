# Apply QoS Policy

## Overview

In this final step of Lab 4, you'll use Bruno to create the complete RoCEv2 QoS configuration on both ACI fabrics through REST API calls.

## Steps

- Select the 1st POST Command
- Click on the Arrow on the right-hand side of the window to apply the POST Command. You should receive a 200 OK, indicating successful login:

![Bruno](../../assets/images/image033.png)

- Select the 2nd POST Command: Apply the QoS Config. Have the APIC GUI in the background to verify that QoS has been applied successfully.

- Select the 3rd POST Command: Reset the QoS Config back to its original Best Effort State.

- Optional: Modify the base_url environment to point to the second APIC (e.g., https://apic1-b.corp.pseudoco.com). Click Save then Activate.

![Bruno](../../assets/images/image034.png)

- Repeat the above steps with the POST Commands and verify successful application to the second APIC via the GUI.

- Optional: Open the RoCEv2 ACI - Full Postman Collection.postman_collection file in Visual Studio Code to view its structure:

![Bruno](../../assets/images/image035.png)

- Notice how the script separates sections for logging in, applying QoS, and removing QoS:

![Bruno](../../assets/images/image036.png)

You can also look at the .json file itself which consolidates all 3 POST commands:

```json
{
	"info": {
		"_postman_id": "f13634bb-f39c-4eda-b784-f6ad4b534e78",
		"name": "RoCEv2 ACI - Full Postman Collection",
		"schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
		"_exporter_id": "1098931"
	},
	"item": [
		{
			"name": "1) Login to APIC",
			"event": [
				{
					"listen": "test",
					"script": {
						"exec": [
							"var jsonData = pm.response.json();",
							"var token = jsonData.imdata[0].aaaLogin.attributes.token;",
							"pm.collectionVariables.set(\"APIC-cookie\", token);"
						],
						"type": "text/javascript",
						"packages": {}
					}
				}
			],
			"request": {
				"method": "POST",
				"header": [
					{
						"key": "Content-Type",
						"value": "application/json"
					}
				],
				"body": {
					"mode": "raw",
					"raw": "{\n  \"aaaUser\": {\n    \"attributes\": {\n      \"name\": \"admin\",\n      \"pwd\": \"C1sco12345\"\n    }\n  }\n}"
				},
				"url": {
					"raw": "{{base_url}}/api/aaaLogin.json",
					"host": [
						"{{base_url}}"
					],
					"path": [
						"api",
						"aaaLogin.json"
					]
				}
			},
			"response": []
		},
		{
			"name": "2) Apply RoCEv2 QoS Config",
			"request": {
				"method": "POST",
				"header": [
					{
						"key": "Content-Type",
						"value": "application/xml"
					},
					{
						"key": "Cookie",
						"value": "APIC-cookie={{APIC-cookie}}"
					}
				],
				"body": {
					"mode": "raw",
					"raw": "<qosClass admin=\"enabled\" dn=\"uni/infra/qosinst-default/class-level2\" prio=\"level2\">\n  <qosCong algo=\"wred\" wredMaxThreshold=\"60\" wredMinThreshold=\"40\" wredProbability=\"0\" ecn=\"enabled\" forwardNonEcn=\"enabled\"/>\n  <qosPfcPol name=\"default\" noDropCos=\"cos3\" adminSt=\"yes\" enableScope=\"fabric\"/>\n <qosSched bw=\"60\"/>\n</qosClass>"
				},
				"url": {
					"raw": "{{base_url}}/api/node/mo/uni/infra/qosinst-default/class-level2.xml",
					"host": [
						"{{base_url}}"
					],
					"path": [
						"api",
						"node",
						"mo",
						"uni",
						"infra",
						"qosinst-default",
						"class-level2.xml"
					]
				}
			},
			"response": []
		},
		{
			"name": "3) Reset RoCEv2 QoS Config",
			"request": {
				"method": "POST",
				"header": [
					{
						"key": "Content-Type",
						"value": "application/xml"
					},
					{
						"key": "Cookie",
						"value": "APIC-cookie={{APIC-cookie}}"
					}
				],
				"body": {
					"mode": "raw",
					"raw": "<qosClass admin=\"enabled\" dn=\"uni/infra/qosinst-default/class-level2\" prio=\"level2\">\r\n  <qosCong algo=\"tail-drop\" ecn=\"disabled\" forwardNonEcn=\"disabled\"/>\r\n  <qosPfcPol name=\"default\" noDropCos=\"\" adminSt=\"no\" enableScope=\"fabric\"/>\r\n  <qosSched bw=\"20\"/>\r\n</qosClass>",
					"options": {
						"raw": {
							"language": "json"
						}
					}
				},
				"url": {
					"raw": "{{base_url}}/api/node/mo/uni/infra/qosinst-default/class-level2.xml",
					"host": [
						"{{base_url}}"
					],
					"path": [
						"api",
						"node",
						"mo",
						"uni",
						"infra",
						"qosinst-default",
						"class-level2.xml"
					]
				}
			},
			"response": []
		}
	],
	"variable": [
		{
			"key": "APIC-cookie",
			"value": ""
		}
	]
}
```

## Lab 4 Complete!

Congratulations! You have successfully:

- ✅ Imported Bruno collection
- ✅ Configured environments
- ✅ Authenticated to both APICsS
- ✅ Created RoCEv2 QoS via REST API
- ✅ Verified in APIC GUI

### Key Takeaways

1. **Bruno provides visual API interaction** - Great for learning and testing
2. **REST API is the foundation** - All tools eventually use the REST API
3. **Collections are reusable** - Share with team, version control
4. **Environments enable flexibility** - Easy testing across multiple fabrics

## Next Steps

Proceed to [Lab 5: Ansible Playbooks](../lab5-ansible/ansible-overview.md) for the final lab!
