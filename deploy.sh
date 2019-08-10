docker build -t jamessutterfield/multi-client:latest -t jamessutterfield/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jamessutterfield/multi-server:latest -t jamessutterfield/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jamessutterfield/multi-worker:latest -t jamessutterfield/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push jamessutterfield/multi-client:latest 
docker push jamessutterfield/multi-server:latest
docker push jamessutterfield/multi-worker:latest

docker push jamessutterfield/multi-client:$SHA
docker push jamessutterfield/multi-server:$SHA
docker push jamessutterfield/multi-worker:$SHA

kubectl apply -f k8s

# imperitively apply the docker image. This forces k8s to download the latest version
kubectl set image deployments/client-deployment client=jamessutterfield/multi-client:$SHA
kubectl set image deployments/server-deployment server=jamessutterfield/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=jamessutterfield/multi-worker:$SHA