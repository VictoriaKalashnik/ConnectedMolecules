# Example Thing Implementation in JS

This small application designed to use AWS IOT mqtt interface with private certificate authentication which is one of our business pillars.

## Installation

*Assuming nodejs version >= 14 installed*

```yaml
npm install
```

## Running

`--endpoint` Endpoint supplied within *thing.json*

`--cert` PEM Certificate

`--key` Private Key

`--ca` AWS Root certificate

`--message` Message Either a plain *string* "hello world", or a *JSON string* '{"hello":"world"}'

`--thing` Thing name, supplied as name within *thing.json*

`--topic` MQTT Topic. `${thingId}/events` or `${thingId}/commands`

`--count` Message count

**Example**
```shell
node pubsub --endpoint "a15auxg78avhs5-ats.iot.eu-west-1.amazonaws.com" --cert "c:\Users\VictoriaKalashnik\Private\candidate-kalashnikviktoriia\certificate.pem" --key "c:\Users\VictoriaKalashnik\Private\candidate-kalashnikviktoriia\private.key" --ca_file "c:\Users\VictoriaKalashnik\Private\candidate-kalashnikviktoriia\AmazonRootCA1.pem" --topic "cagriekin/events"  --message "hey" --thing "cagriekin" --count 1
```
