# GitHub configuration

Create the Environments `dev`, `staging`, `production`; set each of these on every environment (or as repository secrets).

## Secrets
| Name | Used for |
|---|---|
| `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` | Terraform state bucket and AWS resources |
| `SCW_ACCESS_KEY`, `SCW_SECRET_KEY` | Scaleway provider |
| `CLOUDFLARE_API_TOKEN` | Terraform DNS records |
| `CLOUDFLARE_SECRET_API_KEY` | cert-manager DNS-01 challenge |
| `SSH`, `SSH_PRIVATE_KEY` | public key injected by Terraform / private key used by Ansible |
| `ANSIBLE_USER` | user created by cloud-init |
| `PUBLIC_KEY_PEM` | CloudFront signed-URL public key (only if storage is enabled) |
| `DOCKER_USERNAME`, `DOCKER_PASSWORD`, `DOCKER_EMAIL` | ghcr.io pull secret created in the cluster (a PAT with `read:packages`) |
| `GH_CLI_TOKEN` | deploy workflows, to find and download the kubeconfig artifact |
| `SESSION_SECRET_BASE64` | demo secret injected into the API chart (base64) |
| `RELEASE_PLEASE_TOKEN` | repository secret, a PAT so release tags trigger workflows |

## Variables
`SCW_PROJECT_ID`, `LETSENCRYPT_EMAIL`, `CLOUDFLARE_ACCOUNT_EMAIL`.
