# Team E Peer Review Report — Team F

## CampusShare — Software Requirements Specification v0.3

**Reviewing team:** Team E  
**Reviewed team:** Team F  
**Document reviewed:** CampusShare — Software Requirements Specification  
**Version:** v0.3 (draft for team review)  
**Document date:** 27 October 2026  
**Review date:** 1 November 2026  
**Review stage:** First-stage SRS-only review  
**Team identified in the SRS:** Team 26F

---

## 1. Overall distribution overview

### 1.1 Review scope

This review evaluates the submitted SRS document as a requirements specification. It covers scope, roles, functional and security requirements, non-functional requirements, data requirements, process flows, status transitions, verification and traceability, and the treatment of open decisions.

This is **not** a source-code, runtime, deployment, infrastructure or independent test-execution review. The application baseline and test results described in the SRS are treated as statements from the authors; Team E has not independently run the application or the reported 76 automated tests. The review does not assume that referenced companion documents are absent from Team F's repository merely because they were not included in the supplied SRS file.

The supplied SRS ends during the G-31 workflow-items table in Appendix A. The findings below are based on the content provided; no assumptions are made about material that may exist in a later or fuller repository version.

### 1.2 Finding distribution

| Severity | Count | Share |
|---|---:|---:|
| Severe | 0 | 0% |
| Normal | 12 | 80% |
| Minor | 3 | 20% |
| **Total** | **15** | **100%** |

### 1.3 Overall assessment

The CampusShare SRS has several useful strengths. It identifies the product's users and operating environment, separates functional, security and non-functional requirements, records current application status, provides a data-entity summary, includes a request lifecycle diagram and a borrowing sequence flow, and openly records unresolved questions and known prototype limitations. The authors also distinguish simulated payment from real payment and disclose a number of incomplete requirements rather than presenting them as verified.

The central weakness is that the rental workflow is not yet represented by one consistent, authoritative lifecycle. The process flow, permitted status transitions and the Appendix A workflow notes differ on when approval occurs and what happens when inspection fails. Several core transaction rules also need precise boundaries: hourly pricing, overlapping requests, listing availability, deposit/dispute settlement and listing edits during a booking. The remaining findings concern identity assurance, data lifecycle, media backup, formal traceability of condition evidence and the definition of the release scope for payment and administration.

---

## 2. Issue list summary

| ID | Severity | SRS reference | Issue summary |
|---|---|---|---|
| F-01 | Normal | §4.2, FR-REQ-07, Appendix A G-31 | The main borrowing flow approves the request before inspection/payment, while G-31 says approval should occur after inspection, evidence and payment. |
| F-02 | Normal | FR-REQ-08, §4.2 | The inspection-failure branch rejects a request after approval, but the allowed status transitions contain no Approved-to-Rejected transition. |
| F-03 | Normal | FR-REQ-04, FR-REQ-09 | Overlap prevention is specified as a rule but no atomic/concurrent booking acceptance condition is provided. |
| F-04 | Normal | FR-REQ-05 | Hourly price calculation does not define the minimum billable duration or rounding rule. |
| F-05 | Normal | FR-LST-06, FR-REQ-09, §6.2 | The listing-level Booked status can misrepresent availability when multiple non-overlapping bookings are allowed. |
| F-06 | Normal | FR-PAY-05–08, §3.5 data requirements, §4.2 | The deposit/damage/dispute lifecycle and allowed dispute states do not fully define when charges are settled and the remaining deposit is refunded. |
| F-07 | Normal | §1.2, FR-PAY-10, §6.2 | Real online payment is described as out of scope but remains an under-study requirement with an unresolved scope decision. |
| F-08 | Normal | FR-AUTH-01/02, SEC-01, §6.2 | A university email address is verified, but the submitted student ID is not checked against an authoritative source. |
| F-09 | Normal | §2–§3 data and security requirements | The SRS does not define account/data deletion, retention or user-data export rules for the personal information stored by CampusShare. |
| F-10 | Normal | FR-LST-07, NFR-REL-02, §3.4 notes | The backup requirement covers the database, while uploaded photos are stored separately and explicitly excluded from backup. |
| F-11 | Normal | §4.2, Appendix A G-31, §3.5 data requirements | Item-condition photos are part of the documented rental workflow but are not specified as a traceable functional/data requirement. |
| F-12 | Normal | FR-LST-04, FR-REQ-04/07, §3.2 notes | Listing edits during an active or pending booking are not constrained, despite an explicit team comment identifying the need to block or restrict them. |
| F-13 | Minor | §2.2, FR-ADM-01–04 | Administration is included in the product-function summary, but all administrator requirements are Not Done and no release decision is stated. |
| F-14 | Minor | NFR-PERF-01, §3.4 | The performance target is labelled “proposed … to confirm” while its status is Done. |
| F-15 | Minor | §6.1, §6.2, Appendix A G-31 | The open-issues and G-31 appendix material is unfinished in the submitted file, with blank states and an incomplete closing point. |

