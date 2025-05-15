<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'db.php'; 

$query = "SELECT id, question, a, b, c, d, answer_letter FROM quiz WHERE active = 1";
$result = mysqli_query($conn, $query);

$questions = [];

if ($result) {
    while ($row = mysqli_fetch_assoc($result)) {
        $questions[] = $row;
    }

    echo json_encode($questions);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to fetch questions"
    ]);
}
?>
