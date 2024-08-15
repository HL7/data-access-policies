
Extension: ExcludeTagged
Id: dap.excludeTagged
Title: "Tagged data elements to be excluded on Permit"
Description: "When a Permission permits data, some of the elements of that data may need to be excluded. For example when exposing Practitioner resources to a Patient, the patient should not be given access to the Practitioner Home address and Phone. These elements would be tagged with a given security sensitivity tag, and this extension would indicate to exclude that given tagged data."
* ^context[+].type = #element
* ^context[=].expression = "Permission.rule"
* . ^isModifierReason = "Exclusions must be applied when permit"
* . ^isModifier = true
* value[x] only Coding
* valueCoding 1..1

