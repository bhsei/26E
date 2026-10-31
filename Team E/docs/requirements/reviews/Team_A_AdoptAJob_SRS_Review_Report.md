# Team E Peer Review Report — Team A

## AdoptAJob — Software Requirements Specification v0.7

**Reviewing team:** Team E  
**Reviewed team:** Team A  
**Document reviewed:** AdoptAJob — Software Requirements Specification  
**Version:** 0.7  
**Document date:** 29 October 2026  
**Review date:** 1 November 2026  
**Review stage:** First-stage SRS-only review  
**Repository identified in the SRS:** `bhsei/26A`

---

## 1. Overall distribution overview

### 1.1 Review scope

This review evaluates the submitted SRS as a requirements document. The review covers the clarity, completeness, consistency, traceability and verifiability of the stated requirements; the alignment between requirements and the product description; the documented interfaces, security, privacy, quality attributes and AI/ML requirements; and the verification plan.

This is **not** a source-code, runtime, deployment, infrastructure or test-execution review. The verification statuses and implementation statements are treated as claims made by the SRS; Team E has not independently executed the application or the referenced test artifacts. The SRS references separate design and planning documents (R5–R9); their contents were not included in the supplied review package, so this report does not assume that those companion documents are absent from Team A's repository.

### 1.2 Finding distribution

| Severity | Count | Share |
|---|---:|---:|
| Severe | 0 | 0% |
| Normal | 8 | 61.5% |
| Minor | 5 | 38.5% |
| **Total** | **13** | **100%** |

### 1.3 Overall assessment

The SRS has a strong structure for a course-project requirements baseline. It identifies the product scope and exclusions, user classes, assumptions, architecture context, a substantial set of uniquely identified requirements, MoSCoW priorities, rationale, acceptance criteria, verification methods and a requirement-level verification status table. The revision history is unusually helpful in explaining changes to the baseline.

The main weaknesses are concentrated in several high-impact requirement interactions rather than a general absence of structure. Most importantly, one AI acceptance criterion appears to reverse the behavior required by its own statement; the authorization wording is internally ambiguous; the account-deletion requirements conflict with the promised view of existing matches; and the graph-copy deletion guarantee needs a failure-path rule. A smaller set of findings concerns measurable acceptance criteria, reference control and a POC milestone whose planned completion date has passed.

---

## 2. Issue list summary

| ID | Severity | SRS reference | Issue summary |
|---|---|---|---|
| A-01 | Normal | REQ-ML-004, §3.6.1 | Red-flag acceptance criterion says no excluded card is excluded, contradicting the stated exclusion rule. |
| A-02 | Normal | REQ-SEC-003, REQ-FUNC-016, §3.3.2 | Broad own-data-only rule conflicts with the intended recruiter visibility of candidate information after a like. |
| A-03 | Normal | REQ-FUNC-004, REQ-COMP-001, §3.2.1, §3.4 | Permanent deletion of matches/messages conflicts with the other party seeing an existing match as “Account deleted”. |
| A-04 | Normal | REQ-FUNC-004, REQ-ML-008, §3.2.1, §3.6.2 | The 24-hour graph-deletion guarantee is not bounded when graph rebuild retries fail and the previous graph is retained. |
| A-05 | Normal | REQ-COMP-001, §3.4 | The 12-month inactivity deletion rule does not define inactivity or the automatic deletion trigger sufficiently. |
| A-06 | Normal | REQ-COMP-004, §3.4 | Non-discrimination verification checks direct input fields only; the stated fairness objective has no output/proxy evaluation criteria. |
| A-07 | Normal | REQ-ML-001, REQ-ML-007, Appendix B issue 2 | Ranking tests verify deterministic score behavior but do not define a criterion for ranking relevance or quality. |
| A-08 | Normal | REQ-SEC-006, §3.3.2 | The acceptance criteria do not verify the specified aggregate 100-attempts-per-IP limit. |
| A-09 | Minor | REQ-COMP-002, §3.4 | The data-export acceptance criteria do not explicitly resolve coverage of CV files and other stored personal-data categories. |
| A-10 | Minor | References R5–R9, §1.4; cross-references in §3 | Referenced design artifacts are labelled “Current” without a version, date or commit identifier. |
| A-11 | Minor | REQ-MAINT-002, §3.5.4 | The acceptance criterion requires a coverage report but does not repeat the 60% pass threshold. |
| A-12 | Minor | REQ-MAINT-003, §3.5.4 | The requirement includes both formatter and linter, but the acceptance criterion checks only the linter. |
| A-13 | Minor | REQ-POC-001, §3.5.9; §4 | The POC's planned end date is 28 October, before the SRS date of 29 October, but its verification status remains Planned. |

