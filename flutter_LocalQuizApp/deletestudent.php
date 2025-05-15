<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/x-www-form-urlencoded");

include 'db.php';

if (isset($_POST['studentnumber']) && isset($_POST['lastname'])) {
    $studentnumber = mysqli_real_escape_string($conn, $_POST['studentnumber']);
    $lastname = mysqli_real_escape_string($conn, $_POST['lastname']);

    // Set active to 0 (deactivated) – you can change this to 1 if re-activating
    $query = "UPDATE student_account 
              SET active = 0 
              WHERE studentnumber = '$studentnumber' AND lastname = '$lastname'";
              
    $result = mysqli_query($conn, $query);

    if ($result && mysqli_affected_rows($conn) > 0) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => "No student found or update failed."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Missing parameters."]);
}
mysqli_close($conn);
?>
