# Terraform開発規約（MICIN標準）

このルールは、セキュアで保守性の高いTerraform構成を実現するための規約です。
新規プロジェクトでもこの慣習に従ってください。

## 🎯 核となる設計思想

### tfvarsを使わず、locals.tfで環境管理
**理由**: 環境固有の値をコード内で明示的に管理し、DRY原則を実現

```hcl
# ❌ 避けるパターン
# terraform.tfvars で値を注入

# ✅ 推奨パターン
# locals.tf
locals {
  service_name     = "myapp"
  env              = "prod"
  shared_prefix    = "${local.service_name}-${local.env}"  # すべてのリソース名のベース
  domain_name      = "example.com"
  vpc_cidr_prefix  = "10.30"
  aws_account_id   = "123456789012"
  region           = "ap-northeast-1"

  # 複雑な値も計算で導出
  api_domain_name  = "api.${local.domain_name}"
}
```

**暗黙知**:
- 環境間の差分を一箇所で把握できる
- 値の計算・組み合わせが容易
- Git履歴で変更追跡が明確

### shared_prefixパターンの徹底
**全AWSリソース名の接頭辞を統一**

```hcl
# リソース命名
resource "aws_vpc" "vpc" {
  tags = {
    Name = "${var.shared_prefix}-vpc"
  }
}

resource "aws_subnet" "public" {
  for_each = toset(["a", "c", "d"])
  tags = {
    Name = "${var.shared_prefix}-public-subnet-${each.value}"
  }
}

# S3バケット
resource "aws_s3_bucket" "terraform_backend" {
  bucket = "${var.shared_prefix}-terraform-backend"
}

# SSM Parameter
resource "aws_ssm_parameter" "secret" {
  name = "/${var.shared_prefix}/${each.value}"
}
```

**暗黙知**:
- リソースの所属が一目瞭然
- 環境間の干渉防止
- コスト管理の容易化

## 📁 ディレクトリ構成の原則

### 環境とモジュールの2層構造

```
terraform/
├── env/                    # 環境別の実体
│   ├── prod/
│   ├── stg/
│   └── sandbox/
├── modules/                # 再利用可能なモジュール
│   ├── vpc/
│   ├── api/
│   ├── ecs_cluster/
│   └── ...
└── initial_setup/          # 初回のみ実行（OIDC Provider等）
    └── env/{env}/
```

### 環境ディレクトリの標準構成

```
terraform/env/prod/
├── locals.tf              # ★環境固有値の単一管理場所
├── variables.tf           # 外部入力変数（最小限に）
├── terraform.tf           # provider、backend設定
├── aws.tf                 # プロバイダー設定（default_tags含む）
├── data.tf                # データソース集約
├── outputs.tf             # 環境レベルの出力
├── vpc.tf                 # ▼以下、リソース種別ごとに分割
├── ecs_cluster.tf
├── api.tf
├── acm.tf
├── hosted_zones.tf
└── README.md              # terraform-docs自動生成
```

**暗黙知**:
- 1ファイル = 1モジュール呼び出し（見通しの良さ）
- データソースは`data.tf`に集約（重複防止）
- `variables.tf`は最小限（ほとんどlocalsで完結）

### モジュールの構成パターン

**シンプルなモジュール**（単一リソースタイプ）:
```
modules/acm/
├── acm.tf           # main.tfではなく具体的な名前
├── variables.tf
├── outputs.tf
└── README.md
```

**複雑なモジュール**（複数リソースタイプ）:
```
modules/api/
├── alb.tf                 # ▼機能ごとに分割
├── rds.tf
├── task_iam.tf
├── deploy_iam.tf
├── task_security_group.tf
├── service_discovery.tf
├── kms.tf
├── media_bucket.tf
├── domain.tf
├── variables.tf
├── outputs.tf
├── data.tf
└── README.md
```

**暗黙知**:
- main.tfは使わない（ファイル名から内容を推測可能に）
- IAM系は用途別に分割（task_iam, deploy_iam）
- 1ファイルは100-200行程度を目安

## 🔧 必須の自動化設定

### 1. mise設定（.mise.toml）

```toml
[tools]
terraform-docs = "latest"
pre-commit = "latest"
terraform_tflint = "latest"
```

**セットアップコマンド**: `mise i`

### 2. pre-commit設定（.pre-commit-config.yaml）

