
Extension: PermissionResourceType
Id: dap.permissionResourceType
Title: "Permission rule by Resource Type"
Description: "When defining a Permission.rule where the data is a type of resource.
Note that this might be possible with Expression, but I don't know how."
* ^context[+].type = #element
* ^context[=].expression = "Permission.rule.data"
* value[x] only code
* valueCode from http://hl7.org/fhir/ValueSet/resource-types (required)
* valueCode 1..1

Profile: PermissionWithResourceType
Parent: Permission
Id: dap.permissionWithResourceType
Title: "Permission with support for rule on Resource-Type"
Description: "Adds the PermissionResourceType extension to Permission.rule.data"
* rule.data.extension contains PermissionResourceType named resourceType 0..1



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



Instance: ex-overriding-rbac-by-role
InstanceOf: PermissionWithResourceType
Title: "Permission expressing an overriding policy using RBAC with Role first"
Description: """
As an overriding policy, this policy needs to express who can READ, who can CREATE, who can UPDATE, who can DELETE.
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-12-22"
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

// Dietician R
* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#AllergyIntolerance
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Condition
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Practitioner
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#PractitionerRole
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Person
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Patient
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#RelatedPerson
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Organization
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Location
* rule[=].activity.actor.reference = Reference(DieticianRole)
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

// Registration CRU
* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Person
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Patient
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#RelatedPerson
* rule[=].activity.actor.reference = Reference(RegistrationRole)
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#C
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

// Registration R
* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Practitioner
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#PractitionerRole
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Organization
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Location
* rule[=].activity.actor.reference = Reference(RegistrationRole)
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

// Admin UD
* rule[+].type = #permit
* rule[=].activity.actor.reference = Reference(AdminRole)
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT


Instance: ex-overriding-rbac-by-resource
InstanceOf: PermissionWithResourceType
Title: "Permission expressing an overriding policy using RBAC with Resource first"
Description: """
As an overriding policy, this policy needs to express who can READ, who can CREATE, who can UPDATE, who can DELETE.
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-12-22"
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

* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#AllergyIntolerance
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
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Condition
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
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Practitioner
* rule[=].activity[+].actor.reference = Reference(DrRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[+].actor.reference = Reference(DieticianRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(RegistrationRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(AdminRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#PractitionerRole
* rule[=].activity[+].actor.reference = Reference(DrRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[+].actor.reference = Reference(DieticianRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(RegistrationRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(AdminRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Person
* rule[=].activity[+].actor.reference = Reference(DrRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[+].actor.reference = Reference(DieticianRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(RegistrationRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(AdminRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Patient
* rule[=].activity[+].actor.reference = Reference(DrRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[+].actor.reference = Reference(DieticianRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(RegistrationRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#C
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(AdminRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#RelatedPerson
* rule[=].activity[+].actor.reference = Reference(DrRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[+].actor.reference = Reference(DieticianRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(RegistrationRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(AdminRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Organization
* rule[=].activity[+].actor.reference = Reference(DrRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[+].actor.reference = Reference(DieticianRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(RegistrationRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(AdminRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

* rule[+].type = #permit
* rule[=].data[+].extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Location
* rule[=].activity[+].actor.reference = Reference(DrRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[+].actor.reference = Reference(DieticianRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(RegistrationRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(AdminRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT




Instance: ex-overriding-abac-by-tag
InstanceOf: Permission
Title: "Permission expressing an overriding policy using ABAC"
Description: """
As an overriding policy, this policy needs to express who can READ, who can CREATE, who can UPDATE, who can DELETE.
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-12-22"
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

* rule[+].type = #permit
* rule[=].data[+].security = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#L
* rule[=].activity[+].actor.reference = Reference(DrRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[+].actor.reference = Reference(DieticianRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(RegistrationRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(AdminRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT

* rule[+].type = #permit
* rule[=].data[+].security = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#M
* rule[=].activity[+].actor.reference = Reference(DrRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[+].actor.reference = Reference(DieticianRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(RegistrationRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#C
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity[+].actor.reference = Reference(AdminRole)
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity[=].action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity[=].purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT


Instance: ex-consent-overriding
InstanceOf: Consent
Title: "Consent that uses Overriding Permission for base rules"
Description: """
Where there is a Permssion resource that describes the base policy, then a Consent can point at that Permission rather than a URL alone.
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* date = "2024-08-15"
* category = http://loinc.org#59284-0 "Consent Document"
* subject = Reference(ex-patient)
* grantor = Reference(ex-patient)
* policyBasis.reference = Reference(ex-overriding-rbac-by-role)
* decision = #permit