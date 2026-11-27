# Security policy

This project uses **dummy employee data only**. Never commit real personal data, credentials, AWS account IDs, tokens or keys.

- Report a suspected secret leak immediately to @amit-cloudops-ai, then rotate the secret.
- Deploys use GitHub OIDC; there are no long-lived AWS access keys in this repo or in GitHub secrets.
- Access to the dashboard is limited to Cognito groups `HR_Admin` and `Leadership`.
