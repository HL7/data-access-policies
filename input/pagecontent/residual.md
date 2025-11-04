
This use-case is about how to use a Permission to carry residual access control rules in a Bundle with the expectation that the Bundle recipient will enforce these rules. This might be used in Search response, bulk data access, export/excerpt as data input for ML/AL.

Actors:

- Bundle Sender
- Bundle Recipient

```Gherkin
Feature: Residual Permission Bundle

Background: Carry residual Permissions to be enforced by recipient of a Bundle.

Scenario Outline: Bundle needs to carry residual rules

Scenario Outline: basic
    Given that a Bundle Recipient is overall authorized to receive full results of a Bundle, 
    and where that Bundle Recipient is authorized to enforce residual rules
    When a Bundle Sender needs to include residual access control enforcement rules
    Then the Bundle will contain a Permission expressing the residual rules that the Bundle recipient must enforce.
```

Note this should NOT be used if the Bundle recipient is not trusted to enforce the Permission rules.

Note that the Permission rules would be a subset of all possible Permission rules that the Bundle sender knows that the Bundle recipient will enforce.

### Bundle with Permission

In order to make it clear that a Bundle contains a Permission that the Bundle Recipient must enforce, we add an extension to Bundle.meta.security to carry the pointer to this Permission. Thus a Permission in a bundle that is not referenced by a Bundle.meta.security is not a request to enforce. The Bundle.meta.security should also carry `#CPLYPOL` to explain that this policy must be complied with. The Permission would tend to be included in the Bundle as an #include entry, but it is possible the recipient is expected to dereference externally.

- Extension [on Bundle.meta.security imposing a Permission](StructureDefinition-dap.permissionImposedOnBundle.html)
- Bundle that [adds the extension](StructureDefinition-dap.bundleWithPermission.html)
- Example [SearchSet Bundle using the extension](Bundle-ex-SearchSet-withPermission.html)

<p class="stu-note">TODO: should this be added to FHIR core or to DS4P?</p>

### Do Not Redisclose without explicit consent

```Gherkin
Scenario Outline: Do Not Redisclose without explicit consent
    Given that a Bundle Recipient is allowed access
    When the Consent or business rules impose an obligation to not redisclose without an explicit consent
    Then the Bundle Permission needs to express this refrain
```

This use-case could be done with Bundle.meta.security using the NODSCLCDS, however in this case we use a Permission to express the same thing using the same code.

> http://terminology.hl7.org/CodeSystem/v3-ActCode#NODSCLCDS "no disclosure without information subject's consent directive"

#### Analysis

This Permission encodes

- base rule is #permit
- base rule includes TPO so as to be clear this is authorizes TPO (TODO is this needed?)
- includes a residual (limit) using code NODSCLCDS

```fs
* combining = #deny-unless-permit
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#NODSCLCDS "no disclosure without information subject's consent directive"
```

[Example Permission allowing given PurposeOfUse, but limiting redisclosure](Permission-ex-permission-redisclose-forbidden-without-consent.html)

### allowing TPO access except NOT by a given practitioner

This use-case recognizes that most users at the Bundle Recipient organization are authorized, but where the Patient has forbidden access by a given Practitioner.

```Gherkin
Scenario Outline: do not allow a given practitioner
    Given that a Bundle Recipient is allowed access
    When the Consent explicitly forbids access by a given practitioner
    Then the Bundle Permission needs to express this limit
```

Note that this example presumes that the given Practitioner can be identified by a Practitioner resource, such as a common practitioner directory.

#### Analysis

This Permission encodes

- base rule includes TPO so as to be clear this is a consent about TPO
- second rule denying access to ex-practitioner
  - [practitioner 1](Practitioner-ex-practitioner.html)
- nothing else is authorized by this Permission

```fs
* combining = #deny-overrides
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HPAYMT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HOPERAT
* rule[+].type = #deny
* rule[=].activity.actor.reference = Reference(Practitioner/ex-practitioner)
```

[Example Permission allowing most use but not a given practitioner](Permission-ex-permission-not-bob.html)

### allowing TPO access for 1 year

This use-case recognizes that use is allowed by the Bundle Recipient organization are authorized, but the data must be discarded after 1 year.

```Gherkin
Scenario Outline: Do Not use after one year
    Given that a Bundle Recipient is allowed access
    When the Consent or business rules impose a limit on how long the data can be used
    Then the Bundle Permission needs to express this refrain
```

This is not encodable in security label vocabulary as it requires the use of a date of expiration

#### Analysis

This Permission encodes

- base rule includes TPO so as to be clear this is a consent about TPO
- the Permission has a validity element that shows the permission expires
- TODO: Do we really need any .rule?

```fs
* date = "2023-11-22"
* validity.start =  "2023-11-22"
* validity.end =  "2024-11-22"
```

[Example Permission allowing most use but not a given practitioner](Permission-ex-permission-timeout.html)

### allowing Research access with a given K-Anonymity

This use-case is releasing data to a Research project with a limit to not release the data without meeting a given K-Anonymity (4).

Where [K-Anonymity](https://en.wikipedia.org/wiki/K-anonymity) is a measure on a De-Identified dataset to determine within that specific dataset what the smallest grouping of individuals would be. Where this smallest grouping is defined as **k** and this would not be acceptable if it was smaller than the **K** value given in the release authorization (i.e. Permission attached to the Bundle).

Thus the Bundle will contain fully identifiable data, with an obligation on the recipient to De-Identify (`.rule.limit` = `DEID`). Given that this obligation includes a specific K-Anonymity, a Permission is used rather than just using `Bundle.meta.security`.

The purpose of including this use-case is to include a use-case where some parameter needs to go along with a obligation or refrain in order to add specificity. K-Anonymity is thus an examplar, not a recommendation.

```Gherkin
Scenario Outline: Allow only a given K-Anonymity
    Given that a Bundle Recipient is allowed Research access
    When the terms of the release need to impose a given K-Anonymity value
    Then the Bundle Permission needs to express this limit
```

#### Analysis

<div markdown="1" class="stu-note">
This Permission requires an extension to express the K-Anonymity value encodes

- base rule includes Research so as to be clear this is allowing only Research
- this permit has a limit of a given K-anonymity value (4)
  - Define an [extension to carry a K-Anonymity](StructureDefinition-dap.permissionKanonymity.html) number, which are integers
  - Define a [profile binding this extension on the Permission.rule.limit](StructureDefinition-dap.PermissionWithKanonymity.html) to be used with either DEID or ANONY obligation code
- nothing else is authorized by this Permission

```fs
* combining = #deny-overrides
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#DEID
* rule[=].limit.extension[ka].valueInteger = 4
```

[Example Permission allowing Research with a given K-anonymity (4)](Permission-ex-permission-k-anonymity.html)
</div>


