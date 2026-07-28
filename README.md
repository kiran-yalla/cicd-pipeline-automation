# cicd-pipeline-automation

Sample Jenkins declarative pipeline and deployment automation scripts demonstrating a typical enterprise CI/CD release workflow.

## What this demonstrates

- 🔁 **Declarative Jenkins pipeline** — checkout, build, unit test, package, deploy, and smoke-test stages with parameterized environment promotion (dev/staging/prod).
- 🚀 **Deployment automation** — a release-directory/symlink deployment pattern (`scripts/deploy.sh`) for zero-downtime style releases.
- ⏪ **Automated rollback** — `scripts/rollback.sh` reverts to the previous release automatically on pipeline failure for non-dev environments.
- ✅ **Post-deploy validation** — `scripts/smoke-test.sh` runs a health-check against the deployed environment before marking the release successful.

## Structure

```
.
├── Jenkinsfile           # Declarative pipeline definition
└── scripts/
    ├── build.sh          # Install dependencies and produce build artifacts
    ├── run-tests.sh      # Execute unit tests
    ├── deploy.sh         # Release + symlink-based deployment
    ├── rollback.sh       # Revert to previous release on failure
    └── smoke-test.sh     # Post-deploy health check
```

## Usage

This pipeline is designed to run inside Jenkins with the `DEPLOY_ENV` parameter (`dev`, `staging`, or `prod`) selected at build time. The scripts can also be run standalone for local testing:

```bash
./scripts/build.sh
./scripts/run-tests.sh
./scripts/deploy.sh dev
./scripts/smoke-test.sh dev
```

> This is a portfolio/demonstration repository showing CI/CD pipeline design and deployment automation patterns. Paths, hostnames, and service names are illustrative — adapt them to your actual infrastructure before real-world use.

## Author

Kiran Yalla — Senior Platform Engineer specializing in DevOps automation, CI/CD pipeline design, and enterprise release engineering.
