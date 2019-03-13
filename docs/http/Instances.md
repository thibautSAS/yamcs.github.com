---
layout: default
permalink: /docs/http/Instances/
sidebar: yes
chapter: yes
---
The Yamcs instances provide means for one Yamcs server to monitor/control different payloads or sattelites or version of the payloads or satellites at the same time. When Yamcs is used in a Test/EGSE environment it allows creating multiple independent test sessions.

Each instance has a name and a directory where all data from that instance is stored, as well as a specific Mission Database used to process data for that instance.

Starting with version 4.9.0 Yamcs allows creating instances on the fly (until then,  they had to be pre-configured in the yamcs.yaml) by instantiating instance templates. The templates are instance configuration files which can contain template arguments of the shape {{templateArg}} which are replaced by specific values when the template is instantiated.

In addition, the API for creating instances allows to define labels: that is pairs of (name, value) strings. These allow to define metadata for the instance (e.g. test name, purpose, date, etc).