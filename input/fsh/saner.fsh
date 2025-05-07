Instance: ex-saner
InstanceOf: Permission
Title: "Simple Permission of non-patient data"
Description: """
Read-Only access to SANER report is authorized for PurposeOfUse of Public-Health compliance, from the Organizations. Access requests authorized shall be recorded.
"""
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #active
* asserter = Reference(ex-organization)
* date = "2023-07-19"
* combining = #deny-overrides
* rule[+].type = #permit
* rule[=].data.resource.reference = Reference(ex-measurereport)
* rule[=].data.resource.meaning = http://hl7.org/fhir/consent-data-meaning#instance
* rule[=].activity.actor.reference = Reference(ex-organization)
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#read
* rule[=].activity.action[+] = http://hl7.org/fhir/restful-interaction#search-type
* rule[=].activity.purpose = http://terminology.hl7.org/CodeSystem/v3-ActReason#HCOMPL
* rule[=].limit.control = http://terminology.hl7.org/CodeSystem/v3-ActCode#AUDIT



Instance: ex-measurereport
InstanceOf: MeasureReport
Title: "Dummy MeasureReport example"
Description: "Dummy MeasureReport example for completeness sake. No actual use of this resource other than an example target that is NOT patient specific."
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* status = #pending
* type = #summary
* measure = "http://example.org/fhir/uv/saner/Measure/FEMADailyHospitalCOVID19Reporting"
* period.start = "2020-04-05"
* period.end = "2020-04-05"