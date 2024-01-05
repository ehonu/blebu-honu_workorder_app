
//import 'dart:typed_data';
//© Copyright Ewoenam Blebu-Honu
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage>{
  late String errormsg;
  late bool error, showprogress;
  late String username, pw;

  var _username = TextEditingController();
  var _email = TextEditingController();

  startLogin() async {
    String apiurl = "https://www.cyubic.com/dashboard/login.php";
    //print(username);
    var response = await http.post(Uri.parse(apiurl), body: {
      'username': username,
      'pw': pw,
    });
    if(response.statusCode == 200){
      var jsondata = json.decode(response.body);
      if(jsondata["error"]){
        setState(() {
          showprogress = false;
          error = true;
          errormsg = jsondata["message"];
          print(errormsg);
        });
      }else{
        if(jsondata["success"]){
          setState(() {
            error = false;
            showprogress = false;
            errormsg = jsondata["message"];
            {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>MyApp()
            ));};
            print(errormsg);
            //print(errormsg);
          });
          //String uid = jsondata["uid"];
          //String fullname = jsondata["username"];
          //String address = jsondata["pw"];
          //print(fullname);

        }else{
          showprogress = false;
          error = true;
          errormsg = "Something went wrong.";
        }
      }
    }else{
      setState(() {
        showprogress = false;
        error = true;
        errormsg = "Error during connecting to server.";
      });
    }
  }

  @override
  void initState() {
    username = "";
    pw = '';
    //email = "";
    errormsg = "";
    error = false;
    showprogress = false;



    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent

    ));

    return Scaffold(
      body: SingleChildScrollView(
          child:Container(
            constraints: BoxConstraints(
                minHeight:MediaQuery.of(context).size.height

            ),
            width:MediaQuery.of(context).size.width,

            decoration:BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [ Colors.orange,Colors.deepOrangeAccent,
                  Colors.red, Colors.redAccent,
                ],
              ),
            ),

            padding: EdgeInsets.all(20),
            child:Column(children:<Widget>[

              Container(
                margin: EdgeInsets.only(top:80),
                child: Text("Sign Into System", style: TextStyle(
                    color:Colors.white,fontSize: 40, fontWeight: FontWeight.bold
                ),),
              ),

              Container(
                margin: EdgeInsets.only(top:10),
                child: Text("Sign In using Email and Password", style: TextStyle(
                    color:Colors.white,fontSize: 15
                ),),
              ),

              Container(

                margin: EdgeInsets.only(top:30),
                padding: EdgeInsets.all(10),
                child:error? errmsg(errormsg):Container(),


              ),

              Container(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                margin: EdgeInsets.only(top:10),
                child: TextField(
                  controller: _username,
                  style:TextStyle(color:Colors.orange[100], fontSize:20),
                  decoration: myInputDecoration(
                    label: "Username",
                    icon: Icons.person,
                  ),
                  onChanged: (value){

                    username = value;
                  },

                ),
              ),

              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _email,
                  style: TextStyle(color:Colors.orange[100], fontSize:20),
                  obscureText: true,
                  decoration: myInputDecoration(
                    label: "Password",
                    icon: Icons.lock,
                  ),
                  onChanged: (value){
                    pw=value;
                    //email = value;
                  },

                ),
              ),

              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top:20),
                child: SizedBox(
                  height: 60, width: double.infinity,
                  child:ElevatedButton(
                    onPressed: (){
                      setState(() {
                        showprogress = true;
                      });
                      startLogin();
                    },
                    child: showprogress?
                    SizedBox(
                      height:30, width:30,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.orange[100],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
                      ),
                    ):Text("LOGIN NOW", style: TextStyle(fontSize: 20),),

                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top:20),
                child: InkResponse(
                    onTap:(){
                    },
                    child:Text("Forgot Password? Contact admin -XXXXXno",
                      style: TextStyle(color:Colors.white, fontSize:18),
                    )
                ),
              )
            ]),
          )
      ),
    );
  }
  InputDecoration myInputDecoration({required String label, required IconData icon}){
    return InputDecoration(
      hintText: label,
      hintStyle: TextStyle(color:Colors.orange[100], fontSize:20),
      prefixIcon: Padding(
          padding: EdgeInsets.only(left:20, right:10),
          child:Icon(icon, color: Colors.orange[100],)
      ),
      contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color:Colors.orange, width: 1)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color:Colors.orange, width: 1)
      ),
      fillColor: Color.fromRGBO(251,140,0, 0.5),
      filled: true,
    );
  }
  Widget errmsg(String text){

    return Container(
      padding: EdgeInsets.all(15.00),
      margin: EdgeInsets.only(bottom: 10.00),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.red,
          border: Border.all(color:Colors.red, width:2)
      ),
      child: Row(children: <Widget>[
        Container(
          margin: EdgeInsets.only(right:6.00),
          child: Icon(Icons.info, color: Colors.white),
        ),

        Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),

      ]),
    );
  }
}
class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  late List<String> names = <String>[];
  final List<int> msgCount = <int>[1];
  //final List<int> type = <string>[1];
  TextEditingController nameController = TextEditingController();
  void loaddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      names =
      (prefs.getStringList('counter')  as List<String> );
    });
  }

  @override
  void initState(){
    super.initState();
    loaddata();

  }


  void addItemToList()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    setState(()  {

      //nameController.text= (prefs.getString('counter'))!;
      names.add(nameController.text);

      //nameController= ((prefs.getString('names')))! as TextEditingController;
      //type.insert('fbi',0)
      //msgCount.insert(0, 0);
      prefs.setStringList('counter',names );


      //this.preferences?.setString('nameController';
    });
  }

  void removedata(names)async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    setState(()  {

      //nameController.text= (prefs.getString('counter'))!;
      prefs.remove(names);

      //nameController= ((prefs.getString('names')))! as TextEditingController;
      //type.insert('fbi',0)
      //msgCount.insert(0, 0);
      //prefs.setStringList('counter',names );


      //this.preferences?.setString('nameController';
    });



  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Work order processor '),
        ),
        body: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.add_circle_outlined),
                    labelText: 'Link name',
                  ),
                ),
              ),
              ElevatedButton(
                child: Text('Add'),
                onPressed: () {
                  addItemToList();
                },
              ),


              Text('Double tap on Wo to delete'),

              new Container(),
              Icon(
                Icons.add,
                color: Colors.green,
                size: 30.0,
              ),

              Expanded(

                  child: ListView.builder(

                      padding: const EdgeInsets.all(8),
                      itemCount: names.length,
                      itemBuilder: (BuildContext context, int index) {
                        Icon(Icons.add);

                        return Container(

                            height: 50,
                            margin: EdgeInsets.all(2),
                            color:  Colors.black,
                            //child:},







                            child:InkWell(
                                onDoubleTap: (){ setState(() {
                                  names.remove('${names[index]}');
                                  removedata(names[index]);

                                  //prefs.setStringList(names);
                                  Icon(
                                      Icons.add,
                                      color: Colors.green,
                                      size: 30.0);
                                });
                                },

                                child: Center(
                                  child:InkWell(
                                      onTap: (){ setState(() {
                                        Navigator.push( context, MaterialPageRoute (builder: (Context) =>secondPage(woid: names[index])));
                                      });
                                      },

                                      child:
                                      Text('${names[index]} =>>>',
                                        style: TextStyle(fontSize: 18),

                                      )

                                  ),

                                )));
                      }
                  )
              )
            ]
        )
    );
  }
}

