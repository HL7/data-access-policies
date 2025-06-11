This use-case shows how a Permission and Consent can support multiple use-cases with different fine grain needs searching a Patient directory. Where a Patient Directory is an Organization specific directory holding Patient details that are used for non-treatment use-cases such as:

- Inform callers about an admitted Patient and their general condition
- Family Members to discover the Patient and their location
- Clergy to discover Patients interested in their religious affiliation
- Package delivery (e.g. mail, flowers), although usually mitigated by an internal escort or internal delivery service

<div markdown="1" class="dragon">
The purpose of this scenario is to show off and exercise the capability of Permission.
</div>

### Use-cases

#### Outside the USA

I was not able to find non-USA based explaination of a Patient Directory for these use-cases. I would expect the privacy rules are such that no possibility exists.

#### HIPAA enables Patient Directories

HIPAA has explicit policy on family access to patient directory that are nuanced but do include the patient’s right to restrict disclosure if they are able.

There are a number of scenarios in the [HHS Facilities Directories FAQs](https://www.hhs.gov/hipaa/for-professionals/faq/facility-directories/index.html#:~:text=The%20Privacy%20Rule%20provides%20that,general%20terms%3B%20and%20religious%20affiliation.) such as this one:

Does the HIPAA Privacy Rule permit hospitals and other health care facilities to inform visitors or callers about a patient’s location in the facility and general condition?

Answer:

Yes. Covered hospitals and other covered health care providers can use a facility directory to inform visitors or callers about a patient’s location in the facility and general condition. The Privacy Rule permits a covered hospital or other covered health care provider to maintain in a directory certain information about patients – patient name, location in the facility, health condition expressed in general terms that does not communicate specific medical information about the individual, and religious affiliation. The patient must be informed about the information to be included in the directory, and to whom the information may be released, and must have the opportunity to restrict the information or to whom it is disclosed, or opt out of being included in the directory. The patient may be informed, and make his or her preferences known, orally or in writing. The facility may provide the appropriate directory information – except for religious affiliation – to anyone who asks for the patient by name. Religious affiliation may be disclosed to members of the clergy, who are given additional access to directory information under the Rule. (See other FAQs at this site by searching on the term “clergy”.)

Even when, due to emergency treatment circumstances or incapacity, the patient has not been provided an opportunity to express his or her preference about how, or if, the information may be disclosed, directory information about the patient may still be made available if doing so is in the individual’s best interest as determined in the professional judgment of the provider, and would not be inconsistent with any known preference previously expressed by the individual. In these cases, as soon as practicable, the covered health care provider must inform the patient about the directory and provide the patient an opportunity to express his or her preference about how, or if, the information may be disclosed. See 45 CFR 164.510(a).

#### VA policy

A Veteran has the right to opt-out of the facility directory. The facility directory is used to provide information on the location and general status of a Veteran. Veterans must be in an inpatient setting in order to opt-out and thus it does not apply to the emergency room or other outpatient settings. If the Veteran opts out of the facility directory, no information will be given to a member of the public from the directory unless required by law. The Veteran will not receive mail or flowers. If the Veteran has opted out of the directory, visitors will only be directed to the Veteran's room if they already know the room number.

If the Veteran is admitted emergently and medically cannot give their opt-out preference, the provider will use their professional judgment and make the determination for the Veteran. This determination may be based on previous admissions, or by a family member who is involved in the care of the Veteran. When the Veteran becomes able to make a decision, staff is required to ask the individual their preference about opting out of the facility directory and change the opt-out decision, if necessary.

### Use-case Analysis

- Information that might be included: patient name, location in the facility, health condition expressed in general terms that does not communicate specific medical information about the individual, and religious affiliation.
- Patient must be informed (aka see the access control rules - in human language)
- Patient must be allowed to restrict the data or to whom it is exposed
- Consent by the Patient to be included
- Consent by the Patient as to who can see the data
- Clergy may be specially authorized to see Religious affiliation (otherwise Religious affiliation is not exposed?)
- When Consent can't be obtained, professional judgement of the provider can make the directory accessible.
  - When Consent then can be obtained, the Patient must be informed and given the above consent rights.
- All access should be logged, and the Patient informed about who has been looking at their entry.

Thus:

- Permission encode the rules of access to the Patient Directory. This would include administrative access, Consent controls, and rules when Consent has not yet been obtained.
- For the Patient Directory to be seen either evidence of a Permit Consent, or a Practitioner authorization. - Both of these could be a FHIR Consent, with the second a special policy, and with the Practitioner as the grantor. This Consent would be overwritten when the Patient gives Consent which would have the Patient (or guardian) as the grantor. Difference being grantor as Practitioner vs grantor being the Patient or RelatedPerson.
- No access to an entry for this Patient is allowed when no Consent is on file.
  - No entry in the Directory would exist? Or is the registration desk always going to put the data in the directory. This seems like a policy/process/governance question that I can't answer, and for which the answer is not important for this analysis
  - Will presume that the Consent (either Practitioner or Patient) is the trigger to put the Patient data into the directory.
- The Religious affiliation detail can be handled similar to the Provider Directory home location. A different tag `REL`. This uses the `REL` tag on the data element in the Patient, and the `.limit.tag`
  - Given that Religious Affiliation is supported by an [extension on Patient](https://hl7.org/fhir/extensions/StructureDefinition-patient-religion.html), the tagging might not be necessary if business rules can understand the `.limit.tag` requirement.

### Artifacts

- [Permission for Patient Directory](Permission-ex-permission-patient-directory-all.html)
- [Consent given by Practitioner on behalf of the Patient](Consent-ex-consent-patientDirectory-practitioner.html)
- [Consent given by the Patient to deny access](Consent-ex-consent-patientDirectory-deny.html)
- [Consent given by the Patient to permit access](Consent-ex-consent-patientDirectory.html)
- [Patient entry with Religious Affiliation populated](Patient-ex-patient-religion.html)
