# SOFTWARE REQUIREMENTS SPECIFICATION
## DēGlitch — Context-Aware Adaptive Connectivity

**Version:** 1.0 — Final Project Baseline  
**Prepared by:** Elijah Fullah  
**Organization:** Software Engineering course project  
**Date modified:** 21 October 2026  
**Status:** Final baseline for implementation and verification.  

Template basis: SRS-Template-IEEE linked from slide 5 of the supplied course lecture.

## Revision History

| **Version** | **Date** | **Reason for change** | **Status** |
| --- | --- | --- | --- |
| 0.1 | 2026-10-16 | Preliminary SRS from initial project understanding. | Draft |
| 0.2 | 2026-10-17 | Reorganized to follow the SRS template referenced in the course lecture. | For supervisor review |
| 1.0 | 2026-10-21 | Finalized requirements baseline; aligned UI inventory and implementation progress snapshot with the 21 October weekly presentation. | Final |

# 1. Introduction

## 1.1 Document Purpose

This Software Requirements Specification (SRS) establishes the baseline requirements for DēGlitch, a context-aware adaptive connectivity application. It defines system boundaries, intended behavior, external interfaces, quality expectations, constraints, and verification methods for implementation and evaluation. Conditional requirements apply only when the corresponding capability is included in an implementation increment. Values marked TBD must be resolved before the affected requirement can be verified. Finalization of this specification establishes the project baseline; it does not imply that every requirement has already been implemented or verified.

## 1.2 Product Scope

DēGlitch is intended to help users select and maintain an appropriate connectivity strategy by considering available network conditions, device constraints, connection state, and user preferences. The baseline covers connection-state visibility, endpoint selection, diagnostics, profiles and optional connection history, adaptive recommendations, privacy controls, and a resource-aware Lite Mode. The project will evaluate whether context-aware recommendations improve stability or resource use against a defined baseline; no improvement is claimed until measured.

**In scope:** user-facing connectivity controls; permitted network/connection indicators; recommendation logic; diagnostics and optional connection history; privacy controls; and integration with a compatible VPN/tunnel implementation.

**Out of scope for this baseline:** operating a commercial VPN server network; guaranteeing access to external services; claiming perfect anonymity or security; or deploying an unvalidated ML model. Split tunnelling, automatic failover, and custom ML are conditional extensions that require feasibility evidence and a recorded scope change before implementation.

## 1.3 Definitions, Acronyms, and Abbreviations

| **Term** | **Definition** |
| --- | --- |
| Adaptive recommendation | A suggestion based on available context and measurements. |
| Endpoint | A VPN server or tunnel endpoint available to the application. |
| Lite Mode | User-controlled mode that reduces specifically identified non-essential background activity on constrained devices or networks. |
| NFR | Non-functional requirement: a quality or constraint placed on the system. |
| SRS | Software Requirements Specification. |
| VPN | Virtual Private Network. |
| UI | User interface. |
| TBD | To be determined after clarification, feasibility study, or measurement. |

## 1.4 References

1. ISO/IEC/IEEE 29148:2018, *Systems and software engineering — Life cycle processes — Requirements engineering*. https://www.iso.org/standard/72089.html (requirements-engineering reference).
1. ovikrai, *SRS-Template-IEEE*, srs-template.md, based on IEEE 830 and ISO/IEC/IEEE 29148. https://github.com/ovikrai/SRS-Template-IEEE (template referenced on slide 5 of the supplied lecture).
1. *SE1.1 Program Quality Assurance and Analysis*, supplied course lecture PowerPoint, slide 5.
1. *Software Engineering GitHub Operations Guide for International Graduate Students*, supplied course guide, particularly documentation and repository structure guidance, pp. 5–6.
## 1.5 Document Overview

