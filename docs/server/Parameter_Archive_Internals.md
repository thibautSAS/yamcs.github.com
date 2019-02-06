---
layout: default
permalink: /docs/server/Parameter_Archive_Internals/
sidebar: yes
---

## Why not store the values on change only?
As explained [here](../Parameter_Archive), the parameter archive stores for each parameter tuples (t<sub>i</sub>, ev<sub>i</sub>, rv<sub>i</sub>, ps<sub>i</sub>). In Yamcs the timestamp is an 8 bytes long, the raw and engineering values are of usual types (signed/unsigend 32/64 integer, 32/64 floating point, string, boolean, binary) and the parameter status is a protobuf message.

We can notice that in a typical space data stream there are many parameters that do not change very often (like an device ON/OFF status). For these, the space required to store the timestamp can greatly exceed in size the space required for storing the value (if simple compression is used).

In fact since the timestamps are 8 bytes long, they equal or execed in size the parameter values almost in all cases, even for parameters that do change.

To reduce the size of the archive, some parameter archives only store the values when they change with respect to the previous value. Often, like in the above "device ON/OFF" example, the exact timestamps of the non-changing parameter values, received in between actual (but rare) value changes are not very important. One has to take care that gaps in the data are not mistaken for non-changing parameter values.
Storing the values on change only will reduce the space required not only for the value but also (and more importantly) for the timestamp.

However, we know that more often than not parameters are not sampled individually but in packets or frames, and many (if not all) the parameters from one packet share the same timestamp.

Usually some of the parameters in these packets will be counters or other things that do change with each sampling of the value. It follows that at least for storing those ever changing parameter values, one has to store the timestamps anyway.

This is why, in Yamcs we do not adopt the "store on change only" strategy but a different one: we store the timestamps in one record and make reference to that record from all the parameters sharing those same timestamps. Of course it wouldn't make any sense to reference one singe timestamp value, instead we store multiple values in a segment and reference the time segment from all value segments that are related to it.

## Archive structure 
We have established that the Yamcs parameter archive stores rows of data of shape:
(t, pv<sub>0</sub>, pv<sub>1</sub>, pv<sub>2</sub>,...,  pv<sub>n</sub>)

Where pv<sub>0</sub>, pv<sub>1</sub>, pv<sub>2</sub>..pv<sub>n</sub> are parameter values (for different parameters) all sharing the same timestamp t. One advantage of seeing the data this way is that we do keep together parameters extracted from the same packet (and having the same timestamp). It is sometimes useful for operators to know a sepcific parameter from which packet has been extracted (e.g. which APID, packet ID in a CCSDS packet structure).

The parameter archive partitions the data at two levels:

1.  time partitioned in partitions of 2^31 milliseconds duration (=~ 25 days). Each partition is stored in its own ColumnDataFamily in RocksDB (which means separate files and the possibility to remove an entire partition at a time).

2. Inside each partition, data is segmented in segments of 2^22 miliseconds (=~ 70 minutes) duration. One data segment contains all the engineering values or raw values or parameter status for one parameter. A time segment contains all the corresponding timestamps. 

This means that each parameter requires each ~70 minutes three segments for storing the raw, engineering and status plus a segment containing the timestamps. The timestamp segment is shared with other parameters. In order to be able to efficiently compress and work with the data, one segment stores data of one type only.

Each (parameter_fqn, eng_type, raw_type) combination is given an unique 4 bytes parameter_id (fqn= fully qualified name). We do this in order to be able to accomodate changes in parameter definitions in subsequent versions of the mission database (Xtce db).

The parameter_id=0 is reserved for the timestamp.

A ParameterGroup - represents a list of parameter_id which share the same timestamp.
Each ParameterGroup is given a ParameterGroup_id


Column Families
 for storing metadata we have 2 CFs:  
   meta_p2pid:  contains the mapping between parameter fully qualified name and parameter_id and type
   meta_pgid2pg: contains the mapping between ParameterGroup_id and parameter_id
 
For storing parameter values and timestamps we have 1CF per partition: data_<partition_id>.
partition_id is basetimestamp (i.e. the start timetamp of the 2^31 long partitions) in hexadecimal (without 0x in front)

Inside the data partitions we store (key,value) records where:
  key: parameter_id, ParameterGroup_id, type, segment_start_time (the type=0,1 or 2 for the eng value, raw value or parameter status)
  value: ValueSegment or TimeSegment (if parameter_id =0)
      
We can notice from this organization, that inside one partition, the segments containing data for one parameter follows in the rockdsdb files in sequence of engvalue<sub>segment_1</sub>,rawvalue<sub>segment_1</sub>,parameterstatus<sub>segment_1</sub>, engvalue<sub>segment_2</sub>. rawvalue<sub>segment_2</sub>...
      

### Segment encoding
The segments are compressed in different ways depending on their types.

**SortedTimeSegment** - stores the timestamps as uitn32 deltas from the beginning of the segment. The data is first encoded into deltas of deltas, then it's zigzag encoded (such that it becomes positive) and then it's encoded with FastPFOR and VarInt. FastPFOR encodes blocks of 128 bytes so VarInt encoding is used for the remaining data.

Storing timestamps as deltas of deltas helps if the data is sampled at regular intervals (especially by a real-time sytem). In this case the encoded deltas of deltas become very close to 0 and that compresse very well.

Description of the VarInt and zigzag encoding can be found in [Protocol Buffer docs](https://developers.google.com/protocol-buffers/docs/encoding).

Description and implementation of the FastPFOR algorithm can be found [here](https://github.com/lemire/JavaFastPFOR).

**IntSegment** - stores int32 or uint32 encoded same way as the time segment.

**FloatSegment** - stores 32 bits floating point numbers encoded using the algorithm (very slightly modified to work on 32 bits) described in the [Facebook Gorilla paper](http://www.vldb.org/pvldb/vol8/p1816-teller.pdf)

**ParameterStatusSegment**, **StringSegment** and **BinarySegment** are all stored either raw, as an enumeration, or run-length encoded, depeending on which results in smaller compressed size.

**DoubleSegment** and **LongSegment** are only stored as raw for the moment - compression is still to be implemented. For DoubleSegment we can employ the same approach like for 32 bits (since the original approach is in fact designed for compressing 64 bits floating point numbers).


### Future work
**Segment Compression**
Compression for DoubleSegment and the LongSegment. DoubleSegment is straightforward, for the LongSegment one has to dig into the FastPFOR algorithm to understand how to change it for 64 bits.

**Archive filling**
It would be desirable to backfill only parts of the archive. Indeed, some ground generated data may not suffer necessarily of gaps and could be just realtime filled. Currently there is no possibility to specify what parts of the archive to be back-filled. This may be implemented in a future version.
Another useful feature would be to trigger the back filling automatically when gaps are filled in the stream archive. This will hopefully also be implemented in a future version  (contributions welcome!).
