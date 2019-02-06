---
layout: default
permalink: /docs/http/Edit_Tag/
sidebar: yes
---

Edit a tag:

    PATCH /api/archive/:instance/tags/:start/:id


### Parameters

<table class="inline">
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td class="code">name</td>
    <td class="code">string</td>
    <td>The name of the tag.</td>
  </tr>
  <tr>
    <td class="code">description</td>
    <td class="code">string</td>
    <td>The description of the tag.</td>
  </tr>
  <tr>
    <td class="code">start</td>
    <td class="code">string</td>
    <td>The start time of the tag. Must be a date string in ISO 8601 format. Set to empty to indicate unbounded.</td>
  </tr>
  <tr>
    <td class="code">stop</td>
    <td class="code">string</td>
    <td>The stop time of the tag. Must be a date string in ISO 8601 format. Set to empty to indicate unbounded.</td>
  </tr>
  <tr>
    <td class="code">color</td>
    <td class="code">string</td>
    <td>The color of the tag. Must be an RGB hex color, e.g. <tt>#ff0000</tt></td>
  </tr>
</table>

The same parameters can also be specified in the request body. In case both query string parameters and body parameters are specified, they are merged with priority being given to query string parameters.

### Example

Change the color, and the description:

```json
{
  "color" : "#00ff00",
  "description": "an example description"
}
```


### Alternative Media Types

#### Protobuf

Use these HTTP headers:

    Content-Type: application/protobuf
    Accept: application/protobuf
    
Request is of type:

{% proto rest/rest.proto %}
message EditTagRequest {
  optional string name = 1;
  optional string start = 2;
  optional string stop = 3;
  optional string description = 4;
  optional string color = 5;
}
{% endproto %}
