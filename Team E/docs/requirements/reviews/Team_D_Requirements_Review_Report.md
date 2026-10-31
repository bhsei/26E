# Team E Peer Review Report — Team D: NewEra POS

**Reviewer team:** Team E  
**Reviewee:** Team D — NewEra POS  
**Reviewed document:** Software Requirements Specification — NewEra POS  
**SRS version:** 1.0  
**SRS date:** 28 October 2026  
**Review date:** 1 November 2026  
**Review stage:** First review — SRS document only

> **Review scope:** This assessment evaluates the submitted SRS as a requirements document, focusing on clarity, completeness, consistency, traceability and verifiability. It does not evaluate the implemented application, source code, runtime behavior, actual payment processing, hardware devices or external service integrations. The system/application together with the finalized SRS will be assessed during the subsequent review.

## Report structure

1. Overall distribution overview
2. Issue list summary
3. Review comment responses
4. Group discussion summary

---

# 1. Overall distribution overview

## 1.1 Overall review result

Team D's NewEra POS SRS is a structured and relatively detailed specification for a retail point-of-sale system. It contains five goal-oriented use cases, substantial main and alternative flows, functional and interface requirement identifiers, data requirements, business rules and a list of open questions.

The document makes a useful distinction between the Customer as a stakeholder and the direct actors who operate the register. It also attempts to connect use cases with functional requirements, interface requirements and business rules.

However, the review identified several important areas requiring clarification. The most significant specification gaps concern payment and refund timeouts, offline employee authentication, financial calculations, rental and inventory consistency, cashier-session management, external-system recovery and verification traceability.

The review identified **18 findings: 2 Severe, 12 Normal and 4 Minor**.

These classifications represent the potential impact of the specification gaps. They are not findings from application execution or implementation testing.

## 1.2 Severity distribution

| Severity | Number of findings | Percentage | Finding IDs |
|---|---:|---:|---|
| Severe | 2 | 11.1% | D-01, D-02 |
| Normal | 12 | 66.7% | D-03 to D-14 |
| Minor | 4 | 22.2% | D-15 to D-18 |
| **Total** | **18** | **100%** | **D-01 to D-18** |

## 1.3 Main review themes

The findings are concentrated in five areas:

**1. Financial transaction semantics**

The SRS needs to distinguish confirmed payment failure from an unknown outcome after a timeout. It should also define the reconciliation process before retrying a card payment or selecting an alternative refund method.

**2. Authentication and authorization**

The specification needs an explicit freshness limit and fallback policy for the offline employee cache. The cashier and manager session rules also require clarification.

**3. Business rules and data integrity**

The rental-allocation process, returned-item condition, damage and late-fee calculations, tax treatment and stock-discrepancy handling need more deterministic definitions.

**4. Quality and verification**

Performance and availability targets need measurable conditions. Acceptance scenarios should cover the important workflows and alternate paths, with clear traceability to requirements.

**5. Documentation consistency**

Tender-specific payment fields, referenced companion artifacts, and cross-document versions and links need to be made consistent and reviewable.

## 1.4 Distribution by review topic

| Review topic | Finding IDs | Count |
|---|---|---:|
| Payment and financial calculations | D-01, D-05, D-06, D-15 | 4 |
| Authentication and authorization | D-02, D-12, D-14 | 3 |
| Inventory, returns and rental workflows | D-03, D-04, D-07 | 3 |
| Operational and external-system reliability | D-08, D-10 | 2 |
| Quality and verification | D-09, D-13, D-16, D-17 | 4 |
| Compliance and documentation | D-11, D-18 | 2 |
| **Total** | **D-01 to D-18** | **18** |

---

# 2. Issue list summary

The following findings are based on the supplied NewEra POS SRS v1.0. Each finding identifies its location, the problem, its significance, recommended correction and suggested evidence for eventual verification.

These are specification findings, not results of implementation testing.

## D-01 — Define safe handling for payment and refund timeouts before real payment integration

**Severity:** Severe  
**Area:** Financial integrity / Payment lifecycle

