---
Description: Use OpenID Connect within your pipelines to fetch secrets from Hashicorp Vault.
---

# Configure OpenID Connect in Hashicorp Vault

Open ID Connect allows your pipelines to access secrets in Hashicorp Vault without the need
to store long-lived access credentials in Semaphore secrets.

In this guide, you will learn how to configure Hashicorp Vault to trust Semaphore OIDC as a
federated identity, and how to fetch secrets from your Semaphore pipelines.

## Adding the identity provider to Hashicorp Vault

To use Open ID Connect tokens to connect to Hashicorp Vault, you will add a trust configuration
for Semaphore to your Vault instance. For more information about this setup, refer to the
[JWT/OIDC Auth Method][vault-docs] in Vault's documentation.

### Step 1 - Enable JWT support

Enable the JWT auth method in Vault and add Semaphore as an identity provider.

``` bash
vault auth enable jwt
```

``` bash
export ORG_URL="" # the full url to your organization, exaple: https://acme.semaphoreci.com

vault write auth/jwt/config bound_issuer="$ORG_URL" oidc_discovery_url="$ORG_URL"
```

### Step 2 - Configure roles and policies for accessing secrets

Configure a policy that grants access to specific paths that will be accessed by your Semaphore
pipelines. For more details, read [Vault's Policies][vault-policy-docs] documentation.

``` bash
vault policy write example-project - <<EOF
# Read-only permission on 'secret/data/production/*' path

path "secret/data/production/*" {
  capabilities = [ "read" ]
}
EOF
```

Configure a role:

``` bash
vault write auth/jwt/role/example-project -<<EOF
{
  "role_type": "jwt",
  "user_claim": "actor",
  "bound_claims": {
    "repo": "web",
    "branch": "main"
  },
  "policies": ["example-project"],
  "ttl": "5m"
}
EOF
```

The bound claims should be further refined based on your needs. See a list of claims on
the [OpenID Connect Overview][oidc-overview] documentation page.

### Step 3 - Access Vault secrets from your Semaphore pipelines

Finally, in your Semaphore pipelines, assume the above role and fetch secrets.

``` yaml:
commands:
  - export VAULT_TOKEN=$(vault write -field=token auth/jwt/login role=example-project jwt=$SEMAPHORE_OIDC_TOKEN)
  - vault kv get -field=value secret/data/production/example-secret
```

[vault-docs]: https://developer.hashicorp.com/vault/docs/auth/jwt
[vault-policy-docs]: https://developer.hashicorp.com/vault/docs/concepts/policies
[oidc-overview]: ./security/open-id-connect.html
