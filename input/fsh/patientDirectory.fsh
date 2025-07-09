Instance: ex-permission-patient-directory-all
InstanceOf: Permission
Title: "A Permission with all the Patient Directory rules"
Description: """
This Permission has all the rules for the Patient Directory.

Permission allowing patient requested access to Practitioners, but protects the Practitioner sensitive location elements. 

Presumes Practitioner resources are tagged at the element level following [DS4P Inline Security Labels](https://hl7.org/fhir/uv/security-label-ds4p/inline_security_labels.html) that indicate the sensitive location elements using the `LOCIS` tag

This Permission encodes:

- combining rule is deny-unless-permit, ANY permit authorizes access, so rules do not need to be exhaustively processed, but if no permit is found then access is denied.
- rule is #permit for health directory use, patient requested, or family requested
    - This enables access all patients, provided Consent Permit is on file
    - BUT uses .limit.tag to exclude any elements marked with Religious Sensitivity (`#REL`)
    - Note that the Consent requirement is documented here with a .limit of NOAUTH. Might there be a better way?
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
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#PATRQT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#FAMRQT
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#read
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#search-type
* rule[=].limit.tag = http://terminology.hl7.org/CodeSystem/v3-ActCode#REL
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#NOAUTH

* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HSYSADMIN
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#create
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#read
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#update
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#delete
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#search-type




Instance:   ex-patient-religion
InstanceOf: Patient
Title:      "Dummy Patient example with Religion"
Description: "This patient is the same as ex-patient, with the extension for religious affiliation."
Usage: #example
// history - http://playgroundjungle.com/2018/02/origins-of-john-jacob-jingleheimer-schmidt.html
* meta.security[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* meta.security[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#PROCESSINLINELABEL
* name[+].use = #usual
* name[=].family = "Schmidt"
* name[=].given = "John"
* name[+].use = #old
* name[=].family = "Schnidt"
* name[=].given[+] = "John"
* name[=].given[+] = "Jacob"
* name[=].given[+] = "Jingle"
* name[=].given[+] = "Heimer"
* name[=].period.end = "1960"
* name[+].use = #official
* name[=].family = "Schmidt"
* name[=].given[+] = "John"
* name[=].given[+] = "Jacob"
* name[=].given[+] = "Jingleheimer"
* name[=].period.start = "1960-01-01"
* name[+].use = #nickname
* name[=].family = "Schmidt"
* name[=].given = "Jack"
* gender = #other
* birthDate = "1923-07-25"
* address.state = "WI"
* address.country = "USA"
* extension[+].url = "http://hl7.org/fhir/StructureDefinition/patient-religion"
* extension[=].valueCodeableConcept = http://terminology.hl7.org/CodeSystem/v3-ReligiousAffiliation#1041 "Roman Catholic Church"
* extension[=].valueCodeableConcept.extension[+].url = "http://hl7.org/fhir/uv/security-label-ds4p/StructureDefinition/extension-inline-sec-label"
* extension[=].valueCodeableConcept.extension[=].valueCoding = http://terminology.hl7.org/CodeSystem/v3-ActCode#REL


Instance: ex-permission-patient-authoredby
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

Instance: ex-consent-patientDirectory
InstanceOf: Consent
Title: "Consent for Patient Directory"
Description: """
Consent by the patient to allow access to the Patient Directory following the Patient Directory policy.

- Consent is by the Patient
- Permit
- policy Basis is the Permission describing patient directory rules
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* date = "2022-06-13"
* category = http://loinc.org#59284-0 "Consent Document"
* subject = Reference(ex-patient)
* grantor = Reference(ex-patient)
* provisionReference = Reference(ex-permission-patient-directory-all)
* decision = #permit

Instance: ex-consent-patientDirectory-deny
InstanceOf: Consent
Title: "Consent Deny for Patient Directory"
Description: """
Consent by the patient to Deny access to the Patient Directory following the Patient Directory policy.

- Consent is by the Patient
- Deny
- policy Basis is the Permission describing patient directory rules
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* date = "2022-06-13"
* category = http://loinc.org#59284-0 "Consent Document"
* subject = Reference(ex-patient)
* grantor = Reference(ex-patient)
* provisionReference = Reference(ex-permission-patient-directory-all)
* decision = #deny


Instance: ex-consent-patientDirectory-practitioner
InstanceOf: Consent
Title: "Consent for Patient Directory by Clinican"
Description: """
Consent by the Clinician on behalf of the patient to allow access to the Patient Directory following the Patient Directory policy.

- Consent is by the Practitioner
- Permit
- policy Basis is the Permission describing patient directory rules
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* date = "2022-06-13"
* category = http://loinc.org#59284-0 "Consent Document"
* subject = Reference(ex-patient)
* grantor = Reference(ex-practitioner)
* provisionReference = Reference(ex-permission-patient-directory-all)
* decision = #permit
