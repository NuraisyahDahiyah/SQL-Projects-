SELECT * FROM user_events LIMIT 1000;

-- 1.0 define sales funnel and the different stages alter --
WITH funnel_stages AS (
SELECT 
	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_view,
	COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
	COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
	COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
	COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
FROM user_events
WHERE event_date >= '2026-01-04' AND event_date <= '2026-02-03' # setting a specific period to avoid errors
#for a dynamic approach: event_date >= NOW() - INTERVAL 30 DAY OR event_date >= DATE_SUB(CUR_DATE(), INTERVAL 30 DAY)
)
SELECT * FROM funnel_stages; 


-- 2.0 conversion rates through the funnel --
WITH funnel_stages AS (
SELECT
	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_view,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
	COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
	COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
	COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
FROM user_events
WHERE event_date >= '2026-01-04' AND event_date <= '2026-02-03'
)
SELECT 
 stage_1_view,
 stage_2_cart,
 ROUND(stage_2_cart * 100 / stage_1_view) AS view_to_cart_rate,
 
 stage_3_checkout,
 ROUND(stage_3_checkout * 100 / stage_2_cart) AS cart_to_checkout_rate,
 
 stage_4_payment,
 ROUND(stage_4_payment * 100 / stage_3_checkout) AS checkout_to_payment_rate,

stage_5_purchase,
ROUND(stage_5_purchase * 100 / stage_4_payment) AS payment_to_purchase_rate,
ROUND(stage_5_purchase * 100 / stage_1_view) AS overall_conversion_rate

FROM funnel_stages;

# ASSUMPTIONS
# Highest conversion rate is payment_to_purchase and Lowest conversion rate is view_to_cart
# No major bottlenecks in customers making payment and with room to further improve the experience when customers are checking out to payment 
# A lot of people are just browsing without actually putting items in the cart but those who have items in the cart are very likely to move on to the next funnel stage
# Opportunity: Can something be done to improve view_to_cart conversion rate? More targeted ads? Website experience? Are people not finding the items that want? 

-- 3.0 funnel by source --
WITH source_funnel AS (
SELECT
traffic_source, 
	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
	COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS carts,
	COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases
FROM user_events
WHERE event_date >= '2026-01-04' AND event_date <= '2026-02-03' 

GROUP BY traffic_source
)

SELECT 
	traffic_source, 
	views,
	carts,
	purchases, 
	ROUND(carts * 100 / views) AS cart_conversion_rate,
	ROUND(purchases * 100 / views) AS purchases_conversion_rate,
	ROUND(purchases * 100 / carts) AS cart_to_purchase_conversion_rate

FROM source_funnel
ORDER BY purchases DESC;

# ASSUMPTIONS
# a lot of people visit the website through organic and social
# email performs well in having the highest % of customers putting items in their cart, where as social media has the lowest 
# similarly, the same behaviour is seen for purchases 
# social media is bringing in a lot of views but it does not bring in high % of customers that are actually purchasing vice versa for email 


-- 4.0 time to conversion analysis --
WITH user_journey AS (
SELECT
user_id, 
	MIN(CASE WHEN event_type = 'page_view' THEN event_date END) AS view_time,
	MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
	MIN(CASE WHEN event_type = 'purchase' THEN event_date END) AS purchase_time
FROM user_events
WHERE event_date >= '2026-01-04' AND event_date <= '2026-02-03' 
GROUP BY user_id
HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL

)
SELECT 
	COUNT(*) AS converted_users,
	ROUND(AVG(TIMESTAMPDIFF(MINUTE, view_time, cart_time)),2) AS avg_view_to_cart_minute, 
	ROUND(AVG(TIMESTAMPDIFF(MINUTE, cart_time, purchase_time)),2) AS avg_cart_to_purchase_minute,
	ROUND(AVG(TIMESTAMPDIFF(MINUTE, view_time, purchase_time)),2) AS avg_total_journey_minute
    
FROM user_journey;

# ASSUMPTIONS
# realistic numbers 
# question to ask: does the business expect customers to spend around 24 minutes for the whole journey? 

-- 5.0 revenue funnel analysis --
WITH funnel_revenue AS (
SELECT
	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors, 
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers, 
    SUM(CASE WHEN event_type = 'purchase' THEN amount END) AS total_revenue, 
    COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_orders 
    
FROM user_events
WHERE event_date >= '2026-01-04' AND event_date <= '2026-02-03' 
)

SELECT
	total_visitors,
    total_buyers,
    total_orders, 
    ROUND(total_revenue, 2),
    
    ROUND(total_revenue / total_orders, 2) AS avg_order_value,
    ROUND(total_revenue / total_buyers, 2) AS revenue_per_buyer,
    ROUND(total_revenue / total_visitors, 2) AS revenue_per_visitor
    
FROM funnel_revenue;

# ASSUMPTIONS
# compare avg_order_value with CAC to see if profit is being made from each customer and by how much 

-- 6.0 FINAL RECCOMENDATIONS --
# 1. UX & Website Optimization: 
# 	Dont't touch the checkout flow: the conversion rates from checkout to purchase are excellent (~80%+).
#	This indicates the technical payment flow is frictionless.
#	ACTION: Do not redesign the checkout page right now, you risk breaking something that is working perfectly

# 2. Marketing Strategy
#	Stop Over Investing in Social for Sales:
#	Social media is driving 30% of traffic (volume) but has the lowest conversion rate (efficieny). We are likely paying for "window shoppers".
#	ACTION: Shift budget away from "traffic" objectives on social ads and focus on "retargeting" or "lead gen" to capture emails instead

#	Double Down on Email Marketing:
#	Email is our highest converting channel (~13%+ conversion  rate vs ~6% for social)
# 	ACTION: implement an aggresive email capture popup for those high-volume social visitors. If we can get them onto our email list, our data proves they are far more likely to buy later

# 3. Financial & Revenue
#	Audit Ad Spend Against AOV: we found our Average Order Value (AOV) is ~$107 
#	ACTION: set a strict CAC limit. 
#	If we are paying more than $30-$40 to acquire those customers on social media ads (which convert poorly), we are likely loosing money on those specific  transactions made




