Instance: ex-permission-redisclose-forbidden-without-consent
InstanceOf: Permission
Title: "Permission allowing data to be used, but with redisclosure condition"
Description: """
Permission allowing requested use, but restricting redisclosure

This Permission encodes

- base rule is #permit
- base rule includes TPO so as to be clear this is authorizes TPO
- includes a residual (limit) using code NODSCLCDS
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-11-22"
* combining = #deny-unless-permit
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#NODSCLCDS "no disclosure without information subject's consent directive"

Extension: PermissionImposedOnBundle
Id: dap.permissionImposedOnBundle
Title: "Permission imposed on a Bundle"
Description: "When a Bundle carries a Permissiont that must be enforced"
* ^context[+].type = #element
* ^context[=].expression = "Bundle.meta.security"
* value[x] only Reference(Permission)
* valueReference 1..1

Instance: in-permission-redisclose-forbidden-without-consent
InstanceOf: Permission
Title: "Permission allowing data to be used, but with redisclosure condition"
Description: """
Inline copy for Bundle use: Permission allowing requested use, but restricting redisclosure

This Permission encodes

- base rule is #permit
- base rule includes TPO so as to be clear this is authorizes TPO
- includes a residual (limit) using code NODSCLCDS
"""
Usage: #inline
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-11-22"
* combining = #deny-unless-permit
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#NODSCLCDS "no disclosure without information subject's consent directive"

Profile: BundleWithPermission
Parent: Bundle
Id: dap.bundleWithPermission
Title: "Bundle with an imposed Permission"
Description: "Bundle includes an imposed Permission"
* meta.security.extension contains PermissionImposedOnBundle named permissionImposedOnBundle 0..1


Instance:   ex-SearchSet-withPermission
InstanceOf: BundleWithPermission
Title:      "Example of a SearchSet Bundle with Permission"
Description: "Permission in a SearchSet Bundle"
Usage: #example
* meta.security[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* meta.security[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#CPLYPOL
* meta.security[=].extension[permissionImposedOnBundle].valueReference.reference = "http://example.org/R4/fhir/Permission/in-permission-redisclose-forbidden-without-consent"
* type = #searchset
* link[0].relation = #self
* link[0].url = "http://example.org/R4/fhir/Observation?patient=9876&status=current"
* total = 2
* timestamp = 2023-11-22T09:32:24Z
* entry[0].fullUrl = "http://example.org/R4/fhir/Observation/in-Observation"
* entry[0].resource = in-Observation
* entry[0].search.mode = #match
* entry[1].fullUrl = "http://example.org/R4/fhir/Permission/in-permission-redisclose-forbidden-without-consent"
* entry[1].resource = in-permission-redisclose-forbidden-without-consent
* entry[1].search.mode = #include

Instance: in-Observation
InstanceOf: Observation
Title: "Observation - SH: Alcohol Use"
Description: """
This example Observation resource to represent alcohol use assessment in a patient summary.
"""
Usage: #inline
* meta.security[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#ETH
* meta.security[+] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#R
* status = #final
* code = http://loinc.org#74013-4
* subject = Reference(Patient/ex-patient)
* effectiveDateTime = "2022-06-13"
* valueQuantity = 5 '/d' "wine glasses per day"
* performer = Reference(Patient/ex-patient)


Instance: ex-permission-not-bob
InstanceOf: Permission
Title: "Permission allowing most use but NOT a given practitioner"
Description: """
Permission allowing most use of data but NOT a given practitioner

This Permission encodes
- base rule includes TPO so as to be clear this generally authorizes TPO
- second rule denying access to a given ex-practitioner
  - [practitioner 1](Practitioner-ex-practitioner.html)
- nothing else is authorized by this Permission
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* date = "2023-11-22"
* combining = #deny-overrides
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[+].type = #deny
* rule[=].activity.actor.reference = Reference(Practitioner/ex-practitioner)

Instance: ex-permission-timeout
InstanceOf: Permission
Title: "Permission allowing most use but expires in a year"
Description: """
Permission allowing most use of data but expires in a year. Note that this 'year' indication is based on absolute dates of issuing of the Permission, and use of Permission.validity.

This Permission encodes
- base rule includes TPO so as to be clear this generally authorizes TPO
- validity is a period of one year
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* date = "2023-11-22"
* validity.start =  "2023-11-22"
* validity.end =  "2024-11-22"
* combining = #deny-overrides
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT



Extension: PermissionKanonymity
Id: dap.permissionKanonymity
Title: "Permission imposed K-Anonymity value"
Description: "When a limit needs to impose a specific K-Anonymity value."
* ^context[+].type = #element
* ^context[=].expression = "Permission.rule.limit"
* value[x] only integer
* valueInteger 1..1

Profile: PermissionWithKanonymity
Parent: Permission
Id: dap.PermissionWithKanonymity
Title: "Permission with K-Anonymity"
Description: "Permission with the extension for K-Anonymity"
// could have a requirement that this extension be only used where the limit is a DEID or ANONY
* rule.limit.extension contains dap.permissionKanonymity named ka 0..1

Instance: ex-permission-k-anonymity
InstanceOf: PermissionWithKanonymity
Title: "Permission require exposure to meet a given k-anonymity value"
Description: """
Permission allowing use of data but requires exposure meet a given k-anonymity value. 

This Permission encodes
- base rule includes Research so as to be clear this generally authorizes Research
- validity is a period of one year
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* date = "2023-12-20"
* combining = #deny-overrides
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH
// could use ANONY, but I prefer DEID as it is the higher concept allowing pseudonymization or anonymization
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#DEID
* rule[=].limit.extension[ka].valueInteger = 4

