---
layout: default
permalink: /docs/server/Parameter_Archive/
sidebar: yes
---

The parameter archive stores for each parameter tuples of (t<sub>i</sub>, ev<sub>i</sub>, rv<sub>i</sub>, ps<sub>i</sub>) where:

* t<sub>i</sub> - is the "generation" timestamp of the value. The "reception" timestamp is not stored in the Parameter Archive.
* ev<sub>i</sub> - is the engineering value of the parameter at the given time.
* rv<sub>i</sub> - is the engineering value of the parameter at the given time.
* ps<sub>i</sub> - is the parameter status of the parameter at the given time.

The parameter status includes things like out of limits (alarms), processing status, etc. XTCE provides a mechanism through which a parameter can change its alarm ranges depending on the context. For this reason we store in the parameter status also the applicable alarm ranges at the given time. 

In order to speed up the retrieval, the parameter archive stores data in segments of approximately 70 minutes. That means that all engineering values for one parameter for the 70 minutes are stored together; same for raw values, parameter status and timestamps. More detail about the parameter archive organization can be found in the [Parameter Archive Internals](../Parameter_Archive_Internals).
Having all the data inside one segment of the same type offers possibility for good compression especially if the values don't change much or at all (as it is often the case).

While this structure is good for fast retrieval, it doesn't allow updating data very efficiently and in any case not in realtime (like the stream archive does). This is why the parameter archive is filled in batch mode - data is accumulated in memory and flushed to disk periodically. The sections below explain the different filling strategies implemented.

### Archive filling 
There are two fillers that can be used to populate parameter archive:

* Realtime filling - the RealtimeFillerTask will subscribe to a realtime processor and write the parameter values to the archive.
* Backfilling - the ArchiveFillerTask will create from time to time replays from the stream archive and write the generated parameters to the archive.

Due to the fact that data is stored in segments, one segment being a value in the (key,value) RocksDB, it is not efficient to write one "row" (data corresponding to one timestamp) at a time. It is much more efficient to collect data and write entire or at least partial segments at a time. 
The realtime filler will write the partial segments to the archive at each configurable interval. When retrieving data from the parameter archive, the latest (near realtime) data will be missing from the archive. That's why Yamcs uses the processor parameter cache to retrieve the near-realtime values.

The backFiller is by default enabled and it can also be used to issue rebuild requests over HTTP. The realtimeFiller has to be enabled in the configuration and the flushInterval (how often to flush the data in the archive) has to be specified. The flushInterval has to be smaller than the duration configured in the parameter cache.
The backFiller is configured with a so called warmupTime (by default 60 seconds) which means that when it performs a replay, it starts the replay earlier by the specified warmupTime amount. The reason is tha if there are any algorithms that depend on some parameters in the past for computing the current value, this should give them the chance to warmup. The data generated during the warmup is not stored in the archive (because it is part of the previous segment).
