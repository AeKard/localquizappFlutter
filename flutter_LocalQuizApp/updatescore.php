<?php
// Allow access from any origin
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include "db.php"; // <-- Added missing semicolon

// Check if both studentnumber and score are set
if (isset($_POST['studentnumber']) && isset($_POST['score'])) {
    $studentnumber = $_POST['studentnumber'];
    $score = $_POST['score'];

    // Check if both values are not empty
    if (empty($studentnumber) || $score === '') {
        http_response_code(400);
        echo json_encode(["success" => false, "message" => "Missing studentnumber or score"]);
        exit;
    }

    // Check if the student exists in the database
    $stmt = $conn->prepare("SELECT id FROM student_grade WHERE studentnumber = ?");
    $stmt->bind_param("s", $studentnumber);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Update score
        $update = $conn->prepare("UPDATE student_grade SET score = ? WHERE studentnumber = ?");
        $update->bind_param("ss", $score, $studentnumber);
        
        if ($update->execute()) {
            echo json_encode(["success" => true, "message" => "Score updated"]);
        } else {
            http_response_code(500);
            echo json_encode(["success" => false, "message" => "Update failed"]);
        }
    } else {
        http_response_code(404);
        echo json_encode(["success" => false, "message" => "Student not found"]);
    }

    $stmt->close();
    $conn->close();
} else {
    // If studentnumber or score is not provided
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "studentnumber or score not provided"]);
}
?>