**Location:** UC1 extension 9b2b; FR-11; UC2 extension 9b2a and FR-26; UC5 extension 9b2a and FR-55; IR-02/IR-03.

**Finding:**

The SRS permits retrying a card payment after the Payment Service does not answer, and permits a cash refund when a card refund does not answer.

A timeout or dropped connection does not establish that the remote payment or refund was not processed. The service could have completed the transaction while its response was lost.

**Why it matters:**

Without an explicitly defined transaction identity and reconciliation process, a retry may charge the customer twice. Similarly, a cash fallback may refund a transaction that has already been refunded to the customer's card.

The specification therefore does not fully define a safe financial transaction lifecycle, particularly if the simulated services are later replaced by a real payment provider.

**Recommendation:**

Specify an idempotency or transaction reference for every payment and refund attempt. Distinguish between:

- Confirmed Declined
- Confirmed Failed
- Outcome Unknown
- Reconciliation Pending
- Successfully Completed

Require the POS to reconcile the original transaction before retrying or selecting an alternative refund tender.

Define the operator procedure for unresolved outcomes. A timeout must not be treated as equivalent to a confirmed decline.

The SRS should identify this as a release condition before integration with a real payment provider.

**Suggested verification evidence:**

Define scenarios in which a payment or refund succeeds remotely but the response is lost. Subsequent retries must not create a second charge or refund. The verification plan should separately cover declined, confirmed-failed, unknown-outcome and reconciliation-pending states.

## D-02 — Set a maximum age and secure fallback policy for the cached employee list

**Severity:** Severe  
**Area:** Authentication / Offline authorization

**Location:** IR-09; FR-45/FR-46; UC4 extension 6c; §1.5 assumptions/open questions; UC4 open issues.

**Finding:**

When the HR System is unavailable, the POS authenticates against a local employee list.

The SRS explicitly acknowledges that a dismissed employee may remain able to log in until the next synchronization. However, the permitted cache age and refresh interval remain unresolved.

The document also leaves repeated incorrect-PIN lockout behavior as an open question.

**Why it matters:**

The specification does not establish how long outdated employee authorization information may remain valid or what happens when the local cache becomes too old.

It also does not sufficiently define protection against repeated incorrect authentication attempts during offline operation.

**Recommendation:**

Define:

1. The maximum permitted age of the employee cache.
2. The expected synchronization interval.
3. Behavior when the cache is stale or unavailable.
4. Failed-PIN throttling and lockout rules.
5. The offline authorization policy.
6. Manager override and recovery procedures.
7. Protection of local employee credential information.

If the cache exceeds the approved age, specify whether register access is blocked or whether a limited, explicitly authorized degraded mode is permitted.

**Suggested verification evidence:**

The verification plan should cover fresh, stale and missing employee caches; active and disabled employees; correct and incorrect PINs; repeated failures; and recovery when the HR System becomes available again.

## D-03 — Specify atomic rental allocation across multiple registers

**Severity:** Normal  
**Area:** Concurrency / Inventory integrity

**Location:** UC3 open issues; FR-32/FR-33/FR-38; DR-02; Appendix 5.3 open question 6.

**Finding:**

The open questions state the working assumption that only one of two registers attempting to rent the same item will succeed.

However, the requirements check that an item is Available before payment and change it to Rented when the completed rental is saved. They do not specify an atomic reservation or concurrency rule spanning these operations.

**Why it matters:**

Two registers could both observe an item as Available, accept payment and attempt to complete a rental for the same serial-numbered item.

The SRS does not fully establish how this conflicting transaction should be prevented or resolved.

**Recommendation:**

Specify the atomicity boundary for reserving an item, processing payment and committing the rental.

Define:

- The temporary item state or reservation rule.
- The concurrency-control expectation.
- Timeout and cancellation behavior.
- How a competing rental request is rejected.
- How the system handles the payment associated with an unsuccessful competing transaction.

**Suggested verification evidence:**

The verification plan should include two concurrent rental attempts for the same serial number. Exactly one should be permitted to complete, and the unsuccessful attempt should not create an unintended charge or leave the item in an inconsistent state.