Section 2 describes product context, functions, constraints, users, assumptions, dependencies, and planned allocation. Section 3 specifies external interfaces, functional behavior, quality-of-service, security, compliance, implementation, and conditional AI/ML requirements. Section 4 records the dated implementation progress snapshot, verification matrix, and test evidence rules. Section 5 contains implementation decisions and status conventions. Requirement IDs remain stable and changes are tracked in the revision history.

# 2. Product Overview

## 2.1 Product Perspective

DēGlitch is a software-engineering project and is not positioned as a production commercial VPN service. The user interface and application layer are implemented in Flutter and target Android, iOS, macOS, Windows, and Linux. Platform-specific network indicators, permission flows, and tunnel lifecycle features must be validated independently on each target platform before that platform is described as fully supported.

System context: user → DēGlitch UI and recommendation layer → operating-system network and tunnel interfaces → configured endpoint. Any optional remote endpoint directory, diagnostics service, or ML service must have a defined interface before integration.

## 2.2 Product Functions

- Display current connection state and relevant available network indicators.
- Allow selection/configuration of an available endpoint where supported.
- Collect only network/device indicators required by approved functions.
- Generate an adaptive recommendation and explain its principal factors.
- Provide user-controlled Lite Mode for constrained conditions.
- Run an on-demand diagnostic and display limitations.
- Maintain user-visible connection history when enabled, with controls to clear it.
- Provide privacy and permission settings supported by the target platform.
- Handle unavailable endpoints, denied permissions, lost connectivity, and tunnel errors with understandable feedback.
## 2.3 Product Constraints

- The application must operate within permissions and VPN APIs of the selected OS.
- Flutter UI code alone is not assumed to provide a complete VPN tunnel; native integration and an approved tunnel implementation must be selected and validated.
- Only authorized endpoints and test environments may be used.
- Network-generation labels alone must not be treated as sufficient evidence of connection quality; measured indicators should be used where available.
- Sensitive data must not be collected merely because it is technically accessible.
- Numerical performance, battery, memory, stability, and recommendation-quality thresholds are TBD until test conditions and baselines are agreed.
- Third-party dependencies require review of platform support, licensing, maintenance, and security before selection.
## 2.4 User Characteristics

| **User class** | **Characteristics and needs** |
| --- | --- |
| General user | Needs clear state, simple controls, understandable errors, and safe defaults. |
| Advanced user | May need endpoint selection, diagnostics, profiles, and more detailed indicators. |
| Developer/tester | Needs reproducible tests, privacy-aware logs, and requirement-to-evidence traceability. |
| Supervisor/reviewer | Needs verifiable requirements, transparent status, and explicit unresolved decisions. |

## 2.5 Assumptions and Dependencies

| **ID** | **Assumption/dependency** | **Impact if false** | **Status** |
| --- | --- | --- | --- |
| ASM-01 | A test device/build environment will be available for the target platforms: Android, iOS, macOS, Windows, and Linux. | Revise verification plan for any platform that cannot be tested. | Target scope |
| DEP-01 | Each target OS exposes the network and tunnel lifecycle APIs required by the features claimed for that platform. | Some platform capabilities may be limited or deferred. | Verify per platform |
| DEP-02 | An authorized endpoint and compatible tunnel implementation are available for each platform-specific connection test. | End-to-end tunnel evaluation cannot be completed for the affected platform. | Active dependency |
| DEP-03 | Required dependencies can be obtained and used under their licenses. | Implementation choices may change. | License tracking |
| ASM-02 | A baseline scenario can be defined for recommendation/resource comparisons. | Improvement claims cannot be evaluated reliably. | To be defined |
| ASM-03 | Initial evaluation avoids identifiable browsing content. | Additional privacy review is needed if this changes. | Baseline approach |

## 2.6 Apportioning of Requirements

