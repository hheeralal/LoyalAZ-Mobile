<?php

// Put your device token here (without spaces):
$deviceToken = '8016b40cedaf543ab8edd3d60b8df8807e4055a362c1b9f87510cb1481576379';
// $deviceToken = 'e1cdbd15e82214ac0da3de3ab151ee43e8fa701c89fe0c3c4a84cfb2368302eb';

// Put your private key's passphrase here:
$passphrase = 'loyalaz';

// Put your alert message here:
$message = 'My push notification!';

////////////////////////////////////////////////////////////////////////////////

$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', 'laz_push.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

// Open a connection to the APNS server
$fp = stream_socket_client(
	'ssl://gateway.sandbox.push.apple.com:2195', $err,
	$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

if (!$fp)
	exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Create the payload body
$body['aps'] = array(
	'alert' => $message,
	'sound' => 'default'
	);

// Encode the payload as JSON
$payload = json_encode($body);

$payload = "{\"aps\" : {\"alert\" : \"New program is added.\",\"badge\" : 9},\"acme1\" : \"bar\",\"acme2\" : 42}";

// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));

if (!$result)
	echo 'Message not delivered' . PHP_EOL;
else
	echo 'Message successfully delivered' . PHP_EOL;

// Close the connection to the server
fclose($fp);
