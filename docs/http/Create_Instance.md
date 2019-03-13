---
layout: default
permalink: /docs/http/Create_Instance/
sidebar: yes
---

Create a Yamcs Instance:

    POST /api/instances

## Request Body

    {
    name: "simulator2",
    template: "template1",
    templateArgs: {
        tmPort: 30000,
        tcPort: 30001,
        losPort: 30002,
        tm2Port: 30003,
        telnetPort: 30004
    };
    labels: {
        label1: "value1",
        label2: "value2"
    }
    }


Yamcs will look for a template file in
\<YAMCS_ETC\>/instance-templates/template1/template.yaml with a content
like this:

{% raw %} 
    ...
        - class: org.yamcs.simulation.simulator.SimulatorCommander
        args:
        telnet:
            port: {{telnetPort}}
        tctm:
            tmPort: {{tmPort}}
            tcPort: {{tcPort}}
            losPort: {{losPort}}
            tm2Port: {{tm2Port}}
    dataLinks:
    - name: tm_realtime
        enabledAtStartup: false
        class: org.yamcs.tctm.TcpTmDataLink
        args:
        stream: tm_realtime
        host: localhost
        port: {{tmPort}}
    ...
{% endraw %}


After the request is executed successfully, a file will be created:
\<YAMCS_DATA\>/instance_def/yamcs.simulator2.yaml where the template
arguments are replaced with the instantiated values:

    ...
        - class: org.yamcs.simulation.simulator.SimulatorCommander
            args:
            telnet:
                port: 30004
            tctm:
                tmPort: 30000
                tcPort: 30001
                losPort: 30002
                tm2Port: 30003
    dataLinks:
    - name: tm_realtime
        enabledAtStartup: false
        class: org.yamcs.tctm.TcpTmDataLink
        args:
        stream: tm_realtime
        host: localhost
        port: 30000
    ...


## Response


<pre class="header">Status: 200 OK</pre>
```json
{
  "name": "simulator2",
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
...
}
```
