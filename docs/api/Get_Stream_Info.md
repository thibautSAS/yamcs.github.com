---
layout: default
permalink: /docs/api/Get_Stream_Info/
sidebar: yes
---

Get info on a Yamcs stream:

    GET /api/archive/:instance/streams/:name
    
<div class="hint">
    This is low-level API for those cases where access to an internal stream of Yamcs is wanted. It is recommended to use other API operations for any of the default built-in streams.
</div>

### Response

<pre class="header">
Status: 200 OK
</pre>
{% highlight json %}
{
  "name" : "tm_realtime",
  "column" : [ {
    "name" : "gentime",
    "type" : "TIMESTAMP"
  }, {
    "name" : "seqNum",
    "type" : "INT"
  }, {
    "name" : "rectime",
    "type" : "TIMESTAMP"
  }, {
    "name" : "packet",
    "type" : "BINARY"
  } ]
}
{% endhighlight %}

### Alternative Media Types

#### Protobuf

Use HTTP header:

    Accept: application/protobuf

Response if of type:

<pre class="r header"><a href="/docs/api/archive.proto/">archive.proto</a></pre>
{% highlight proto %}
message StreamInfo {
  optional string name = 1;
  repeated ColumnInfo column = 2;
}
{% endhighlight %}