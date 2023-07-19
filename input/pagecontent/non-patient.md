Read-Only access to SANER report is authorized for PurposeOfUse of Public-Health, from Organizations in List/P1. Access requests are denied shall be recorded using the profiled auditEvent S-audit-1. Access requests authorized shall be recorded using profiled auditEvent S-audit-2.  No access is granted to previous historic revisions (only current report).

### Analysis

Permission

- status - active
- intent - permit (how to get multiple vectors?)
- asserter - organization holding the data
- assertionDate - today
- purpose - Public-Health
- dataScope - this SANER report
- accesses must be audit logged

[Example Permission explicitly identifying this SANER report](Permission-ex-saner.html)

NOTES:

- How do you create structured policy with branching rules ==> Could bring in nesting that exists in Consent.provision (infinite .provision)
- How do you address ordered rules?
  - Consent has rule nesting, and has predicisor policy
- Conflict resolution policy
  - May be unsaid in FHIR resource? Or do we need a conflict resolution Resource?
- purpose -- Change to the list of purpose of use the permission rule applies (positive or negative)
  - what does multiple values mean? Any, One, All?
- why is purpose at root and also at processingActivity? How do they relate to each other.
- .justification.evidence
  - could this be another Permission?
- justification - need a way to identify organization (public health)

### Variations

Similar yet different

- have a validity scope