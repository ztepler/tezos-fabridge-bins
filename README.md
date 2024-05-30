# Build image:
```
docker build --build-arg REPO="https://gitlab.com/baking-bad/tezos.git" --build-arg BRANCH="feat/token-deposits-squashed-v4" -t tezos-fabridge-bins .
```

# Run locally:
```
docker run -it --rm tezos-fabridge-bins /bin/bash
```

# Push:
```
docker tag tezos-fabridge-bins ztepler/tezos-fabridge-bins:latest
docker push your-dockerhub-username/tezos-fabridge-bins:latest
```

