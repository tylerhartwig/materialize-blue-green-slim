# materialize-blue-green-slim

A simple dbt project demonstrating Materialize blue-green deployments combined with slim deployments.

## Project Structure

This project contains 3 models:
- `foo.sql` - Base model with people and their favorite colors
- `bar.sql` - References `foo` and adds color categories
- `foobar.sql` - References `bar` and adds mood classifications

All models are deployed to the `blue_green_slim` schema as views.

## Blue-Green Deployment with Slim CI/CD

### Overview

This project demonstrates how to combine Materialize's blue-green deployment capabilities with dbt's slim deployment features for efficient CI/CD workflows.

**Blue-Green Deployment**: Creates a parallel environment for testing changes before swapping to production, ensuring zero-downtime deployments -- the blue/green schema could remain as an active configuration to potentially reduce hydration time.

**Slim Deployment**: Only builds models that have changed since a previous state, reducing build times and compute costs.

### POC Workflow

#### 1. Initial Setup

```bash
# Install dependencies
pip install dbt-materialize

# Deploy models normally to establish baseline
dbt run

```

#### 2. Blue-Green with Slim Deployment Sequence

```bash
# Initialize blue-green deployment environment
dbt run-operation deploy_init

# Copy deployed state so we can do a slim deployment later
mkdir -p state
cp target/manifest.json state/manifest.json

# Deploy all models to blue-green environment
dbt run --vars 'deploy: True'

# Make an arbitrary change to bar.sql then continue

# Deploy only the modified models
dbt run --vars 'deploy: True' --select state:modified+ --state state/

# Wait for hydration to finish (should only be modified models)
dbt run-operation deploy_await

# Promote blue-green environment to production
dbt run-operation deploy_promote

# Once promotion is finished, bring the other environment up-to-date
dbt run --vars 'deploy: True' --select state:modified+ --state state/

# update state
cp target/manifest.json state/manifest.json

# Instead of cleaning up, keep environment running for future changes
```