| **Increment** | **Requirement groups / likely allocation** | **Status** |
| --- | --- | --- |
| 1. Requirements and UI baseline | REQ-FUNC-001–004; Flutter UI and interface prototype | Planned |
| 2. Connection integration | REQ-FUNC-005–007; REQ-REL-001; platform adapter and approved tunnel | Pending feasibility |
| 3. Recommendation and Lite Mode | REQ-FUNC-008–010; REQ-PERF-001; REQ-ML-001 | Conditional |
| 4. Verification and privacy | REQ-SEC-001–003; REQ-OBS-001; test assets and evidence | Planned |
| Deferred | ML training/retraining service, split tunnelling, commercial server infrastructure | Deferred/TBD |

The allocation defines the planned implementation sequence. Inclusion in this specification does not, by itself, indicate that a requirement has been implemented or verified.

# 3. Requirements

This specification defines 31 unique requirement IDs across external interfaces, functional behavior, quality of service, security, reliability, availability, observability, compliance, implementation, portability, proof of concept, change management, and conditional AI/ML. Each requirement includes an acceptance criterion and a verification method. Verification status is established from recorded evidence.

## 3.1 External Interfaces

Exact APIs, payload schemas, platform-specific permission flows, and tunnel details are defined during each platform adapter implementation. Unresolved choices and measurable thresholds are recorded in Appendix A and must be settled before the affected requirements are verified.

### 3.1.1 User Interfaces

The application provides a connection/home view, endpoint selection, diagnostics, profiles/settings, and clear error and recovery paths. Detailed layouts are defined in the UI specification. Empty, loading, permission-denied, and error states are specified for each relevant screen.

**Core Flutter screen prototypes (current increment):** Home/Dashboard, Servers/Server Recommendation, Diagnostics, Profile & Settings, and More. These are the five core screens highlighted in the weekly progress presentation.

**The wider design portfolio contains 20+ UI concepts:** Splash/Launch, Onboarding, Sign-up/Login, Server List, Activity Profiles, Network Monitoring, Diagnostic Results, AI Assistant, Connection Strategy and Recommendation Details, Connection History, Notifications, Language Settings, Network Profiles, Security & Privacy, Data Saver, Battery Saver, Lite Mode, AI Model Details, Help & Support, About DēGlitch, and Split Tunneling. These additional concepts are design coverage, not a claim that every screen or behavior is implemented or verified.

### 3.1.2 Hardware Interfaces

The system uses device network interfaces and device status information exposed by the operating system. Direct control of modem hardware is not assumed. Device-specific capability limits are validated on the supported test matrix.

### 3.1.3 Software Interfaces

| **ID** | **Interface** | **Requirement / current definition** |
| --- | --- | --- |
| REQ-INT-001 | OS network status | The application shall obtain only OS-exposed network-state indicators required by approved features. Exact fields and permissions are platform-dependent and TBD. |
| REQ-INT-002 | VPN/tunnel interface | The application shall interact with a selected authorized tunnel implementation through supported platform interfaces. Protocol/library selection is TBD. |
| REQ-INT-003 | Local persistence | If history or profiles are enabled, the application shall use a defined local storage mechanism; stored fields, retention, and protection require review. |
| REQ-INT-004 | Optional remote service | Any endpoint directory, diagnostics service, or ML service shall be specified before integration. No remote service is assumed in this baseline. |

## 3.2 Functional

### 3.2.1 Connection Status and Controls

**REQ-FUNC-001 — Display connection state**

**Statement:** The system shall display disconnected, connecting, connected, disconnecting, or error state when that state is supplied by the underlying implementation.

**Rationale:** Users need an accurate view of connection state.

**Acceptance criteria:** For each state supplied by the test adapter, the UI displays the matching state; an unavailable state is shown as unknown rather than guessed.

**Verification:** Test and demonstration.

**More information:** Depends on REQ-INT-002.

**REQ-FUNC-002 — Start and stop connection**

**Statement:** The system shall provide user controls to request connection and disconnection where supported by the platform and configured tunnel.

**Acceptance criteria:** A valid request is passed to the tunnel adapter; the UI reflects the reported result and does not show success before confirmation.

