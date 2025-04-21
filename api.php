<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");
$method = $_SERVER['REQUEST_METHOD'];
require_once 'vendor/autoload.php';
use \Firebase\JWT\JWT;

$secretKey = '3st0y-S3gurO-4Qu1';
$rawInput = file_get_contents("php://input");
$data = json_decode($rawInput, true);

// Verificar que los parámetros requeridos existen
if (isset($data["nombre"]) && isset($data["correo"]) && isset($data["dni"])) {
    $nombre = $data["nombre"];
    $correo = $data["correo"];
    $dni = $data["dni"];

    // Lista de administradores (ejemplo de dni admin)
    $ad = array(
		"02416492", 
		"42729761",
		"02445278",
		"02045892",
		"02430689",
		"02045304",
		"02412446",
		"02145647",
		"02173801",
		"02435472",
		"43989847",
		"88888888",
		"99999999"
	);

    // Conexión a la base de datos
    $db = @new mysqli("localhost", "root", "", "metodica_maestro");
    if ($db->connect_errno) {
        echo json_encode([
            'status' => 0,
            'message' => 'Error en base de datos: ' . $db->connect_error
        ]);
        exit();
    }

    // Verificar si el DNI es de un administrador
    if (in_array($dni, $ad)) {
        // Construir payload del token
        $payload = [
            "dni" => $dni,
            "nombre" => $nombre,
            "correo" => $correo,
            "iat" => time() // Tiempo de emisión
            // No se incluye "exp" para token sin expiración
        ];

        // Generar JWT
        $jwt = JWT::encode($payload, $secretKey, 'HS256');

        // Responder con el token
        echo json_encode([
            'status' => 1,
            'message' => 'Login exitoso',
            'token' => $jwt
        ]);
    } else {
        echo json_encode([
            'status' => 0,
            'message' => 'No eres un administrador.'
        ]);
    }
} else {
    echo json_encode([
        'status' => 0,
        'message' => 'Faltan parámetros (dni, nombre, correo)'
    ]);
}

if ($method === 'POST') {
    // Leer headers
    $headers = getallheaders();
    $token = isset($headers['Authorization']) ? $headers['Authorization'] : null;

    // Validar token
    if ($token !== $secretKey) {
        http_response_code(401);
        echo json_encode(["error" => "Token inválido"]);
        exit;
    }

    // Leer datos del cuerpo (JSON)
    $input = json_decode(file_get_contents("php://input"), true);

    // Validar campos necesarios
    if (
        isset($input['nombre'], $input['latitud'], $input['longitud'], $input['fecha_inicio'], $input['fecha_fin'])
    ) {
        // Conexión a BD
        $conn = new mysqli("localhost", "root", "", "metodica_maestro");

        if ($conn->connect_error) {
            echo json_encode(["error" => "Error al conectar a la BD"]);
            exit;
        }

        $nombre = $conn->real_escape_string($input['nombre']);
        $latitud = floatval($input['latitud']);
        $longitud = floatval($input['longitud']);
        $fecha_inicio = $conn->real_escape_string($input['fecha_inicio']);
        $fecha_fin = $conn->real_escape_string($input['fecha_fin']);
        $imagen = isset($input['imagen']) ? $conn->real_escape_string($input['imagen']) : null;

        $sql = "INSERT INTO maestro_evento (nombre, latitud, longitud, fecha_inicio, fecha_fin, imagen) 
                VALUES ('$nombre', $latitud, $longitud, '$fecha_inicio', '$fecha_fin', " . ($imagen ? "'$imagen'" : "NULL") . ")";

        if ($conn->query($sql) === TRUE) {
            echo json_encode(["success" => true, "evento_id" => $conn->insert_id]);
        } else {
            echo json_encode(["error" => "No se pudo insertar el evento", "detalle" => $conn->error]);
        }

        $conn->close();
    } else {
        echo json_encode(["error" => "Faltan campos obligatorios"]);
    }
} else {
    echo json_encode(["error" => "Método no permitido"]);
}

