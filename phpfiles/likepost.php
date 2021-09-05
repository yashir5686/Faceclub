<?php

include "db_conn.php";
//post details
$userid = $_POST['userid'];
$postid = $_POST['postid'];

//Insert into Database
$sql = "INSERT INTO posts (userid,caption,category,image,isphoto,location)
			VALUES('".$userid."', '".$caption."', '".$category."', '".$imageurl."', '".$videoorphoto."', '".$location."')";
$conn->query($sql);
echo "post uploaded";