## D-04 — Define inventory handling for damaged or unsellable returned sale items

**Severity:** Normal  
**Area:** Returns / Stock integrity

**Location:** UC2 success guarantees, especially the postcondition on increasing stock; UC2 open issues; FR-27; DR-08.

**Finding:**

The UC2 postconditions state that the stock level of each returned product is increased by the returned quantity.

The open issues separately ask whether damaged or used returned items should be kept out of stock. However, the return workflow does not record item condition or define the inventory disposition.

**Why it matters:**

A damaged or unsellable item could be returned directly to available stock and sold again. Alternatively, the specification may not provide a way to represent the actual condition of returned goods.

**Recommendation:**

Define the accepted return conditions and how each condition affects stock.

If item-condition assessment is required, include it in UC2, the corresponding functional requirements and the data model.

Distinguish between:

- Saleable stock.
- Items requiring inspection.
- Items requiring repair.
- Damaged or unsellable items.
- Items requiring disposal or another approved disposition.

**Suggested verification evidence:**

Define acceptance scenarios covering normal resaleable returns and damaged or unsellable returns. Each outcome should produce the correct documented inventory state and quantity.

## D-05 — Resolve the contradictory deposit treatment when a rental is both damaged and late

**Severity:** Normal  
**Area:** Rental return / Financial calculation

**Location:** UC5 extension 6a and 7a/7b; FR-54; BR-10 (referenced); UC5 open issues.

**Finding:**

UC5 extension 6a states that a damaged item causes the entire deposit to be retained and no refund to be paid.

The same flow then continues to the late-fee calculation, which says the late fee and tax are taken from the deposit and the refund is calculated as deposit minus fee and tax.

FR-54 combines these rules without defining the order or allocation.

**Why it matters:**

The specification does not establish whether damage retention and late fees are independent, cumulative or mutually exclusive.

This may produce contradictory financial calculations, double-counting of the deposit or unclear handling when the late fee exceeds the remaining deposit.

**Recommendation:**

Define the calculation for all relevant combinations:

1. Undamaged and returned on time.
2. Undamaged and returned late.
3. Damaged and returned on time.
4. Damaged and returned late.
5. Late fee and tax exceeding the deposit.

Specify whether damage retention is a fixed amount or assessed charge, how it interacts with late fees and tax, and when an additional payment is required.

Align UC5, FR-54, BR-10, receipts and accounting requirements.

**Suggested verification evidence:**

Provide worked examples and corresponding verification scenarios for all combinations, including boundary cases where fees equal or exceed the deposit. All displayed amounts should reconcile with the specified calculation.

## D-06 — Choose the tax basis for a returned sale and define rounding

**Severity:** Normal  
**Area:** Returns / Tax calculation

**Location:** FR-23; UC2 special requirements/open issues; §1.5 open questions; DR-17; Appendix 5.3 open question 8.

**Finding:**

FR-23 calculates the refund using tax obtained from the Tax Calculator.

However, UC2 explicitly leaves unresolved whether the refund should use the tax from the original sale or the tax rate on the return date.

The currency and tax-rounding method are also open.

**Why it matters:**

The refund amount and accounting correction may vary depending on which interpretation is used. The requirement therefore does not yet define a single deterministic business rule.

**Recommendation:**

Define the authoritative tax and refund rule based on the intended business case and applicable tax policy.

Specify:

- Whether the original transaction tax is authoritative.
- How tax corrections are represented.
- The transaction currency.
- The rounding precision.
- Whether rounding occurs per line or per transaction.
- How the Accounting System receives the resulting adjustment.

Align FR-23, DR-03/DR-08/DR-17, acceptance criteria and the Accounting System interface.

**Suggested verification evidence:**

Define boundary-value scenarios covering partial returns, discounted items, multiple quantities, rounding and tax-rate changes between the original sale and return. The expected result should reconcile with the documented rule.

## D-07 — Record stock discrepancies instead of silently clamping negative stock to zero

**Severity:** Normal  
**Area:** Inventory / Auditability

**Location:** UC1 extension 11c; FR-19; FR-14; DR-01.

