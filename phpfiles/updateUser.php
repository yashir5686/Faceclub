<?php 

include "db_conn.php";

$id = $_POST['userid'];
$name = $_POST['name'];
$oldpic = $_POST['oldpic'];
$bio = $_POST['bio'];
$website = $_POST['website'];
$displayname = $_POST['displayname'];


if($oldpic === 'not updated'){
    $sql = "UPDATE users SET name = '$name', displayname = '$displayname', bio = '$bio', website = '$website' WHERE userid = '$id' ";
    if($conn->query($sql) === true){
    echo "Records was updated successfully.";
} else{
    echo "ERROR: Could not able to execute $sql. "
                                        . $conn->error;
}
}else{
unlink($oldpic);


$img_name = $_FILES['file']['name'];
$tmp_name = $_FILES['file']['tmp_name'];

$img_ex = pathinfo($img_name, PATHINFO_EXTENSION);
$img_ex_lc = strtolower($img_ex);

$new_img_name = uniqid("user_", true).'.'.$img_ex_lc;
$img_upload_path = 'uploads/users/'.$new_img_name;
move_uploaded_file($tmp_name, $img_upload_path);

$profileImageUrl = 'https://bawratest.000webhostapp.com/'.$img_upload_path;

//$conn->query("UPDATE users SET name='".$name."',displayname = '".$displayname."',profileImageUrl = '".$profileImageUrl."',bio = '".$bio."',website = '".$website."' WHERE userid=$id");
//}
$sql = "UPDATE users SET name = '$name', displayname = '$displayname', profileImageUrl = '".$profileImageUrl."', bio = '$bio', website = '$website' WHERE userid = '$id' ";

if($conn->query($sql) === true){
    echo "Records was updated successfully.";
} else{
    echo "ERROR: Could not able to execute $sql. "
                                        . $conn->error;
}
}

?>