---

## 3. Review comment responses

The following findings are formatted as separate review comments. Each should be posted as its own GitHub comment so Team A can respond to each finding independently.

### A-01 — Normal

**Reference:** `REQ-ML-004: Red flag effect`, §3.6.1.

**Problem:** The requirement statement says cards from the same company/role must be excluded after a red flag. However, the acceptance criterion says: “In the next 20 feed cards, no card is excluded by the rule above.” Read literally, this criterion requires the opposite of the intended behavior.

**Why it matters:** A test derived literally from this acceptance criterion could pass when excluded cards remain in the feed, or fail when the system correctly removes them. The requirement therefore cannot be verified consistently in its current form.

**Recommendation:** Rewrite the criterion to say that none of the cards matching the exclusion rule appears in the next 20 feed cards. Keep the separate score-reduction criterion for remaining cards that share tags.

**Team A response / disposition:** Pending.

### A-02 — Normal

**Reference:** `REQ-SEC-003: Authorization`, §3.3.2; `REQ-FUNC-016: Interested candidates`.

**Problem:** The first sentence states that a user may read or change only their own data. The same requirement then permits recruiters to view candidate data after the candidate likes one of the company's cards. Its acceptance criterion also says attempts to access another user's profile, cards, matches or chats should return 403 or 404, without describing the intended candidate-profile visibility exception.

**Why it matters:** The authorization boundary is ambiguous. A literal implementation of the first sentence could block the intended recruiter workflow, while a broad interpretation of the exception could expose more candidate information than intended.

**Recommendation:** Define the permitted data fields and actions for each role and state. Specify whether all recruiters in the candidate's company may see the candidate summary, whether full profile fields are restricted, and what access is granted after a like, acceptance, match or unmatch. Align the negative authorization tests with these explicit exceptions.

**Team A response / disposition:** Pending.

### A-03 — Normal

**Reference:** `REQ-FUNC-004: Account deletion`, §3.2.1; `REQ-COMP-001: Privacy notice and consent`, §3.4.

**Problem:** `REQ-FUNC-004` requires the profile, swipes, flags, matches, messages, applications and CVs to be permanently removed from the relevant stores. At the same time, its acceptance criteria require the other party in each match to continue seeing that match as “Account deleted”. The SRS does not explain what record remains to render that state after the match itself has been permanently removed.

**Why it matters:** The deletion and retained-match behaviors cannot both be implemented literally without a defined minimal residual record or anonymisation approach. The ambiguity affects data deletion, chat access, user-visible history and the verification test.

**Recommendation:** Define the deletion model explicitly. For example, specify which personal fields and message contents are erased, whether a minimal anonymised match tombstone is retained, what the other party can still see, and whether any remaining content can be accessed. Align the acceptance criteria with that model.

**Team A response / disposition:** Pending.

### A-04 — Normal

**Reference:** `REQ-FUNC-004: Account deletion`; `REQ-ML-008: Graph data minimisation`, §3.6.2.

**Problem:** Account data must be removed from the graph store within the 24-hour deletion period defined by `REQ-FUNC-004`. `REQ-ML-008` schedules full graph rebuilds at least every 15 minutes and permits up to three retries while leaving the previous graph in place after a failed rebuild. The SRS does not define retry timing, a maximum period of graph unavailability, an escalation path after all retries fail, or an alternate deletion action that preserves the 24-hour guarantee.

**Why it matters:** If repeated rebuild failures leave the old graph active, a deleted user's identifiers and relationships may remain beyond the stated deletion period. The acceptance criterion checks deletion after a sync runs, but does not exercise the failed-rebuild path against the deletion deadline.