```yaml
repos:
- repo: https://github.com/antonbabenko/pre-commit-terraform
  rev: v1.96.1
  hooks:
    - id: terraform_docs
      args:
        - --hook-config=--add-to-existing-file=true
        - --hook-config=--create-file-if-not-exist=true
        - --args=--config=.terraform-docs.yml
    - id: terraform_tflint
      args:
        - --args=--call-module-type=all
        - --args=--config=__GIT_WORKING_DIR__/.tflint.hcl
```

**セットアップ**:
```bash
pre-commit install
```

**暗黙知**:
- コミット時にREADME.md自動更新
- Failed時はREADME.mdも追加コミット
- 新規モジュール作成時は空のREADME.md作成必須

### 3. terraform-docs設定（.terraform-docs.yml）

```yaml
formatter: "md tbl"
version: "<= 1.0.0"

sections:
  hide: []
  show: []

output:
  file: README.md
  mode: inject
  template: |-
    <!-- BEGIN_TF_DOCS -->
    <!-- Don't write any explanations between commentouts. -->
    {{ .Content }}
    <!-- END_TF_DOCS -->

sort:
  enabled: true
  by: required

settings:
  anchor: true
  default: true
  required: true
  type: true
```

### 4. tflint設定（.tflint.hcl）

```hcl
plugin "terraform" {
  enabled = true
  version = "0.10.0"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

# 無効化する標準ルール（独自ルール優先）
rule "terraform_naming_convention" {
  enabled = false
}

rule "terraform_standard_module_structure" {
  enabled = false
}

# 有効化する重要ルール
rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

# AWSプラグイン
plugin "aws" {
  enabled = true
  version = "0.37.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# 必須タグの強制
rule "aws_provider_missing_default_tags" {
  enabled = true
  tags    = ["service", "env", "env_id"]
}
```

**暗黙知**:
- `terraform_naming_convention`は無効（shared_prefixルールと競合）
- default_tags必須: service, env, env_id

### 5. Renovate設定（renovate.json5）

```json5
{
  "extends": [
    "github>micin-jp/micin-shared-workflow:renovate_terraform.json5",
  ],
  "reviewers": ["team:sre"],
  "includePaths": [
    "**/.github/workflows/**",
    "**/terraform/**",
  ]
}
```

### 6. AWS Provider設定（aws.tf）

```hcl
provider "aws" {
  region = local.region

  default_tags {
    tags = {
      service = local.service_name
      env     = local.env
      env_id  = local.shared_prefix
    }
  }
}

provider "aws" {
  alias  = "us"
  region = local.us_region

  default_tags {
    tags = {
      service = local.service_name
      env     = local.env
      env_id  = local.shared_prefix
    }
  }
}
```

**暗黙知**:
- 全リソースに自動タグ付与
- us-east-1用のaliasプロバイダー（ACM等で使用）

## 💡 コーディング規約

### 命名規則

| 対象 | パターン | 例 |
|------|---------|-----|
| ローカル変数 | `snake_case` | `shared_prefix`, `vpc_cidr_prefix` |
| プライベート変数 | `_snake_case` | `_transit_gateway_configurations` |
| リソース名 | `snake_case` | `resource "aws_vpc" "vpc"` |
| AWSリソース実名 | `${shared_prefix}-${type}` | `myapp-prod-vpc` |
| ファイル名 | `{resource_type}.tf` | `vpc.tf`, `ecs_cluster.tf` |

### for_each vs count

```hcl
# ✅ 推奨: for_each（削除時の位置ずれなし）
resource "aws_subnet" "public" {
  for_each = toset(["a", "c", "d"])

  availability_zone = "${data.aws_region.current.name}${each.value}"
  tags = {
    Name = "${var.shared_prefix}-public-subnet-${each.value}"
  }
}

# ❌ 避ける: count（削除時にインデックスずれ）
resource "aws_subnet" "public" {
  count = 3
  # ...
}
```

### lifecycle管理

```hcl
resource "aws_vpc" "vpc" {
  # ...

  tags = {
    Name = "${var.shared_prefix}-vpc"
  }

  lifecycle {
    ignore_changes = [tags]  # 外部からのタグ追加を許容
  }
}

resource "aws_ssm_parameter" "secret" {
  value = local.dummy_value  # 初期値のみ設定

  lifecycle {
    ignore_changes = [value]  # 実際の値は手動設定
  }
}
```

**暗黙知**:
- 外部ツールが追加するタグは`ignore_changes`
- 機密情報の初期値は`ignore_changes`で保護

### データソースの配置

```hcl
# env/prod/data.tf - 環境レベルのデータソース
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# modules/vpc/data.tf - モジュール固有のデータソース
data "aws_availability_zones" "available" {
  state = "available"
}
```

