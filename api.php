<?php
require_once 'vendor/autoload.php';
use \Firebase\JWT\JWT;

$secretKey = 'your-secret-key';  // Cambia esto por una clave secreta única y segura

if (isset($_REQUEST["dni"]) && isset($_REQUEST["nombre"]) && isset($_REQUEST["correo"])) {
    $dni = isset($_REQUEST["dni"]) ? trim($_REQUEST["dni"]) : false;
    $nombre = isset($_REQUEST["nombre"]) ? trim($_REQUEST["nombre"]) : false;
    $correo = isset($_REQUEST["correo"]) ? trim($_REQUEST["correo"]) : false;

    // Lista de administradores (ejemplo de dni admin)
    $ad = array("02416492", "42729761", "02445278", "02045892");

    // Conexión a la base de datos
    @$db = new mysqli("localhost", "root", "", "metodica_maestro");
    if ($db->connect_errno != null) {
        $a = array('status' => 0, 'message' => 'Error en base de datos: ' . $db->connect_error);
        echo json_encode($a);
        exit();
    }

    // Verificación si el DNI es de un administrador
    if (in_array($dni, $ad)) {
        // Aquí puedes personalizar lo que desees incluir en el payload del JWT
        $payload = array(
            "dni" => $dni,
            "nombre" => $nombre,
            "correo" => $correo,
            "iat" => time() // Hora de emisión
            // No agregamos el campo "exp" para que el token no expire nunca
        );

        // Generar el token JWT
        $jwt = JWT::encode($payload, $secretKey,'HS256');

        // Responder con el token
        $a = array('status' => 1, 'message' => 'Login exitoso', 'token' => $jwt);
        echo json_encode($a); // Respuesta con el token
    } else {
        $a = array('status' => 0, 'message' => 'No eres un administrador.');
        echo json_encode($a); // Respuesta de error
    }
} else {
    $a = array('status' => 0, 'message' => 'Faltan parámetros (dni, nombre, correo)');
    echo json_encode($a);
}

if(isset($_REQUEST["dni"])){
	$dni = isset($_REQUEST["dni"]) ? trim($_REQUEST["dni"]) : false;
	$nombre = isset($_REQUEST["nombre"]) ? trim($_REQUEST["nombre"]) : false;
	$correo = isset($_REQUEST["correo"]) ? trim($_REQUEST["correo"]) : false;
	$fecha = isset($_REQUEST["fecha"]) ? trim($_REQUEST["fecha"]) : false;
	$hora = isset($_REQUEST["hora"]) ? trim($_REQUEST["hora"]) : false;
	$qr = isset($_REQUEST["respuestaQr"]) ? trim($_REQUEST["respuestaQr"]) : false;
	$flag = isset($_REQUEST["flag"]) ? trim($_REQUEST["flag"]) : 0;

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

	// @$db = new mysqli("localhost","metodica_maestro","Yachay00","metodica_maestro");
	@$db = new mysqli("localhost","root","","metodica_maestro");
	if ($db->connect_errno != null) {
		$a=array('status'=>0,'message'=>'Error '.$db->connect_errno.' en base de datos: '.$db->connect_error);
		echo json_encode($a);
		exit();
	}

	if (in_array($dni, $ad) && $flag!=5) { // solo para administradores
	        
	        date_default_timezone_set('America/Lima');
            $fecha=date('Y-m-d', time());
            $fecha1=date('d/m/Y');
            $hora=date('G:i:s', time());
            $hora1=date('G:i',time());
	        $ipx = $_SERVER["REMOTE_ADDR"];
	        
	        $r = $db->query("SELECT * FROM maestro_data LEFT JOIN maestro_asistencia ON maestro_data.le = maestro_asistencia.dni WHERE maestro_data.le=$qr");
			$m = $r->fetch_assoc();
			$r->free();
			if($m){

                if(empty($m["dni"])){
			        $r = $db->query("INSERT INTO maestro_asistencia(fecha, hora, porx, dni) VALUES ('$fecha', '$hora', '$dni', '$qr')");
			        $a=array('status'=>1,'message'=>'>>> CODIGO - '.mysqli_insert_id($db).' <<<','dni'=>$qr,'nombre'=>utf8_decode($m["nombres"]),'fecha'=>$fecha1,'hora'=>$hora1);
				echo json_encode($a);
			    }else{
			         $a=array('status'=>3,'message'=>'>>>CODIGO -  '.$m["id"].' - '.$m["le"].' - '.utf8_encode($m["nombres"]).'-'.' Registrado por:'.$m["dni"].' a horas: '.$m["hora"]);
			         echo json_encode($a);
			    }


			}else{
				$a=array('status'=>5,'message'=>'El DNI '.$qr.' no figura en nuestra base de datos comunicarse con 951419161');
				echo json_encode($a);
			}
	}else{ // para cualquier empleado
		if($flag==5){ // si consulta de un Ticket
			$r = $db->query("SELECT * FROM maestro_data INNER JOIN maestro_asistencia ON maestro_data.le = maestro_asistencia.dni WHERE maestro_asistencia.id=$qr");
			$m = $r->fetch_assoc();
			$r->free();
			if($m){
				$a=array('status'=>5,'message'=>" PREMIADO - ".$m["id"]." >>>".$m["le"]."<<< ".utf8_encode($m["nombres"])." ".$m["servidor"]." ".utf8_encode($m["centro"]));
				
				$r = $db->query("UPDATE maestro_asistencia SET premiado='SI' WHERE maestro_asistencia.id=$qr");
			}else{
				$a=array('status'=>3,'message'=>'El Codigo '.$qr.' no esta registrado en nuestra DB1');
			}
			echo json_encode($a);
		}
	}	

}       
?>