**Verification:** Integration test and demonstration.

**More information:** Platform permissions and consent flow are TBD.

**REQ-FUNC-003 — Report connection failures**

**Statement:** The system shall display an understandable error when a connection request fails or the tunnel reports an error.

**Acceptance criteria:** Simulated permission denial, endpoint unavailability, and tunnel failure do not result in a false connected state and produce an appropriate message.

**Verification:** Test.

**REQ-FUNC-004 — Select an available endpoint**

**Statement:** The system shall allow the user to select from endpoints supplied by the configured endpoint source.

**Acceptance criteria:** Only endpoints returned as available are selectable; an empty list has an explicit empty state.

**Verification:** Test. Endpoint source/schema TBD.

### 3.2.2 Context and Adaptive Recommendations

**REQ-FUNC-005 — Read available network context**

**Statement:** The system shall read supported network indicators needed for connection status or recommendation, subject to OS permissions.

**Acceptance criteria:** If permission is denied or a field is unavailable, the system marks it unavailable and does not invent a value.

**Verification:** Test.

**REQ-FUNC-006 — Produce a connection recommendation**

**Statement:** The system shall produce a recommendation only when configured inputs are available; otherwise, it shall indicate insufficient information.

**Acceptance criteria:** Given a reviewed test-input set, the system returns a recommendation or explicit insufficient-data result and identifies principal factors used.

**Verification:** Test against a reviewed scenario set. A rule-based baseline may be used; no custom ML model is assumed.

**REQ-FUNC-007 — Preserve user control**

**Statement:** The system shall present recommendations as suggestions unless the user has enabled a separately specified automatic action.

**Acceptance criteria:** With automatic action disabled, a recommendation does not initiate a connection change without user action.

**Verification:** Test.

**REQ-FUNC-008 — Provide Lite Mode**

**Statement:** The system shall provide a user-controlled Lite Mode that reduces only non-essential background activities explicitly identified in the implementation specification.

**Acceptance criteria:** UI shows whether Lite Mode is enabled; tests verify each listed activity; battery/data improvements are not claimed without comparative evidence.

**Verification:** Inspection and controlled measurement. Activity list and targets TBD.

**REQ-FUNC-009 — Run diagnostics on request**

**Statement:** The system shall allow the user to start an on-demand diagnostic using measurements supported by the implementation.

**Acceptance criteria:** Results display collected measurements and units where applicable; missing measurements are identified as unavailable.

**Verification:** Test and demonstration.

**REQ-FUNC-010 — Manage history and profiles**

**Statement:** When history and profiles are enabled in a release, the system shall let the user view and delete locally stored history and manage saved profile settings.

**Acceptance criteria:** Tests confirm view, delete, edit, and profile deletion behavior; persistence and retention are documented.

**Verification:** Test. Fields and retention TBD.

## 3.3 Quality of Service

Numerical performance, resource-use, stability, and recommendation-quality targets are established after the baseline test environment and workload are defined. Until those values are recorded, TBD values are not pass/fail thresholds.

### 3.3.1 Performance

**REQ-PERF-001 — Recommendation response time**

**Statement:** Under a defined device, workload, and network test profile, the system shall produce a recommendation within a response-time threshold approved by the supervisor.

**Acceptance criteria:** Report device, OS, input profile, sample count, percentile/maximum, and measured latency; threshold TBD.

**Verification:** Measurement.

**REQ-PERF-002 — Lite Mode resource comparison**

**Statement:** The project shall measure agreed background resource use with Lite Mode enabled and disabled under matched conditions.

**Acceptance criteria:** A repeatable report compares CPU, memory, network traffic, and battery where available; unsupported metrics are marked unavailable.

**Verification:** Controlled measurement. Target improvement TBD.

### 3.3.2 Security

**REQ-SEC-001 — Protect configuration secrets**

