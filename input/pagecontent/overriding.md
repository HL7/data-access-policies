This use-case shows how a Permission can express an organization's overriding policy. As such it needs to express what roles exist, and what each role can do.

### Analysis

The following is for illustration purposes. It is neither complete, nor represents the real-world.

| role      | access | resource type | data relationship |
| --------- | ------ | ------ | -------------------|
| doctor    | CR   | Observation, AllergyIntolerance, Condition
| doctor    | U    | Observation, AllergyIntolerance, Condition | their authored data
| doctor    | R      | Practitioner, PractionerRole, Person, RelatedPerson
| dietician | R      | AllergyIntolerance, Condition
| patient   | R      | * | their own data
| registration | CRU | Patient, RelatedPerson, Person
| janitor   |        |
| admin     | CRUD   | *
{:.grid}

#### TODO

Not obvious how to define a rule that is on a Resource type (note that Consent has documentType and resourceType)

Not obvious how to do security roles. Can use PractitionerRole if that applies, but that does not apply to Patients acting as a User.

should the action codes be more CRUD vs current privacy codes? or both?
- https://hl7.org/fhir/valueset-audit-event-action.html

Not clear how to define permission enabled by relationship to the data. For example 
- Doctors can Update Observations that they authored, but can't update the Observations created by someone else.
- Patient can access THEIR data, but not all data