---

## 3. Review comment responses

The following findings are formatted as separate review comments. Each should be posted as its own GitHub comment so Team F can respond to each finding independently.

### F-01 — Normal

**Reference:** §4.2 Main borrowing flow; `FR-REQ-07`; Appendix A, G-31 approval workflow.

**Problem:** The main borrowing flow shows the owner approving or rejecting the request before the parties meet, inspect the item and make payment. In contrast, G-31 says the owner should approve only after the borrower has completed the inspection, condition documentation and payment. These represent different approval sequences for the same rental.

**Why it matters:** The order of approval, inspection and payment determines when a request becomes a confirmed rental, when the item is reserved and which actions are available to each party. Different interpretations can produce inconsistent status, payment and handover behavior.

**Recommendation:** Select one authoritative sequence and update the process flow, functional requirements and status model to match it. State whether initial owner approval is provisional or final, and identify the event that confirms the rental and starts the rental period.

**Team F response / disposition:** Pending.

### F-02 — Normal

**Reference:** `FR-REQ-08`; §4.1 Request lifecycle; §4.2 Main borrowing flow.

**Problem:** In the inspection-failure branch of §4.2, the system rejects the rental request after it has already been approved. However, `FR-REQ-08` permits only Pending-to-Approved, Pending-to-Rejected, Approved-to-Completed, Approved-to-Overdue and Overdue-to-Completed transitions. Approved-to-Rejected is not allowed.

**Why it matters:** The process flow asks for a state transition that the formal state-machine requirement forbids. It is also unclear what happens to any rental payment or deposit that has already been recorded before inspection failure.

**Recommendation:** Define the correct post-approval failure state (for example, a cancellation/inspection-failed state) and its allowed transitions. Specify the corresponding payment/deposit outcome and add acceptance tests for inspection failure before and after payment.

**Team F response / disposition:** Pending.

### F-03 — Normal

**Reference:** `FR-REQ-04` and `FR-REQ-09`, §3.2.4.

**Problem:** The requirements reject a request that overlaps an existing Pending or Approved booking and permit several non-overlapping bookings for one listing. They do not specify how the system prevents two simultaneous requests for overlapping times from both passing the availability check before either is saved.

**Why it matters:** A simple check-then-save sequence can allow conflicting bookings under concurrent use, even if each request passes the rule when checked independently. This threatens the central booking guarantee.

**Recommendation:** Specify that overlap validation and booking creation must be atomic (or otherwise serialized) for the same listing. Add a concurrent test in which two overlapping requests are submitted at the same time and only one can remain Pending/Approved.

**Team F response / disposition:** Pending.

### F-04 — Normal

**Reference:** `FR-REQ-05`, §3.2.4.

**Problem:** The hourly calculation is described as using hours and minutes “with minimum”, but the minimum billable period and rounding rule are not defined. The accompanying team comment also says the calculation needs to be narrowed down to minutes.

**Why it matters:** Different developers could calculate the same rental differently for partial hours, short rentals or boundary times. This affects the price shown before submission and the recorded amount used later in the payment flow.

**Recommendation:** Define the minimum billable duration, whether partial units are rounded up or down, the treatment of seconds, and the exact formula for the hourly price. Add examples for a duration shorter than the minimum and for a duration crossing a unit boundary.

**Team F response / disposition:** Pending.

### F-05 — Normal

**Reference:** `FR-LST-06`, `FR-REQ-09`, §3.2.2 and §3.2.4; §6.2, question 5.

**Problem:** `FR-REQ-09` permits multiple non-overlapping bookings of one listing, but `FR-LST-06` uses one listing-level status of Available, Pending or Booked. The SRS note says the listing becomes Booked as soon as it has one approved request, even when other dates are free, and the open-issues section asks whether this should remain the behavior.

**Why it matters:** A listing can be displayed as unavailable even when the requested dates do not overlap an existing booking. This can mislead browsing, filtering and availability decisions.

**Recommendation:** Decide whether availability is a listing-level summary or a date/time-specific state. Define how the status is calculated when one or more bookings exist and ensure the browse/search requirements distinguish a fully unavailable listing from one with remaining availability.

**Team F response / disposition:** Pending.

### F-06 — Normal

**Reference:** `FR-PAY-05` to `FR-PAY-08`; §3.5 data requirements; §4.2 Main borrowing flow.

**Problem:** The process flow allows a borrower to dispute a damage report within 48 hours, after which the owner may revise or uphold the charge and the agreed charge is deducted from the deposit. However, the data requirements only say that dispute status starts as “Not Disputed”; they do not define the remaining dispute states. The requirements also do not clearly state when the 48-hour period expires, when an undisputed charge is settled, or how the remaining deposit is refunded after a damage deduction. `FR-PAY-06` explicitly describes a refund only for Good Condition, while the flow describes refunding the remainder in the Damaged branch.

