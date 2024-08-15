These use-cases show the alternative way to encode Consent rules using the Permission. The Consent resource would still be used to capture the consent ceremony, but would not include any access control rules. The Consent would point at the Permission that holds the access control rules.

Leverage for documentation sake the IG published by [IHE on Privacy Consent on FHIR (PCF)](https://profiles.ihe.net/ITI/PCF/index.html)

Thus we show some Consent use-cases and how they are encoded in FHIR Consent.provisions, then the equivalent using Consent and Permission together.

### Consent allowing data authored by a practitioner

This Consent is covered in [PCF - Consent allowing data authored by a practitioner](https://profiles.ihe.net/ITI/PCF/Consent-ex-consent-intermediate-authoredby.html)

```fs
* provision.type = #permit
* provision.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* provision.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* provision.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* provision.data[aData].meaning = #authoredby
* provision.data[aData].reference = Reference(Practitioner/ex-practitioner)
```

#### Analysis

This Permission encodes

- base rule is #permit
- base rule includes TPO so as to be clear this is a consent about TPO
- Permits access to data authored by [practitioner 1](Practitioner-ex-practitioner.html)
- Given that there is only one targeted permit rule, then nothing else is allowed.

[Example Permission explicitly identifying the authorization for TPO access to data authored by a given practitioner](Permission-ex-permission-intermediate-authoredby.html)

### Consent allowing TPO access except NOT data authored by a practitioner

Given [PCF example](https://profiles.ihe.net/ITI/PCF/Consent-ex-consent-intermediate-not-authoredby.html)

```fs
* provision.type = #permit
* provision.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* provision.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* provision.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* provision.provision.type = #deny
* provision.provision.data[aDataP].meaning = #authoredby
* provision.provision.data[aDataP].reference = Reference(Practitioner/ex-practitioner)
```

#### Analysis

This Permission encodes

- base rule includes TPO so as to be clear this is a consent about TPO
- second rule denying access to data authored by ex-practitioner
  - [practitioner 1](Practitioner-ex-practitioner.html)
- nothing else is authorized by this Permission

```fs
* combining = #deny-overrides
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[+].type = #deny
* rule[=].data.resource.reference = Reference(Practitioner/ex-practitioner)
* rule[=].data.resource.meaning = http://hl7.org/fhir/consent-data-meaning#authoredby
```

#### Consent pointing at this

Given that a Consent provisions are rather encoded in Permissions. Here is how that [Consent could reference the Permission](Consent-ex-consent-permission.html).

```fs
...
* decision = #permit
* provision[+].expression.expression = "Permission/ex-permission-intermediate-not-authoredby"
* provision[=].expression.language = #application/x-fhir-query
* provision[=].expression.description = "Points to the instance of Permission with THIS patients provisions encoded in Permission.rule form."
```

Note that there is a [JIRA ticket FHIR-46021](https://jira.hl7.org/browse/FHIR-46021) on file to add clarity for FHIR R6.
