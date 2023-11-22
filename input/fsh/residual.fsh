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
* rule[=].limit = http://terminology.hl7.org/CodeSystem/v3-ActCode#NODSCLCDS "no disclosure without information subject's consent directive"

Extension: BundlePermission
Id: bundlePermission
Title: "Permission imposed in a Bundle"
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
* rule[=].limit = http://terminology.hl7.org/CodeSystem/v3-ActCode#NODSCLCDS "no disclosure without information subject's consent directive"

Profile: BundleWithPermission
Parent: Bundle
Title: "Bundle with an imposed Permission"
Description: "Bundle includes an imposed Permission"
* meta.security.extension contains BundlePermission named bundlePermission 0..1


Instance:   ex-SearchSet-withPermission
InstanceOf: BundleWithPermission
Title:      "Example of a SearchSet Bundle with Permission"
Description: "Permission in a SearchSet Bundle"
Usage: #example
* meta.security[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* meta.security[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#CPLYPOL
* meta.security[=].extension[bundlePermission].valueReference = Reference(in-permission-redisclose-forbidden-without-consent)
* type = #searchset
* link[0].relation = #self
* link[0].url = "http://test.fhir.net/R4/fhir/Observation?patient=9876&status=current"
* total = 2
* timestamp = 2023-11-22T09:32:24Z
* entry[0].fullUrl = "http://test.fhir.net/R4/fhir/ex-Observation"
* entry[0].resource = in-Observation
* entry[0].search.mode = #match
* entry[1].fullUrl = "http://test.fhir.net/R4/fhir/in-permission-redisclose-forbidden-without-consent"
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
* rule[=].activity.actor = Reference(Practitioner/ex-practitioner)

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