**Why it matters:** The parties and implementers cannot determine when the deposit is still held, when a charge becomes final, or when a borrower is entitled to the remaining amount. The data model also lacks a complete state vocabulary for the dispute workflow.

**Recommendation:** Define the deposit and dispute state transitions, the event that starts the 48-hour window, the result if no dispute is filed, the outcome if a dispute is filed, who can resolve it, when the charge is settled and how any remaining deposit is refunded. Align the requirements, allowed values and process flow.

**Team F response / disposition:** Pending.

### F-07 — Normal

**Reference:** §1.2 Product scope; `FR-PAY-10`; §2.5 Constraints; §6.2, question 2.

**Problem:** The product scope says real online payment processing is out of scope, and the payment note states that the current QR flow is simulated and moves no money. At the same time, `FR-PAY-10` says the system shall support online payment through an external provider, even though it is marked Could/Under study, and §6.2 asks whether real payment is in scope.

**Why it matters:** The release boundary remains undecided. Developers and reviewers cannot tell whether the external payment requirement is part of the assessed product, a future option or explicitly excluded from the current baseline.

**Recommendation:** Record the decision in the product scope and requirement status. If real payment is out of scope for the current release, mark `FR-PAY-10` as deferred/out of scope for that release and retain the simulated payment behavior as the baseline. If it is included, specify provider interactions, failure handling and verification expectations.

**Team F response / disposition:** Pending.

### F-08 — Normal

**Reference:** `FR-AUTH-01`, `FR-AUTH-02`, `SEC-01`; §2.3; §6.2, question 3.

**Problem:** The application is described as a platform for Beihang University students. Registration collects a student ID and restricts email addresses to `@buaa.edu.cn`, but the SRS explicitly notes that the student ID is not checked against any source and leaves the verification source as an open question.

**Why it matters:** A verified university-domain email confirms control of that email address, but the SRS does not define how the separate student-ID field establishes that the registrant is an eligible student. The eligibility rule is therefore not fully specified.

**Recommendation:** Define the authoritative source or procedure for validating student IDs, or explicitly state that the current release only verifies university-email ownership and does not independently verify student status. Align the scope and user-class description with that decision.

**Team F response / disposition:** Pending.

### F-09 — Normal

**Reference:** §2.1–§2.3; §3.2; §3.3; §3.5 Data requirements.

**Problem:** The SRS stores personal and account-linked information including names, university emails, student IDs, password hashes, messages, ratings, rental requests, damage/dispute details and uploaded photos. It does not define user account deletion, data-export behavior or retention periods for these records and related copies such as logs and backups.

**Why it matters:** Without a data-lifecycle requirement, the team cannot determine how long account and transaction data remains available, what happens when a user leaves the platform, or how records are handled when they are no longer needed. This is also relevant to the trust expectations of a university-only service.

**Recommendation:** Add a data-lifecycle section that identifies the main personal-data categories, their purposes, retention periods, deletion/anonymisation behavior, treatment of transaction history, and any exceptions for unresolved rentals or disputes. Include corresponding verification methods.

**Team F response / disposition:** Pending.

### F-10 — Normal

**Reference:** `FR-LST-07`, `NFR-REL-02`, §3.4 notes.

**Problem:** `NFR-REL-02` requires a daily database backup, but photos are stored on local disk and the SRS explicitly states that they are not covered by the database backup. The product also relies on listing photos and the process flow includes condition photos as evidence.

**Why it matters:** A database restore may recover listing and rental records while leaving their associated photos unavailable. This can reduce the usefulness of listing records and remove evidence that the process flow expects to rely on.

**Recommendation:** Define whether uploaded media is part of the backup/recovery scope. If it is, specify how media files are backed up together with their database references and how restoration is verified. If not, explicitly document the data-loss limitation and its effect on the product workflow.

**Team F response / disposition:** Pending.

### F-11 — Normal

**Reference:** §4.2 Main borrowing flow; Appendix A, G-31 item-condition documentation; §3.5 Data requirements.

**Problem:** The workflow says the borrower uploads photos of the item's condition before handover so they can be compared with its condition on return. G-31 marks parts of this workflow as resolved, but the functional-requirement tables do not provide a specific requirement for capturing, associating and retrieving those rental-condition photos. The data-entity summary lists a photo path for equipment but does not identify a rental-specific condition-evidence record or its relationship to a borrowing request.

**Why it matters:** Listing photos and time-specific condition evidence serve different purposes. Without a requirement and data relationship, the system's expected evidence trail, access rules and verification are unclear.

