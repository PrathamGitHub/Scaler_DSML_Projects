# Case Study Documentation: Zee Personalized Movie Recommender

## 1) Business Framing and Technical Narrative

### A. Objective and Business Value

- Objective: build a personalized movie recommender that predicts user preferences and improves recommendation relevance.
- Expected business impact:
  - higher engagement and watch-time,
  - better session depth and return visits,
  - improved catalog utilization across popular and long-tail content.

### B. Dataset and Unit of Analysis

- Ratings file: `UserID::MovieID::Rating::Timestamp`
- Users file: `UserID::Gender::Age::Occupation::Zip-code`
- Movies file: `MovieID::Title::Genres`
- Unit of analysis: explicit user-item interaction (a rating event).

### C. Data Quality and Preprocessing

- Handled embedded header-like records in all three `.dat` files.
- Enforced proper numeric types for IDs, ratings, timestamps, age, and occupation.
- Parsed release year and decade from movie title.
- Converted timestamps to datetime for temporal split and trend checks.
- Verified missingness and duplicate behavior before modeling.

### D. EDA Highlights

- Rating distribution concentrated at 3 and 4 stars.
- Strong right-skew in ratings-per-user and ratings-per-movie confirms sparsity.
- Most active age group and occupation cohort identified from interaction volume.
- Genre-level volume and average-rating heatmap by age exposed preference heterogeneity.

### E. Feature Engineering

- User-level features: mean rating, interaction count.
- Movie-level features: mean rating, rating count.
- Temporal features: rating year and datetime.
- Genre exploded to support genre-level aggregation and preference diagnostics.

### F. Modeling Strategy

- Leakage-safe temporal split by user:
  - train: historical interactions,
  - validation: second-latest per user,
  - test: latest per user.
- Baselines first:
  - global mean,
  - regularized user-item bias model.
- Collaborative filtering:
  - item-based using Pearson correlation,
  - user-based using Cosine similarity.
- Matrix factorization:
  - Truncated SVD on user-mean-centered interaction matrix.

### G. Evaluation Metrics and Stability

- Primary metrics: RMSE and MAPE on unseen data.
- Validation-driven tuning for neighborhood size and latent factors.
- Stability check for SVD across multiple random seeds.
- Contingency alternatives benchmarked when/if instability appears.

### H. Key Interpretation

- Regularized bias model provided strongest RMSE in this run.
- User-based cosine performed competitively and remained explainable.
- Item-based Pearson had lower accuracy under current sparsity profile.
- SVD was stable across seeds but not top-accuracy versus tuned bias baseline.

### I. Stakeholder Translation Script

- "We benchmarked multiple recommender families and selected the best-performing one on leakage-safe unseen interactions."
- "The solution balances predictive quality, robustness, and deployment practicality."
- "We also retain interpretable fallback strategies for operational resilience."

## 2) Questionnaire Answer Key (Notebook-backed)

1. Users of which age group watched and rated the most movies?

- Age group 25.

2. Users belonging to which profession watched and rated the most movies?

- Occupation code 4.

3. Most users in the dataset who rated movies are Male. (T/F)

- True.

4. Most movies in dataset were released in which decade?

- 1990s.

5. Movie with maximum number of ratings?

- American Beauty (1999).

6. Top 3 movies similar to Liar Liar (item-based approach)?

- Ace Ventura: Pet Detective (1994)
- Dumb & Dumber (1994)
- Tommy Boy (1995)

7. Collaborative filtering methods are classified into **_-based and _**-based.

- User-based and Item-based.

8. Pearson Correlation range and Cosine Similarity range?

- Pearson: -1 to 1; Cosine: 0 to 1.

9. RMSE and MAPE for matrix factorization model?

- RMSE = 1.0674, MAPE = 0.3642.

10. Sparse row matrix representation for [[1, 0], [3, 7]]?

- rows = [0, 1, 1], cols = [0, 0, 1], data = [1, 3, 7].

## 3) Risks, Assumptions, Monitoring Plan

### Assumptions

- Historical explicit ratings represent short-term user preferences.
- User and movie IDs are stable over time.
- Temporal split approximates production chronology.

### Risks

- Cold-start users/items.
- Popularity bias suppressing long-tail discovery.
- Drift in preferences due to changing content trends.
- Sparse interactions harming neighborhood quality for niche content.

### Monitoring

- Offline: RMSE, MAPE, coverage, personalization, diversity.
- Online: CTR, watch-time, completion, repeat sessions, churn proxy.
- Data quality: rating volume shifts, schema drift, missingness spikes.
- Retraining cadence: monthly full retraining, with drift-triggered incremental updates.

## 4) Actionable Next Steps

1. Add implicit feedback (watch duration, completion, skips, rewatches).
2. Build hybrid recommender with content embeddings for cold start.
3. Add post-ranking controls for diversity/freshness/exploration.
4. Run controlled A/B tests for measurable business uplift.