class secondPage extends StatefulWidget{
  //({Key?key, required this.woid}) : super(key:key);

  final String woid;



  secondPage({required this.woid,
    //required this.camera,
  });
  tss createState() => tss(woid: this.woid);
}
class tss extends State<secondPage> {
  final String woid;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  List<String> data2 =[];
  TextEditingController distance = TextEditingController();
  TextEditingController location = TextEditingController();


  tss({required this.woid,
    //required this.camera,
  });
  void loaddata1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      data2 =
      (prefs.getStringList('$woid') ?? '') as List<String> ;
    });
  }
//void removedata1() function to remove data after successful submit and update on shared preferences




  Future<void> getlocation() async {
    final position = await _geolocatorPlatform.getCurrentPosition();
    setState(() => location.text = position.toString(),
      //controller.text = "my initial value";
    );
  }

  @override
  void initState(){
    super.initState();
    loaddata1();
    getlocation ();
  }

  Future  saveImage( data2) async {
    var uri = Uri.parse('https://www.cyubic.com/honu.php');
    //server IP here

    for (int i = 0; i < data2.length; i++) {
      //for(int i=0; i < data2.length; i++){
      //data3;
      String data3 = data2[i];

      int length = (await data2.length);
      var request = MultipartRequest('POST', uri);
      //var multipartFile = new http.MultipartFile('image',stream,length,
      //filename: (imf.path));
      request.files.add(await http.MultipartFile.fromPath('image', data3));
      request.fields ['distance'] = distance.text;
      request.fields ['location'] = location.text;
      request.fields ['descrip'] = woid;
//files.addFile(multipartFile);


      // filename: data2 );

      //var stream = ByteStream(data2.openRead());
      //var length = await data2.length();
      //  var uri = Uri.parse('http://192.168.88.254/dashboard/honu.php');
      //
      //var multipartFile = await http.MultipartFile.fromPath('image',stream.toString(),
      // filename: data2 );
      //
//
// request.fields ['distance']=controllerDis.txt
      var response = await request.send();
      var responsed =await http.Response.fromStream(response);
      //final reponseData = json.decode(responsed.body);
      if (response.statusCode == 200) {
        setState(() {
          ///the main list should be deleted after this and go back home
          ;
        });

      }
      else
        print('try again');
    }
  }
  //void submit()async{
  //if (data2!=null){
  //for (var i=0;
  //i<data2.length; i++) {
  //ByteData byteData= (await data2[i]) as ByteData;
  //List<int> imagedata=byteData.buffer.asInt8List();

  //var MultipartFile multipartFile = MultipartFile.fromBytes(imagedata),
  //filename: data2[i].name;
  //contentType: MediaType('image', 'jpg'),);
  //}
  //}
  //}

  void showcam(BuildContext context) async{
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    //WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final camera = cameras.first;
    List<String> data1 = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>TakePictureScreen(
              // Pass the appropriate camera to the TakePictureScreen widget.
                camera: camera)
        ));
    SharedPreferences prefs= await SharedPreferences.getInstance();
    setState(() { //imageNames.add(_url);
      //data1.add(data2.toString());
      data2=data1;
      prefs.setStringList('$woid', data2 );

      //return data1;
      //print('$data1');
    });

  }


  Widget build(BuildContext context) {
    //String woid;


    return Scaffold (
      appBar: AppBar(
        //title:Text ('process wo'),
          title:Text('process wo $woid')
      ),

      body: Column(
          children: <Widget>[

      Padding(
      padding: EdgeInsets.all(20),
      child: TextField(
        //controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: '$woid',
        ),
      ),
    ),
    TextField(controller: location),
    TextField( controller: distance),
    ElevatedButton(
    child: Text('submit'),
    onPressed: () {
    //Navigator.of(context).pop();
    //data1();
    saveImage(data2)
    ;
    //Go back home and update page--send the text name.index and remove from homepage;
    () async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    setState(()  {
    //nameController.text= (prefs.getString('counter'))!;
    prefs.remove('$woid');});};





    },
    ),
    ElevatedButton(
    child: Text('Take picture'),
    onPressed: () {
    //Navigator.of(context).pop();
    //data1();
    showcam(context);//addItemToList();

    },
    ),

    Expanded(
    child:ListView.builder(

    //scrollDirection: Axis.horizontal,
    itemCount: data2.length,
    itemBuilder: (BuildContext context, int index) {
    //index=add;
    //List <String> null1= data2[index].toString() as List<String>
        ;
    return new GestureDetector(
    //
    child: Image.file(
    File(data2[index]),
    height: 100,
    width: 120,
    ),


    onTap:()=>{Navigator.push(context, MaterialPageRoute(builder: (context) =>DisplayPictureScreen(imagePath:data2)))}
    //TextField()



    );}))]));




    }}

