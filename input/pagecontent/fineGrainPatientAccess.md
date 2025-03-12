### Use-Case

REST API scopes allow us to give CRUD rights to resource consumers.
However, we cannot give detailed access to a specific pool of Patients or to only certain elements inside of the allowed resource.

This use-case aims to enable fine-grained filtering using the Permission resource to express which pool of resources are accessible to a specific data collector and which data is allowed whithin these resources.
For now this use-cases only applies to request on Patient resources, but aims to apply to any kind of resource in the futur.

### Security Layers
Our security design consists of five layers, each providing additional depth to data protection:

1. **Network Authorization:** IP filtering and firewall protection.
2. **Application Authorization:** OAuth2 token-based authentication.
3. **Resource-Type Access Authorization:** SMART on FHIR scopes (e.g., `Patient.read`).
4. **Specific Resource Access Authorization:** Filters access to defined pools of resources.
5. **Data Access Authorization:** Applies fine-grained filtering on resource elements before sending the response.

***Layers 4 and 5 leverage the Permission resource for advanced filtering and are the focus of this document.***

---

### Platform Architecture
Our platform's architecture integrates a FHIR server and a middleware that acts as both an Enterprise Application Integration (EAI) layer and an proxy for Patient identity consumers.

This architecture, ensures that data collectors never directly interact with the FHIR server, adding a layer of protection and allowing us to apply changes between the request and the response.  
This EAI will interact with the FHIR server when it receives the request and apply Permission-based filters to the request before sending the response to the initial request sender.

#### Workflow:
1. The data collector sends a REST API request (e.g., `GET /Patient?family=Baker`) with its scope and Permission ID within the Oauth2token.
2. The middleware retrieves the relevant Permission resource from the FHIR server.
3. The middleware applies the 4th security layer by modifying the request to target only allowed resources (e.g., patients tagged with `TAG_1` and not patients tagged with `VIP`).
4. The FHIR server responds with raw resource data.
5. The middleware applies the 5th security layer, filtering out restricted elements (e.g., address, birth date...).
6. The secured response is sent back to the data collector.

---

### Tagging Resources
Before applying Permissions, we must identify and tag resource pools. 
For example, if we want to restrict access to patients from a specific department or age group, we use security labels within the `meta` element of resources.

#### Example:
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

### Building the Permission Resource
The Permission resource defines the rules for granting or denying access to specific data pools or elements. It consists of general information and two primary rule types:

1. **Permit Rules:** Specify the data allowed for access (e.g., resources tagged with `EXAMPLE`).
2. **Deny Rules:** Restrict access to specific data (e.g., resources tagged with `VIP` or sensitive elements like addresses).

#### Example Permission Resource:

In this example, the Permission resource allow consumer `EXAMPLE` to see exclusively Patient resources with the security label `TAG_1` but cannot see Patients with the security label `VIP`. They also cannot see the Patient's given name, address and metadata.

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


### Example of Applying Permissions in Request Handling

#### Initial Request:
```rest
GET /Patient?family=Baker
Scope: Patient.read EXAMPLE
```
#### Permission Applied:
- **id:** `EXAMPLE`
- **Permit:** `TAG_1`
- **Deny:** `VIP`
- **Filtered Elements:** `Address`, `BirthDate`, `Metadata`

#### Final Response:
```json
{
  "resourceType": "Patient",
  "name": "Baker Joséphine",
  "gender": "female"
}
```

---
### Work in progress
<div markdown="1" class="dragon">

1. Current usage is limited to the `Patient` resource since it is the only resource we actually have.
2. Tagging relies on custom scripts, which may need adaptation for more complex criteria.
    - We are thinking about using List/Group resources to create specific groups of patients instead of using security tags, allowing more flexibility and negating the impact of our own managment inside of the Patient's resource.
    - Using expressions to specify criterias using resources elements is very interesting but we lack resource diversity for now and retrieve these informations from outside of the FHIR platform.
3. Using custom `Identifier` element to retrieve Permissions is not ideal, but for now search parameters are restricted to identifier and status element. 
  - Should we create a custom Search parmater to search depending on the actor ?

---
</div>



## Fine Grained patient access - Version 2

In this new version, we've adressed a few points mentioned previously :

1. Using a List resource to reference which Patients are allowed for a specific data collector.
  - We added FHIRPath expressions to express that we need Patients in said List.
2. Use a Device resource to represent the data collector (in our first use-case, an App).
3. Stop using specific ids for the Permission resource but instead use the actor.reference element.
  - This change requires the addition of a new SearchParameter on Actor.reference to the Permission resource.
4. Specify which Search Parameters we would like to be added to the resource.

### Using a Device to represent our data collector

In our first use-case using Permissions, the data collector is an app that wants to retrieve certain Patient informations.

We used a Device resource to represent it.

This device resource has an `id`, which we will use to refer to this Device later on.

### Using a List resource instead of using meta.security tags

The List resource seems to suit our needs well as it can store references to other resources such as Patients.
We created a List resource with it's `subject` element referencing to the Device resource representing our data collector App and each `entry.item` representing a Patient.

