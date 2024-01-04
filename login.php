<?php 
$db = "test_db"; 
  $dbuser = "root"; 
  $dbpassword = ""; 
  $dbhost = "127.0.0.1"; 

  $return["error"] = false;
  $return["message"] = "";
  $return["success"] = false;

  $link = mysqli_connect($dbhost, $dbuser, $dbpassword, $db);

  if(isset($_POST["username"]) && isset($_POST["pw"])){
       

       $username = $_POST["username"];
       $password = $_POST["pw"];

       $username = mysqli_real_escape_string($link, $username);


       $sql = "SELECT * FROM lg WHERE username = '$username' ";
       
       $res = mysqli_query($link, $sql);
       $numrows = mysqli_num_rows($res);
       
       if($numrows > 0){
           
           $obj = mysqli_fetch_object($res);
           
           if(($password) == $obj->password){
               $return["success"] = true;
               $return["username"] = $obj->username;
               //$return["fullname"] = $obj->fullname;
               //$return["images"] = $obj->images;
               $return["message"] = "Your Password is correct.";
           }else{
               $return["error"] = true;
               $return["message"] = "Your Password is Incorrect.";
           }
       }else{
           $return["error"] = true;
           $return["message"] = 'Wrong username.';
       }
  }else{
      $return["error"] = true;
      $return["message"] = 'Send all parameters.';
  }

  mysqli_close($link);

  header('Content-Type: application/json');
  
  echo json_encode($return);
  
?>

