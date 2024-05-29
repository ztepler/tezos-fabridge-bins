```
docker build --no-cache -t tezos-fabridge-bins -f Dockerfile .
docker save -o tezos-fabridge-bins.tar tezos-fabridge-bins
docker login
docker tag tezos-fabridge-bins ztepler/tezos-fabridge-bins:latest
docker push your-dockerhub-username/tezos-fabridge-bins:latest
```

