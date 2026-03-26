# Case Study Documentation: Neural Network Regression for Delivery Time Prediction

## 1) Business and Technical Framing

### Business objective

Build a reliable ETA prediction system for Company A (anonymized intra-city logistics platform) to improve customer communication, reduce SLA misses, and optimize partner allocation.

### Why this matters

- Better ETA quality increases customer trust and repeat usage.
- Stronger delivery-time predictions improve dispatch prioritization.
- Operational planning improves when delay-risk orders are identified early.

### Problem formulation

- Task type: Supervised regression.
- Target variable: `delivery_time_min`, engineered as:

$$
\text{delivery\_time\_min} = \frac{\text{actual\_delivery\_time} - \text{created\_at}}{60\ \text{seconds}}
$$

- Modeling goal: minimize error while maintaining interpretability and production stability.

## 2) Data Strategy and EDA Decisions

### Data quality checks performed

- Schema audit (types, cardinality, missingness).
- Duplicate detection and removal.
- Datetime parsing with invalid-row filtering.
- Guardrails for unrealistic delivery durations.

### EDA highlights

- Univariate:
  - Delivery time and operational load variables are right-skewed.
  - Market/category distributions are imbalanced.
- Bivariate:
  - Delivery time rises with estimated store-to-customer driving duration.
  - Peak-hour windows show elevated median delivery times.
- Multivariate:
  - Combined load and distance signals explain large variation in ETA.

### Outlier rationale

Outliers were not aggressively removed because extreme delays can represent real business events (traffic spikes, demand bursts, dispatch constraints). Instead, robust preprocessing and nonlinear models were used.

## 3) Feature Engineering and Preprocessing

### Features added

- Time features: `order_hour`, `order_dayofweek`, `is_weekend`, `order_month`.
- Load features:
  - `partner_load_ratio = total_busy_dashers / (total_onshift_dashers + 1)`
  - `outstanding_to_onshift_ratio = total_outstanding_orders / (total_onshift_dashers + 1)`
- Basket-price structure:
  - `price_range = max_item_price - min_item_price`
  - `avg_item_price_proxy = subtotal / total_items`

### Leakage-safe pipeline

- Split strategy: train/validation/test = 70/15/15.
- Imputation, scaling, and encoding fitted on train only.
- Categorical: one-hot encoding.
- Numeric: median imputation + standardization.

## 4) Model Development Strategy

### Baselines first

1. Dummy median regressor
2. Linear regression
3. Random forest regressor
4. HistGradientBoosting regressor

### Preferred advanced model

- PyTorch feed-forward neural network:
  - ReLU hidden activations
  - Linear output layer (regression)
  - Batch normalization + dropout
  - Adam optimizer with early stopping

### Why Adam

Adam handles noisy gradients and mixed-scale tabular data well with adaptive learning rates, reducing manual tuning burden.

## 5) Evaluation Framework

### Core metrics

- MAE: average absolute error in minutes.
- RMSE: penalizes large misses more heavily.
- R2: explained variance.

### Diagnostic checks

- Residuals vs predictions.
- Residual distribution shape.
- Actual vs predicted scatter against ideal diagonal.

### Stability check

The selected NN configuration is retrained across multiple seeds; performance variance is tracked. If variance is high, fallback alternatives are compared.

## 6) Interpretation Layer

### Explainability used

- Permutation importance (SHAP-equivalent approach for global feature influence).

### Business interpretation

Top predictors are usually driving-duration proxies and operational load indicators, which map directly to staffing, dispatch, and queue prioritization decisions.

## 7) Trade-offs and Deployment View

### Trade-offs

- Neural network:
  - Pros: captures nonlinear interactions effectively.
  - Cons: higher monitoring burden and sensitivity to drift.
- Tree ensembles:
  - Pros: strong tabular performance with stable behavior.
  - Cons: may underperform in complex nonlinear regimes.

### Deployment recommendation

Adopt a champion-challenger framework with NN as champion and a tree model as challenger for safe rollouts.

## 8) Risks, Assumptions, and Monitoring Plan

### Assumptions

- Historical patterns remain representative in the short term.
- Real-time operational features are available at scoring time.

### Risks

- Drift from seasonal or operational changes.
- Missingness spikes in partner-load fields.
- New category/market expansion causing feature distribution shifts.

### Monitoring plan

- Weekly segmented MAE/RMSE/R2 by hour, market, and category.
- Feature drift and prediction drift alerts.
- Retraining trigger after sustained error degradation.
- Ongoing champion-challenger comparison.

## 9) Interview/Stakeholder Ready Talking Points

1. Problem statement and uses:
   Predict delivery time to improve ETA reliability, staffing strategy, and customer communication.

2. Three pandas datetime functions:

- `pd.to_datetime()`: parses string/object values into datetime.
- `.dt.hour`: extracts hour for intraday demand patterns.
- `.dt.dayofweek`: captures weekly cyclic effects.

3. Datetime vs timedelta vs period:

- Datetime: a timestamp point.
- Timedelta: elapsed time between points.
- Period: a span bucket such as a week or month.

4. Why check outliers:
   They can skew model fit and metrics, and they may represent real operational exceptions requiring policy decisions.

5. Three outlier methods:
   IQR capping/winsorization, z-score filtering, robust transforms/scalers.

6. Classical ML options:
   Linear Regression, Random Forest, Gradient Boosting.

7. Why scaling for NN:
   Improves optimization conditioning, convergence speed, and gradient stability.

8. Optimizer choice:
   Adam, because adaptive updates reduce sensitivity to initial learning-rate settings.

9. Activation function:
   ReLU in hidden layers for nonlinear capacity and efficiency; linear output for continuous target.

10. Why NN benefits from large data:
    More data helps represent complex feature interactions and improves generalization.

## 10) LinkedIn Project Content

### Recommended title

Neural Network Regression for Delivery ETA Optimization: A Business-Ready Logistics Case Study

### Recommended project description

Built an end-to-end delivery-time prediction solution for an anonymized intra-city logistics platform (Company A). The workflow included robust data quality checks, timestamp-based target engineering, leakage-safe preprocessing, and baseline benchmarking before deploying a tuned PyTorch neural network. I evaluated MAE, RMSE, and R2, performed residual diagnostics, and added model-interpretation using permutation importance.

The project translated technical outcomes into operational actions: peak-hour staffing optimization, queue prioritization for delay-prone orders, and a production-grade monitoring plan with champion-challenger fallback models. This work demonstrates how ML can directly improve ETA reliability and customer experience in logistics operations.
