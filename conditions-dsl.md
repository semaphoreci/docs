The Conditions DSL is a new, universal way of specifying conditional execution
of CI/CD commands in Semaphore.

Using Conditions you can perform a full or regular expression matches and
combine them with boolean operations. For example:
```
branch == 'master' OR tag =~ '^v1\.'
```

Currently you can use Conditions to specify when a block should and should not
run, with more applications coming soon.

- [Formal language definition](#Formal-language-definition)
- [Usage examples](#usage-examples)

## Formal language definition

Formal language definition in [extended Backus-Naur Form (EBNF)][ebnf] notation:

```
expression = expression bool_operator term
           | term

term = "(" expression ")"      
     | keyword operator string
     | string operator keyword
     | string                  
     | boolean

bool_operator = "and" | "AND" | "or" | "OR"

keyword = "branch" | "BRANCH" | "tag" | "TAG"

operator = "=" | "!=" | "=~" | "!~"

boolean = "true" | "TRUE" | "false" | "FALSE"

string = ? all characters between two single quotes, e.g. 'master' ?
```           

Each `keyword` in passed expression is replaced with actual value of that
attribute for current pipeline when expression is evaluated, and then operations
identified with one of the `operators` from above are executed with those values.

|    KEYWORD     |             ATTRIBUTE IT REPRESENTS              |
| :------------- | :----------------------------------------------- |
| branch         | Name of the Git branch from which originated the pipeline that is being executed. |
| tag            | Name of the Git tag from which originated the pipeline that is being executed. |


|  OPERATOR |                 OPERATION RESULT                          |
| :-------: | :-------------------------------------------------------- |
|   =       | True if keyword value and given string are equal          |
|   !=      | True if keyword value and given string are not equal      |
|   =~      | True if keyword value and given PCRE* string match        |
|   !~      | True if keyword value and given PCRE* string do not match |
|   and     | True if expressions on both sides are true                |
|   or      | True if at least one of two expressions is true           |

\* PCRE = Perl Compatible Regular Expression


## Usage examples

### Condition is met always

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "true"
```

### Condition is met for any branch

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch =~ '.*'"
```

### Condition is met when branch is master

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch = 'master'"
```

### Condition is met when branch starts with “df/”

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch =~ '^df\/'"
```

### Condition is met when branch is staging or master

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch = 'staging' OR branch = 'master'"
```

### Condition is met for any tag

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "tag =~ '.*'"
```

### Condition is met when tag start with “v1.”

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "tag =~ '^v1\.'"
```

### Condition is met when branch is master or if it is a tag

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch = 'master' OR tag =~ '.*'"
```

### Condition is met when branch does not start with "dev/"

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch !~ '^dev\/'"
```


[ebnf]: https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form
