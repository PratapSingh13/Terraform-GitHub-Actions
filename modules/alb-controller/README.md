# AWS Load Balancer Controller Module

This Terraform module deploys the AWS Load Balancer Controller on an Amazon EKS cluster using a **modular architecture** with Helm.

## Overview

The AWS Load Balancer Controller manages AWS Elastic Load Balancers for a Kubernetes cluster. It provisions:
- **Application Load Balancers (ALB)** for Kubernetes Ingress resources
- **Network Load Balancers (NLB)** for Kubernetes Service resources of type LoadBalancer

## Modular Architecture

This module follows a modular design pattern with three distinct submodules:

```
modules/alb-controller/
├── main.tf                    # Orchestrator (calls submodules)
├── variables.tf               # Input variables
├── outputs.tf                 # Aggregated outputs
├── versions.tf                # Provider requirements
│
├── modules/
│   ├── iam/                   # IAM role & policy (IRSA)
│   ├── k8s-resources/         # Kubernetes service account
│   └── helm-chart/            # Helm deployment
│
└── scripts/
    └── alb-controller-iam-policy.json
```

### Submodules

1. **IAM Module** (`modules/iam/`)
   - Creates IAM role with OIDC trust policy for IRSA
   - Attaches IAM policy with ALB permissions
   - Reusable for other IRSA configurations

2. **Kubernetes Resources Module** (`modules/k8s-resources/`)
   - Creates Kubernetes service account
   - Annotates with IAM role ARN
   - Manages namespace and labels

3. **Helm Chart Module** (`modules/helm-chart/`)
   - Deploys AWS Load Balancer Controller via Helm
   - Configurable chart version and values
   - Resource limits and replica management

## Prerequisites

- EKS cluster with OIDC provider configured
- Helm provider configured in your Terraform
- Kubernetes provider configured in your Terraform

## Usage

```hcl
module "alb_controller" {
  source = "./modules/alb-controller"
  
  project              = "myproject"
  environment          = "dev"
  cluster_name         = module.eks.cluster_name
  region               = "us-east-1"
  vpc_id               = module.vpc.vpc_id
  oidc_provider_arn    = module.eks.oidc_provider_arn
  oidc_issuer_url      = module.eks.oidc_issuer_url
  namespace            = "kube-system"
  service_account_name = "aws-load-balancer-controller"
  
  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | Project name | `string` | n/a | yes |
| environment | Deployment environment | `string` | n/a | yes |
| cluster_name | Name of the EKS cluster | `string` | n/a | yes |
| region | AWS region where the cluster is deployed | `string` | n/a | yes |
| vpc_id | VPC ID where the cluster is deployed | `string` | n/a | yes |
| oidc_provider_arn | ARN of the OIDC provider for the EKS cluster | `string` | n/a | yes |
| oidc_issuer_url | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| namespace | Namespace for the ALB controller service account | `string` | `"kube-system"` | no |
| service_account_name | Service account name for the ALB controller | `string` | `"aws-load-balancer-controller"` | no |
| helm_chart_version | Version of the AWS Load Balancer Controller Helm chart | `string` | `"1.7.1"` | no |
| replica_count | Number of replicas for the ALB controller | `number` | `2` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_controller_role_arn | The ARN of the IAM role for the ALB controller |
| alb_controller_service_account_name | The name of the Kubernetes service account for the ALB controller |
| alb_controller_policy_arn | The ARN of the IAM policy for the ALB controller |

## Post-Deployment

After deploying this module, you can create Ingress resources that will automatically provision ALBs:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  rules:
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-service
                port:
                  number: 80
```

## Verification

To verify the controller is running:

```bash
kubectl get deployment -n kube-system aws-load-balancer-controller
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
```

## References

- [AWS Load Balancer Controller Documentation](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)
- [Helm Chart Repository](https://github.com/aws/eks-charts)
- [IAM Policy Reference](https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json)
