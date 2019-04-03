---
layout: default
permalink: /docs/server/UDP_TC_Data_Link/
sidebar: yes
---

Sends telecommands via UDP.

### Class Name
{% javadoc org/yamcs/tctm/UdpTcDataLink %}


### Configuration Options

<table class="inline">
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td class="code">stream</td>
    <td class="code">string</td>
    <td><b>Required.</b> The stream where command instructions are received</td>
  </tr>
  <tr>
    <td class="code">host</td>
    <td class="code">string</td>
    <td><strong>Required.</strong> The host of the TC provider</td>
  </tr>

  <tr>
    <td class="code">port</td>
    <td class="code">integer</td>
    <td><strong>Required.</strong> The UDP port to connect to</td>
  </tr>

  <tr>
    <td class="code">tcQueueSize</td>
    <td class="code">integer</td>
    <td>Limit the size of the queue. Default: unlimited</td>
  </tr>

  <tr>
    <td class="code">tcMaxRate</td>
    <td class="code">integer</td>
    <td>Ensure that on overage no more than <tt>tcMaxRate</tt> commands are issued during any given second. Default: unspecified</td>
  </tr>

  <tr>
    <td class="code">commandPostprocessorClassName</td>
    <td class="code">string</td>
    <td>
      Class name of a <a href="https://www.yamcs.org/yamcs/javadoc/index.html?org/yamcs/tctm/CommandPostprocessor.html"><tt>CommandPostprocessor</tt></a> implementation. Default is <a href="https://www.yamcs.org/yamcs/javadoc/index.html?org/yamcs/tctm/IssCommandPostprocessor.html"><tt>org.yamcs.tctm.IssCommandPostProcessor</tt></a> which applies ISS conventions. Put <tt>org.yamcs.tctm.GenericCommandPostProcessor</tt> to use a UDP Link.
    </td>
  </tr>

  <tr>
    <td class="code">commandPostprocessorArgs</td>
    <td class="code">map</td>
    <td>
      Optional args of arbitrary complexity to pass to the CommandPostprocessor. Each CommandPostprocessor may support different options.
    </td>
  </tr>
</table>