**Recommendation:** Add a requirement for pickup/return condition evidence, including who uploads it, its association with a specific borrowing request, permitted file types and sizes, who can view it, and its retention/deletion behavior. Add the related data fields/entity and acceptance tests.

**Team F response / disposition:** Pending.

### F-12 — Normal

**Reference:** `FR-LST-04`, `FR-REQ-04`, `FR-REQ-07`; §3.2.2 team comment.

**Problem:** `FR-LST-04` lets an owner edit their own listings without stating which fields may be edited while a request is Pending or an item is Approved/Overdue. The team comment says editing should be blocked during a booking, but this restriction is not part of the requirement or its acceptance criteria.

**Why it matters:** Changes to availability, price, deposit, condition or pickup/return rules could affect a rental request that was submitted using the previous listing values. The SRS does not say whether existing requests retain a snapshot or adopt changed values.

**Recommendation:** Define which edits are allowed in each listing/booking state, whether price and terms are snapshotted when a request is created, and what happens to pending requests if the owner changes the listing. Add acceptance cases for editing during Pending and Approved bookings.

**Team F response / disposition:** Pending.

### F-13 — Minor

**Reference:** §2.2 Product functions; `FR-ADM-01` to `FR-ADM-04`, §3.2.9.

**Problem:** The product-functions summary says an administrator role handles moderation. However, all four administrator requirements are marked Not Done, with priorities ranging from Should to Could, and the SRS does not identify the release or milestone in which they are expected.

**Why it matters:** Readers cannot tell whether moderation is part of the current assessed scope or a future enhancement. The summary can therefore imply a capability that the requirement status table says is not yet implemented.

**Recommendation:** State whether administrator moderation is included in the current release. If deferred, move it to the out-of-scope/future-release statement and assign a target milestone or release. If in scope, identify the minimum administrator capabilities required for the demo.

**Team F response / disposition:** Pending.

### F-14 — Minor

**Reference:** `NFR-PERF-01`, §3.4.

**Problem:** The performance requirement is marked “Done”, while its target is explicitly labelled “proposed target, to confirm”. The note also explains that the benchmark uses an in-process test client and is not a real-network or production-host measurement.

**Why it matters:** A requirement should not be treated as finally verified against a threshold that has not yet been approved. The measurement context also needs to be clear so the result is not interpreted as production end-to-end performance.

**Recommendation:** Confirm or revise the 2-second/95th-percentile target, then update the status. State that the existing result validates the defined in-process benchmark only, and identify whether a separate deployment/network measurement is required.

**Team F response / disposition:** Pending.

### F-15 — Minor

**Reference:** §6.1–§6.2 and Appendix A, G-31.

**Problem:** The open-issues section contains the incomplete sentence “Hourly borrowing and the is scope and built. Please confirm this is the intended scope.” The question numbering jumps from 3 to 5. In Appendix A, several G-31 workflow items have blank states, and the supplied file ends immediately after the second hourly-rental item without completing the table or recording the remaining workflow decisions.

**Why it matters:** The reader cannot reliably distinguish resolved, in-progress and unresolved workflow decisions from the appendix. The incomplete wording and table also make it difficult to use this material as a controlled record of scope decisions.

**Recommendation:** Correct the sentence, reconcile the question numbering, and complete the G-31 table with an explicit state for each item (Resolved, In progress, Not resolved or Deferred). Confirm that the final submitted SRS includes the complete appendix.

**Team F response / disposition:** Pending.

---

## 4. Group discussion summary

1. **Agree on one rental lifecycle.** The highest-value improvement is to make the approval, inspection, payment, handover, return, overdue and dispute sequence consistent across the process flow, requirements and status model.
2. **Make transaction rules precise.** Team F should define hourly-price rounding, concurrent booking prevention, listing availability semantics, editing restrictions during bookings, and the deposit/dispute settlement states.
3. **Close the student-eligibility and data-lifecycle questions.** The SRS should explain what the university-email check proves, how student eligibility is established, and how personal data and uploaded evidence are retained, exported, deleted and backed up.
4. **Separate current scope from future work.** Decide whether real online payment and administrator moderation belong to the current release or are deferred. Reflect the decision consistently in the scope statement, requirement priorities and statuses.
5. **Complete the documentation baseline.** Resolve the open G-31 items, complete the appendix, confirm the provisional performance target and ensure each requirement has an unambiguous verification outcome.
6. **Close the review through individual dispositions.** Team F should respond separately to F-01 through F-15, indicating Accepted, Partially accepted or Not accepted, with a correction, clarification, planned action or reason. The issue should remain open until all findings have recorded dispositions.

**Review conclusion:** CampusShare's SRS v0.3 provides a useful draft foundation and is transparent about several known implementation limitations. Before it can serve as a reliable baseline, the team should align its rental lifecycle, resolve ambiguous transaction rules, and complete the data, evidence and scope definitions identified in these 15 findings.
