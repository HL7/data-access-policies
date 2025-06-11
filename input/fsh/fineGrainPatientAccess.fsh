Instance: ex-fingrained-patient-access
InstanceOf: PermissionWithResourceType // using this profile as it adds resourceType extension
Title: "Fine Grained Patient Access to Data"
Description: """
Fine Grained Patient Access to Data
This Permission allows access to Patient resources marked with a TAG_1, but would remove the .address, .birthDate, and .meta
This Permission denies access to Patient resources marked with a VIP

TODO [Jira FHIR-51070](https://jira.hl7.org/browse/FHIR-51070) for potential better way to identify type of resource
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-11-22"
* combining = #permit-unless-deny
* rule[+].type = #permit
* rule[=].data.extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Patient
* rule[=].data.security[+] = http://your-fhir-server.com/fhir/ValueSet/local-tags#TAG_1
* rule[=].limit[+].element = "Patient.address"
* rule[=].limit[+].element = "Patient.birthDate"
* rule[=].limit[+].element = "Patient.meta"
* rule[+].type = #deny
* rule[=].data.extension[resourceType].valueCode = https://hl7.org/fhir/codesystem-fhir-types#Patient
* rule[=].data.security[+] = http://your-fhir-server.com/fhir/ValueSet/local-tags#VIP
