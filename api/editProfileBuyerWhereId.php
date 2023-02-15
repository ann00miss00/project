<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}


if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
			
		$id = $_GET['id'];
		$avatar = $_GET['avatar'];
		$email = $_GET['email'];
		$user = $_GET['user'];
		$name = $_GET['name'];
		$phone = $_GET['phone'];
		$address = $_GET['address'];
		$road = $_GET['road'];
		
		
							
		$sql = "UPDATE `user` SET `avatar` = '$avatar',`email` = '$email', `user` = '$user',`name` = '$name', `phone` = '$phone',`address` = '$address', `road` = '$road', WHERE id = '$id'";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master UNG";
   
}

	mysqli_close($link);
?>