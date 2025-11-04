// Generic resources used for examples. 


Instance: ex-practitioner
InstanceOf: Practitioner
Title: "Dummy Practitioner example"
Description: "Dummy Practitioner example for completeness sake. No actual use of this resource other than an example target"
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* telecom.system = #email
* telecom.value = "JohnMoehrke@gmail.com"


Instance:   ex-organization
InstanceOf: Organization
Title:      "Dummy Organization example"
Description: "Dummy Organization example for completeness sake. No actual use of this resource other than an example target"
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* name = "nowhere"


Instance:   ex-patient
InstanceOf: Patient
Title:      "Dummy Patient example"
Description: "Dummy patient example for completeness sake. No actual use of this resource other than an example target"
Usage: #example
// history - http://playgroundjungle.com/2018/02/origins-of-john-jacob-jingleheimer-schmidt.html
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
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


/* if I add a profile then sushi fails. It does not mind no snapshot until it needs to profile it.

Sushi: error Structure Definition http://hl7.org/fhir/StructureDefinition/Permission is missing a snapshot. Snapshot is required for import. (00:00.012 / 00:04.930, 50Mb)
Sushi:   File: C:\Users\johnm\git\HL7\data-access-policies\input\fsh\stuff.fsh                       (00:00.000 / 00:04.930, 50Mb)
Sushi:   Line: 52 - 56                                                                               (00:00.000 / 00:04.931, 50Mb)


*/

/*
Profile: ex-Profile
Parent: Permission
Title: "example profiling"
Description: "don't do much"
* identifier MS
*/



/* if I make an example using Permission then sushi fails. It does not mind no snapshot until it needs to create an example.

Sushi: error Structure Definition http://hl7.org/fhir/StructureDefinition/Permission is missing a snapshot. Snapshot is required for import. (00:00.092 / 00:04.422, 51Mb)
Sushi:   File: C:\Users\johnm\git\HL7\data-access-policies\input\fsh\stuff.fsh                       (00:00.000 / 00:04.422, 51Mb)
Sushi:   Line: 70 - 104                                                                              (00:00.000 / 00:04.423, 51Mb)

*/
/*
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
*/
