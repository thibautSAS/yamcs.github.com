---
layout: default
permalink: /docs/http/Control_Instance/
sidebar: yes
---

Control a Yamcs instance:
-> Allows to control (start/stop/restart) a Yamcs instance:

Suggest to have "stop", "restarted"... in fixed width character, see the Control Processor.
Also the description should not be in bold.


    POST /api/instances/:instance?state=:state
    
## Parameters

<table class="inline">
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td class="code">state</td>
    <td class="code">string</td>
    <td><p>It can be: <tt>stop</tt>/<tt>stopped</tt>, <tt>restarted</tt> or <tt>running</tt>.</p>
    <p>stop/stopped - stop all services of the instance. The instance state
will be OFFLINE. If the instance state is already OFFLINE, this call
will do nothing.</p>
    <p>restarted - if the instance state is RUNNING, the instance will be
stopped and then restarted. Otherwise the instance will be started. Note
that the Mission Database will be also reloaded before restart.</p>
<p>running - start the instance. If the instance is in the RUNNING state,
this call will do nothing. Otherwise the instance will be started.</p></td>
  </tr>
</table>

## Example

    POST /api/instances/simulator?state=stop

#### Response:
<pre class="header">Status: 200 OK</pre>
```json
{
  "name": "simulator",
  "missionDatabase": {
  },
  "missionTime": "2019-03-12T11:06:08.514Z",
  "state": "OFFLINE"
}
```

#### Other Example:

     POST /api/instances/simulator?state=running

#### Response:
<pre class="header">Status: 200 OK</pre>
```json
{
  "name": "simulator",
  "missionDatabase": {
    "name": "",
    "spaceSystem": [{
      "name": "yamcs",
      "qualifiedName": "/yamcs",
      "parameterCount": 0,
      "containerCount": 0,
      "commandCount": 0,
      "algorithmCount": 0,
      "sub": [{
        "name": "cmdHist",
        "qualifiedName": "/yamcs/cmdHist",
        "parameterCount": 1,
        "containerCount": 0,
        "commandCount": 0,
        "algorithmCount": 0
      }, {
        "name": "cmd",
        "qualifiedName": "/yamcs/cmd",
        "parameterCount": 0,
        "containerCount": 0,
        "commandCount": 0,
        "algorithmCount": 0,
        "sub": [{
          "name": "arg",
          "qualifiedName": "/yamcs/cmd/arg",
          "parameterCount": 1,
          "containerCount": 0,
          "commandCount": 0,
          "algorithmCount": 0
        }]
      }
      ...
}

```