**Recommendation:** Define bounded retry timing and a maximum graph-data staleness/deletion window. Specify alerting and a safe fallback or targeted deletion procedure when the full rebuild cannot complete, and add a test for deletion while graph rebuilds fail.

**Team A response / disposition:** Pending.

### A-05 — Normal

**Reference:** `REQ-COMP-001: Privacy notice and consent`, §3.4.

**Problem:** The retention statement says account data is kept until account deletion or 12 months of inactivity, after which it is deleted. The SRS does not define what counts as activity, which event updates the inactivity timestamp, whether all account-associated data follows the same rule, or what process initiates and verifies the automatic deletion. The stated cleanup test uses shifted timestamps but does not define these operational rules.

**Why it matters:** Different implementations could calculate inactivity differently, resulting in premature deletion or data being retained beyond the stated period. Reviewers also cannot derive a repeatable test from the current definition.

**Recommendation:** Define the inactivity reference event and timestamp, the records covered by the inactivity rule, any excluded records or legal holds, and the scheduled cleanup behavior. Add acceptance cases for an account just below and just above the 12-month boundary.

**Team A response / disposition:** Pending.

### A-06 — Normal

**Reference:** `REQ-COMP-004: Non-discrimination`, §3.4; `REQ-ML-001` and `REQ-ML-007`.

**Problem:** The requirement is titled “Non-discrimination” and its rationale refers to fair matching, but its only acceptance criterion is inspection that a list of named attributes is not used as a direct ranking input. It does not define how the team will assess indirect proxies or whether ranking outcomes are reviewed for materially different treatment across representative synthetic scenarios.

**Why it matters:** The current test can establish that named fields are not directly passed into the ranking algorithm, but it does not establish the broader fairness objective expressed by the title and rationale.

**Recommendation:** Clarify the intended scope of the fairness requirement. At minimum, document which ranking inputs are permitted, how potentially sensitive proxies will be reviewed, and a proportionate set of synthetic scenarios or outcome checks that can be repeated. If the team intends only a direct-input prohibition, narrow the title and rationale accordingly.

**Team A response / disposition:** Pending.

### A-07 — Normal

**Reference:** `REQ-ML-001: Card ranking`; `REQ-ML-007: Graph-based ranking`; Appendix B, issue 2.

**Problem:** The ranking requirements verify that the score/order matches a manually calculated fixture and that one graph co-like example raises a score. They do not define an acceptance criterion for whether the resulting ranking is useful or relevant to a candidate's stated preferences and interaction history. Appendix B says the algorithm's evaluation criteria were selected, but the SRS only identifies deterministic behavior tests.

**Why it matters:** A scoring implementation can satisfy the arithmetic tests while consistently producing poor recommendations. The current verification plan tests score implementation, not the quality objective described in the product scope.

**Recommendation:** Add a small, reproducible synthetic evaluation set with expected ranking judgments or scenario-based relevance outcomes, together with a metric or pass/fail rule appropriate to the project's scale. If only deterministic functional correctness is intended for v1.0, state that the SRS does not claim to verify recommendation quality.

**Team A response / disposition:** Pending.

### A-08 — Normal

**Reference:** `REQ-SEC-006: Brute-force protection`, §3.3.2.

**Problem:** The statement defines two limits: 10 failed attempts per account per source IP in 15 minutes, and 100 failed attempts per source IP across all accounts in 15 minutes. The acceptance criteria test the first limit and the behavior from a second IP, but do not verify the aggregate 100-attempt limit across multiple accounts.

**Why it matters:** One half of the specified security control has no explicit acceptance test, so the verification table cannot demonstrate that the full requirement has been met.

**Recommendation:** Add a test that makes failed attempts across multiple accounts from one IP, confirms the 100-attempt threshold and 429 response, and checks the reset/window behavior. Retain the existing per-account/per-IP and alternate-IP tests.

**Team A response / disposition:** Pending.

### A-09 — Minor

**Reference:** `REQ-COMP-002: Data subject rights`, §3.4; `REQ-FUNC-021: Apply`.

