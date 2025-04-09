This use-case analysis shows how a Permission can express an organization's overriding policy. 

An Overriding policy is an important part of an organization’s overall risk management strategy. They help to protect the organization from potential legal liability, as well as from reputational damage. Overriding policies should be aligned with other policies within the organization, such as data security policies, employee training policies, and incident response plans.  Overriding policies should be reviewed and updated regularly to ensure that they reflect the latest legal and regulatory requirements. They should also be communicated to employees and customers in a clear and concise way.

<div markdown="1" class="dragon">

The use-case analysis is still a work in progress. Only the very basis has been described here. Many open-issues need further development, including:

- Not obvious how to define a rule that is on a Resource type (note that Consent has documentType and resourceType) -- expression can do this --> Created [extension PermissionResourceType](StructureDefinition-dap.permissionResourceType.html)   an extension similar to Consent.rule.resourceType. Created [profile PermissionWithResourceType](StructureDefinition-dap.permissionWithResourceType.html). This might need to be added to Permission resource, unless the Expression method works just as well. -- **2024-03-24 - Decided that this is likely a good idea to add this to Permission. [Jira FHIR-45077](https://jira.hl7.org/browse/FHIR-45077)**
- Not obvious how to do security roles. Can use PractitionerRole if that applies, but that does not apply to Patients acting as a User. -- **2024-03-24 - Got close to agreeing to follow the pattern that Consent has.**
- should the action codes be more CRUD vs current privacy codes? or both? -- **2024-03-24 - Seems to be a better valueSet, but if we switch we should not use the same element name so as to avoid confusion. Given that we both have example binding, it is not clear that the element name needs to be different as example binding allows all codes to be used.**
  - http://hl7.org/fhir/restful-interaction 
- Not clear how to define permission enabled by relationship to the data. These are easy to express in ABAC as it is simply using the fact that ABAC can address any attribute in a rule. For example 
    - Doctors can Update Observations that they authored, but can't update the Observations created by someone else.
    - Patient can access THEIR data, but not all data
    - PurposeOfUse of the activity
    - Time-of-day restrictions. Some activities might be restricted to specific time of day, or day of the week. Such as registering new patients is only allowed during the day, except for emergency department. Should there be a .rule.activity.period to limit the time in which that activity is allowed? Or is this beyond 80% need and thus should be done with extensions.
- do we need a way to identify the overriding policy among all the Permission instances found in a FHIR server. Or is there some other mechanism that knows which Permission instance is the overriding policy? Certainly any Consent instances would point at the overriding policy, so it is findable that way.

The following is some other parts of an overriding policy that likely should be worked on here:

- How break-glass rules are expressed, and how break-glass is authorized, and how break-glass is declared. Note that with just FHIR resources, this would likely need to be TWO PractitionerRole resources. The first one indicates who has the authority to declare break-glass, all the doctors that are allowed would be part of this PractitionerRole. The second one would be those that are currently in a break-glass state, where normally no Practitioners would be assigned this role. This role gets assigned as part of a workflow that is authorized by the First PractitionerRole, includes a user interaction to confirm the safety concern. Either a workflow to un-declare and emergency, or a timeout, would remove the Practitioner from this second PractitionerRole.
- relationship to Consent / dissent -- default allow vs default deny -- Likely this could be expressed as two trees of rules, one tree when a consent is not found, one tree when the consent is found, and another when a dissent is found.
- a dietician might be allowed to create Observations of a given type. So although they can't see the majority of Observations, they can create dietary Observations.

</div>

An Overriding policy expresses the default rules at an organization. An overriding policy must include all the rules necessary for the organization to function. This includes clinical workflows but also non-clinical workflows. Workflows such as billing, public-health reporting, response to legal requests, etc. 

The Overriding policy fits within larger policies that cover operational aspects, such as how users are created, activated, and deactivated. How Patients are given access to their data as a User. 

The Overriding policy includes the rules around clinical accessibility to a Patient's data when that Patient has not expressed a Consent. Where the Consent restricts access, what kind of circumstances may a break-glass be used. 

An Overriding policy must express how it relates to the regulations that the organization must be conformant. This may include expressing the specific rules that are derived from a given regulation. Further background on the writing of Overriding (Privacy) policies can be found in [IHE Appendix P: Privacy Access Policies (Informative)](https://profiles.ihe.net/ITI/PCF/ch-P.html).

The following does not try to express a complete Overriding policy, but rather picks some parts of an Overriding policy that might be difficult.

The analysis here includes what is commonly called "Role Based Access Control" (RBAC) and "Attribute Based Access Control" (ABAC). Below are some various perspectives on how an Overriding policy might be structured around RBAC and ABAC. These are not recommendation, but are rather given so as to fully exercise the FHIR Permission structure.

1. Simple Role based Access Control given FHIR Resource types. 
2. Attribute Based Access Control given FHIR security tagging (i.e. .meta.security)
3. Contextual Access Control rules. Such as doctors being allowed to update artifacts that they have authored, but not other

### Simple RBAC

In Simple RBAC the access control rules are simply a given role authorizes some Create/Read/Update/Delete to a given FHIR Resource type. This is shown first as it is the most easy to write rule set. However this simple mapping is often problematic for a specific set of common usecases.

This is the kind of access control rule that [SMART-App-Launch](https://hl7.org/fhir/smart-app-launch/index.html) is founded up; although SMART-App-Launch allows the server to further refine the access control rules in undefined ways which is how Consents are managed and how Patient access is managed.

### Security Tag ABAC

In Security Tagged ABAC the rules are for a given role (clearance) authorizes some Create/Read/Update/Delete to data with a given security tag (compartment). This is shown second as it is easy to write the rule set, but relies on a security labeling service to tag all data. The Security labeling service tends to be where the complexity is. In this most simple form of ABAC there would still be some common usecases that are not addressed.

### Deep ABAC

The Deep ABAC use-case leverages Security Tag ABAC, and adds to this further refinements that use different data attributes, user attributes, and contextual details. Thus this set of use-cases can include Access Control rules such as:

- doctors can change data that they authored, but can not change data they did not author
- doctors can create data for a given patient if there is a legitimate relationship between doctor and patient
- doctors can declare break-glass to override a Privacy Consent restriction in cases where there is a medical safety concern
- patient can access their own data
- patient can authorize a related person to access that patient's data

### Analysis

#### Simple RBAC analysis

The following is for illustration purposes. It is neither complete, nor represents the real-world.

Note that the Patient is not included as Patient access to their own data requires deep ABAC support.

Note that role first and resource-type first can both be used, but the choice is important for traversing the Permission instance.

##### Role first

Role first sets down the rules starting from the roles, then expressing what they can do. 

| role      | access | resource type |
| --------- | ------ | ------------------- |
| doctor    | CRU    | Observation, AllergyIntolerance, Condition, ...
| doctor    | R      | Practitioner, PractionerRole, Person, RelatedPerson, Organization, Location, ...
| dietician | R      | AllergyIntolerance, Condition, ...
| registration | CRU | Patient, RelatedPerson, Person
| registration | R   | Organization, Location, Practitioner, PractitionerRole...
| janitor   |        |
| admin     | UD     | *
{:.grid}

Traversing [the Permission holding role first rules](Permission-ex-overriding-rbac-by-role.html) one simply looks for the rules that apply to the given role(s) that the user/actor has. Thus like the table above, see example below, one would find in the Permission the second and third rule entries apply to the doctor role, and thus they are the only rules needing to be looked at. The other rules do not apply.  Within these two rules, the combining element indicated permit-overrides and thus either of the two that allows the requested action would permit the action. The first rule in this Permission is a `deny` with a `permit-overrides` combining rule, thus if no `permit` is found then no access is granted. Note that the Access Control rules engine need only find a reason to permit.

Note that PurposeOfUse is also represented in this Permission instance as part of the activity. Thus one must, in addition to looking for role first, must look for role and purposeOfUse. Thus you can see that the Doctor is not authorized to request any data except under PurposeOfUse of treatment.

```fs
...
* combining = #permit-overrides
* rule[+].type = #deny // default is that NO ONE gets access

// Doctor CRU
* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Observation
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#AllergyIntolerance
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Condition
* rule[=].activity.actor.reference = Reference(DrRole)
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#C
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

// Doctor R
* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Practitioner
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#PractitionerRole
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Person
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Patient
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#RelatedPerson
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Organization
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Location
* rule[=].activity.actor.reference = Reference(DrRole)
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT
...
```

##### Resource-Type first

Resource-type first sets down the rules starting from the resource-type, then expressing who can do what

| resource type      | doctor | dietician | registration | janitor | admin |
| ------------------ | ------ | --------- | ------------ | ------- | ----- |
| Observation        | CRU    |           |              |         | UD    |
| ... other clinical | CRU    |           |              |         | UD    |
| AllergyIntolerance | CRU    | R         |              |         | UD    |
| Condition          | CRU    | R         |              |         | UD    |
| Practitioner       | R      | R         | R            |         | UD    |
| PractionerRole     | R      | R         | R            |         | UD    |
| Person             | R      | R         | RU           |         | UD    |
| RelatedPerson      | R      | R         | RU           |         | UD    |
| Organization       | R      | R         | R            |         | UD    |
| Location           | R      | R         | R            |         | UD    |
| Patient            | R      | R         | CRU          |         | UD    |
| ... |
{:.grid}

Traversing [the Permission holding resource first rules](Permission-ex-overriding-rbac-by-resource.html) one needs to understand the kind of resource being requested, find that in the rules, and can then understand the roles / purposeOfUse that have a given action right. So where an access request is to the Observation resource, the second entry in the Permission would be all that is needed.

```fs
...
* combining = #permit-overrides
* rule[+].type = #deny // default is that NO ONE gets access

// Observation
* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Observation
* rule[=].activity[+].actor.reference = Reference(DrRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#C
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[+].actor.reference = Reference(AdminRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT
...
```

#### Security Tag ABAC analysis

The following is for illustration purposes. It is neither complete, nor represents the real-world.

| role      | access | Confidentiality Tag |
| --------- | ------ | -------------------|
| doctor    | CRU    | Normal, Restricted
| doctor    | R      | Low, Moderate
| dietician | R      | Normal, Low, Moderate
| registration | CRU | Moderate
| registration | R   | Low
| janitor   |        |
| admin     |   UD   | *
{:.grid}

Note that we are using the same "role" concept as above, but in an ABAC system these grouping mechanisms for users would be called "clearance". In both cases the `PractitionerRole` resource is used. 

Presumes that [Confidentiality Tag](https://terminology.hl7.org/5.1.0/CodeSystem-v3-Confidentiality.html) is added to all data by a Security Labeling Service (SLS). This example is only using the following ConfidentalityCodes for simplicity purposes. This model can be extended to other codes as well such as sensitivity classifications. The advantage of using ConfidentialityCodes in this example is because the vocabulary is a non-overlapping set of codes. Thus any piece of data will fall into ONE of the given codes. This simplification for this model is not realistic overall, but ABAC is not limited in this way. ABAC can operate on any vocabulary and against any 'attribute' (in FHIR these are called 'elements'), and any relationshps between attributes and their values.

For our example purposes: SLS would be configured to tag using ConfidentialityCode:

- Restricted - Patient Identifiable Clinical Information of a sensitive nature
- Normal - Patient Identifiable Clinical information of normal (average) sensitivity
- Moderate - Patient Identifiable administrative information such as patient demographics, relationships to family members, etc
- Low - Business information

Note that the Patient is not included as Patient access to their own data requires deep ABAC support.

Note that the concept of Break-Glass is introduced here as a PurposeOfUse of `ETREAT`, to indicate that Restricted data can only be accessed by doctors under emergency treatment context.

ABAC can be role first or security tag first. The [Permission example for ABAC](Permission-ex-overriding-abac-by-tag.html) is showing security tag first. So there is a rule for each ConfidentialityCode, and the activities indicate who can do what with that kind of data.

```fs
...
* combining = #permit-overrides
* rule[+].type = #deny // default is that NO ONE gets access

* rule[+].type = #permit
* rule[=].data[+].security = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N
* rule[=].activity[+].actor.reference = Reference(DrRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#C
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[+].actor.reference = Reference(DieticianRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(AdminRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

* rule[+].type = #permit
* rule[=].data[+].security = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#R
* rule[=].activity[+].actor.reference = Reference(DrRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#C
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#ETREAT
* rule[=].activity[+].actor.reference = Reference(AdminRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT
...
```

### Using Overriding Permission

Given that an Overriding Policy could be written using Permission. Then a [Consent.policyBasis could point at that Permission](Consent-ex-consent-permission.html).

```fs
...
Instance: ex-consent-permission
InstanceOf: Consent
Title: "Consent that uses Permission for rules"
Description: """
Some would prefer to use the Permission rule encoding, and not the Consent.provision; thus the Consent is used to capture the ceremony, and points at a Permission for the rules.
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* date = "2022-06-13"
* category = http://loinc.org#59284-0 "Consent Document"
* subject = Reference(ex-patient)
* grantor = Reference(ex-patient)
* policyBasis.reference = Reference(ex-overriding-rbac-by-role)
* decision = #permit
...
```

#### Deep ABAC analysis

- doctors can change data that they authored, but can not change data they did not author
- doctors can create data for a given patient if there is a legitimate relationship between doctor and patient
- doctors can declare break-glass to override a Privacy Consent restriction in cases where there is a medical safety concern
- patient can access their own data
- patient can authorize a related person to access that patient's data
- use dynamic compartments such as CareTeam, List, and Group

