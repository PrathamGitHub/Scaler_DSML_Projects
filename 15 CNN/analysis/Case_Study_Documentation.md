# Case Study Documentation: Produce Image Classification (Company A)

## 1) Business Case Narrative for Stakeholder Discussion

### Business Objective
Company A needs a reliable computer-vision classifier to identify images as potato, onion, tomato, or noise (non-target scenes). This supports automated sorting and reduces wrong-item dispatch risk in time-sensitive produce operations.

### Why This Matters
- Faster and more accurate sorting reduces operational bottlenecks.
- Better classification quality lowers downstream returns/replacements.
- Confidence-calibrated predictions enable safe automation with human fallback.

### Success Metrics
- Primary: Macro F1 on holdout test set.
- Secondary: Class-wise precision/recall, ROC-AUC (OvR), PR-AUC, calibration quality, confusion matrix error profile.

## 2) Technical Design Choices (Interview Ready)

### Data Audit and EDA
- Built file-level schema for all images with: class, path, extension, width, height, channels, mode, file size, hash.
- Performed checks for missing metadata, corrupt images, duplicate files (content hash), and class count consistency.
- Conducted univariate analysis on class distribution and geometric features.
- Conducted bivariate/multivariate analysis using class vs brightness/color signal and dimensional behavior.
- Performed outlier and skewness diagnostics for width, height, pixels, and aspect ratio.

### Preprocessing and Feature Engineering
- Standardized image size to 224x224.
- Normalized with ImageNet statistics for transfer-learning compatibility.
- Applied train-only augmentation: flip, rotation, color jitter.
- Used weighted sampling to mitigate mild class imbalance.
- Kept strict split discipline (train/validation/test) to avoid leakage.

### Modeling Strategy
1. Baseline 1: Logistic Regression on RGB histogram features.
2. Baseline 2: Custom CNN from scratch.
3. Tuned model: ResNet18 transfer learning with two-stage training:
   - Stage 1: classifier head training.
   - Stage 2: selective fine-tuning of deeper residual layers.

### Evaluation Stack
- Accuracy, macro precision, macro recall, macro F1.
- Macro ROC-AUC (OvR) and macro PR-AUC.
- Confusion matrix for class-wise failure analysis.
- Calibration curve and Brier score for confidence reliability.

### Model Interpretation
- Gradient-based saliency overlays used as image-domain equivalent of feature importance.
- Supports QA by showing which regions drive model decisions.

### Model Artifact
- Best model persisted as a PyTorch checkpoint (`best_model_final.pt`) with class mapping and image size metadata.

## 3) What to Say in an Interview or Stakeholder Review

### 30-Second Technical Pitch
I converted an image-folder dataset into a governed ML workflow with explicit data quality checks, robust EDA, and leakage-safe model validation. I benchmarked classical and deep-learning baselines, selected a transfer-learning model on validation macro F1, and validated on holdout test using both discrimination and calibration metrics. I also added saliency-based interpretability and deployment-ready model persistence.

### Trade-off Framing
- Transfer models improve generalization but add dependency and retraining complexity.
- Confidence thresholding reduces false auto-routing but increases manual review volume.
- Ensembling can improve robustness but increases inference latency.

## 4) If Performance Becomes Unstable: Alternative Strategies

### Alternative A: EfficientNet-B0 Transfer Learning
- Pros: strong performance/parameter ratio, often robust for medium image datasets.
- Cons: may need tighter learning-rate and augmentation controls.

### Alternative B: Soft-Voting Ensemble (Scratch CNN + Transfer Model)
- Pros: improved robustness and often better calibration.
- Cons: increased compute and deployment complexity.

## 5) Risks, Assumptions, Monitoring Plan

### Assumptions
- Labels are largely correct in source folders.
- Production camera setup is reasonably aligned with training domain.

### Key Risks
- Domain shift from new backgrounds/light conditions.
- Cross-class confusion in cluttered market scenes.
- Calibration drift over time.

### Monitoring Plan
- Weekly class-wise precision/recall on audited samples.
- Data drift checks: brightness, color histograms, class mix.
- Confidence monitoring: overconfidence/underconfidence trend.
- Retraining trigger: macro F1 degradation beyond SLA threshold.

## 6) LinkedIn Project Section

### Suggested Title
Production-Ready Computer Vision Classifier for Fresh Produce Routing (PyTorch)

### Suggested Description
Developed an end-to-end computer vision case study for Company A to classify images into potato, onion, tomato, and noise categories. Built a complete pipeline covering data audit, EDA, augmentation, stratified validation design, baseline benchmarking, transfer learning with ResNet18, and holdout test evaluation using macro F1, ROC-AUC, PR-AUC, confusion matrix, and calibration diagnostics. Added saliency-based model interpretation and saved deployment-ready model artifacts with confidence-based inference.

### Optional Short Description
Built and validated a PyTorch image classifier with business-grade evaluation, interpretability, and monitoring design for automated produce sorting.