**Finding:**

If a sale would push stock below zero, UC1 states that the sale is completed, stock is set to zero and a stock check is flagged.

FR-19 repeats this behavior but does not require recording the shortage quantity or an auditable adjustment.

**Why it matters:**

Setting stock to zero discards the magnitude of the discrepancy.

Subsequent reconciliation may be unable to determine the difference between the physical quantity, attempted sale quantity and stored stock history.

**Recommendation:**

Define the intended exception policy and require an auditable stock-discrepancy record that preserves:

- Observed quantity.
- Attempted stock decrement.
- Resulting stock quantity.
- Affected transaction.
- Discrepancy amount.
- Review status.

Clarify whether a sale may complete in this situation and what warning or approval is required.

**Suggested verification evidence:**

Define a scenario in which a sale quantity exceeds recorded stock. The documented business rule should determine whether the sale completes, and the resulting discrepancy record should preserve the variance for reconciliation.

## D-08 — Resolve the cashier-session end and shift-handover gap

**Severity:** Normal  
**Area:** Session lifecycle / Cash management

**Location:** UC4 open issues; DR-09; UC4 postconditions; §1.3.1 operations.

**Finding:**

The POS explicitly models opening cash, a single active cashier session per register and transactions linked to that session.

However, the SRS also states that there is no use case for logging out or closing the register and leaves session termination out of scope.

**Why it matters:**

Without a defined end or handover rule, the specification does not fully describe cash reconciliation, session end-time recording, shift changes or what happens to an open register at store closing.

If this is intentionally excluded, the operational boundary and alternative procedure should be clear.

**Recommendation:**

Either introduce a close-session/shift-handover use case covering:

- Cash counting.
- Expected-versus-actual reconciliation.
- Outstanding transactions.
- Pending accounting records.
- Manager exception handling.
- Register closing and restart.

Alternatively, explicitly justify the exclusion and define how the single-session rule is maintained between cashiers and at store closing.

Align UC4, DR-09 and the operating assumptions.

**Suggested verification evidence:**

The future verification plan should cover normal shift closing, mismatched cash, pending accounting records, open transactions, manager handover and register restart.

## D-09 — Define measurement conditions for performance and uptime targets

**Severity:** Normal  
**Area:** Quality attributes / Measurement

**Location:** NFR-01, NFR-02, NFR-03; UC1/UC4 special requirements; §4 Verification.

**Finding:**

The SRS sets item-entry under one second, start-up under 30 seconds and 99.9% uptime during store hours.

However, it does not define the test hardware, workload, measurement window, uptime boundary or how planned maintenance and external-system outages are counted.

UC4 also states that sending the accounting queue must not delay readiness.

**Why it matters:**

The targets cannot be reproduced consistently without defined measurement conditions.

Different interpretations of system availability and dependency outages may produce inconsistent results. Startup readiness may also be interpreted differently if queue synchronization is synchronous.

**Recommendation:**

Define:

1. The start and end events for the NFR-01 measurement.
2. The workload and hardware conditions.
3. Exactly when the 30-second startup measurement begins and ends.
4. The period over which 99.9% uptime is measured.
5. How planned maintenance and external-system outages are treated.
6. How availability is reported.

Clarify whether queued accounting delivery must not prevent the register from reaching its specified ready state.

**Suggested verification evidence:**

Define a repeatable test protocol specifying hardware, software, workload and measurement window, with pass/fail thresholds for each quality requirement.

## D-10 — Complete the Accounting System queue policy for long outages and recovery

**Severity:** Normal  
**Area:** External integration / Reliability

**Location:** IR-06/IR-07; DR-12/DR-13; UC4 extensions 3a/3b; NFR-19; Appendix 5.3 open question 9.

**Finding:**

The SRS requires local queued records to be delivered in order and deleted only after acknowledgement.

However, the Accounting System has no timeout defined in the interface table, and NFR-19 defines timeouts only for payment, tax and HR.

The SRS also leaves open how long the POS may operate without the Accounting System before a manager is warned.

**Why it matters:**