// A screen that allows users to take a picture using a given camera.
    class TakePictureScreen extends StatefulWidget {
    final CameraDescription camera;


    TakePictureScreen({required this.camera,
    //required this.camera,
    });

    //final CameraDescription camera;

    @override
    TakePictureScreenState createState() => TakePictureScreenState();
    }

    class TakePictureScreenState extends State<TakePictureScreen> {
    late CameraController _controller;
    late Future<void> _initializeControllerFuture;
    //bool _isInited = false;
    late String _url;
    List<String> imageNames =[];
    List<String> TOTAL =[];
    final List<int> msgCount1 = <int>[1];
    late int add ;
    late int n1;





    @override
    void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
    // Get a specific camera from the list of available cameras.
    widget.camera,
    // Define the resolution to use.
    ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    }

    @override
    void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
    }





    @override
    Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: const Text('Take a picture')),
    // You must wait until the controller is initialized before displaying the
    // camera preview. Use a FutureBuilder to display a loading spinner until the
    // controller has finished initializing.
    body: FutureBuilder<void>(
    future: _initializeControllerFuture,
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
    // If the Future is complete, display the preview.

    return Column(
    children: <Widget>[
    Expanded(
    child: CameraPreview(_controller),
    ),

    Row(children: <Widget>[
    Expanded(
    child: IconButton(
    icon: Icon(Icons.add_circle_outlined),
    onPressed: () async {
    Navigator.pop(context, imageNames);

    ;
    })

    ),
    //child: Icon(Icons.add_circle_outlined)),


    Column(

    children: <Widget>[
    Container(
    height: 120,
    width: 120,
    child:ListView.builder(
    //scrollDirection: Axis.horizontal,
    itemCount: imageNames.length,
    itemBuilder: (BuildContext context, int index) {
    //index=add;
    return GestureDetector(
    onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context) =>DisplayPictureScreen(imagePath:imageNames )
    ));},
    onDoubleTap:(){ setState(() {
    imageNames.remove(imageNames[index]
    );});},
    child:_url != null
    ? Image.file(
    File(imageNames[index]),
    height: 120,
    width: 120,
    )
    //: CameraPreview(_controller),
        :Container()




    );}))],


    ),
    ],
    )]);





    } else {
    // Otherwise, display a loading indicator.
    return const Center(child: CircularProgressIndicator());
    }
    },
    ),





    floatingActionButton: FloatingActionButton(
    // Provide an onPressed callback.
    onPressed: () async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
    // Ensure that the camera is initialized.
    await _initializeControllerFuture;

    // Attempt to take a picture and get the file `image`
    // where it was saved.
    final image = await _controller.takePicture();

    setState(() {

    _url = image.path;
    //n1= add++;
    imageNames.add(_url);
    for(var i=0;i<imageNames.length;i++){
    TOTAL.add( _url);
    }
    //type.insert('fbi',0)
    msgCount1.insert(0, 0);
    // If the picture was taken, display it on a new screen.
//Text(imageNames.toString());
    });
    } catch (e) {
    // If an error occurs, log the error to the console.
    print(e);
    }
    },
    child: const Icon(Icons.camera_alt),
    ),

    );


    }
    }

// A widget that displays the picture taken by the user.
    class DisplayPictureScreen extends StatelessWidget {
    final List<String> imagePath;

    const DisplayPictureScreen({Key? key, required this.imagePath})
        : super(key: key);

    @override
    Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: const Text('Display the Picture')),
    // The image is stored as a file on the device. Use the `Image.file`
    // constructor with the given path to display the image.
    body: Column(
    children: <Widget>[

    Expanded(

    child: ListView.builder(

    padding: const EdgeInsets.all(8),
    itemCount: imagePath.length,
    itemBuilder: (BuildContext context, int index) {
    //Icon(Icons.add);

    return Container(

    child: Image.file(File(imagePath[index]))

    //child:
    );


    }))]));
    }
    }
//© Copyright Ewoenam Blebu-Honu
