<?php

// Put your device token here (without spaces):
//8d460ea10de0fbdd07347604de8493fd4b76ed6e621e597cdeae4e32a8c08b72
//7763fd668545e52630f0ffcbd5093fee82b8c5ec89e519f77d1830649ca28528
$deviceToken = '7763fd668545e52630f0ffcbd5093fee82b8c5ec89e519f77d1830649ca28528';
// $deviceToken = '7dc96e66c281b36393ff380450bdd2c438d04d0c771810b3e8ad4901d78d0caf';
$deviceToken = '2238b79f86104fd6abd6e3182dfcd6c7dc1967ea07e8fb461f77ced04966f60c';

// Put your private key's passphrase here:
$passphrase = 'saturday';

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

$payload = "{\"aps\" : {\"alert\" : \"You got hjh hk kh your emails.\",\"badge\" : 9},\"acme1\" : \"bar\",\"acme2\" : 42}";

// $payload = "{\"aps\" : {\"alert\" : \"Driver accepted and started for pickup.\",\"badge\" : 1},\"data\":{\"msgtype\":\"10\",\"tripID\":1,\"tripUniqueID\":\"1000\",\"driverID\":2,\"pickupAddress\":\"Unnamed Rd, Phase 8, Industrial Area, Sector 73 Sahibzada Ajit Singh Nagar, Punjab 140308 \",\"dropOffAddress\":\"Sector 71 Sahibzada Ajit Singh Nagar, Punjab \"}}";

// $payload = "{\"aps\" : {\"alert\" : \"Driver reached at pickup.\",\"badge\" : 1},\"data\":{\"msgtype\":\"2\",\"tripID\":1,\"tripUniqueID\":\"1000\",\"pickupAddress\":\"Unnamed Rd, Phase 8, Industrial Area, Sector 73 Sahibzada Ajit Singh Nagar, Punjab 140308 \",\"dropOffAddress\":\"Sector 71 Sahibzada Ajit Singh Nagar, Punjab \",\"distancePickupDropoff\":\"3Km\",\"timePickupDropoff\":\"6 mins\",\"tripFare\":60}}";

// $payload = "{\"aps\" : {\"alert\" : \"Please confirm onboard.\",\"badge\" : 1},\"data\":{\"msgtype\":\"3\"}}";

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