The specification does not define how the POS detects a stalled acknowledgement, retries delivery, warns operators or handles a growing local queue during a prolonged outage.

**Recommendation:**

Specify:

- Accounting System request timeout.
- Retry and backoff policy.
- Duplicate-delivery and idempotency expectations.
- Queue capacity and retention behavior.
- Manager alert threshold.
- Recovery and reconciliation procedure.
- POS functions that remain available during the outage.
- Behavior when the queue approaches its storage limit.

**Suggested verification evidence:**

Define scenarios covering timeouts, lost acknowledgements, duplicate delivery, prolonged outages, queue recovery and a queue close to its configured limit. The expected results should establish that no accounting record is lost or counted twice.

## D-11 — Do not equate card masking and data minimization with full PCI DSS or GDPR compliance

**Severity:** Normal  
**Area:** Standards / Compliance claims

**Location:** NFR-11, NFR-12; DC-06; DR-05/DR-18; §3.7 Standards compliance.

**Finding:**

NFR-11 states that the system complies with PCI DSS by masking card numbers on receipts, and NFR-12 states that it complies with GDPR by not storing unnecessary personal data.

These are relevant controls, but the SRS does not define the compliance scope, applicable obligations or evidence required to support the full claims.

**Why it matters:**

The wording may promise a level of regulatory or standards compliance that is not established by the listed controls alone.

The system also handles payment integration and employee/customer information, whose applicable requirements depend on the actual deployment and processing arrangements.

**Recommendation:**

Replace blanket claims with specific, verifiable security and privacy requirements.

Identify the responsible owner for determining applicability. Document the payment-data flow, system boundary, retained fields, access, transmission, retention/deletion and supporting evidence.

If full compliance has not been assessed, state that masking and data minimization are individual safeguards rather than proof of complete compliance.

**Suggested verification evidence:**

Define an applicability statement and control checklist mapping each compliance claim to specific requirements and supporting evidence. Unsupported claims should be removed or qualified.

## D-12 — Specify protection for PINs sent to the HR System and stored in the offline cache

**Severity:** Normal  
**Area:** Credential security / Interface protection

**Location:** IR-08/IR-09; FR-44/FR-45; DR-11; NFR-08; §3.1.3.

**Finding:**

IR-08 sends the employee ID and PIN to the HR System, and the local employee list keeps a salted PIN hash for offline validation.

The SRS does not specify transport protection and authentication for the HR interface or detailed protection of the local credential cache and its logs/backups.

**Why it matters:**

The rule that credentials must never be stored in plaintext does not fully describe protection while PINs are transmitted or safeguards against exposure through diagnostic logs and local files.

**Recommendation:**

Define:

- Authenticated and integrity-protected transport for the HR interface.
- Credential handling in memory.
- Restrictions on logging PINs or credential values.
- Protection and access restrictions for the local cache.
- Credential-hash parameters at an appropriate specification level.
- Cache update and revocation behavior.
- Logging behavior when communication fails.

Ensure failed communication events are recorded without including credential values.

**Suggested verification evidence:**

Define interface-security verification covering protected transport, absence of PINs in logs, protected local credential data and expected offline authentication behavior.

## D-13 — Provide testable acceptance coverage for UC2–UC5 and critical extensions

**Severity:** Normal  
**Area:** Verification / Traceability

**Location:** §4 Verification; §4.1 AC-01–AC-05; §5.2 Traceability matrix (referenced external artifact).

**Finding:**

Within the supplied SRS, detailed Given/When/Then acceptance criteria are provided only for five UC1 cases.

The general verification table groups broad requirement ID ranges into test types, while the full traceability matrix and detailed test cases are referenced in another file that was not included in the review upload.

**Why it matters:**

From the submitted SRS alone, there is not enough information to confirm that return, rental, rental-return and start-up alternate paths are individually testable and traceable.

This may already be covered by the linked companion file; its contents could not be checked during this review.

**Recommendation:**

Ensure `requirements_conventions.md` and the referenced traceability matrix are included and their links resolve in the repository.

