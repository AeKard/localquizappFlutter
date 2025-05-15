<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Handle preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

include 'db.php';

// Read input only once
$raw = file_get_contents("php://input");
file_put_contents("log.txt", "RAW: $raw\n", FILE_APPEND); // for debugging

$input = json_decode($raw, true);

// Validate input
if (!isset($input['ids']) || !is_array($input['ids'])) {
    echo json_encode(["status" => "error", "message" => "Invalid input"]);
    exit;
}

// Sanitize and prepare IDs for SQL
$ids = array_map('intval', $input['ids']);
$idList = implode(",", $ids);

// Prepare and execute UPDATE query
$sql = "UPDATE quiz SET active = 0 WHERE id IN ($idList)";
if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success", "message" => "Questions deleted successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error deleting questions: " . $conn->error]);
}

$conn->close();
?>
