<?php
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/x-www-form-urlencoded");

    include 'db.php';

    if (isset($_POST['studentnumber']) && isset($_POST['lastname'])) {
        $studentnumber = $_POST['studentnumber'];
        $lastname = $_POST['lastname'];

        $studentnumber = mysqli_real_escape_string($conn, $studentnumber);
        $lastname = mysqli_real_escape_string($conn, $lastname);

        mysqli_begin_transaction($conn);

        try {
            $query1 = "INSERT INTO student_account (studentnumber, lastname, active) 
                       VALUES ('$studentnumber', '$lastname', DEFAULT)";
            $result1 = mysqli_query($conn, $query1);

            $query2 = "INSERT INTO student_grade (studentnumber, score) 
                       VALUES ('$studentnumber', 0)";
            $result2 = mysqli_query($conn, $query2);

            if ($result1 && $result2) {
                mysqli_commit($conn);
                echo json_encode(["status" => "success"]);
            } else {
                mysqli_rollback($conn);
                echo json_encode(["status" => "error", "message" => "Insert failed."]);
            }
        } catch (Exception $e) {
            mysqli_rollback($conn);
            echo json_encode(["status" => "error", "message" => $e->getMessage()]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing parameters."]);
    }
?>