Add or link explicit acceptance scenarios for UC2–UC5 and important extensions, including:

- Refund failure and unknown payment outcomes.
- Damaged and late rental returns.
- Concurrent rental attempts.
- Stale offline employee lists.
- Accounting queue retries.
- Recovery following unexpected interruption.

Map each scenario to its requirement IDs and test cases.

**Suggested verification evidence:**

A reviewer should be able to follow every high-priority requirement to an acceptance scenario, test case, expected result and eventual recorded outcome. The referenced companion artifact should be available at a versioned repository path.

## D-14 — Clarify the store manager's session and authorization model

**Severity:** Normal  
**Area:** Authorization / Role model

**Location:** §1.3.1; IR-08; FR-40/FR-43; UC4 open issues; manager actions described in §1.3.1 and IR-05/IR-09.

**Finding:**

The SRS states that the HR System identifies both cashiers and store managers, and that managers may authenticate at the register for overrides without closing the cashier session.

However, IR-08 and FR-40 describe opening a cashier session only for a valid active cashier, while UC4 leaves open whether a manager may open a session.

**Why it matters:**

The documented role and session rules do not establish whether a manager operates only through a step-up approval context or can also open an ordinary cashier session.

Transaction attribution and accountability for manager actions are also unclear.

**Recommendation:**

Define a role/session state model that specifies:

- Which roles may open a cashier session.
- How a manager authenticates to approve an exception during a cashier's session.
- Whether manager actions leave the cashier session intact.
- Whose identity is recorded for the transaction.
- How the manager approval is recorded.
- How the same policy applies to tax changes and local employee disabling.

**Suggested verification evidence:**

Define role-based scenarios for cashier login, manager approval, manager-only settings, transaction attribution and unauthorized role attempts.

## D-15 — Clarify what "last four digits" means for check payments

**Severity:** Minor  
**Area:** Data model / Tender-specific fields

**Location:** DR-05; UC1 extension 9c; FR-12; glossary/check-payment interface references.

**Finding:**

DR-05 states that for a credit-card or check payment, only the last four digits and the authorization code are stored.

The phrase "last four digits" is clear for a card number but not for a check unless the field, such as the check number, is explicitly identified.

**Why it matters:**

The data model may store an undefined field or retain more check/payment information than the requirement intends.

**Recommendation:**

Separate card and check payment fields.

Specify exactly which non-sensitive reference is retained for each payment method and which values must never be stored.

Ensure receipt, data-model and logging requirements use the same definitions.

**Suggested verification evidence:**

The data dictionary defines each tender-specific field and identifies the permitted reference data for storage.

## D-16 — Reclassify or define the "three development days" payment-method target

**Severity:** Minor  
**Area:** Non-functional requirement classification

**Location:** NFR-09; DC-02; §3.8 Software system attributes.

**Finding:**

NFR-09 states that adding a payment method shall take less than three development days.

This is primarily a development-effort or productivity target rather than an observable quality attribute of the running POS. The SRS does not define the baseline change or the method for measuring development effort.

**Why it matters:**

The target may vary with team familiarity, scope and external provider requirements. It is therefore difficult to verify consistently as a product-quality requirement.

**Recommendation:**

Move this target to a maintainability/design constraint or project engineering metric, or define the exact change scenario, measurement start/end points, dependencies and acceptance method.

Retain DC-02 as the architectural decoupling requirement if that is the actual product property being protected.

**Suggested verification evidence:**

The SRS classifies the metric appropriately and defines a repeatable change scenario if the development-effort target is retained.

## D-17 — Define the test scope behind "standard" device compatibility

**Severity:** Minor  
**Area:** Hardware compatibility / Portability

**Location:** IR-11–IR-14; NFR-10; §3.1.2 Hardware interfaces.

**Finding:**

NFR-10 requires compatibility with "standard receipt printers and scanners", but the SRS does not define supported interface types, host operating environment, driver assumptions or a compatibility/test matrix.

The interface section also covers a card reader and cash drawer, which are not explicit in NFR-10.

**Why it matters:**

