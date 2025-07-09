This use-case shows how a Permission can support multiple use-cases with different fine grain needs searching a Practitioner directory, resulting in SUBSETTED Practitioner resources. 

<div markdown="1" class="dragon">
The following is an example, and not a recommendation. Physical isolation of these various kinds of data is likely safer from accidental risk of exposure. Very unlikely that an HR use-case would be included in a directory that has ANY kind of public access. The purpose of this scenario is to show off and exercise the capability of Permission.

Further the policies asserted here are for example purpose and not an endorsement that these are good policies.
</div>

### Use-cases

Given an organizations has a provider directory contains comprehensive information:

- includes clinicians, dieticians, registration clerks, billing clerks, and all other kinds of workers, including comfort dogs.
- They use an established structural code to differentiate the various kinds of practitioners.
- includes all the details about the employee that may be needed by anyone including HR, thus home phone numbers and addresses, work phone numbers and addresses.

Thus the practitioner directory has many possible use-cases, but also has too much information to be exposed. Employees have privacy rights as well.

some Use-cases we will look to enable:

- When an internal clinician searches, they will get all clinicians internal allowed data (not personal home address, or personal phone number)
- When a patient searches, they will get only name and structural role (not phone, address, or functional roles)
- When HR searches, they do get personal home address and personal phone numbers.
- When Public-Health searches, they get only the human name and the NPI number
- When an admin searches, they will get all the data with no subsetting, so that they can do updates to the directory

### Practitioner Consent

Not covered here, but covered elsewhere is that each Practitioner should be allowed to Consent to being included in the directory. Given that the directory has many use-cases, this Consent likely is just enabling the public facing use-cases. This would be implemented with a Consent resource, as it is a consent by the practitioner, with the Practitioner as the Consent.subject and Consent.grantor. The Consent.policyBasis would indicate the rules around public facing practitioner use-cases. The Consent.decision would be permit or deny.

This could also be implemented using the [Permission based Consent](consent.html).

### Attribute Based Access Control

The use-cases will be satisfied with [Attribute Based Access Control (ABAC)](overriding.html) based on elements of

- the Practitioner resource
- the PractitionerRole resource
- the resource meta.security
- DS4P element level tagging

#### Practitioner resource

There is no elements in the Practitioner resource that can be used by ABAC to filter on given the example policies here, but there are elements that would be filtered out for specific use-cases. For example, when the patient is searching, they have no access need for any of the Practitioner.address.

##### Limit by tag

The current Permission has the Permission.rule.limit.tag, are tagged data to be removed from any Resources authorized by this itteration of `.rule` before the response Bundle is assembled. This tagging leverages the [DS4P Inline Security Labels]({{site.data.fhir.ds4p}}/inline_security_labels.html) which defines how to tag individual elements within a Resource, and also tag the Resource as having element level tags.

- Example of a [permission using this extension](Permission-ex-permission-directory-exclude-location.html)
- Example of [Practitioner with element level tagging](Practitioner-ex-practitioner-sensitive.html)
- Example of that Practitioner that has had permission applied to [exclude sensitive elements](Practitioner-ex-practitioner-de-sensitive.html)

#### PractitionerRole resource

It is in the PractitionerRole resource that will be used mostly to identify if a Practitioner is proper for a given use-case.

Note that for our purposes here, we will presume that there is at-least ONE PractitionerRole for every Practitioner. Many will have multiple PractitionerRole resources (e.g. Doctor, Nurse, Researcher, Surgeon, etc.)

Note that the PractitionerRole may not be accessible to all users, such as Patients, but that does not mean it is not available for the Access Control to enforce proper ABAC policies.

So for Patient searching, the search parameters provided by the Patient (app) are applied in addition to a filter on all PractitionerRole.role being in a valueSet that the patient has access to. This could be processed by combining the Patient provided search parameters with the Permission defined filters.

For Example:

- Where the Patient is searching for Practitioner with the name "Moehrke".
- The Permission would assure that only clinicians are searched.
- Therefore if there are three Practitioner
  - Practitioner: John Moehrke
    - PractitionerRole.code = doctor
  - Practitioner: Ryan Moehrke
    - PractitionerRole.code = claims-adjudicator
  - Practitioner: Daryl Moehrke
    - PractitionerRole.code = janitor
  - Practitioner: Diesel Moehrke
    - PractitionerRole.code = comfort-cat

Executing a search is possible:

> GET [base]/Practitioner?name=moehrke&_has:PractitionerRole:practitioner:role=doctor

#### rule using Expression

The illustration here is to show that the Patient can't gain access to entries that they should not have access to by way of their authorization. The above search would work, but they would also get the same results if they just searched for "moehrke"

> GET [base]/Practitioner?name=moehrke

For this we use the `Permission.rule.data.expression` to select only those Practitioners that have a PractitionerRole.code=doctor. See [permission using this expression for data selection](Permission-ex-permission-directory-doctors-only.html)

```fs
* rule[+].permit
* rule[=].data.expression.expression = "Practitioner?_has:PractitionerRole:practitioner:role=doctor"
```

### Public-Health

This use-case would enable public-health access to only the doctors, only their names and their NPI number.

I did not mock this up, as I expect this is similar to the Patient, with more data removed.

### Administration

There are actors that would have rights to maintain the directory. HR would be one of these so that they can add new employees, and manage changes over time. There may be other administrative actors that might be responsible for changes not beyond HR. These users would have the role / clearance to use the `HDIRECT` purposeOfUse. The Permission would them indicate that this purposeOfUse has rights to all the actions. 

<div markdown="1" class="stu-note">
The vocabulary bound to the `.action` element are the Privacy actions. These are good action verbs regarding privacy, but are not sufficient or appropriate at the security level. The vocabulary needs to be changed to the [RESTful Actions (CRUDE)]({{site.data.fhir.path}}valueset-audit-event-action.html), which are defined for AuditEvent.action. Fortunately the current binding is example binding, so it does not keep us from using the CRUDE verbs. But the CRUDE verbs are better for Permission use.
</div>

```fs
* combining = #deny-unless-permit
* rule[+].type = #permit
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HDIRECT
* rule[=].activity.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HSYSADMIN
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#create
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#read
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#update
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#delete
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#search-type
```

- Permission [enabling administrative CRUDE](Permission-ex-permission-directory-admin.html)

### Everything combined

All the above fragments of a Permission would then be [combined into one Permission for the Director](Permission-ex-permission-directory-all.html)
