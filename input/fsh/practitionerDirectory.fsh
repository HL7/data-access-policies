Instance: ex-permission-directory-all
InstanceOf: Permission
Title: "A Permission with all the Directory rules"
Description: """
This Permission has all the rules for the Directory.

Permission allowing patient requested access to Practitioners, but protects the Practitioner sensitive location elements. 

Presumes Practitioner resources are tagged at the element level following [DS4P Inline Security Labels](https://hl7.org/fhir/uv/security-label-ds4p/inline_security_labels.html) that indicate the sensitive location elements using the `LOCIS` tag

This Permission encodes:

- combining rule is deny-unless-permit, ANY permit authorizes access, so rules do not need to be exhaustively processed, but if no permit is found then access is denied.
- rule is #permit for administrative actions on the directory
    - This enables maintenance by those with directory admin authorization
- rule is #permit for Treatment, Payment, and Operations
    - This enables workers to access all workers
    - BUT includes an exclusion extension for any elements marked with Location Sensitivity (`#LOCIS`)
- rule is #permit for Patient requested (`#PATRQT`)
    - permits access by patients (or authorized patient delegate)
    - BUT only Practitioners that have a PractitionerRole.code=#doctor
    - BUT includes an exclusion extension for any elements marked with Location Sensitivity (`#LOCIS`)
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-11-22"
* combining = #deny-unless-permit
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HDIRECT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HSYSADMIN
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#C
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#E
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#E
* rule[=].modifierExtension[+].url = Canonical(ExcludeTagged)
* rule[=].modifierExtension[=].valueCoding = http://terminology.hl7.org/CodeSystem/v3-ActCode#LOCIS
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#PATRQT
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#E
* rule[=].modifierExtension[+].url = Canonical(ExcludeTagged)
* rule[=].modifierExtension[=].valueCoding = http://terminology.hl7.org/CodeSystem/v3-ActCode#LOCIS
* rule[=].data.expression.expression = "Practitioner?_has:PractitionerRole:practitioner:role=http://terminology.hl7.org/CodeSystem/practitioner-role|doctor"
* rule[=].data.expression.language = #application/x-fhir-query
* rule[=].data.expression.description = "select all Practitioner resources where the Practitioner has a PractitionerRole with code of doctor"

Instance: ex-permission-directory-admin
InstanceOf: Permission
Title: "A Permission for admin of the Directory"
Description: """
This Permission has enables administrative changes to the Directory

- rule is #permit for administrative actions on the directory
    - This enables maintenance by those with directory admin authorization
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-11-22"
* combining = #deny-unless-permit
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HDIRECT
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#C
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#E
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HSYSADMIN
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#C
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#R
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#U
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#D
* rule[=].activity.action[+] = http://hl7.org/fhir/audit-event-action#E

Instance: ex-permission-directory-doctors-only
InstanceOf: Permission
Title: "Permission showing how to allow only Doctors to be exposed"
Description: """
Permission allowing patient requested access to Practitioners, BUT only Practitioners that have a PractitionerRole.code=#doctor
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-11-22"
* combining = #deny-unless-permit
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#PATRQT
* rule[=].data.expression.expression = "Practitioner?_has:PractitionerRole:practitioner:role=http://terminology.hl7.org/CodeSystem/practitioner-role|doctor"
* rule[=].data.expression.language = #application/x-fhir-query
* rule[=].data.expression.description = "select all Practitioner resources where the Practitioner has a PractitionerRole with code of doctor"

Instance: ex-permission-directory-exclude-location
InstanceOf: Permission
Title: "Permission allowing data to be used, but don't expose sensitive location elements"
Description: """
Permission allowing patient requested access to Practitioners, but protects the Practitioner sensitive location elements. 

Presumes Practitioner resources are tagged at the element level following [DS4P Inline Security Labels](https://hl7.org/fhir/uv/security-label-ds4p/inline_security_labels.html) that indicate the sensitive location elements using the `LOCIS` tag
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-11-22"
* combining = #deny-unless-permit
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#PATRQT
* rule[=].modifierExtension[+].url = Canonical(ExcludeTagged)
* rule[=].modifierExtension[=].valueCoding = http://terminology.hl7.org/CodeSystem/v3-ActCode#LOCIS

Instance: ex-permission-directory-exclude-location-alt2
InstanceOf: Permission
Title: "Alt2: Permission allowing data to be used, but don't expose sensitive location elements"
Description: """
Permission allowing patient requested access to Practitioners, but protects the Practitioner sensitive location elements. 

Presumes Practitioner resources are tagged at the element level following [DS4P Inline Security Labels](https://hl7.org/fhir/uv/security-label-ds4p/inline_security_labels.html) that indicate the sensitive location elements using the `LOCIS` tag

This alternative uses two rules, and leverages the combining algorithm 
1. Allow Patient requested access
2. Disallow access to any data tagged with LOCIS

Using combining alrithm, the second rule applies to any otherwise permitted access. So it does need to be carefully combined with other permits such as permitting doctors full access to doctors.
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-11-22"
* combining = #ordered-deny-overrides
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#PATRQT
* rule[+].type = #deny
* rule[=].modifierExtension[+].url = Canonical(ExcludeTagged)
* rule[=].modifierExtension[=].valueCoding = http://terminology.hl7.org/CodeSystem/v3-ActCode#LOCIS


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

