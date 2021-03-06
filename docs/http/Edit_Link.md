---
layout: default
permalink: /docs/http/Edit_Link/
sidebar: yes
---

Edit a link:

    PATCH /api/links/:instance/:name

### Parameters

<table class="inline">
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td class="code">state</td>
    <td class="code">string</td>
    <td>The state of the link. Either <tt>enabled</tt> or <tt>disabled</tt>.</td>
  </tr>
</table>

The same parameters can also be specified in the request body. In case both query string parameters and body parameters are specified, they are merged with priority being given to query string parameters.

### Example

Enable a link:

```json
{
  "state" : "enabled"
}
```

Disable a link:

```json
{
  "state" : "disabled"
}
```

### Alternative Media Types

#### Protobuf

Use these HTTP headers:

    Content-Type: application/protobuf
    Accept: application/protobuf
    
Request is of type:

{% proto rest/rest.proto %}
message EditLinkRequest {
  optional string state = 1;
}
{% endproto %}