Terms such as "standard" and "fully compatible" can be interpreted differently, making the hardware compatibility requirement difficult to verify across register configurations.

**Recommendation:**

Define the supported connection and driver approach and a representative compatibility matrix covering:

- Barcode scanner.
- Card reader.
- Receipt printer.
- Cash drawer.
- Relevant host operating environment.

Also define expected behavior when a device is unavailable.

If the intended compatibility is limited to specified prototype devices or simulators, state that scope accurately.

**Suggested verification evidence:**

A compatibility matrix identifies supported devices and interfaces and defines successful and failure-mode verification criteria for each.

## D-18 — Ensure every referenced companion artifact is present and version-aligned

**Severity:** Minor  
**Area:** Submission completeness / Cross-document consistency

**Location:** §1.3.1, §1.3.2, §1.4, §1.5, §§3.1.3/3.2/3.5/3.9/3.10, §5.2 and relative links throughout the SRS.

**Finding:**

The SRS relies on separate artifacts for the use-case model, external-interface detail, glossary/business rules, NFRs/quality goals, stakeholders, domain model, requirements conventions/traceability matrix, project plan, UI prototype and use-case diagram.

These companion files were not included in the supplied review upload, so their contents and link resolution could not be independently checked.

**Why it matters:**

If a referenced artifact is absent, out of sync or linked through an incorrect path, the SRS becomes harder to review and may not provide sufficient context for readers receiving only the main specification.

**Recommendation:**

Submit the SRS together with the referenced deliverables or identify a clear repository release/tag where they are maintained.

Verify that:

1. Every relative link resolves from the repository root.
2. Companion artifact versions and dates are identifiable.
3. Requirements and open questions agree across documents.
4. Use-case and interface references remain consistent.
5. Traceability identifiers match the relevant artifacts.

**Suggested verification evidence:**

A clean-clone link check succeeds for every relative link, and a companion-document version/consistency review is recorded.

**Review qualification:** The companion artifacts were not included in the supplied review material. This finding does not establish that they are absent from Team D's repository. If they already exist, Team D may provide their versioned links for review.

---

# 3. Review comment responses

No Team D response or revised SRS was supplied when this report was prepared. Therefore, **all 18 findings remain Pending**.

Team D should respond to each individual GitHub finding comment with one of the following dispositions:

- **Accepted:** The finding is acknowledged and the corrected SRS section/requirement and revision or commit are identified.
- **Partially accepted:** The accepted portion, remaining concern and rationale are explained.
- **Rejected:** A reasoned explanation and supporting specification reference are provided.

Team E will examine the revised SRS or versioned companion requirements documentation before marking a finding resolved.

Acceptance by Team D alone does not mean that a finding is resolved.

The application/system and its conformity with the finalized SRS are reserved for the later review.

## 3.1 Review disposition tracker

| Finding | Severity | Team D response | Revision/commit | Team E verification |
|---|---|---|---|---|
| D-01 | Severe | Pending | — | Not yet verified |
| D-02 | Severe | Pending | — | Not yet verified |
| D-03 | Normal | Pending | — | Not yet verified |
| D-04 | Normal | Pending | — | Not yet verified |
| D-05 | Normal | Pending | — | Not yet verified |
| D-06 | Normal | Pending | — | Not yet verified |
| D-07 | Normal | Pending | — | Not yet verified |
| D-08 | Normal | Pending | — | Not yet verified |
| D-09 | Normal | Pending | — | Not yet verified |
| D-10 | Normal | Pending | — | Not yet verified |
| D-11 | Normal | Pending | — | Not yet verified |
| D-12 | Normal | Pending | — | Not yet verified |
| D-13 | Normal | Pending | — | Not yet verified |
| D-14 | Normal | Pending | — | Not yet verified |
| D-15 | Minor | Pending | — | Not yet verified |
| D-16 | Minor | Pending | — | Not yet verified |
| D-17 | Minor | Pending | — | Not yet verified |
| D-18 | Minor | Pending | — | Not yet verified |

## 3.2 GitHub review procedure

The review of SRS v1.0 should use one GitHub Issue in Team D's repository.

