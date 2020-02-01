docker build -t hellojs:latest .
docker run --rm -p 8080:8080 hellojs:latest
docker tag hellojs:latest gcr.io/serverless-world-demo/hellojs:latest

docker push gcr.io/serverless-world-demo/hellojs:latest
gcloud run deploy serverlessworlddemo --image gcr.io/serverless-world-demo/hellojs:latest --platform managed --region europe-west1