**Statement:** The system shall not embed credentials, private keys, tokens, or other secrets in source code, public documentation, logs, or screenshots.

**Acceptance criteria:** Source/configuration inspection finds no committed secrets and documents any required secret-storage mechanism.

**Verification:** Inspection.

**REQ-SEC-002 — Use authorized tunnel configuration**

**Statement:** The system shall use only endpoints and tunnel configurations supplied by an authorized source or explicitly configured for testing.

**Acceptance criteria:** Test configuration identifies the authorized source and malformed configuration is rejected or flagged.

**Verification:** Inspection and test.

**REQ-SEC-003 — Minimize sensitive diagnostics**

**Statement:** The system shall not collect or store browsing content for network diagnostics unless a separately reviewed requirement explicitly authorizes and justifies it.

**Acceptance criteria:** Diagnostic fields and stored records exclude browsing content.

**Verification:** Inspection and test.

### 3.3.3 Reliability

**REQ-REL-001 — Handle network/tunnel loss**

**Statement:** When the platform reports network loss or tunnel failure, the system shall update visible state and shall not continue to report connected.

**Acceptance criteria:** A simulated failure updates the state within an approved threshold; threshold TBD.

**Verification:** Integration test. Automatic reconnection and failover are outside the current baseline unless added through change control.

### 3.3.4 Availability

**REQ-AVAIL-001 — Handle unavailable optional services**

**Statement:** If an optional endpoint directory or remote service is unavailable, the system shall explain the limitation and preserve unrelated local functions where feasible.

**Acceptance criteria:** With the optional service disabled, the system reports the failure and leaves available local settings/diagnostics accessible.

**Verification:** Test. Availability and recovery targets TBD until deployment is defined.

### 3.3.5 Observability

**REQ-OBS-001 — Provide privacy-aware diagnostic evidence**

**Statement:** The system shall provide sufficient diagnostic information to explain connection state and recommendation results without logging secrets or unnecessary personal data.

**Acceptance criteria:** Diagnostic fields are documented and inspection confirms secrets are absent or redacted.

**Verification:** Inspection and test. Log format/retention TBD.

## 3.4 Compliance

**REQ-COMP-001 — Document dependency licenses**

**Statement:** Before a third-party library or protocol implementation is included in a release build, the project shall record its name, version, source, and applicable license.

**Acceptance criteria:** Dependency inventory covers release dependencies.

**Verification:** Inspection.

**REQ-COMP-002 — Follow platform permission requirements**

**Statement:** The application shall request and use network/VPN permissions according to the selected platform’s documented mechanisms.

**Acceptance criteria:** Permission flows are documented and tested on each supported platform.

**Verification:** Inspection and test. No specific legal certification is claimed by this SRS.

## 3.5 Design and Implementation

This section records project constraints and controls; it does not replace the later architecture/design document.

### 3.5.1 Installation

**REQ-INST-001:** The project shall document supported platform(s), prerequisites, development setup, and installation steps for a test device or emulator before formal testing. **Acceptance:** A reviewer can follow the steps in a clean supported environment. Platform/prerequisites TBD. **Verification:** Demonstration and inspection.

### 3.5.2 Build and Delivery

**REQ-BUILD-001:** The project shall document the build procedure and required non-secret configuration for each submitted test build. **Acceptance:** Instructions identify toolchain versions and configuration without committing secrets. **Verification:** Inspection and repeat build.

### 3.5.3 Distribution

Current scope is a student prototype for controlled testing. Public commercial distribution, global server deployment, multi-region operations, and production SLAs are not established requirements. Revisit if scope changes.

### 3.5.4 Maintainability

**REQ-MAINT-001:** The project shall maintain requirements, implementation documentation, and verification evidence under version control. **Acceptance:** Baseline requirements have stable IDs and status/evidence entries; changes are recorded in revision history. **Verification:** Inspection. The course GitHub guide recommends placing requirements under docs/requirements/.

### 3.5.5 Reusability

