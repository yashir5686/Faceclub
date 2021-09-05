<?php

$dns = 'mysql:host=localhost;dbname=id17405876_testdatabase';
$user = 'id17405876_testuser';
$pass = 'TestPass@934';

try{
    $db = new PDO ($dns, $user, $pass);
    echo 'connected';
}catch( PDOException $e){
    $error = $e->getMessage();
    echo $error;
}
