/*
──────────────────────────────────────────────────────────────────────
IAM Submodule for ALB Controller – IRSA Configuration
──────────────────────────────────────────────────────────────────────
📌 Purpose:  Create IAM role and policy for AWS Load Balancer Controller
            using IRSA (IAM Roles for Service Accounts)
──────────────────────────────────────────────────────────────────────
*/

# ---------------------------------------------------------------------
# IAM Policy Document for OIDC Trust Relationship
# ---------------------------------------------------------------------
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# ---------------------------------------------------------------------
# IAM Role for ALB Controller
# ---------------------------------------------------------------------
resource "aws_iam_role" "alb-controller-iam" {
  name               = "${var.project}-${var.environment}-alb-controller"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = merge(
    var.tags,
    {
      Name      = "${var.project}-${var.environment}-alb-controller"
      Component = "alb-controller"
    }
  )
}

# ---------------------------------------------------------------------
# IAM Policy for ALB Controller Permissions
# ---------------------------------------------------------------------
resource "aws_iam_policy" "alb-controller-iam-policy" {
  name        = "${var.project}-${var.environment}-alb-controller-policy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file(var.policy_json_path)

  tags = merge(
    var.tags,
    {
      Name      = "${var.project}-${var.environment}-alb-controller-policy"
      Component = "alb-controller"
    }
  )
}

# ---------------------------------------------------------------------
# Attach Policy to Role
# ---------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.alb-controller-iam.name
  policy_arn = aws_iam_policy.alb-controller-iam-policy.arn
}
