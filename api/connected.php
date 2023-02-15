
        <?php

        $servername = 'localhost';
        $username = 'root';
        $password = '';
        $dbname = 'shoppingmall';
        
        $conn = new mysqli($servername, $username, $password, $dbname);
        
        if($conn->connect_error){
            die('Connect failed' . $conn->connect_error);
        }
        
        ?>



