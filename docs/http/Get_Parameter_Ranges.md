---
layout: default
permalink: /docs/http/Get_Parameter_Ranges/
sidebar: yes
---

Retrieve a history of ranges for the specified parameter:

    GET /api/archive/:instance/parameters/:namespace/:name/ranges 

A range is a tuple <tt>(start, stop, value, count)</tt> that represents the time interval for which the parameter has been steadily coming in with the same value. This request is useful for retrieving an overview for parameters that change unfrequently in a large time interval. For example an on/off status of a device, or some operational status. Two consecutive ranges containing the same value will be returned if there was a gap in the data. The gap is determined according to the parameter expiration time configured in the MDB.

### Parameters

<table class="inline">
    <tr>
        <th>Name</th>
        <th>Type</th>
        <th>Description</th>
    </tr>
    <tr>
        <td class="code">start</td>
        <td class="code">string</td>
        <td>Filter the lower bound of the parameter's generation time. Specify a date string in ISO 8601 format</td>
    </tr>
    <tr>
        <td class="code">stop</td>
        <td class="code">string</td>
        <td>Filter the upper bound of the parameter's generation time. Specify a date string in ISO 8601 format</td>
    </tr>
    <tr>
        <td class="code">minGap</td>
        <td class="code">long</td>
        <td>Time in milliseconds. Any gap (detected based on parameter expiration) smaller than this will be ignored. However if the parameter changes value, the ranges will still be split.</td>
    </tr>
    <tr>
        <td class="code">maxGap</td>
        <td class="code">long</td>
        <td>Time in milliseconds. If the distance between two subsequent values of the parameter is bigger than this value (but smaller than the parameter expiration), then an artificial gap will be constructed.
        This also applies if there is no parameter expiration defined for the parameter.</td>
    </tr>
    <tr>
        <td class="code">norealtime</td>
        <td class="code">boolean</td>
        <td>Disable loading of parameters from the parameter cache. Default: <tt>false</tt></td>
    </tr>
    <tr>
        <td class="code">processor</td>
        <td class="code">string</td>
        <td>The name of the processor from which to use the parameter cache. Default: <tt>realtime</tt></td>
    </tr>
</table>
 

### Response

<pre class="header">Status: 200 OK</pre>
```json
{
  "range": [{
    "timeStart": "2018-04-06T11:24:01.752Z",
    "timeStop": "2018-04-06T12:21:25.187Z",
    "engValue": {
      "type": "STRING",
      "stringValue": "UNLOCKED"
    },
    "count": 11
  }, {
    "timeStart": "2018-04-06T12:21:25.187Z",
    "timeStop": "2018-04-06T12:26:25.187Z",
    "engValue": {
      "type": "STRING",
      "stringValue": "LOCKED"
    },
    "count": 1
  }]
}
```

* <tt>engValue</tt> is the engineering value of the parameter in the interval <tt>[timeStart, timeStop)</tt> time interval have to be considered as closed at start and open at stop.
* <tt>timeStart</tt> is the generation time of a parameter value.
* <tt>timeStop</tt> is:
  * if the value changes, <tt>timeStop</tt> is the generation time of the new value
  * if the parameter expires or the <tt>maxGap</tt> has been set, <tt>timeStop</tt> is the generation time of the last value plus the expiration time or the <tt>maxGap</tt>.
* <tt>count</tt> is the number of parameter values received in the interval.

### Alternative Media Types

#### Protobuf

Use HTTP header:

    Accept: application/protobuf
    
Response is of type:

{% proto pvalue/pvalue.proto %}
message Ranges {
   message Range {
        optional string timeStart = 1;
        optional string timeStop = 2;
        optional yamcs.Value engValue = 3;
        optional int32 count = 4;
   }
   repeated Range range = 1;
}
{% endproto %}
