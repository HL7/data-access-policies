Instance: ex-permission-exclude-location
InstanceOf: Permission
Title: "Permission allowing data to be used, but don't expose sensitive location elements"
Description: """
Permission allowing patient requested access to Practitioners, but protects the Practitioner sensitive location elements. 

Presumes Practitioner resources are tagged at the element level following [DS4P Inline Security Labels](https://hl7.org/fhir/uv/security-label-ds4p/inline_security_labels.html) that indicate the sensitive location elements using the `LOCIS` tag

This Permission encodes

- base rule is #permit for Treatment, Payment, and Operations
    - This enables workers to access all workers
- base rule includes Patient requested (`#PATRQT`)
    - permits access 
    - BUT only Practitioners that have a PractitionerRole.code=#doctor
    - BUT includes an exclusion extension for any elements marked with Location Sensitivity (`#LOCIS`)

Note other examples will cover other usecases in [Provider Directory Fine Grain](providerDirectoryFineGrain.html).
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
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#PATRQT
* rule[=].extension[+].url = Canonical(ExcludeTagged)
* rule[=].extension[=].valueCoding = http://terminology.hl7.org/CodeSystem/v3-ActCode#LOCIS
* rule[=].data.expression.expression = "Practitioner?_has:PractitionerRole:practitioner:role=http://terminology.hl7.org/CodeSystem/practitioner-role|doctor"
* rule[=].data.expression.language = #application/x-fhir-query
* rule[=].data.expression.description = "select all Practitioner resources where the Practitioner has a PractitionerRole with code of doctor"

Extension: ExcludeTagged
Id: dap.excludeTagged
Title: "Tagged data elements to be excluded on Permit"
Description: "When a Permission permits data, some of the elements of that data may need to be excluded. For example when exposing Practitioner resources to a Patient, the patient should not be given access to the Practitioner Home address and Phone. These elements would be tagged with a given security sensitivity tag, and this extension would indicate to exclude that given tagged data."
* ^context[+].type = #element
* ^context[=].expression = "Permission.rule"
* value[x] only Coding
* valueCoding 1..1


Instance: ex-practitioner-sensitive
InstanceOf: Practitioner
Title: "Dummy Practitioner sensitive example"
Description: "Dummy Practitioner example. This Practitioner has some phone and address information that is tagged as sensitive location information. Note that because of this the Resource is tagged in .meta.security as having inline tags `PROCESSINLINELABEL`."
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActCode#PROCESSINLINELABEL
* telecom[+].system = #email
* telecom[=].use = #work
* telecom[=].value = "JohnMoehrke@gmail.com"
* telecom[+].system = #email
* telecom[=].use = #home
* telecom[=].value = "JohnMoehrke@example.com"
* telecom[=].extension[+].url = "http://hl7.org/fhir/uv/security-label-ds4p/StructureDefinition/extension-inline-sec-label"
* telecom[=].extension[=].valueCoding = http://terminology.hl7.org/CodeSystem/v3-ActCode#LOCIS


Instance: ex-practitioner-de-sensitive
InstanceOf: Practitioner
Title: "Dummy Practitioner de-sensitive example"
Description: "Dummy Practitioner example. This Practitioner has has been de-sensitized from [ex-practitioner-sensitive](Practitioner-ex-practitioner-sensitive.html). Note that because the data has been redacted then .meta.security will have tag `PROCESSINLINELABEL`."
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActCode#REDACTED
* telecom[+].system = #email
* telecom[=].use = #work
* telecom[=].value = "JohnMoehrke@gmail.com"

