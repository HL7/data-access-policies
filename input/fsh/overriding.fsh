


CodeSystem:  MyOrgRolesCS
Title: "MyOrg defined Roles CodeSystem"
Description:  """
The codes for Roles in MyOrg

Could possibly use the defined valueSet [practitioner-role](https://hl7.org/fhir/valueset-practitioner-role.html)
"""
* ^caseSensitive = true
* ^experimental = false
* #doctor "Doctor" "Any Doctor with practicing privileges"
* #dietician "Dietician" "Any Dietician such as working in food preparation"
* #patient "Patient" "Any Patient recognized as a USER"
* #registration "Registration Clerk" "Any Registration Clerk"
* #janitor "Janitor" "Any Janitor working for MyOrg"
* #admin "Administration" "Any highly privileged user authorized to do administrative tasks"

ValueSet: MyOrgRolesVS
Title: "Current Roles in MyOrg"
Description:  "MyOrg current security roles"
* ^experimental = false
* codes from system MyOrgRolesCS

Instance: DrRole
InstanceOf: PractitionerRole
Title: "PractitionerRole defining those that are Doctors"
Description: "Doctors"
* code = MyOrgRolesCS#doctor

Instance: DieticianRole
InstanceOf: PractitionerRole
Title: "PractitionerRole defining those that are Dietician"
Description: "Dietician"
* code = MyOrgRolesCS#dietician

Instance: RegistrationRole
InstanceOf: PractitionerRole
Title: "PractitionerRole defining those that are Registration"
Description: "Registration"
* code = MyOrgRolesCS#registration

Instance: JanitorRole
InstanceOf: PractitionerRole
Title: "PractitionerRole defining those that are Janitor"
Description: "Janitor"
* code = MyOrgRolesCS#janitor

Instance: AdminRole
InstanceOf: PractitionerRole
Title: "PractitionerRole defining those that are Admin"
Description: "Admin"
* code = MyOrgRolesCS#admin



Instance: ex-overriding
InstanceOf: Permission
Title: "Permission expressing an overriding policy"
Description: """
As an overriding policy, this policy needs to express who can READ, who can CREATE, who can UPDATE, who can DELETE.
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-07-19"
* combining = #permit-overrides
* rule[+].type = #deny // presumption is that NO ONE gets access

// Doctor CRU
* rule[+].type = #permit
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#Observation
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#AllergyIntolerance
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#Condition
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].activity.actor = Reference(DrRole)
* rule[=].activity.action = http://hl7.org/fhir/audit-event-action#C
* rule[=].activity.action = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.action = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

// Doctor R
* rule[+].type = #permit
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#Practitioner
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#PractitionerRole
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#Person
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#RelatedPerson
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].activity.actor = Reference(DrRole)
* rule[=].activity.action = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

// Dietician R
* rule[+].type = #permit
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#AllergyIntolerance
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#Condition
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#Practitioner
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#PractitionerRole
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#Person
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#RelatedPerson
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].activity.actor = Reference(DieticianRole)
* rule[=].activity.action = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

// Patient R
* rule[+].type = #permit
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#Observation
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#AllergyIntolerance
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#Condition
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#Practitioner
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#PractitionerRole
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#Person
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].data[+].resource.reference.type = https://hl7.org/fhir/codesystem-fhir-types#RelatedPerson
* rule[=].data[=].resource.meaning = http://hl7.org/fhir/consent-data-meaning#related
* rule[=].activity.actor.type =  https://hl7.org/fhir/codesystem-fhir-types#Patient
* rule[=].activity.action = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT
