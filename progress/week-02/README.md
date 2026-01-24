# Week 02 – Account Risk Assessment Engine (Core Backend)

## Objective
Design and implement a **production-ready backend risk assessment engine** for Accounts using Apex, following **clean code, bulkification, and separation of concerns** principles.

This week focuses on **business logic**, not UI.

---

## Business Problem
In real-world CRM systems, organizations need a **data-driven way to identify risky customer accounts** to:
- Prioritize account management
- Proactively reduce churn
- Allocate support resources effectively

---

## Solution Overview
A backend service that:
- Evaluates **Account risk** using multiple signals
- Produces a **Risk Score (0–100)**
- Classifies Accounts as **Low / Medium / High Risk**
- Persists results back to Salesforce

---

## Risk Scoring Model

### 1 Revenue Risk (0–40 points)
| Annual Revenue | Risk Points |
|---------------|------------|
| > 10M         | 0          |
| 5M – 10M      | 10         |
| 1M – 5M       | 20         |
| < 1M          | 40         |
| Null          | 30         |

---

### 2 Open Case Risk (0–40 points)
| Open Cases | Risk Points |
|-----------|------------|
| 0         | 0          |
| 1 – 3     | 10         |
| 4 – 7     | 20         |
| 8 – 10    | 30         |
| > 10      | 40         |

---

### 3 Industry Risk (0–20 points)
| Industry      | Risk Points |
|--------------|------------|
| Technology   | 0          |
| Healthcare   | 5          |
| Finance      | 10         |
| Retail       | 15         |
| Null / Other | 20         |

---

## Apex Architecture (Clean Code)

| Layer | Responsibility |
|-----|----------------|
| `RiskDataFetcher` | SOQL & aggregate queries only |
| `RiskCalculator` | Pure business logic (score calculation) |
| `RiskClassifier` | Converts score → Low / Medium / High |
| `RiskService` | Orchestrates flow & handles DML |
| `RiskResult` | DTO for result transport |

✔ Bulkified  
✔ No SOQL/DML in loops  
✔ Single Responsibility Principle  
✔ Testable & extensible  

---

## Testing Strategy
- `@TestSetup` for shared data
- Scenario-based tests:
  - High revenue / no cases
  - Low revenue / many cases
  - Null revenue handling
  - Unknown industry
  - Bulk processing (9+ accounts)
- **100% coverage with meaningful assertions**

---

## Outcomes Achieved
- End-to-end backend risk engine
- Deterministic, explainable scoring logic
- Production-style Apex structure
- Bulk-safe and test-driven implementation

---

## Next Week (Week 03 Preview)
- Trigger or Platform Event integration
- Decouple logic using Domain/Selector pattern
- Prepare for UI or automation layer

---

## Key Takeaway
Focused on building **real Salesforce backend systems**, not just learning syntax.

