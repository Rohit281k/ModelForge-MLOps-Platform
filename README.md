# Model Anywhere MLOps Platform

A production-style open-source MLOps platform where you can plug in **any ML model** and run the full lifecycle:

```text
Data Ingestion -> Data Versioning -> Validation -> Feature Store -> Training -> Experiment Tracking -> Model Registry -> Packaging -> Deployment -> Monitoring -> Drift Detection -> Retraining -> GitOps Release
```

## Open-source stack

| Lifecycle Area | Tool |
|---|---|
| Data versioning | DVC |
| Data lake branching | lakeFS |
| Data validation | Great Expectations |
| Feature store | Feast |
| Experiment tracking | MLflow |
| Model registry | MLflow Registry |
| Pipeline orchestration | Kubeflow Pipelines |
| Hyperparameter tuning | Katib |
| Model packaging | BentoML |
| REST API | FastAPI/BentoML |
| Containerisation | Docker |
| Orchestration | Kubernetes |
| Model serving | KServe |
| Autoscaling | HPA |
| Drift reports | Evidently |
| Performance monitoring | NannyML-style alert JSON |
| Metrics | Prometheus |
| Dashboards | Grafana |
| GitOps | Argo CD |
| Release packaging | Helm |

---

## Architecture

```text
                 +----------------------+
                 | Any ML Model Code    |
                 | sklearn/xgboost/bert |
                 +----------+-----------+
                            |
                            v
Raw Data -> lakeFS -> DVC -> Great Expectations -> Feast
                            |
                            v
                    Kubeflow Pipeline
                            |
              +-------------+-------------+
              |                           |
              v                           v
        Katib Tuning                 MLflow Tracking
                                          |
                                          v
                                  MLflow Registry
                                          |
                                          v
                                   BentoML Service
                                          |
                                          v
                                      Docker Image
                                          |
                                          v
                                 Kubernetes + KServe
                                          |
                                          v
                         HPA + Prometheus + Grafana
                                          |
                                          v
                           Evidently + NannyML Alerts
                                          |
                                          v
                              Retraining Trigger
                                          |
                                          v
                               Argo CD GitOps Sync
```

---

## Quick start

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

make data
make validate
make train
make monitor
make serve
```

Test local API:

```bash
curl -X POST http://127.0.0.1:3000/predict \
  -H 'Content-Type: application/json' \
  -d '{"features":{"feature_1":5.1,"feature_2":3.5,"feature_3":1.4,"feature_4":0.2}}'
```

---

## Plug in any model

Edit this file:

```text
src/model_plugin/custom_model.py
```

Required interface:

```python
class CustomModel:
    def train(self, X, y):
        pass

    def predict(self, X):
        pass

    def predict_proba(self, X):
        pass
```

The platform does not care if the model is:

```text
Logistic Regression
Random Forest
XGBoost
LightGBM
CatBoost
BERT
LSTM
PyTorch
TensorFlow
Custom Python model
```

As long as it follows the adapter interface.

---

## DVC lifecycle

```bash
dvc init
dvc repro
dvc dag
```

---

## MLflow lifecycle

```bash
mlflow ui --host 0.0.0.0 --port 5000
make train
```

Model is registered as:

```text
universal_mlops_model
```

---

## BentoML local serving

```bash
bentoml serve serving/bentoml_service.py:svc --reload --port 3000
```

---

## Docker

```bash
docker build -t rohit1k/model-anywhere-mlops:latest .
docker run -p 3000:3000 rohit1k/model-anywhere-mlops:latest
```

---

## Helm deployment

```bash
helm upgrade --install model-anywhere charts/model-anywhere \
  -n mlops --create-namespace \
  --set image.repository=rohit1k/model-anywhere-mlops \
  --set image.tag=latest
```

Enable KServe:

```bash
helm upgrade --install model-anywhere charts/model-anywhere \
  -n mlops --create-namespace \
  --set image.repository=rohit1k/model-anywhere-mlops \
  --set image.tag=latest \
  --set kserve.enabled=true
```

---

## Retraining trigger

```bash
make monitor-and-retrain
```

Flow:

```text
Evidently/NannyML alert JSON -> retraining trigger -> DVC/Kubeflow pipeline -> MLflow Registry -> Argo CD deployment
```

---

## Resume description

```text
Designed a reusable open-source MLOps platform to deploy any ML model through a full production lifecycle using DVC, lakeFS, Great Expectations, Feast, MLflow Registry, Kubeflow, Katib, BentoML, Docker, Kubernetes, KServe, HPA, Evidently, NannyML-style alerts, Prometheus/Grafana, Helm and Argo CD for automated training, serving, monitoring, drift detection and retraining.
```
