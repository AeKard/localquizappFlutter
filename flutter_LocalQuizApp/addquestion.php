<?php
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json');
header("Content-Type: application/x-www-form-urlencoded");

include 'db.php';

// Check if all required POST parameters are present
if (
    isset($_POST['question']) &&
    isset($_POST['a']) &&
    isset($_POST['b']) &&
    isset($_POST['c']) &&
    isset($_POST['d']) &&
    isset($_POST['answer_letter'])
) {
    // Sanitize input
    $question = mysqli_real_escape_string($conn, $_POST['question']);
    $a = mysqli_real_escape_string($conn, $_POST['a']);
    $b = mysqli_real_escape_string($conn, $_POST['b']);
    $c = mysqli_real_escape_string($conn, $_POST['c']);
    $d = mysqli_real_escape_string($conn, $_POST['d']);
    $answer_letter = mysqli_real_escape_string($conn, $_POST['answer_letter']);
    // Insert into database
    $sql = "INSERT INTO quiz (question, a, b, c, d, answer_letter) 
            VALUES ('$question', '$a', '$b', '$c', '$d', '$answer_letter')";

    if (mysqli_query($conn, $sql)) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode([
            "status" => "error", 
            "message" => "Failed to insert: " . mysqli_error($conn)
        ]);
    }
} else {
    echo json_encode([
        "status" => "error", 
        "message" => "Missing required fields '$question' '$a' '$b' '$c' '$d' '$answer_letter'"
    ]);
}

mysqli_close($conn);
?>