Each of the 18 findings should be posted as an individual comment so that every issue can be discussed and resolved independently.

Each comment should contain:

- Finding identifier.
- Severity.
- Exact SRS location.
- Problem description.
- Why the problem matters.
- Recommended correction.
- Requested team disposition.

Team D should reply to each comment and identify the relevant SRS revision or commit.

The Issue should remain open until the findings have been handled or explicitly dispositioned.

---

# 4. Group discussion summary

The following section presents Team E's reviewer synthesis and recommended discussion points. It is not presented as minutes of a meeting that has not taken place.

The discussion is limited to the requirements document. Application execution, hardware operation and external-service behavior are not part of this first review.

## 4.1 Strengths to preserve

1. The system boundary distinguishes NewEra POS from external payment, tax, accounting and HR systems.
2. Five goal-oriented use cases are separated, and UC1–UC5 contain substantial main and alternative flows.
3. The SRS considers external-system failures and local accounting queue behavior.
4. Requirements address stock quantities, return quantities, transaction records, session attribution and unique item serial numbers.
5. The data model is intended to preserve historical unit prices and financial transaction records.
6. Open questions are explicitly listed instead of silently treating every assumption as confirmed.
7. Acceptance criteria AC-01–AC-05 provide concrete test data for core sale scenarios.

## 4.2 Recommended correction order

### Priority 1 — Financial transaction and authentication policies

Address D-01 and D-02 first.

The SRS should clearly define payment/refund outcomes after timeouts and the maximum age and security policy for offline employee authentication.

These are the most consequential gaps because they affect financial integrity and register-access rules.

### Priority 2 — Transaction and inventory consistency

Address D-03 through D-07.

Clarify:

- Concurrent rental allocation.
- Damaged-item return disposition.
- Deposit, damage and late-fee calculations.
- Original-sale versus return-date tax treatment.
- Stock discrepancy recording.

These rules should produce deterministic outcomes and consistent financial/inventory records.

### Priority 3 — Operational and role definitions

Address D-08, D-09, D-10 and D-14.

Define cashier-session closure, shift handover, measurable startup/performance/availability targets, Accounting System recovery behavior and the manager authorization/session model.

### Priority 4 — Verification and security requirements

Address D-11, D-12 and D-13.

Ensure standards-compliance language is appropriately scoped, employee PIN protection is sufficiently specified, and all important use cases have traceable acceptance coverage.

### Priority 5 — Documentation and presentation consistency

Address D-15 through D-18.

Clarify tender-specific payment data, classify development-effort measurements properly, define device compatibility and verify referenced companion artifacts.

## 4.3 Reviewer conclusion

**Disposition: Revision and response requested.**

NewEra POS has a strong requirements foundation. The main opportunity for improvement is to resolve ambiguities that could lead to different financial, authorization or inventory outcomes, and to make the resulting requirements objectively verifiable.

Team E recommends that Team D prioritize D-01 and D-02, followed by the business-rule and traceability findings.

The report evaluates the SRS only. The implemented system/application will be assessed later together with the finalized SRS.

**Reviewer team:** Team E  
**Reviewed team:** Team D — NewEra POS  
**Reviewed document:** Software Requirements Specification v1.0

---

## Review basis and limitations

**Primary source:** Team D's submitted `SRS(2).md`, Software Requirements Specification — NewEra POS, Version 1.0.

**Review organization:** The four-part structure demonstrated in the professor-provided Team B Week 6 and Week 7 requirements-review presentations:

1. Overall distribution overview.
2. Issue list summary.
3. Review comment responses.
4. Group discussion summary.

**GitHub procedure:** One Issue per reviewed SRS version and one separate comment per finding, following the supplied Software Engineering GitHub Operations Guide.

**Scope limitation:** This is the first-stage SRS-document review. No source code, application behavior, hardware operation, payment execution, runtime configuration, deployment environment or external integration was tested. Referenced companion artifacts were not presumed absent; where their contents were not included in the review material, Team D may supply their controlled links and versions for assessment.

The later system/application review will assess the implemented product together with the finalized SRS.