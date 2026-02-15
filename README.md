# CDK x GitHub Actions (Sandbox S3) — Docker-friendly

This repo is a tiny AWS CDK (TypeScript) project that creates a **private S3 bucket**.
It is designed so you can:
- run CDK locally via **Docker** (no local npm required)
- deploy from **GitHub Actions** (simple secrets-based credentials)

## What it creates
- S3 bucket with **Block Public Access** enabled
- Bucket policy that **denies non-TLS (HTTP) access**
- Auto-delete objects on stack deletion (CDK adds a custom resource/Lambda)

## Local (Docker) usage

### 0) Build image
```bash
docker build -t cdk-sandbox .
docker volume create cdk_node_modules
```

### 1) Synthesize (no AWS calls)
```bash
docker run --rm -it \
  -v "$PWD:/app" -w /app \
  -v cdk_node_modules:/app/node_modules \
  cdk-sandbox \
  bash -lc "cdk --version && cdk synth"
```

### 2) Diff / Deploy (needs AWS credentials)
If you have `~/.aws` configured on your host:
```bash
docker run --rm -it \
  -v "$PWD:/app" -w /app \
  -v cdk_node_modules:/app/node_modules \
  -v "$HOME/.aws:/root/.aws:ro" \
  -e AWS_REGION=ap-northeast-1 \
  -e AWS_PAGER="" \
  cdk-sandbox \
  bash -lc "cdk diff"
```

Deploy:
```bash
docker run --rm -it \
  -v "$PWD:/app" -w /app \
  -v cdk_node_modules:/app/node_modules \
  -v "$HOME/.aws:/root/.aws:ro" \
  -e AWS_REGION=ap-northeast-1 \
  -e AWS_PAGER="" \
  cdk-sandbox \
  bash -lc "cdk deploy --require-approval never"
```

Destroy:
```bash
docker run --rm -it \
  -v "$PWD:/app" -w /app \
  -v cdk_node_modules:/app/node_modules \
  -v "$HOME/.aws:/root/.aws:ro" \
  -e AWS_REGION=ap-northeast-1 \
  -e AWS_PAGER="" \
  cdk-sandbox \
  bash -lc "cdk destroy --force"
```

## GitHub Actions (deploy on push to main)
Workflow: `.github/workflows/deploy-sandbox.yml`

Add repository secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

Then push to `main` — the workflow runs `npm ci` and `npx cdk deploy --require-approval never`.

> Tip: for learning, this secrets-based approach is simplest. For production, prefer OIDC.
