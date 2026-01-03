pipeline {
    agent any

    environment {
        SNOWFLAKE_ACCOUNT   = credentials('snowflake_account')
        SNOWFLAKE_USER      = credentials('snowflake_user')
        SNOWFLAKE_PASSWORD  = credentials('snowflake_password')
        SNOWFLAKE_ROLE      = credentials('snowflake_role')
        SNOWFLAKE_WAREHOUSE = 'COMPUTE_WH'
        SNOWFLAKE_DATABASE  = 'OLIST'
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
                python3 -m venv .venv
                source .venv/bin/activate
                pip install --upgrade pip
                pip install "dbt-core==1.9.8" "dbt-snowflake==1.9.4"
                dbt --version
                '''
            }
        }

        stage('Write dbt profile') {
            steps {
                sh '''
                mkdir -p ~/.dbt
                cat > ~/.dbt/profiles.yml <<'YAML'
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
                      schema: "OLIST_PROD"
                      threads: 4
                YAML
                '''
            }
        }

        stage('Run dbt build') {
            steps {
                sh '''
                source .venv/bin/activate
                dbt debug
                dbt deps
                dbt build
                '''
            }
        }
    }
}
