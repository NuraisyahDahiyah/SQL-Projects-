# E-Commerce Sales Funnel Analysis

This case study, inspired by [Lorenzo Rosa funnel analysis](https://www.youtube.com/watch?v=U-JlXWDqvco), uses SQL to analyse user behaviour across an e-commerce sales funnel, identifying conversion bottlenecks, channel performance, customer journey behaviour, and revenue opportunities.

**Database:** `MySQL`

## Business Problem

The objective is to understand how users move through the e-commerce purchase journey and identify opportunities to improve conversion and revenue.

Key questions:

- Where are users dropping off in the sales funnel?
- Which traffic sources generate the highest-quality customers?
- How long does it take users to convert?
- How does funnel performance translate into revenue?
- Where should the business prioritise optimisation efforts?

## Data

The analysis uses a `user_events` dataset containing customer interactions throughout the e-commerce journey. 

| Column | Description |
|---|---|
| `user_id` | Unique customer identifier |
| `event_type` | Customer action such as page view, add to cart or purchase |
| `event_date` | Date of customer activity |
| `traffic_source` | Customer acquisition channel |
| `amount` | Purchase amount |

**Analysis Period:** 4 January 2026 - 3 February 2026

## Analysis 

### Analysis Overview

| Analysis | Objective |
|---|---|
| Sales Funnel | Measure users progressing through each funnel stage |
| Conversion | Identify major drop-off points |
| Traffic Source | Compare channel volume and conversion efficiency |
| Customer Journey | Analyse time taken to convert |
| Revenue | Evaluate revenue and order performance |

### 1. Sales Funnel

The customer journey was structured into five stages:
`Page View → Add to Cart → Checkout → Payment → Purchase`

The analysis uses `COUNT(DISTINCT user_id)` to measure unique users reaching each stage.

<img width="1034" height="88" alt="image" src="https://github.com/user-attachments/assets/823f6132-4ab9-4e76-9c7a-4f23a95c1cb5" />

### 2. Conversion

Stage-to-stage conversion rates were calculated to identify where the largest customer drop-offs occur, alongside the overall visitor-to-purchase conversion rate.

<img width="2334" height="106" alt="image" src="https://github.com/user-attachments/assets/27a05b7a-0b49-4f87-b718-f8f0d6827a5e" />

### 3. Traffic Source 

Funnel performance was segmented by acquisition channel to compare traffic volume against conversion efficiency.

<img width="1452" height="200" alt="image" src="https://github.com/user-attachments/assets/e467be82-54da-4917-af44-840f5e94b456" />

### 4. Customer Journey 

The analysis measures the average time taken for converted users to progress from:

`Page View → Add to Cart → Purchase`

This provides insight into customer decision-making and potential opportunities for retargeting or customer nurturing.

<img width="1214" height="94" alt="image" src="https://github.com/user-attachments/assets/9eb773fe-526d-44ee-84e1-559f52324824" />

### 5. Revenue 

Revenue metrics were analysed alongside funnel performance, including:
- Total revenue
- Total orders
- Average Order Value (AOV)
- Revenue per buyer
- Revenue per visitor

<img width="1460" height="110" alt="image" src="https://github.com/user-attachments/assets/4f9dc06e-7965-4f04-b180-76199436cd2a" />

## Key Insights and Recommendations

<details> 
  <summary>
    <strong> 01 — Largest drop-off occurs early in the funnel </strong>
  </summary>
  
The biggest conversion gap occurs between page view and add to cart, suggesting that the primary optimisation opportunity lies in earlier-stage engagement.

**Recommendation:** Investigate product discoverability, landing-page relevance, pricing, value proposition, and CTA effectiveness to improve view-to-cart conversion.

</details>

<details> 
  <summary>
    <strong> 02 — Traffic volume does not equal traffic quality </strong>
  </summary>

Social media generates substantial traffic but has weaker conversion efficiency, while email generates lower traffic volume but stronger downstream conversion.

**Recommendation:** Shift social toward retargeting, higher-intent audiences and lead generation, while strengthening email campaigns to nurture captured leads.

</details>

<details> 
  <summary>
    <strong> 03 — Lower-funnel conversion is relatively strong </strong>
  </summary>

Users who reach the later stages of the funnel are considerably more likely to complete their purchase, suggesting that optimisation should initially focus on earlier funnel stages.

**Recommendation:** Avoid prioritising a major checkout redesign for now. Focus optimisation efforts on the earlier stages of the customer journey.

</details>

<details> 
  <summary>
    <strong> 04 — Revenue performance should be evaluated alongside acquisition costs </strong>
  </summary>

AOV and revenue-per-visitor provide useful benchmarks, but strong conversion does not necessarily mean a channel is profitable.

**Recommendation:** Compare CAC against contribution margin to establish channel-level profitability and determine where marketing spend should be increased or reduced.

</details>

---

**SQL Techniques Used**

`CTEs` · `CASE WHEN` · `COUNT(DISTINCT)` · `GROUP BY` · `Conditional Aggregration` · `TIMESTAMPDIFF` 




