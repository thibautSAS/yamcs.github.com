---
layout: default
permalink: /docs/http/Parameter_Updates/
sidebar: yes
---

Subscribe to parameter updates:

```json
[ 1, 1, :seq, {
    "parameter": "subscribe",
    "data": {
        "id": [
            { "namespace": ":namespace", "name": ":name" }
        ],
        "updateOnExpiration": false,
        "abortOnInvalid": false,
        "sendFromCache": true,
        "subscriptionId": -1
    }
} ]
```

Options that can be used for parameter subscription:

* <tt>updateOnExpiration</tt> if set to true (the default is false), will cause parameter updates to be sent when parameters expire.
The update sent when the parameter expires will have the same value and timestamp like the previous sent one, but the acquisition status will be set to EXPIRED (instead of ACQUIRED).
* <tt>abortOnInvalid</tt> if set to false (default), then no error will be raised if some of the specified parameters are invalid. Instead the valid ones will be subscribed and the response will return the list of invalid parameters. If set to true and some parameters are invalid, an exception will be returned and no subscription will be made.
* <tt>sendFromCache</tt> if set to true (default), the existing values of the parameters from the cache (if any) will be sent immediately. Otherwise the values will only be sent when the  parameters update.
* <tt>subscriptionId</tt> is used to have multiple independent subscriptions. Each subscription is given a numeric id which can be used to add or remove parameters to/from the subscription. How to use multiple subscriptions:
  * each request will return the <tt>subcriptionId</tt> where the parameter have been added. Note that if <tt>abortOnInvalid</tt> is false and all the parameters are invalid, the request will return <tt>subscriptionId=-1</tt> and no subscription will be made. Each parameter message (containing parameter data) will also contain the <tt>subscriptionId</tt>.
  * the <tt>subscriptionId</tt> can be specified in the request to add parameters to an existing subcription.
  * if <tt>subscriptionId=-1</tt> is specified in the request, then a new subscription will be created and its <tt>subscriptionId</tt> will be returned.
  * for compatibility with the old API, if the <tt>subscriptionId</tt> is not specified in the <tt>subscribe/unsubscribe</tt> request, then the parameters will be added or removed to/from the first subscription created.



### Example

Subscribe to BatteryVoltage1 through a qualified name, and BatteryVoltage2 using an OPS name:

```json
[ 1, 1, 789, {
    "parameter": "subscribe",
    "data": {
        "id": [
            { "name": "/YSS/SIMULATOR/BatteryVoltage1" },
            { "namespace": "MDB:OPS Name", "name": "SIMULATOR_BatteryVoltage2" }
        ]

    }
} ]
```

### Response

You first get an reply message confirming the positive receipt of your request and the generated <tt>subscriptionId</tt>:

```json
[1, 2, 3, {"type":"ParameterSubscriptionResponse", "data":{
  "subscriptionId": 6
}}]
```
    
Further messages will be marked as type <tt>PARAMETER_DATA</tt>. Directly after you subscribe, you will receive the latest cached values if the option <tt>sendFromCache</tt> has been set.
Note that all parameters are returned with the same identification they have been subscribed to.

```json
[1, 4, 2, {
    "dt": "PARAMETER",
    "data": {
        "parameter": [{
            "id": {
                "name": "/YSS/SIMULATOR/BatteryVoltage1"
            },
            "rawValue": {
                "type": "UINT32",
                "uint32Value": 10
            },
            "engValue": {
                "type": "UINT32",
                "uint32Value": 10
            },
            "acquisitionTime": 1514993937058,
            "generationTime": 1514993932468,
            "acquisitionStatus": "ACQUIRED",
            "processingStatus": true,
            "monitoringResult": "IN_LIMITS",
            "acquisitionTimeUTC": "2018-01-03T15:38:20.058Z",
            "generationTimeUTC": "2018-01-03T15:38:15.468Z",
            "expirationTime": 1514993950358,
            "expirationTimeUTC": "2018-01-03T15:38:33.358Z",
            "alarmRange": [{
                "level": "CRITICAL",
                "minInclusive": 9.0,
                "maxInclusive": 15.0
            }],
            "expireMillis": 13300
        }, {
            "id": {
                "name": "SIMULATOR_BatteryVoltage2",
                "namespace": "MDB:OPS Name"
            },
            "rawValue": {
                "type": "UINT32",
                "uint32Value": 192
            },
            "engValue": {
                "type": "UINT32",
                "uint32Value": 192
            },
            "acquisitionTime": 1514993937058,
            "generationTime": 1514993932468,
            "acquisitionStatus": "ACQUIRED",
            "processingStatus": true,
            "monitoringResult": "CRITICAL",
            "rangeCondition": "HIGH",
            "acquisitionTimeUTC": "2018-01-03T15:38:20.058Z",
            "generationTimeUTC": "2018-01-03T15:38:15.468Z",
            "expirationTime": 1514993950358,
            "expirationTimeUTC": "2018-01-03T15:38:33.358Z",
            "alarmRange": [{
                "level": "CRITICAL",
                "minInclusive": 2.0,
                "maxInclusive": 15.0
            }],
            "expireMillis": 13300
        }],
        "subscriptionId": 6
    }
}]
```


### Unsubscribe

Unsubscribe from selected parameter updates:

```json
[ 1, 1, 790, {
    "parameter": "unsubscribe" 
    "data": {
        "id": [
            { "name": "/YSS/SIMULATOR/BatteryVoltage1" },
            { "namespace": "MDB:OPS Name", "name": "SIMULATOR_BatteryVoltage2" }
        ],
        "subscriptionId": 6
    }} ]
```

This will be confirmed with an empty reply message:

```json
[ 1, 2, 790 ]
```

Note that if <tt>subcriptionId</tt> is not specified , the parameters will be removed from the first subscription created.

### Unsubscribe all
Unsubscribe from all parameter updates for a given subscription:

```json
[ 1, 1, 790, {
    "parameter": "unsubscribeAll"
    "subscriptionId": 6
} ]
```

This will be confirmed with an empty reply message:

```json
[ 1, 2, 790 ]
```

After this call has been invoked, it is not possible anymore to reuse the <tt>subscriptionId</tt>; Instead a new one can be created by using <tt>subscriptionId = -1</tt> in the request.
