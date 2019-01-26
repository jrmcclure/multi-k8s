#!/usr/bin/env bash
docker build -t jrmcclure/multi-client:latest -t jrmcclure/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jrmcclure/multi-server:latest -t jrmcclure/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jrmcclure/multi-worker:latest -t jrmcclure/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push jrmcclure/multi-client:latest
docker push jrmcclure/multi-server:latest
docker push jrmcclure/multi-worker:latest

docker push jrmcclure/multi-client:$SHA
docker push jrmcclure/multi-server:$SHA
docker push jrmcclure/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=jrmcclure/multi-server:$SHA
kubectl set image deployments/client-deployment client=jrmcclure/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=jrmcclure/multi-worker:$SHA
