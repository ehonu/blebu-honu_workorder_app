<?php 
  $db = "honu";
  $host = "127.0.0.1";
  $db_user = 'root';
  $db_password = '';
  //MySql server and database info
 
 $connect = mysqli_connect($host, $db_user, $db_password, $db);
//if(!connect){echo json_encode("connection failed");}

$return['error']=false;
$return['message']='';

 $image = $_FILES['image']['name'];
 $distance=$_POST['distance'];
 $email=$_POST['email'];
 $describe=$_POST['descrip'];
 $location=$_POST['location'];
$distance=mysqli_real_escape_string( $connect,$distance);

  //$pof = $_POST['pof'];
  //$rfo = $_POST['rfo'];
  //$jbox = $_POST['jbox'];
  //$cable = $_POST['cable'];
   //$distance = mysqli_real_escape_string($connect,$_POST['distance']);

//$image= 'xyzzzzz';

 $imagePath = "uploads/".$image;
$image = $_FILES['image']['name'];

move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);


$query="INSERT INTO cs ( distance,location, description,images) VALUES ('.$distance.','.$location.', ' $describe','$image')";
$results=mysqli_query($connect,$query);
if($results==='true'){echo 'successfully saved';}
else{
$return['error']=true;
$return['message']='send all parameters';
}

mysqli_query($connect);
//header('Content-Type:application/json');
echo json_encode($return);

//$connect->query("INSERT INTO product (product_name,image) VALUES ('".$productname."','"."')");

?>