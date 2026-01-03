pipeline {
  agent any

  options {
    timestamps()
  }

  environment {
    // Use workspace-local profiles to avoid ~/.dbt permission/path issues
    DBT_PROFILES_DIR    = "${WORKSPACE}/.dbt"

    // Non-secret config
    SNOWFLAKE_WAREHOUSE = "COMPUTE_WH"
    SNOWFLAKE_DATABASE  = "OLIST"
    SNOWFLAKE_SCHEMA    = "ANALYTICS_CI"
    DBT_THREADS         = "4"
    DBT_TARGET          = "prod"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Set up Python') {
      steps {
        sh '''
set -euxo pipefail
python3 -m venv .venv
. .venv/bin/activate
pip install --upgrade pip
# Keep core + adapter aligned
pip install "dbt-core" "dbt-snowflake"
dbt --version
'''
      }
    }

    stage('Write dbt profile') {
      steps {
        withCredentials([
          string(credentialsId: 'snowflake_account',  variable: 'SNOWFLAKE_ACCOUNT'),
          string(credentialsId: 'snowflake_user',     variable: 'SNOWFLAKE_USER'),
          string(credentialsId: 'snowflake_password', variable: 'SNOWFLAKE_PASSWORD'),
          string(credentialsId: 'snowflake_role',     variable: 'SNOWFLAKE_ROLE')
        ]) {
          sh '''
set -euxo pipefail
mkdir -p "${DBT_PROFILES_DIR}"

# IMPORTANT: the closing YAML must be at column 1 (no indentation)
cat > "${DBT_PROFILES_DIR}/profiles.yml" <<'YAML'
dbt_olist_project:
  target: prod
  outputs:
    prod:
      type: snowflake
      account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"
      user: "{{ env_var('SNOWFLAKE_USER') }}"
      password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"
      role: "{{ env_var('SNOWFLAKE_ROLE') }}"
      warehouse: "COMPUTE_WH"
      database: "OLIST"
      schema: "ANALYTICS_CI"
      threads: 4
YAML

# Validate YAML structure (doesn't print secrets)
python3 - <<'PY'
import yaml, os
p = os.path.join(os.environ["DBT_PROFILES_DIR"], "profiles.yml")
yaml.safe_load(open(p))
print("profiles.yml YAML OK:", p)
PY
'''
        }
      }
    }

    stage('Run dbt build') {
      steps {
        withCredentials([
          string(credentialsId: 'snowflake_account',  variable: 'SNOWFLAKE_ACCOUNT'),
          string(credentialsId: 'snowflake_user',     variable: 'SNOWFLAKE_USER'),
          string(credentialsId: 'snowflake_password', variable: 'SNOWFLAKE_PASSWORD'),
          string(credentialsId: 'snowflake_role',     variable: 'SNOWFLAKE_ROLE')
        ]) {
          sh '''
set -euxo pipefail
. .venv/bin/activate

# Ensure dbt reads the profile we wrote
export DBT_PROFILES_DIR="${DBT_PROFILES_DIR}"

dbt debug --target "${DBT_TARGET}"
dbt deps  --target "${DBT_TARGET}"
dbt build --target "${DBT_TARGET}"
'''
        }
      }
    }
  }

  post {
    always {
      // Optional cleanup
      sh 'rm -rf .venv .dbt || true'
    }
  }
}
