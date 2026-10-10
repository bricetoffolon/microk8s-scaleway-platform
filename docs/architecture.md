# Architecture

## Provisioning flow
1. `cd-infra-provision-config` runs Terraform for one environment. State lives in S3 (`envs/<env>.backend.hcl`), locked with Terraform's native `use_lockfile`.
2. Terraform creates a Scaleway instance (cloud-init creates the Ansible user), a security group, a reserved IP, a Cloudflare A record, and optionally S3 buckets with CloudFront (signed URLs).
3. The instance IP is passed to Ansible, which installs MicroK8s, enables add-ons, installs cert-manager with a Cloudflare DNS-01 ClusterIssuer, creates the namespace `platform-<env>` and a namespaced service account, installs Redis, and generates a kubeconfig for that service account.
4. The kubeconfig is uploaded as `kubeconfig-<env>`; the same workflow creates the `regcred` image-pull secret in the app namespace.

## Deployment flow
Merging to `main` makes release-please open release PRs; merging one tags `api-vX.Y.Z` or `web-vX.Y.Z`, which builds and pushes the image. `cd-*-deploy` downloads the latest unexpired kubeconfig for the environment and runs `helm upgrade --install --atomic`, so a failed rollout is rolled back.

## Design choices
- **One root module, three variable sets** instead of copy-pasted environment directories.
- **Service account kubeconfig** rather than admin credentials, so CI can only act inside its namespace.
- **MicroK8s on a single VM** to keep cost low; the charts do not depend on it and would run on any cluster with ingress-nginx and cert-manager.
