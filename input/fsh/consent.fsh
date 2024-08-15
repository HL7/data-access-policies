Instance: ex-permission-intermediate-authoredby
InstanceOf: Permission
Title: "Permission allowing data authored by a practitioner"
Description: """
Permission allowing data authored by

There is a Consent that captures the consent ceremony and setting
- status is active - so it should be enforced
- scope is privacy 
- category is LOINC 59284-0 Consent
- date indicated when the consent is recorded
- patient is identified
- performer is the patient
- organization is identified
- source indicate a DocumentReference (with included text of the policy)
- policy url points at this Permission

This Permission encodes
- base rule is #permit 
- base rule includes TPO so as to be clear this is a consent about TPO
- Permits access to data authored by [practitioner 1](Practitioner-ex-practitioner.html)
- Given that there is only one targeted permit rule, then nothing else is allowed.
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2022-06-13"
* combining = #deny-unless-permit
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].data.resource.reference = Reference(Practitioner/ex-practitioner)
* rule[=].data.resource.meaning = http://hl7.org/fhir/consent-data-meaning#authoredby


Instance: ex-permission-intermediate-not-authoredby
InstanceOf: Permission
Title: "Permission allowing most sharing but NOT data authored by a practitioner"
Description: """
Permission allowing most sharing of data but NOT data authored by a practitioner

The Consent that captures the consent ceremony and setting:
- status is active - so it should be enforced
- scope is privacy 
- category is LOINC 59284-0 Consent
- date indicated when the consent is recorded
- patient is identified
- performer is the patient
- organization is identified
- source indicate a DocumentReference (with included text of the policy)
- policy url points at this Permission

This Permission encodes
- base rule includes TPO so as to be clear this is a consent about TPO
- second rule denying access to data authored by ex-practitioner
  - [practitioner 1](Practitioner-ex-practitioner.html)
- nothing else is authorized by this Permission
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* date = "2022-06-13"
* combining = #deny-overrides
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[+].type = #deny
* rule[=].data.resource.reference = Reference(Practitioner/ex-practitioner)
* rule[=].data.resource.meaning = http://hl7.org/fhir/consent-data-meaning#authoredby

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
* category = https://loinc.org#59284-0 "Consent Document"
* subject = Reference(ex-patient)
* grantor = Reference(ex-patient)
* policyBasis.reference = Reference(ex-permission-intermediate-authoredby)
* decision = #permit

