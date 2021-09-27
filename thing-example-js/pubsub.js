const { mqtt, auth, io, iot } = require('aws-iot-device-sdk-v2');
const { TextDecoder } = require('util');
const yargs = require('yargs');

yargs.command('*', false, (yargs) => {
  yargs
    .option('endpoint', {
      alias: 'e',
      description: "Your AWS IoT custom endpoint, not including a port. "  +
        "Ex: \"abcd123456wxyz-ats.iot.us-east-1.amazonaws.com\"",
      type: 'string',
      required: true
    })
    .option('ca_file', {
      alias: 'r',
      description: 'FILE: path to a Root CA certficate file in PEM format.',
      type: 'string',
      required: false
    })
    .option('cert', {
      alias: 'c',
      description: 'FILE: path to a PEM encoded certificate to use with mTLS',
      type: 'string',
      required: false
    })
    .option('key', {
      alias: 'k',
      description: 'FILE: Path to a PEM encoded private key that matches cert.',
      type: 'string',
      required: false
    })
    .option('client_id', {
      alias: 'C',
      description: 'Client ID for MQTT connection.',
      type: 'string',
      required: false
    })
    .option('topic', {
      alias: 't',
      description: 'STRING: Targeted topic',
      type: 'string',
      default: 'test/topic'
    })
    .option('count', {
      alias: 'n',
      default: 10,
      description: 'Number of messages to publish/receive before exiting. ' +
        'Specify 0 to run forever.',
      type: 'number',
      required: false
    })
    .option('signing_region', {
      alias: 's',
      default: 'eu-west-1',
      description: 'If you specify --use_websocket, this ' +
        'is the region that will be used for computing the Sigv4 signature',
      type: 'string',
      required: false
    })
    .option('message', {
      alias: 'M',
      description: 'Message to publish.',
      type: 'string',
      default: 'Hello world!'
    })
    .option('thing', {
      description: 'Thing name to publish.',
      type: 'string',
      required: false
    })
    .option('verbosity', {
      alias: 'v',
      description: 'BOOLEAN: Verbose output',
      type: 'string',
      default: 'none',
      choices: ['fatal', 'error', 'warn', 'info', 'debug', 'trace', 'none']
    })
    .help()
    .alias('help', 'h')
    .showHelpOnFail(false)
}, main).parse();

async function execute_session(connection, argv) {
  return new Promise(async (resolve, reject) => {
    try {
      const decoder = new TextDecoder('utf8');
      const on_publish = async (topic, payload, dup, qos, retain) => {
        const json = decoder.decode(payload);
        console.log(`Publish received. topic:"${topic}" dup:${dup} qos:${qos} retain:${retain}`);
        console.log(json);
        const message = JSON.parse(json);
        if (message.sequence === argv.count) {
          resolve();
        }
      }

      await connection.subscribe(argv.topic, mqtt.QoS.AtLeastOnce, on_publish);

      let payload;
      try {
        payload = JSON.parse(argv.message);
      } catch(e) {
        payload = argv.message;
      }

      for (let op_idx = 0; op_idx < argv.count; ++op_idx) {
        const publish = async () => {
          const msg = {
            thingId: argv.thing,
            payload,
            timestamp: Date.now(),
          };
          const json = JSON.stringify(msg);
          connection.publish(argv.topic, json, mqtt.QoS.AtLeastOnce);
        }
        setTimeout(publish, op_idx * 1000);
      }
    }
    catch (error) {
      reject(error);
    }
  });
}

async function main(argv) {
  if (argv.verbosity !== 'none') {
    const level = parseInt(io.LogLevel[argv.verbosity.toUpperCase()]);
    io.enable_logging(level);
  }

  const client_bootstrap = new io.ClientBootstrap();

  let config_builder = null;
  if(argv.use_websocket) {
    config_builder = iot.AwsIotMqttConnectionConfigBuilder.new_with_websockets({
      region: argv.signing_region,
      credentials_provider: auth.AwsCredentialsProvider.newDefault(client_bootstrap)
    });
  } else {
    config_builder = iot.AwsIotMqttConnectionConfigBuilder.new_mtls_builder_from_path(argv.cert, argv.key);
  }

  if (argv.ca_file != null) {
    config_builder.with_certificate_authority_from_path(undefined, argv.ca_file);
  }

  config_builder.with_clean_session(false);
  config_builder.with_client_id(argv.client_id || "test-" + Math.floor(Math.random() * 100000000));
  config_builder.with_endpoint(argv.endpoint);

  // force node to wait 60 seconds before killing itself, promises do not keep node alive
  const timer = setTimeout(() => {}, 60 * 1000);

  const config = config_builder.build();
  const client = new mqtt.MqttClient(client_bootstrap);
  const connection = client.new_connection(config);

  await connection.connect()
  await execute_session(connection, argv)
  await connection.disconnect()

  // Allow node to die if the promise above resolved
  clearTimeout(timer);
}