// if(isset($_REQUEST["dni"])){
// 	$dni = isset($_REQUEST["dni"]) ? trim($_REQUEST["dni"]) : false;
// 	$nombre = isset($_REQUEST["nombre"]) ? trim($_REQUEST["nombre"]) : false;
// 	$correo = isset($_REQUEST["correo"]) ? trim($_REQUEST["correo"]) : false;
// 	$fecha = isset($_REQUEST["fecha"]) ? trim($_REQUEST["fecha"]) : false;
// 	$hora = isset($_REQUEST["hora"]) ? trim($_REQUEST["hora"]) : false;
// 	$qr = isset($_REQUEST["respuestaQr"]) ? trim($_REQUEST["respuestaQr"]) : false;
// 	$flag = isset($_REQUEST["flag"]) ? trim($_REQUEST["flag"]) : 0;

// 	$ad = array(
// 		"02416492", 
// 		"42729761",
// 		"02445278",
// 		"02045892",
// 		"02430689",
// 		"02045304",
// 		"02412446",
// 		"02145647",
// 		"02173801",
// 		"02435472",
// 		"43989847",
// 		"88888888",
// 		"99999999"
// 	);

// 	// @$db = new mysqli("localhost","metodica_maestro","Yachay00","metodica_maestro");
// 	@$db = new mysqli("localhost","root","","metodica_maestro");
// 	if ($db->connect_errno != null) {
// 		$a=array('status'=>0,'message'=>'Error '.$db->connect_errno.' en base de datos: '.$db->connect_error);
// 		echo json_encode($a);
// 		exit();
// 	}

// 	if (in_array($dni, $ad) && $flag!=5) { // solo para administradores
	        
// 	        date_default_timezone_set('America/Lima');
//             $fecha=date('Y-m-d', time());
//             $fecha1=date('d/m/Y');
//             $hora=date('G:i:s', time());
//             $hora1=date('G:i',time());
// 	        $ipx = $_SERVER["REMOTE_ADDR"];
	        
// 	        $r = $db->query("SELECT * FROM maestro_data LEFT JOIN maestro_asistencia ON maestro_data.le = maestro_asistencia.dni WHERE maestro_data.le=$qr");
// 			$m = $r->fetch_assoc();
// 			$r->free();
// 			if($m){

//                 if(empty($m["dni"])){
// 			        $r = $db->query("INSERT INTO maestro_asistencia(fecha, hora, porx, dni) VALUES ('$fecha', '$hora', '$dni', '$qr')");
// 			        $a=array('status'=>1,'message'=>'>>> CODIGO - '.mysqli_insert_id($db).' <<<','dni'=>$qr,'nombre'=>utf8_decode($m["nombres"]),'fecha'=>$fecha1,'hora'=>$hora1);
// 				echo json_encode($a);
// 			    }else{
// 			         $a=array('status'=>3,'message'=>'>>>CODIGO -  '.$m["id"].' - '.$m["le"].' - '.utf8_encode($m["nombres"]).'-'.' Registrado por:'.$m["dni"].' a horas: '.$m["hora"]);
// 			         echo json_encode($a);
// 			    }


// 			}else{
// 				$a=array('status'=>5,'message'=>'El DNI '.$qr.' no figura en nuestra base de datos comunicarse con 951419161');
// 				echo json_encode($a);
// 			}
// 	}else{ // para cualquier empleado
// 		if($flag==5){ // si consulta de un Ticket
// 			$r = $db->query("SELECT * FROM maestro_data INNER JOIN maestro_asistencia ON maestro_data.le = maestro_asistencia.dni WHERE maestro_asistencia.id=$qr");
// 			$m = $r->fetch_assoc();
// 			$r->free();
// 			if($m){
// 				$a=array('status'=>5,'message'=>" PREMIADO - ".$m["id"]." >>>".$m["le"]."<<< ".utf8_encode($m["nombres"])." ".$m["servidor"]." ".utf8_encode($m["centro"]));
				
// 				$r = $db->query("UPDATE maestro_asistencia SET premiado='SI' WHERE maestro_asistencia.id=$qr");
// 			}else{
// 				$a=array('status'=>3,'message'=>'El Codigo '.$qr.' no esta registrado en nuestra DB1');
// 			}
// 			echo json_encode($a);
// 		}
// 	}	

// }       
?>