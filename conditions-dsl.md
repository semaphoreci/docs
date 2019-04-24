- [Introduction](#introduction)
- [Formal language definition](#Formal-language-definition)
- [Usage examples](#usage-examples)

## Introduction

Sometimes there is a need to configure some behavior to only happen under specific conditions, like skipping execution of block A when push is from branch which is not master or does not have 'include-A' in name or it is a tag with '1.x' in name or ...

Since this conditions can be really complex and hard to express in yaml syntax, we decided to introduced Domain Specific Language(DSL), called Conditions DSL, to streamline the way those conditions are expressed.

With Conditions DSL you can perform direct or regex match on values of different attributes and use boolean operations to group those matches.  

To illustrate how this works here is an example condition from above written in Conditions DSL:
```
branch != 'master' OR branch !~ 'include-A' OR tag =~ '1\.'
```

## Formal language definition

Formal language definition in [extended Backus-Naur Form (EBNF)](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form) notation:

```
expression = expression bool_operator term
           | term

term = "(" expression ")"      
     | keyword operator string
     | string operator keyword
     | string                  
     | boolean

bool_operator = "and" | "AND" | "or" | "OR"

keyword = "branch" | "BRANCH" | "tag" | "TAG" | "result" | "RESULT" |
          "result_reason" | "RESULT_REASON"

operator = "=" | "!=" | "=~" | "!~"

boolean = "true" | "TRUE" | "false" | "FALSE"

string = ? all characters between two single quotes, e.g. 'master' ?
```           

Each `keyword` in passed expression is replaced with actual value of that attribute for current pipeline when expression is evaluated, and then operations identified with one of the `operators` from above are executed with those values.

|    KEYWORD     |             ATTRIBUTE IT REPRESENTS              |
| :------------- | :----------------------------------------------- |
| branch         | Name of the GitHub branch from which originated the pipeline that is being executed. |
| tag            | Name of the GitHub tag from which originated the pipeline that is being executed. |
| result         | Execution result of pipeline, block, or job. Possible values are: passed, stopped, canceled and failed. |
| result_reason  | The reason for given result of execution. Possible values are: test, malformed, stuck, deleted, internal and user. |


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

### Skip block execution always

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "true"
```

### Skip block execution on any branch

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch =~ '.*'"
```

### Skip block execution when branch is master

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch = 'master'"
```

### Skip block execution when branch starts with “df/”

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch =~ '^df\/'"
```

### Skip block execution when branch is staging or master

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch = 'staging' OR branch = 'master'"
```

### Skip block execution on any tag

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "tag =~ '.*'"
```

### Skip block execution when tag start with “v1.”

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "tag =~ '^v1\.'"
```

### Skip block execution on master branch and any tags

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch = 'master' OR tag =~ '.*'"
```

### Execute block when branch starts with “dev/” == Skip block execution when branch doesn’t start with dev/

```yaml
blocks:
  - name: Unit tests
    skip:
      when: "branch !~ '^dev\/'"
```