No separate reusable product or public SDK is currently in scope. If reusable components or public APIs are introduced, supported interfaces, dependency boundaries, and documentation requirements must be defined. Not applicable beyond ordinary modularity at this stage; review if scope changes.

### 3.5.6 Portability

**REQ-PORT-001:** The project shall identify the OS/platform supported by each submitted build and shall not claim cross-platform VPN support unless verified on each claimed platform. **Acceptance:** Release notes and evidence list verified platform/device combinations. **Verification:** Inspection and test. Platform matrix TBD.

### 3.5.7 Cost

No project budget, hosting budget, or cost-per-user target is defined. Cost limits remain TBD. Any paid service or infrastructure dependency must be documented before adoption.

### 3.5.8 Deadline

The course materials identify the SRS milestone for Week 7 and software design/architecture for Week 11. The project schedule shall be aligned with the instructor’s current course schedule and shall apportion scope to milestones rather than imply that every candidate feature will be delivered in one increment.

### 3.5.9 Proof of Concept

**REQ-POC-001 — Validate connection-path feasibility**

**Statement:** Before committing to full tunnel integration, the project shall demonstrate a minimal authorized connection lifecycle on the selected platform.

**Success criteria:** The prototype requests connection, reports resulting state, handles at least one failure case, and documents platform/API limitations.

**Verification:** Demonstration and test. Timebox TBD after platform/tunnel selection.

### 3.5.10 Change Management

**REQ-CM-001:** Changes to this SRS baseline shall record the requirement ID, reason, impact on dependent requirements/tests, and review status. **Acceptance:** Changes appear in revision history and traceability/verification tables; IDs are not silently reused. **Verification:** Inspection.

## 3.6 AI/ML

Custom ML is a conditional extension, not an assumed component of the current implementation. A rule-based baseline may be used first. ML-related requirements in this section apply only if an ML capability is included in an implementation increment.

### 3.6.1 Model Specification

**REQ-ML-001:** If ML is included in an implementation increment, the project shall document its task, input features, output, baseline comparator, evaluation dataset, metrics, and acceptance threshold before claiming performance. **Acceptance:** A reviewed model specification exists before evaluation; thresholds are recorded rather than invented. **Verification:** Inspection and analysis. **Status:** Conditional.

### 3.6.2 Data Management

If ML is included, data origin, permissions/consent, labels, missing-value handling, versioning, storage, access, retention, and anonymization/pseudonymization are documented before training/evaluation. No dataset is part of the current implementation baseline. **Status:** Conditional.

### 3.6.3 Guardrails

If ML is included, it shall not directly change connection settings or initiate connections unless a separately specified and enabled automated action permits that behavior. It shall return an insufficient-data or fallback result when inputs are missing or outside its validated range. **Status:** Conditional.

### 3.6.4 Ethics

If ML is included, the project shall document limitations and known sources of bias in evaluation data and shall not present recommendations as guaranteed outcomes. Context-specific fairness criteria shall be added where a justified concern is identified. **Status:** Conditional.

### 3.6.5 Human-in-the-Loop

For the initial scope, recommendations remain user-visible suggestions unless an automated action is separately specified and explicitly enabled. The user must be able to decline a recommendation. Any future automation requires explicit override and recovery requirements. **Status:** Baseline.

### 3.6.6 Model Lifecycle and Operations

No production model, remote inference service, or retraining pipeline is included in the current implementation baseline. If introduced by a future scope change, requirements must define versioning, evaluation before replacement, rollback, monitoring, drift handling, and retirement. Status: Conditional.

# 4. Verification

## 4.1 Verification Approach

Use test, analysis, inspection, measurement, and demonstration as appropriate. Evidence should identify requirement ID, build/version, platform/device, preconditions, input data, expected and actual results, and outcome. A requirement is not verified merely because it appears in the UI or source code.

