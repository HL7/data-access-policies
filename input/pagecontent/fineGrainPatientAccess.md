# Fine Grained patient access


<div markdown="1" class="dragon">

REST API scopes allow us to give CRUDS rights to resource consumers.
However, we cannot give detailed access to a specific pool of Patients or to only certain data inside of the allowed resource.

This use-case aims to enable fine-grained filtering using the permission resource to express which pool of resources are accessible to a specific data consumer and which data in allowed whithin these resources.
For now this use-cases only applies to request on Patient resources, but aims to apply to any kind of resource in the futur.
---
</div>

## Security Layers
Our security design consists of five layers, each providing additional depth to data protection:

1. **Network Authorization:** IP filtering and firewall protection.
2. **Application Authorization:** OAuth2 token-based authentication.
3. **Resource-Type Access Authorization:** SMART on FHIR scopes (e.g., `Patient.read`).
4. **Specific Resource Access Authorization:** Filters access to defined pools of resources.
5. **Data Access Authorization:** Applies fine-grained filtering on resource elements before sending the response.

**Layers 4 and 5 leverage the Permission resource for advanced filtering and are the focus of this document.**

---

## Platform Architecture
Our platform's architecture integrates a FHIR server and a middleware that acts as both an Enterprise Application Integration (EAI) layer and an interface for Patient identity consumers.

This architecture, ensures that data consumers never directly interact with the FHIR server, adding a layer of protection and allowing us to apply changes between the request and the response.  
This EAI will interact with the FHIR server when it receives the request and apply permission-based filters to the request before sending the response to the initial request sender.

### Workflow:
1. The data consumer sends a REST API request (e.g., `GET /Patient?family=Baker`) with its scope and Permission ID.
2. The middleware retrieves the relevant Permission resource from the FHIR server.
3. The middleware applies the 4th security layer by modifying the request to target only allowed resources (e.g., patients tagged with `TAG_1` and not patients tagged with `VIP`).
4. The FHIR server responds with raw resource data.
5. The middleware applies the 5th security layer, filtering out restricted elements (e.g., address, birth date...).
6. The secured response is sent back to the data consumer.

---

## Tagging Resources
Before applying permissions, we must identify and tag resource pools. 
For example, if we want to restrict access to patients from a specific department or age group, we use security labels within the `meta` element of resources.

### Example:
```json
{
  "resourceType": "Patient",
  "id": "EXAMPLE",
  "meta": {
    "security": [
      {
        "system": "http://your-fhir-server.com/fhir/ValueSet/local-tags",
        "code": "TAG_1"
      }
    ]
  }
}
```

We utilize custom scripts within the middleware to automate the tagging process, based on events triggering PATCH requests, adding or removing security labels on specific patients using their national identifier, ensuring consistency and efficiency.

---

## Building the Permission Resource
The Permission resource defines the rules for granting or denying access to specific data pools or elements. It consists of general information and two primary rule types:

1. **Permit Rules:** Specify the data allowed for access (e.g., resources tagged with `EXAMPLE`).
2. **Deny Rules:** Restrict access to specific data (e.g., resources tagged with `VIP` or sensitive elements like addresses).

### Example Permission Resource:

In this example, the permission resource allow consumer `EXAMPLE` to see exclusively Patient resources with the security label `TAG_1` but cannot see Patients with the security label `VIP`. They also cannot see the Patient's given name, address and metadata.

```json
{
  "resourceType": "Permission",
  "id": "EXAMPLE"
  "status": "active",
  "combining": "permit-unless-deny",
  "rule": [
    {
      "type": "permit",
      "data": [
        {
          "resource": {
            "type": "Patient",
          },
          "security": [
            {
              "system": "http://your-fhir-server.com/fhir/ValueSet/local-tags", 
              "code": "TAG_1"
            }
          ]
        }
      ]
    },
    {
      "type": "deny",
      "data": [
        {
          "resource": {
            "type": "Patient",
          },
          "security": [
            {
              "system": "http://your-fhir-server.com/fhir/ValueSet/local-tags", 
              "code": "VIP"
            }
          ],
          "expression": [
            {"language": "text/jsonpath", "expression": "$.address"}
          ],
          "expression": [
            {"language": "text/jsonpath", "expression": "$.birthdate"}
          ],
          "expression": [
            {"language": "text/jsonpath", "expression": "$.name.given"}
          ]
        }
      ]
    }
  ]
}
```

---


## Example of Applying Permissions in Request Handling

### Initial Request:
```rest
GET /Patient?family=Baker
Scope: Patient.read EXAMPLE
```
### Permission Applied:
- **id:** `EXAMPLE`
- **Permit:** `TAG_1`
- **Deny:** `VIP`
- **Filtered Elements:** `Address`, `BirthDate`, `Metadata`

### Final Response:
```json
{
  "resourceType": "Patient",
  "name": "Baker Joséphine",
  "gender": "female"
}
```

---

## Limitations and Future Work
1. Current usage is limited to the `Patient` resource since it is the only resource we actually have.
2. Tagging relies on custom scripts, which may need adaptation for more complex criteria.
    - We are thinking about using Group resources to create specific groups of patients instead of using security tags, allowing more flexibility and negating the impact of our own managment inside of the Patient's resource.
    - Using expressions to specify criterias using resources elements is very interesting but we lack resource diversity for now and retrieve these informations from outside of the FHIR platform.
3. Using custom `Identifier` element to retrieve permissions is not ideal, but fow now search parameters are restricted to identifier and status element, should we create a custom Search parmater to search depending on the actor ?

