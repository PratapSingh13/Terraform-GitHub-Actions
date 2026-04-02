# Example Ingress Configuration for AWS Load Balancer Controller

This directory contains example Kubernetes manifests for using the AWS Load Balancer Controller.

## Basic Application Load Balancer (ALB) Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-alb-ingress
  namespace: default
  annotations:
    # Specify the ingress class
    kubernetes.io/ingress.class: alb
    
    # ALB scheme - internet-facing or internal
    alb.ingress.kubernetes.io/scheme: internet-facing
    
    # Target type - ip or instance
    alb.ingress.kubernetes.io/target-type: ip
    
    # Health check configuration
    alb.ingress.kubernetes.io/healthcheck-path: /health
    alb.ingress.kubernetes.io/healthcheck-interval-seconds: '15'
    alb.ingress.kubernetes.io/healthcheck-timeout-seconds: '5'
    alb.ingress.kubernetes.io/healthy-threshold-count: '2'
    alb.ingress.kubernetes.io/unhealthy-threshold-count: '2'
    
    # Listen ports
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
    
    # Tags for the ALB
    alb.ingress.kubernetes.io/tags: Environment=dev,ManagedBy=kubernetes
spec:
  rules:
    - host: example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-service
                port:
                  number: 80
```

## HTTPS with SSL Certificate

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-https-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    
    # SSL Certificate ARN from ACM
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:region:account-id:certificate/certificate-id
    
    # Listen on both HTTP and HTTPS
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    
    # Redirect HTTP to HTTPS
    alb.ingress.kubernetes.io/ssl-redirect: '443'
spec:
  rules:
    - host: secure.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-service
                port:
                  number: 80
```

## Multiple Path Routing

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: multi-path-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  rules:
    - host: api.example.com
      http:
        paths:
          - path: /api/v1
            pathType: Prefix
            backend:
              service:
                name: api-v1-service
                port:
                  number: 8080
          - path: /api/v2
            pathType: Prefix
            backend:
              service:
                name: api-v2-service
                port:
                  number: 8080
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend-service
                port:
                  number: 80
```

## Internal Load Balancer

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: internal-ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: alb
    
    # Internal ALB (only accessible within VPC)
    alb.ingress.kubernetes.io/scheme: internal
    
    alb.ingress.kubernetes.io/target-type: ip
    
    # Specify subnets for internal ALB
    alb.ingress.kubernetes.io/subnets: subnet-xxxxx,subnet-yyyyy
spec:
  rules:
    - host: internal.example.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: internal-service
                port:
                  number: 80
```

## Network Load Balancer (NLB) Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nlb-service
  namespace: default
  annotations:
    # Use NLB instead of CLB
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    
    # NLB scheme
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
    
    # Cross-zone load balancing
    service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
    
    # Target type
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: "ip"
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

## Common Annotations Reference

### ALB Scheme
- `alb.ingress.kubernetes.io/scheme: internet-facing` - Public ALB
- `alb.ingress.kubernetes.io/scheme: internal` - Private ALB

### Target Type
- `alb.ingress.kubernetes.io/target-type: ip` - Route to pod IPs (recommended for Fargate)
- `alb.ingress.kubernetes.io/target-type: instance` - Route to node instances

### SSL/TLS
- `alb.ingress.kubernetes.io/certificate-arn` - ACM certificate ARN
- `alb.ingress.kubernetes.io/ssl-policy` - SSL policy (e.g., ELBSecurityPolicy-TLS-1-2-2017-01)
- `alb.ingress.kubernetes.io/ssl-redirect` - Redirect HTTP to HTTPS

### Health Checks
- `alb.ingress.kubernetes.io/healthcheck-path` - Health check path
- `alb.ingress.kubernetes.io/healthcheck-interval-seconds` - Interval between checks
- `alb.ingress.kubernetes.io/healthcheck-timeout-seconds` - Timeout for each check
- `alb.ingress.kubernetes.io/healthy-threshold-count` - Consecutive successes needed
- `alb.ingress.kubernetes.io/unhealthy-threshold-count` - Consecutive failures needed

### Advanced
- `alb.ingress.kubernetes.io/group.name` - Group multiple Ingresses into single ALB
- `alb.ingress.kubernetes.io/subnets` - Specify subnets for ALB
- `alb.ingress.kubernetes.io/security-groups` - Specify security groups
- `alb.ingress.kubernetes.io/tags` - Add custom tags to ALB
- `alb.ingress.kubernetes.io/wafv2-acl-arn` - Associate WAF WebACL

## Deployment Steps

1. Deploy your application and service:
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

2. Deploy the ingress:
```bash
kubectl apply -f ingress.yaml
```

3. Check the ingress status:
```bash
kubectl get ingress
kubectl describe ingress <ingress-name>
```

4. Get the ALB DNS name:
```bash
kubectl get ingress <ingress-name> -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

## Troubleshooting

Check controller logs:
```bash
kubectl logs -n kube-system deployment/aws-load-balancer-controller
```

Check ingress events:
```bash
kubectl describe ingress <ingress-name>
```

Verify service endpoints:
```bash
kubectl get endpoints <service-name>
```
