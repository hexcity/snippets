<?php

$redis=new Redis();
$connected= $redis->connect('127.0.0.1', 6379);

if(!$connected) {
        die( "Cannot connect to redis server.\n" );
}

echo "Connected successfully.\n";

?>
