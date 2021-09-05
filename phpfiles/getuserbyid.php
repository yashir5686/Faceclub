<?php

require_once('db.php');
$id = intval($_GET['id']);
$query = "SELECT * FROM users WHERE userid=$id";
$stm = $db->prepare($query);
$stm->execute();
$row = $stm->fetch(PDO::FETCH_ASSOC);
echo json_encode($row);