**Problem:** The requirement promises export of a user's personal data, but the acceptance criterion lists profile, swipes, flags, matches, messages and applications without explicitly stating whether attached CV files, reports, notification data or other account-linked records are included or intentionally excluded.

**Why it matters:** The term “personal data” is broader than the listed items, and implementers may make different decisions about attachments and supporting records.

**Recommendation:** Provide a defined export inventory by data category, including the treatment of CV attachments and reports. State any intentionally excluded data and how the user can obtain it, if applicable.

**Team A response / disposition:** Pending.

### A-10 — Minor

**Reference:** §1.4, references R5–R9; requirements that rely on these references.

**Problem:** The architecture, database design, Neo4j mapping, API contract and project plan are each identified with version/date “Current”. The SRS relies on at least some of these artifacts for requirement details, including the ranking formula in R6 §7.4, but “Current” does not identify a stable revision.

**Why it matters:** A future change to a companion document could silently change the meaning of a requirement or make a previous review/test result refer to a different design.

**Recommendation:** Record a version/date or a repository commit identifier for each referenced artifact, and update the SRS reference when the baseline changes. This does not imply the referenced files are missing; it is a version-control and traceability improvement.

**Team A response / disposition:** Pending.

### A-11 — Minor

**Reference:** `REQ-MAINT-002: Test coverage`, §3.5.4.

**Problem:** The statement requires at least 60% line coverage for backend and matching-service unit tests, but the acceptance criterion only says that a coverage report is attached.

**Why it matters:** A report could be attached while coverage remains below 60%, yet the acceptance criterion as written would still be satisfied.

**Recommendation:** State that the report must show at least 60% line coverage for each specified component, or define whether the 60% threshold applies to the combined total or separately to each component.

**Team A response / disposition:** Pending.

### A-12 — Minor

**Reference:** `REQ-MAINT-003: Code style`, §3.5.4.

**Problem:** The statement requires both an automatic formatter and a linter, but the acceptance criterion checks only that the linter runs without errors.

**Why it matters:** The formatter requirement is not independently verified.

**Recommendation:** Add a formatter check (for example, a clean formatting check in CI) or remove the formatter obligation if it is not part of the release baseline.

**Team A response / disposition:** Pending.

### A-13 — Minor

**Reference:** `REQ-POC-001: Swipe-feed POC`, §3.5.9; verification table in §4.

**Problem:** The POC is planned for 14–28 October 2026, while the submitted SRS is dated 29 October 2026. The verification table still marks `REQ-POC-001` as Planned and provides no evidence or revised date.

**Why it matters:** The schedule and verification status do not show whether the POC was completed, missed or rescheduled. This weakens the milestone traceability used by the SRS.

**Recommendation:** Update the requirement status and evidence if the POC was completed; otherwise record the revised plan and explain the schedule change. Do not leave a past target marked Planned without a disposition.

**Team A response / disposition:** Pending.

---

## 4. Group discussion summary

1. **Preserve the existing structure.** The requirement template, priority scheme, revision history and verification matrix provide a useful baseline. The recommendations focus on tightening the internal consistency and testability of specific requirements rather than replacing the SRS format.
2. **Resolve requirement interactions first.** Team A should prioritize the red-flag acceptance criterion, authorization exceptions, account-deletion behavior and graph-deletion failure path, because these affect core behavior, access control and data lifecycle guarantees.
3. **Make quality claims testable.** The ranking-quality and non-discrimination objectives should be aligned with measurable, proportionate acceptance criteria. Security-rate-limit tests should cover every threshold stated in the requirement.
4. **Keep supporting artifacts versioned.** Record stable versions or commit identifiers for design artifacts that supply details referenced by the SRS.
5. **Close the review through individual dispositions.** Team A should respond separately to A-01 through A-13, indicating Accepted, Partially accepted or Not accepted, with a correction, clarification, planned action or reason. The issue should remain open until all findings have recorded dispositions.

**Review conclusion:** Team A's SRS v0.7 is well structured and contains a strong requirement-level foundation. The 13 findings identify targeted corrections and clarifications that would make the baseline more internally consistent, measurable and traceable before it is finalized.
