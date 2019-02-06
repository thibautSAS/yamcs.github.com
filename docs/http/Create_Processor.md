---
layout: default
permalink: /docs/http/Create_Processor/
sidebar: yes
---

Create a processor for the given Yamcs instance:

    POST /api/processors/:instance


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
    <td><strong>Required.</strong> The name of the processor. Must be unique for the Yamcs instance.</td>
  </tr>
  <tr>
    <td class="code">type</td>
    <td class="code">string</td>
    <td><strong>Required.</strong> The type of the processor. The available values depend on how Yamcs Server is configured. Most Yamcs deployments support at least a type <tt>Archive</tt> which allows for the creation of processors replaying archived data</td>
  </tr>
  <tr>
    <td class="code">persistent</td>
    <td class="code">bool</td>
    <td>Keep the processor when terminated. Default: <tt>no</tt></td>
  </tr>
  <tr>
    <td class="code">clientId</td>
    <td class="code">array of integers</td>
    <td>The client IDs that should be connected to this processor.</td>
  </tr>
  <tr>
    <td class="code">config</td>
    <td class="code">string</td>
    <td>Configuration options specific to the processor type. Note that this should be a string representation of a valid JSON structure.</td>
  </tr>
</table>

#### Replay Config

When creating a processor of type `Archive`, the <tt>config</tt> JSON supports these parameters:

<table class="inline">
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td class="code">utcStart</td>
    <td class="code">string</td>
    <td><strong>Required.</strong> The time at which the replay should start. Must be a date string in ISO 8601 format.</td>
  </tr>
  <tr>
    <td class="code">utcStop</td>
    <td class="code">string</td>
    <td>The time at which the replay should stop. Must be a date string in ISO 8601 format. If unspecified, the replay will keep going as long as there is remaining data.</td> 
  </tr>
  <tr>
    <td class="code">loop</td>
    <td class="code">bool</td>
    <td>Whether the processing should restart at the end of the replay. Default: <tt>no</tt></td>
  </tr>
  <tr>
    <td class="code">speed</td>
    <td class="code">string</td>
    <td>
        The speed of the processor. One of:
        <ul>
            <li><tt>afap</tt></li>
            <li>a speed factor relative to the original speed. Example: <tt>2x</tt></li>
            <li>a fixed delay value in milliseconds. Example: <tt>2000</tt></li>
        </ul>
        Default: <tt>1x</tt>
    </td>
  </tr>
  <!--tr>
    <td class="code">paraname</td>
    <td class="code">array of strings</td>
    <td>Name patterns of parameters that are included in the replay. Patterns are matched on the qualified names and support wildcard expansion. If the pattern matches the name of a space system, all parameters directly within that system are included.</td>
  </tr>
  <tr>
    <td class="code">ppgroup</td>
    <td class="code">array of strings</td>
    <td>
        <p>Exact names of the groups of processed parameters to include in the replay.</p>
        <p><strong>Partial wildcard matching is not currently supported.</strong></p>
    </td>
  </tr>
  <tr>
    <td class="code">packetname</td>
    <td class="code">array of strings</td>
    <td>
        <p>Exact qualified names of the packets to include in the replay. Specify <tt>*</tt> to include all packets.</p>
        <p><strong>Partial wildcard matching is not currently supported.</strong></p>
    </td>
  </tr>
  <tr>
    <td class="code">cmdhist</td>
    <td class="code">bool</td>
    <td>Whether or not to replay Command History. Default: <tt>no</tt></td>
  </tr-->
</table>

<!--The criteria <tt>paraname</tt>, <tt>ppgroup</tt>, <tt>packetname</tt> and <tt>cmdhist</tt> are additive. At least one of them should be filled in, or there will be nothing to replay.-->


### Example

Start a replay at January 1st 2015 at 4.5x the original speed, and add client 12 to the replay:

```json
{
  "name" : "An example processor",
  "type": "Archive",
  "clientId" : [ 12 ],
  "config": "{\"utcStart\":\"2015-01-01T00:00:00.000Z\",\"speed\":\"4.5x\"}",
}
```


### Alternative Media Types

#### Protobuf

Use these HTTP headers:

    Content-Type: application/protobuf
    Accept: application/protobuf
    
Request is of type:

{% proto rest/rest.proto %}
message CreateProcessorRequest {
  optional string name = 1;
  repeated int32 clientId = 6;
  optional bool persistent = 11;
  optional string type = 12;
  optional string config = 13;
}
{% endproto %}
