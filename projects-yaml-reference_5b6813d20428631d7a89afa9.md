  * [About Projects YAML](#projects-yaml-reference)
  * [Properties](#properties)
  * [apiVersion](#apiversion)
  * [kind](#kind)
  * [metadata](#metadata)
    * [name](#name)
  * [spec](#spec)
    * [repository](#repository)
      * [url](#url)
  * [Example](#example)
  * [See also](#see-also)
 
# Projects YAML Reference


## Properties


## apiVersion

## kind

## metadata

### name

## spec


### repository


#### url



## Example

    apiVersion: v1alpha
    kind: Project
    metadata:
      name: goDemo2.1
    spec:
      repository:
        url: "git@github.com:renderedtext/goDemo.git"

## See Also

   * [Secrets YAML reference]
   * [Changing organizations]
