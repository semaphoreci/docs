# Secrets YAML reference




## Secrets example

    apiVersion: v1alpha
    kind: Secret
    metadata:
      name: a-secrets-bucket-name
    data:
      env_vars:
        - name: SECRET_ONE
          value: "This is the value of SECRET_ONE"
        - name: SECRET_TWO
          value: "This is the value of SECRET_TWO"

