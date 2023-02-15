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

if (isset($_POST)) {
	if ($_POST['isAdd'] == 'true') {
				
		$avatar = $_POST['avatar'];
		$email = $_POST['email'];
		$password = $_POST['password'];
		$user = $_POST['user'];
		$name = $_POST['name'];
		$phone = $_POST['phone'];
		$address = $_POST['address'];
		$road = $_POST['road'];
		$detail = $_POST['detail'];
		
		
		
							
		$sql = "INSERT INTO `user`(`id`, `avatar`, `email`, `password`, `user`, `name`, `phone`, `address`, `road`, `detail`) VALUES (NULL,'$avatar','$email','$password','$user','$name','$phone','$address','$road','$detail')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "สวัสดีค่ะ";
   
}
	mysqli_close($link);
?>