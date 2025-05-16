<?php
    header("Access-Control-Allow-Origin: *");
    // header("Content-Type: application/x-www-form-urlencoded");
    header("Content-Type: application/json");
    
    include 'db.php';
    $studentnumber = $_POST['studentnumber'];
    $query = "SELECT * FROM student_account WHERE studentnumber = '$studentnumber' and active = 1";
    $result = mysqli_query($conn, $query);

    if (!empty($result) && mysqli_num_rows($result) > 0) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error"]);
    }

    mysqli_close($conn);
?>