# Data Usage and Transformation Documentation

## Overview

This application allows users to upload and analyze datasets in a reproducible and model-ready way. Before the data is used for modeling, it is **validated, cleaned, transformed, and encoded** to ensure compatibility with machine learning algorithms and to prevent common data quality issues.

The data preparation pipeline consists of **input validation**, **automatic cleaning**, **feature selection**, **train/test splitting**, and **numerical encoding**.

---

## 1. Data Loading

* The dataset is loaded into the application and immediately converted into a `data.table` structure for efficient processing.
* A default dataset (`iris`) is used when no user dataset is provided.
* The dataset metadata (title, variables, detected columns) is stored using `reactiveValues` to allow dynamic interaction in the Shiny application.

```r
data <- data.table(data)
```

---

## 2. Dataset Size Validation

To ensure performance and prevent memory issues:

* Datasets larger than **1 million rows** are rejected.
* An error is raised immediately if the limit is exceeded.

```r
if (nrow(data) > 1e6) {
  stop("Input dataset must not exceed one million rows")
}
```

---

## 3. Column Name Sanitization

To ensure compatibility with R and modeling functions:

* Column names are cleaned by:

  * Removing leading or trailing special characters
  * Enforcing valid R naming conventions
  * Ensuring column names are unique

If any column names are modified, the user is notified via a warning message in the UI.

**Purpose:**

* Prevents errors in modeling functions
* Ensures consistent variable referencing

---

## 4. Automatic Detection and Removal of ID Columns

Columns that are unlikely to be useful for modeling are automatically removed. A column is considered an **ID column** if:

* It is a character or factor column with very high cardinality
  (more than 50% unique values), **or**
* Its name ends with `"id"` (case-insensitive)

```r
(is.character(x) || is.factor(x)) && length(unique(x)) > 0.5 * length(x)
```

**Purpose:**

* Prevents data leakage
* Reduces model complexity
* Removes non-informative identifiers

Users are notified when such columns are removed.

---

## 5. Date and Timestamp Column Removal

* Columns containing `Date` or `POSIXct` values are detected automatically.
* These columns are removed before modeling.

**Reasoning:**

* Most machine learning models cannot directly handle raw date objects
* Temporal feature engineering is out of scope for automatic processing

Users are informed whenever date columns are removed.

---

## 6. Available Variables Tracking

After cleaning:

* The remaining column names are stored as `available_variables`
* Date and ID columns are tracked separately
* These values are used to dynamically populate feature and target selectors in the UI

---

## 7. Target and Feature Selection

### Target Variables

* Only **numeric or integer columns** are allowed as prediction targets
* Date columns are excluded
* Ensures compatibility with regression and classification models

### Feature Variables

* Users can select a subset of available variables
* The selected target variable is automatically excluded from features

This prevents invalid configurations and circular dependencies.

---

## 8. Train/Test Split

The dataset is split into **training and testing sets** using random sampling.

* Default split: **70% training / 30% testing**
* The split is configurable
* Sampling is row-based and randomized

```r
index <- sample(seq_len(nrow(data)), split$train * 0.01 * nrow(data))
```

**Purpose:**

* Enables proper model evaluation
* Prevents overfitting

---

## 9. Data Type Normalization

Before encoding:

* Numeric and integer columns are preserved
* All non-numeric columns are converted to factors

```r
if (!is.numeric(data_train[[col]]) && !is.integer(data_train[[col]])) {
  data_train[[col]] <- as.factor(data_train[[col]])
}
```

**Purpose:**

* Ensures consistent categorical handling
* Prevents unexpected behavior during encoding

---

## 10. Feature Selection Application

If the user selects specific features:

* Only the selected features and the target variable are retained
* Both training and test datasets are filtered identically

**Purpose:**

* Reduces dimensionality
* Improves model interpretability and performance

---

## 11. Feature Encoding for Modeling

To make the data usable for machine learning models:

* Categorical variables are **one-hot encoded** using `model.matrix`
* Encoding is applied consistently to training and test sets
* The target variable is preserved in its original form

```r
model.matrix(~ . -1, data = x_train)
```

### Outputs Produced

The pipeline produces four datasets:

| Dataset              | Description                    |
| -------------------- | ------------------------------ |
| `data_train`         | Clean, unencoded training data |
| `data_test`          | Clean, unencoded test data     |
| `data_train_encoded` | One-hot encoded training data  |
| `data_test_encoded`  | One-hot encoded test data      |

---

## 12. Resulting Data Quality

After processing, the data is:

* Free of invalid column names
* Free of ID and date columns
* Type-safe and consistent
* Encoded and ready for machine learning models
* Split into training and test sets

---

## Summary

The data preparation pipeline ensures that all datasets entering the application are **clean, valid, and model-ready**. By automatically handling common data quality issues—such as invalid column names, ID leakage, categorical encoding, and train/test splitting—the application reduces user error and enforces best practices in data science workflows.