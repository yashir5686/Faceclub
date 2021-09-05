<?php

include "db_conn.php";
//post details
$userid = $_POST['userid'];
$isphoto = $_POST['isphoto'];
$category = $_POST['category'];
$caption = $_POST['caption'];
$location = $_POST['location'];


$img_name = $_FILES['file']['name'];
$tmp_name = $_FILES['file']['tmp_name'];


if($isphoto === '1'){
    $videoorphoto = 1;
}else{
    $videoorphoto = 0;
}


$img_ex = pathinfo($img_name, PATHINFO_EXTENSION);
$img_ex_lc = strtolower($img_ex);

$new_img_name = uniqid("post_", true).'.'.$img_ex_lc;
$img_upload_path = 'uploads/posts/'.$new_img_name;
move_uploaded_file($tmp_name, $img_upload_path);

$imageurl = 'https://bawratest.000webhostapp.com/'.$img_upload_path;
//Insert into Database
$sql = "INSERT INTO posts (userid,caption,category,image,isphoto,location)
			VALUES('".$userid."', '".$caption."', '".$category."', '".$imageurl."', '".$videoorphoto."', '".$location."')";
$conn->query($sql);
echo "post uploaded";