As of 21 October 2026, 10 of the 31 unique requirement IDs are completed at prototype/UI-artifact level and 21 are in progress. “Completed (prototype)” means an initial screen, interface, or project artifact is available; it does not mean the requirement has passed formal acceptance testing. The verification matrix that follows tracks verification evidence separately.

## 4.2 Implementation Progress Register

| **Requirement ID** | **Requirement summary** | **Implementation progress** |
| --- | --- | --- |
| **REQ-INT-001** | Read permitted OS network indicators | **In progress** |
| **REQ-INT-002** | VPN / tunnel lifecycle interface | **In progress** |
| **REQ-INT-003** | Local profile persistence path (prototype) | **Completed (prototype)** |
| **REQ-INT-004** | Optional remote endpoint / diagnostics service | **In progress** |
| **REQ-FUNC-001** | Display connection and tunnel state | **Completed (prototype)** |
| **REQ-FUNC-002** | Start and stop the connection | **In progress** |
| **REQ-FUNC-003** | Show connection failure / handshake feedback | **Completed (prototype)** |
| **REQ-FUNC-004** | Browse and select a server entry | **Completed (prototype)** |
| **REQ-FUNC-005** | Read available network context | **In progress** |
| **REQ-FUNC-006** | Recommendation flow and factor presentation | **Completed (prototype)** |
| **REQ-FUNC-007** | Keep connection changes under user control | **Completed (prototype)** |
| **REQ-FUNC-008** | Lite Mode control surface | **Completed (prototype)** |
| **REQ-FUNC-009** | Diagnostics screen and run/results flow | **Completed (prototype)** |
| **REQ-FUNC-010** | Profile and connection-history interfaces | **Completed (prototype)** |
| **REQ-PERF-001** | Measure recommendation response time | **In progress** |
| **REQ-PERF-002** | Compare resource use with Lite Mode on/off | **In progress** |
| **REQ-SEC-001** | Protect configuration secrets | **In progress** |
| **REQ-SEC-002** | Use authorized tunnel profiles / endpoints | **In progress** |
| **REQ-SEC-003** | Minimize sensitive diagnostic data | **In progress** |
| **REQ-REL-001** | Handle network loss and tunnel failure | **In progress** |
| **REQ-AVAIL-001** | Handle an unavailable optional service | **In progress** |
| **REQ-OBS-001** | Provide privacy-aware diagnostic evidence | **In progress** |
| **REQ-COMP-001** | Record dependency versions and licenses | **In progress** |
| **REQ-COMP-002** | Implement platform network/VPN permissions | **In progress** |
| **REQ-INST-001** | Document supported platforms and installation | **In progress** |
| **REQ-BUILD-001** | Document and repeat the build process | **In progress** |
| **REQ-MAINT-001** | Version requirements, code documentation and evidence | **In progress** |
| **REQ-PORT-001** | Verify Android, iOS, macOS, Windows and Linux | **In progress** |
| **REQ-POC-001** | Validate authorized connection lifecycle | **In progress** |
| **REQ-CM-001** | Track requirement changes and impacts | **Completed (prototype)** |
| **REQ-ML-001** | Specify model, data and evaluation if approved | **In progress** |

## 4.3 Verification Matrix

