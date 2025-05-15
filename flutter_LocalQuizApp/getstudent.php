<?php
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json");

    include 'db.php';

    $query = "SELECT * FROM student_account WHERE active = 1";
    $result = mysqli_query($conn, $query);

    $students = [];

    while ($row = mysqli_fetch_assoc($result)) {
        $students[] = $row;
    }
    echo json_encode($students);
    mysqli_close($conn);
?>