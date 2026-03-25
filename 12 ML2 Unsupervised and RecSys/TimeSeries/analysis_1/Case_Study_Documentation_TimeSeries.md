# Case Study Documentation: Ad Ease Multi-Language Page View Forecasting

## 1) Business Framing

- Objective: forecast language-level Wikipedia page views to improve ad placement, timing, and budget allocation.
- Why time series: demand evolves over time with trend, weekly seasonality, and event-driven spikes.
- Value to Ad Ease:
  - better inventory planning,
  - stronger campaign timing decisions,
  - improved cost efficiency by language market.

## 2) Dataset Understanding

- Primary dataset: train_1.csv
- Grain: each row is a page; each date column contains daily page views.
- Page identifier format contains:
  - page name,
  - language domain,
  - access type,
  - access origin/agent.
- Working analytical level in notebook: aggregated daily views per language.

## 3) Data Quality and Preprocessing

- Checked:
  - schema shape and data types,
  - missingness by column and row patterns,
  - duplicate rows and duplicate page keys.
- Parsed page metadata using regex:
  - language,
  - access type,
  - access agent.
- Converted wide date columns to numeric safely.
- Aggregated language-level time series using robust groupby sum across date columns.

## 4) EDA Highlights

- Univariate:
  - language-wise total view distribution,
  - daily overall trend.
- Bivariate:
  - rolling trend comparison across top languages.
- Multivariate:
  - correlation heatmap between top language series.
- Volatility diagnostics:
  - outlier share via IQR,
  - skewness (raw and log-transformed scale).

## 5) Time-Series Diagnostics

- Stationarity: ADF test per language.
- Decomposition: additive trend + weekly seasonality + residual for top languages.
- Differencing checks:
  - first difference,
  - seasonal lag-7 difference.
- ACF/PACF used to guide ARIMA/SARIMA structural decisions.

## 6) Modeling Strategy

Chronological split (leakage-safe):

- train: earliest segment,
- validation: next 60 days,
- test: final 60 days.

Baselines:

- Naive,
- Seasonal Naive (period=7),
- Moving Average (window=7).

Advanced models:

- ARIMA (small grid for order tuning via validation RMSE),
- SARIMA/SARIMAX with weekly seasonality,
- SARIMAX exogenous campaign input enabled only when campaign file is available.

Optional benchmark:

- Prophet (if package available in runtime).

## 7) Evaluation Metrics

Used regression-style forecast metrics:

- MAE,
- RMSE,
- R2,
- sMAPE.

Model selection rule:

- rank by validation RMSE,
- confirm on test RMSE and sMAPE.

## 8) Interpretation and Stakeholder Translation

- Winning model differs by language; not all series benefit equally from complex models.
- Weekly seasonality is a strong signal across multiple languages.
- Event spikes produce residual autocorrelation risk and can degrade pure univariate models.
- Practical recommendation: language-specific model portfolio instead of one global model.

## 9) Trade-offs and Risks

Trade-offs:

- Simpler models: faster and easier to operate, but can underfit event-heavy series.
- Complex seasonal models: better fit in many cases, but higher maintenance.

Risks:

- event shocks can invalidate recent patterns,
- missing exogenous inputs limit causal context,
- metadata format drift can break parsing.

## 10) Monitoring Plan

- Daily monitoring by language:
  - MAE, RMSE, sMAPE.
- Drift alerts:
  - trigger when rolling error exceeds threshold versus trailing baseline.
- Governance:
  - monthly backtesting,
  - regular model refresh (weekly/biweekly),
  - fallback to seasonal-naive when advanced model instability is detected.

## 11) Interview-Ready 30-Second Script

"I translated Ad Ease's ad-optimization question into a multi-language forecasting pipeline. I started with robust quality checks and metadata extraction, then built leakage-safe train/validation/test splits. I benchmarked naive baselines against tuned ARIMA and weekly SARIMA/SARIMAX models using MAE, RMSE, R2, and sMAPE. The key finding is that model performance varies by language, so a language-specific model portfolio with active monitoring provides better operational reliability than one universal model."
