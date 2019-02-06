---
layout: default
sidebar: yes
permalink: /docs/studio/Processed_Variables/
---

Processed Variable or 'PV' is a term used by Yamcs Studio that covers the different types of data sources that a widget can be connected to. It is a more general term than parameter, which is a Yamcs Server notion.

PVs are uniquely identified by a <em>PV Name</em>. If multiple widgets have dependencies on the same PV, only one instance will be created and shared between these widgets.

The term PV is used to indicate both the name of a specific data source definition, as well as any instances of that definition. Context usually makes it apparent which of the two is meant.

A PV is considered <em>connected</em> if the data source is available, and at least one widget within Yamcs Studio is subscribing to it. As soon as no more widgets are connected to a PV, the PV gets <em>disconnected</em>.

{% hint %}
  A side effect of this last property, is that widgets with memory, such as chart widgets, lose their history when closing and reopening the display. We are aware of this, and are taking care of this shortcoming.
{% endhint %}

There are different types of PVs:

* TOC
{:toc}

### Local PVs
Local PVs are read and written entirely in a running Yamcs Studio instance. They are never communicated to Yamcs, nor to any other copies of Yamcs Studio. Local PVs are typically used by the display author as a means to store information that needs to be communicated from one widget to another. They also form a powerful building block when scripting advanced displays due to their ability to store runtime state. This makes it possible to script logic based on a historical window of values.

Local PVs are transient, and are reset when Yamcs Studio is restarted. Local PVs do not need to be specially created. They are automatically instantiated when needed.

Example PV Names:

* <tt>loc://foo</tt>
* <tt>loc://my-favourite-local-pv</tt>
* <tt>loc://anything-you-want-really</tt>

You can assign an initial value to a local PV by adding it after its name. For instance:

* <tt>loc://foo(1)</tt>
* <tt>loc://bar("abc")</tt>


### Parameters
Parameter PVs represent a read-only value that is provided by Yamcs. Typically this denotes telemetry.

The PV Name for parameters is the fully qualified XTCE name as specified in the Yamcs Mission Database.

Example PV Names:

* <tt>para:///YSS/SIMULATOR/BatteryVoltage1</tt>
* <tt>para:///YSS/SIMULATOR/BatteryTemperature1</tt>

Or simply:

* <tt>/YSS/SIMULATOR/BatteryVoltage1</tt>
* <tt>/YSS/SIMULATOR/BatteryTemperature1</tt>

In these examples <tt>YSS</tt> is the name of the root space system. <tt>SIMULATOR</tt> is the name of the space system directly below, which defines both measurements <tt>BatteryVoltage1</tt> and <tt>BatteryTemperature1</tt>.

### Software Parameters
Same concept as a Parameter, but has additional support for writing values from the client to the server. In this regard they can be used as a means of communicating information from one client to another using Yamcs Server as the medium.

Remark that software parameters are not currently archived by Yamcs Server, and will therefore be reset when Yamcs is restarted.

Example PV Name:

* <tt>sw:///YSS/SIMULATOR/some-software-param</tt>

### Simulated Values
Locally generated simulation data. Mainly useful during testing, or in combination with other PVs using formulas. Full documentation is upcoming. For now please have a look at the example operator displays in the YSS projects.

Example PV Names:

* <tt>sim://ramp(0,1,1,0.5)</tt>
* <tt>sim://const(4)</tt>
* <tt>sim://noise</tt>
* <tt>sim://sine</tt>

### Formulas
PVs can be combined with mathematical expressions. Formulas always start with <tt>=</tt> followed by a formula expression. Note that any referenced PVs must be wrapped with single quotes. 

Example PV Names:

* <tt>=3*'loc://foo(2)'</tt>
* <tt>=3.14</tt>
* <tt>=log('loc://foo(2)')<tt>

Supported formulas include:

* abs(a)
* acos(a)
* asin(a)
* atan(a)
* ceil(a)
* cos(a)
* cosh(a)
* exp(a)
* expm1(a)
* floor(a)
* log(a)
* log10(a)
* round(a)
* sin(a)
* sinh(a)
* sqrt(a)
* tan(a)
* tanh(a)
* toDegrees(a)
* toRadians(a)
* atan2(a, b)
* hypot(a, b)
* pow(a, b)
* min(a, b, c, d, e)
* max(a, b, c, d, e)
