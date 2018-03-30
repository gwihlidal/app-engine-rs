app-engine-rs
--
docker build -t gcr.io/YOUR_PROJECT_ID/rust-app-engine:v1 .
docker run -p 8080:8080 -P gcr.io/YOUR_PROJECT_ID/rust-app-engine:v1

gcloud docker -- push gcr.io/YOUR_PROJECT_ID/rust-app-engine:v1
gcloud app deploy --image-url gcr.io/YOUR_PROJECT_ID/rust-app-engine:v1