Here's an example of a short List :

```json
{
    "resourceType": "List",
    "status": "current",
    "mode": "working",
    "subject": [
        {
            "reference": "Device/1",
        }
    ],
    "entry": [
        {
            "item": {
                "reference": "Patient/1",
            }
        },
        {
            "item": {
                "reference": "Patient/2",
            }
        }
    ]
}
```

The goal here is to create an empty list and then use a script to add patients to the List using PATCH requests when they match specific criterias or triggers.


### Changes to the Permission resource

With these changes, the Permission resource needs some adjustments
  - Stop using specific ids and instad use the actor element to refer to the Device resource
  - Adding a FHIRPath expression to express that the Permission resource applies to the consumption of Patient resources in said List.

Here is a new example of a Permission resource with these changes applied :

```json
{
"resourceType": "Permission",
    "status": "active",
    "asserter": {
        "reference": "Organization/1",
        "display": "Hospital of Toulouse"
    },
    "combining": "permit-overrides",
    "rule": [
        {
            "activity": [
                {
                    "actor": [
                        {
                            "reference": "Device/1"
                        }
                    ],
                    "action": [
                        {
                            "coding": [
                                {
                                    "system": "http://hl7.org/fhir/ValueSet/consent-action",
                                    "code": "collect",
                                    "display": "Collect"
                                }
                            ]
                        }
                    ]
                }
            ],
            "type": "permit",
            "data": [
                {
                    "resource": [
                        {
                            "meaning": "related",
                            "reference": {
                                "reference": "List/1",
                                "display": "Patient List managed by xxxxx"
                            }
                        }
                    ],
                    "expression": {
                        "description": "Access only patients from the xxxxx-managed list",
                        "language": "text/fhirpath",
                        "expression": "entry.item.reference.where(resolve() is Patient)"
                    }
                }
            ]
        },
        {
            "type": "deny",
            "data": [
                {
                    "expression": {
                        "language": "text/jsonpath",
                        "expression": "$.id"
                    }
                },
                {
                    "expression": {
                        "language": "text/jsonpath",
                        "expression": "$.active"
                    }
                },
                {
                    "expression": {
                        "language": "text/jsonpath",
                        "expression": "$.name"
                    }
                }
            ]
        }
    ],
}
```

### Changes needed on the Permission resource 

#### Changes to the Limit element

As discussed previously, for now we use `data.expression` to refer to jsonpath elements that we want to remove from the Patient resource.
This `data.expression` is meant to be used as a data selector, like we use it in our example to use a fhirpath expression selecting Patients inside of our List.

The `limit` element is meant for this use, but is a `CodeableConcept` which cannot refer to specific elements inside of a FHIR resource.

Solution n°1 :

The Jira ticket n°49031 refers a similar issues, it's solution being a change in the `limit` element :
  " change the limit element to a backbone element
    move the CodeableConcept from limit to `control` - 0..* - http://terminology.hl7.org/ValueSet/v3-SecurityControlObservationValue (preferred)
    add `.tag` - 0..* - Coding – http://terminology.hl7.org/ValueSet/v3-InformationSensitivityPolicy (preferred)
    add `.element` - 0..* - string - "path of the element in the hierarchy of elements"
  "
  
#### Changes to Permission's search parameters

For now, it is only possible to search Permission resources based on two parameters :
  - `Permission.identifier` : The unique id for a particular Permission
  - `Permission.status` : active | entered-in-error | draft | rejected

In order to stop using custom ids for our Permissions and use `actor.reference` to refer to a device, we need to be able to search a Permission resource based on this element.

In addition to this mandatory change, we've thought of a few search parameters that will be useful when we will have several Permissions in use.

1. `Validity`
  Allowing the search of expressions based on they `Validity.start` element or `Validity.end` element could allow us to quickly check on Permissions that will close/open on a specific date which will be useful.
2. `Data.resource.reference`
  This element is used to refer to the List containing each allowed Patient.  
  Researching a Permission based on its reference to a specific List could help us when we encounter issues with a List and don't know which Permission this List is used for.
3. `Limit.element`
  If we are able to change the Limit element to use element, we will need to be able to call for all permissions that disable Patient's name or Patient's address for example, allowing this search parameter will prevent going through every permission or use solutions such as FHIR SQL Builders to find these permissions.
4. `Data.expression.expression`
  The data.expression.expression element is a fhirpath expression used to specify which element we aim to use inside of the List, for now we only use Patient, but once we use several resources we might need to search for Permissions using a specific fhirpath expression.

### Pending questions

1. Can we make all of these changes ? If so, what is the procedure ?
2. Should the Data.expressions.expression element be used this way ?
3. Adding patients to a List using a PATCH request is easy, but removing it is hard since we can't remove a item based on its reference but only using its index (e.g : entry/2), I developped a script that can parse through the List and create the according PATCH request but is there an easier way ?
4. Sould we use fhirpath expressions instead of jsonpath to refer to elements that we want to remove ?