### モジュール呼び出しパターン

```hcl
# env/prod/vpc.tf
module "vpc" {
  source = "../../modules/vpc"

  shared_prefix = local.shared_prefix  # locals経由で渡す
  vpc_cidrblock = "${local.vpc_cidr_prefix}.0.0/16"
}

# env/prod/api.tf
module "api" {
  source = "../../modules/api"

  shared_prefix = local.shared_prefix

  # 他モジュールのoutputを使用
  vpc    = module.vpc.vpc
  subnet = module.vpc.subnet

  # locals値を渡す
  domain_name = "api.${local.domain_name}"
}
```

**暗黙知**:
- モジュール間の依存は outputs/variables で明示
- 計算可能な値はlocalsで事前計算
- モジュールには最小限の変数のみ渡す

## 🚀 CI/CD設定

### GitHub Actions標準構成

**terraform_plan.yml**（PR時）:
```yaml
name: "Terraform Plan"
on:
  pull_request:
    types: [opened, synchronize]
    branches: [main]

permissions:
  id-token: write
  contents: read
  pull-requests: write

jobs:
  TerraformPlan:
    strategy:
      fail-fast: false
      matrix:
        include:
          - root_module: terraform/env/prod
            role_arn: arn:aws:iam::123456789012:role/myapp-prod-terraform-plan
          - root_module: terraform/env/stg
            role_arn: arn:aws:iam::123456789012:role/myapp-stg-terraform-plan
    uses: micin-jp/micin-shared-workflow/.github/workflows/terraform_plan.yml@main
    with:
      root_module: ${{ matrix.root_module }}
      role_arn: ${{ matrix.role_arn }}

  Tfsec:
    uses: micin-jp/micin-shared-workflow/.github/workflows/tfsec.yml@main
```

**terraform_apply.yml**（mainマージ時）:
```yaml
name: "Terraform Apply"
on:
  push:
    branches: [main]

jobs:
  TerraformApply:
    # plan.ymlと同様の構成
```

**暗黙知**:
- 環境ごとに異なるIAM Roleを使用（OIDC認証）
- matrixで複数環境を並列実行
- shared-workflowで標準化

## 📋 バージョン管理

### terraform.tf標準設定

```hcl
terraform {
  required_version = "~> 1.10"  # メジャーバージョン固定

  backend "s3" {
    bucket       = "${service_name}-${env}-terraform-backend"
    key          = "${repo_name}/terraform.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.39"
    }
  }
}
```

**暗黙知**:
- `~>`で自動アップデート（パッチバージョンのみ）
- Renovateが定期的にバージョン提案

## 🔒 セキュリティ要件

### 必須設定
- ✅ GuardDuty有効化
- ✅ tfsecスキャン（CI/CD組み込み）
- ✅ default_tags設定（service, env, env_id）
- ✅ VPC Flow Logs（必要に応じて）
- ✅ RDS暗号化（デフォルト有効）

### tfsec ignore時のルール

```hcl
# tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "vpc" {
  # 理由: コスト削減のため開発環境ではFlow Logs無効
}
```

**暗黙知**: ignore理由をコメント必須

## ✅ 開発フロー

### 新規モジュール作成時
1. ディレクトリ作成: `mkdir -p terraform/modules/mymodule`
2. 空README作成: `touch terraform/modules/mymodule/README.md`
3. 標準ファイル作成: `variables.tf`, `outputs.tf`, `{resource}.tf`
4. pre-commit実行で自動ドキュメント生成

### コード変更時
```bash
# 1. フォーマット
terraform fmt -recursive

# 2. pre-commit実行（自動的にREADME更新）
git add .
git commit -m "feat: add new resource"
# → terraform_docs, tflint自動実行

# 3. README.mdも追加コミット（Failedの場合）
git add terraform/modules/*/README.md
git commit --amend --no-edit
```

### PR作成時
- terraform planが自動実行
- tfsecスキャン実行
- SREチームがレビュー

## 📚 参考情報

### 内部ドキュメント
- [AWS VPC CIDR管理](https://micin.atlassian.net/wiki/spaces/engdesign/pages/153715859/AWS+VPC+CIDR)
- [AWS Organization構成](https://micin.atlassian.net/wiki/spaces/engdesign/pages/153879509/AWS+Organization)

### モジュール設計の判断基準
- **小規模**: 単一リソースタイプ（ACM、Parameter Store）
- **中規模**: 関連リソース群（VPC、ECS Cluster）
- **大規模**: アプリケーション全体（API、WEB）
