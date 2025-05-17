<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
error_reporting(E_ALL);
ini_set('display_errors', 1);

include "db.php"; // Include your database connection

// Get the student number from the POST request
$studentnumber = $_POST['studentnumber'] ?? '';

if (empty($studentnumber)) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Missing student number"]);
    exit;
}

try {
    // 🔹 Fetch the student's score
    $stmt1 = $conn->prepare("SELECT score FROM student_grade WHERE studentnumber = ?");
    $stmt1->bind_param("s", $studentnumber);
    $stmt1->execute();
    $result1 = $stmt1->get_result();

    // 🔹 Fetch the total number of active questions
    $stmt2 = $conn->prepare("SELECT COUNT(*) AS question_count FROM quiz WHERE active = 1");
    $stmt2->execute();
    $result2 = $stmt2->get_result();

    if ($result1->num_rows > 0 && $result2->num_rows > 0) {
        $studentData = $result1->fetch_assoc();
        $quizData = $result2->fetch_assoc();
        
        echo json_encode([
            "success" => true,
            "score" => $studentData['score'],
            "question_count" => $quizData['question_count']
        ]);
    } else {
        echo json_encode(["success" => false, "message" => "No records found"]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Server error", "error" => $e->getMessage()]);
}

$conn->close();
?>
