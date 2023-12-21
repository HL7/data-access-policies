This is the Security WG, FHIR data-access-policy **sandbox** Implementation Guide. 

<div markdown="1" class="stu-note">
This documentation and set of artifacts are still undergoing development.
This content is only for informative purposes.
</div>

The top menu allows quick navigation to the different sections, and a [Table of Contents](toc.html) is provided with the entire content of this Implementation Guide. (Be aware that some pages have multiple tabs).

### Use-Case analysis

This IG purpose is to include use-case analysis to enable the FHIR [Permission]({{site.data.fhir.path}}Permission) resource to mature. These use-cases will confirm where the Permission resource is properly constructed, where updates are needed, and where core extensions and vocabulary are needed.

The use-cases and analysis are found on these pages:

- [Simple explicit permission of a given resource to a given organization](non-patient.html)
- [Consent with rules in Permissions](consent.html)
- [Bundle with residual enforcement rules in Permission](residual.html)

### Permission

[Permission]({{site.data.fhir.path}}Permission) is a portion of an Access Control environment. It is provided in FHIR form to enable Access Control rules to more naturally utilize the FHIR model.

<figure>
{%include using-rules.svg%}
<figcaption><b>Figure Using Rules</b></figcaption>
</figure>
<br clear="all">

### Intellectual Property Considerations

While this implementation guide and the underlying FHIR are licensed as public domain, this guide includes examples making use of terminologies such 
as LOINC, SNOMED CT and others which have more restrictive licensing requirements. Implementers should make themselves familiar with licensing and 
any other constraints of terminologies, questionnaires, and other components used as part of their implementation process. In some cases, 
licensing requirements may limit the systems that data captured using certain questionnaires may be shared with.

#### Dependency Table

{% include dependency-table.xhtml %}

#### Globals Table

{% include globals-table.xhtml %}

#### IP Statements

{% include ip-statements.xhtml %}

### Disclaimer

The specification herewith documented is a demo working specification, and may not be used for any implementation purposes. 
This draft is provided without warranty of completeness or consistency, and the official publication supersedes this draft.
No liability can be inferred from the use or misuse of this specification, or its consequences.

#### Cross Version Analysis

{% include cross-version-analysis.xhtml %}

### Download

You can also download:

- [this entire guide](full-ig.zip),
- the definition resources in [json](definitions.json.zip), [xml](definitions.xml.zip), or [ttl](definitions.ttl.zip)
- the example resources in [json](examples.json.zip), [xml](examples.xml.zip) or [ttl](examples.ttl.zip) format.
  
The source code for this Implementation Guide can be found on [IHE HL7 data-access-policies Github Repo](https://github.com/HL7/data-access-policies).