| **Requirement ID** | **Method** | Evidence / test artifact | Verification status |
| --- | --- | --- | --- |
| REQ-INT-001 | Test/inspection | OS permission/network-indicator tests | Planned |
| REQ-INT-002 | Integration test | Authorized tunnel lifecycle | Pending platform selection |
| REQ-INT-003 | Test/inspection | Profile/history persistence, update and deletion tests | Planned |
| REQ-INT-004 | Inspection/test | Optional remote interface specification, if included | Conditional |
| REQ-FUNC-001 | Test | State-to-UI cases | Planned |
| REQ-FUNC-002 | Integration/demo | Connect/disconnect and failures | Pending tunnel integration |
| REQ-FUNC-003 | Test | Permission, endpoint, tunnel errors | Planned |
| REQ-FUNC-004 | Test | Endpoint list/selection/empty state | Planned |
| REQ-FUNC-005 | Test | Available/missing/denied indicators | Planned |
| REQ-FUNC-006 | Test/analysis | Reviewed recommendation scenarios | Planned |
| REQ-FUNC-007 | Test | No automatic action by default | Planned |
| REQ-FUNC-008 | Inspection/measurement | Lite Mode checklist and comparison | Planned |
| REQ-FUNC-009 | Test/demo | Diagnostic and unavailable metrics | Planned |
| REQ-FUNC-010 | Test | History/profile operations | Conditional |
| REQ-PERF-001 | Measurement | Latency under approved profile | Threshold TBD |
| REQ-PERF-002 | Measurement | Matched Lite Mode resource comparison | Planned |
| REQ-SEC-001 | Inspection | Secret/configuration review | Planned |
| REQ-SEC-002 | Inspection/test | Authorized endpoint configuration | Planned |
| REQ-SEC-003 | Inspection/test | Diagnostic field/storage review | Planned |
| REQ-REL-001 | Integration test | Network loss/tunnel failure | Planned |
| REQ-AVAIL-001 | Test | Optional service unavailable | Conditional |
| REQ-OBS-001 | Inspection/test | Diagnostic and redaction review | Planned |
| REQ-COMP-001 | Inspection | Dependency/license inventory | Planned |
| REQ-COMP-002 | Inspection/test | Permission-flow evidence | Pending platform selection |
| REQ-INST-001 | Demo/inspection | Installation instructions | Planned |
| REQ-BUILD-001 | Inspection/rebuild | Build instructions; repeat build | Planned |
| REQ-MAINT-001 | Inspection | Version-controlled docs/traceability | Planned |
| REQ-PORT-001 | Inspection/test | Verified platform matrix | Pending platform selection |
| REQ-POC-001 | Demo/test | Minimal authorized tunnel proof | Pending feasibility |
| REQ-CM-001 | Inspection | Change/revision history | Planned |
| REQ-ML-001 | Inspection/analysis | Model spec if ML approved | Conditional |

## 4.4 Test Environment and Evidence Rules

Record target OS/version, device/emulator, build ID, permissions, endpoint/test configuration, network conditions, and measurement tools. Performance comparisons must use matched conditions and disclose sample counts and unavailable measurements. Security testing must use authorized configurations and controlled environments. No test is Passed until evidence exists and acceptance criteria are met.

# 5. Appendices

## Appendix A — Implementation Decision Register

1. Define and validate platform-specific tunnel/network adapters, permissions, and limits for Android, iOS, macOS, Windows, and Linux.

2. Identify authorized endpoint sources; specify secure local profile import, validation, storage, update, and removal behavior.

3. Define per-platform network indicators and expected behavior when data is unavailable or permissions are denied.

4. Define recommendation inputs, ranking rules, and fallbacks; decide whether to use a rule-based baseline or ML, and specify data/evaluation if ML is selected.

5. Establish repeatable test conditions and thresholds for response time, state updates, stability, and resource use; claim improvements only after measurement.

6. Decide the first-release scope for history and split tunnelling, including profile fields, retention, platform feasibility, dependency licences, infrastructure cost, and build/submission acceptance criteria.

## Appendix B — Requirement Status and Priority Convention

Status: Baseline = included in this SRS; Conditional = applies when the capability is selected; Deferred = outside the current increment; TBD = unresolved before the affected requirement can be verified; Verified = acceptance criteria met and evidence recorded. Priority: Must = required for the minimum viable prototype; Should = valuable but not essential; Could = optional. Priority is maintained through change control. Implementation progress in Section 4.2 is tracked separately: Completed (prototype) means an initial UI/prototype artifact has been delivered; In progress means implementation, integration, or supporting evidence remains outstanding. Neither label means formally Verified.
