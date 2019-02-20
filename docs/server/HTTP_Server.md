---
layout: default
permalink: /docs/server/HTTP_Server/
sidebar: yes
---

Embedded HTTP server that provides these functionalities:

* Serve HTTP API (REST and WebSocket)
* Serve the Yamcs web interface

The HTTP Server is tightly integrated with the security system of Yamcs and serves as the default interface for external tooling wanting to integrate. This covers both server-to-server and server-to-user communication patterns.

The HTTP Server can be disabled when its functionality is not needed. Note that in this case also official external clients such as Yamcs Studio will not be able to connect to Yamcs.

### Class Name
{% javadoc org/yamcs/web/HttpServer %}

### Configuration

This is a global service defined in <tt>etc/yamcs.yaml</tt>. Example from a typical deployment:

{% yaml yamcs.yaml %}
services:
  - class: org.yamcs.web.HttpServer
    args:
      webRoot: lib/yamcs-web
      port: 8090
      webSocket:
        writeBufferWaterMark:
          low: 32768
          high: 65536
        connectionCloseNumDroppedMsg: 5
      cors:
        allowOrigin: "*"
        allowCredentials: false
      website:
        displayScope: GLOBAL
{% endyaml %}

### Configuration Options

<table class="inline">
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td class="code">port</td>
    <td class="code">integer</td>
    <td>The port at which Yamcs web services may be reached. Default: <tt>8090</tt></td>
  </tr>
  <tr>
    <td class="code">webRoot</td>
    <td class="code">string or string[]</td>
    <td>List of file paths that are statically served. This usually points to the web files for the built-in Yamcs web interface (<tt>lib/yamcs-web</tt>).</td>
  </tr>
  <tr>
    <td class="code">zeroCopyEnabled</td>
    <td class="code">boolean</td>
    <td>Indicates whether zero-copy can be used to optimize non-SSL static file serving. Default: <tt>true</tt></td>
  </tr>
  <tr>
    <td class="code">webSocket</td>
    <td class="code">map</td>
    <td>Configure WebSocket properties. Detailed below. If unset, Yamcs uses sensible defaults.</td>
  </tr>
  <tr>
    <td class="code">cors</td>
    <td class="code">map</td>
    <td>Configure cross-origin resource sharing for the HTTP API. Detailed below. If unset, CORS is not supported.</td>
  </tr>
  <tr>
    <td class="code">website</td>
    <td class="code">map</td>
    <td>Configure properties of the Yamcs website.</td>
  </tr>
</table>


#### WebSocket sub-configuration

<table class="inline">
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td class="code">maxFrameLength</td>
    <td class="code">integer</td>
    <td>Maximum frame length in bytes. Default: <tt>65535</tt></td>
  </tr>
  <tr>
    <td class="code">writeBufferWaterMark</td>
    <td class="code">map</td>
    <td>Water marks for the write buffer of each WebSocket connection. When the buffer is full, messages are dropped. High values lead to increased memory use, but connections will be more resilient against unstable networks (i.e. high jitter). Increasing the values also help if a large number of messages are generated in bursts. The map requires keys <tt>low</tt> and <tt>high</tt> indicating the low/high water mark in bytes.<br>
    Default: <tt>{ low: 32768, high: 65536}</tt></td>
  </tr>
  <tr>
    <td class="code">connectionCloseNumDroppedMsg</td>
    <td class="code">integer</td>
    <td>Allowed number of message drops before closing the connection. Default: <tt>5</tt></td>
  </tr>
</table>

#### CORS sub-configuration

CORS (cross-origin resource sharing) facilitates use of the API in client-side applications that run in the browser. CORS is a W3C specification enforced by all major browsers. Details are described at <a href="https://www.w3.org/TR/cors/">https://www.w3.org/TR/cors/</a>. Yamcs simply adds configurable support for some of the CORS preflight response headers.

Note that the embedded web interface of Yamcs does not need CORS enabled, because it shares the same origin as the HTTP API.

<table class="inline">
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td class="code">allowOrigin</td>
    <td class="code">string</td>
    <td>Exact string that will be set in the <tt>Access-Control-Allow-Origin</tt> header of the preflight response.</td>
  </tr>
  <tr>
    <td class="code">allowCredentials</td>
    <td class="code">boolean</td>
    <td>Whether the <tt>Access-Control-Allow-Credentials</tt> header of the preflight response is set to true. Default: <tt>false</tt></td>
  </tr>
</table>

#### Website sub-configuration

<table class="inline">
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td class="code">displayScope</td>
    <td class="code">string</td>
    <td>Where to locate displays and layouts. One of <tt>INSTANCE</tt> or <tt>GLOBAL</tt>. Setting this to <tt>GLOBAL</tt> means that displays are shared between all instances. Setting this to <tt>INSTANCE</tt>, means that each instance uses its own displays. Default: <tt>GLOBAL</tt></td>
  </tr>
</table>
