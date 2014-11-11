<?php
/**
 * Created by IntelliJ IDEA.
 *
 * This program will parse input CSV file and depending of the Decision column will mark the documents as
 * complete, duplicate or deleted. To do that it will connect directly to couchDb using the PHP-on-Couch-master
 * library downloaded from GitHub. For more information on this library go here:
 *
 * http://www.ibm.com/developerworks/library/os-php-couchdb/#resources
 *
 *
 * User: vbakalov
 * Date: 10/31/2014
 * Time: 10:45 AM
 */

/****** LOCAL HOST *****************/
//$couch_dsn = "http://localhost:5984/";

/****** PRODUCTION **************/
//$couch_dsn = "http://107.20.181.244:5984/";

/****** DEVELOPMENT *****************/
$couch_dsn = "http://54.204.20.212:5984/";

$couch_db = "coconut";

require_once "./lib/couch.php";
require_once "./lib/couchClient.php";
require_once "./lib/couchDocument.php";

// open client connection with couchDB
$client = new couchClient($couch_dsn,$couch_db);

// test update couch doc
//testUpdateCouchDoc($client);

$activitiesCSVFileName = 'input/SantoDomingoActivitiesDEV.csv';
$inputCSVFileName = 'output/testAttendanceDEV.csv';
$outputCSVFileName = 'output/testAttendanceDEV_PROCESSED.csv';



$outputCSVAry = array();

$numProcessed = 0;

echo "START PROCESSING.....";

// set timezone to user timezone
date_default_timezone_set("EST");

//$uuid = getUUID();

phpinfo();

/*
$activitiesAry = loadActivities($activitiesCSVFileName);

$inputCSVAry = loadCSV($inputCSVFileName);

if ($inputCSVAry != null) {
    $outputCSVAry= updateDocs($inputCSVAry);

    print2file($outputCSVFileName, $outputCSVAry);
}

echo $numProcessed."DATA SUCCESSFULLY PROCESSED....."."/n";
*/

/**
 * Load the activities CSV file into array of records.
 *
 * [0][[ACTIVITY_NAME][PROVIDER_ID][ACTIVITY_ID]
 *
 * @param $inputCSVFileName
 */
function loadActivities($activitiesCSVFileName){
    $retAry = array();
    $cntLn = 0;
    $i = 0;

    // load PhenX data dictionary
    $file_handle = fopen($activitiesCSVFileName, "r");

    if ($file_handle == false)
        return null;

    while (!feof($file_handle) ) {
        $lineAry = array();

        $lineOfText = fgetcsv($file_handle, 2048);

        // skip the header
        if ($cntLn === 0){
            $cntLn++;
            continue;
        }
        // first column is the protocol id, second is the protocol name
        $lineAry['ACTIVITY_NAME'] = $lineOfText[0];
        $lineAry['PROVIDER_ID'] = $lineOfText[2];
        $lineAry['ACTIVITY_ID'] = $lineOfText[3];

        $retAry[$i++] = $lineAry;
    }

    fclose($file_handle);

    return $retAry;

}


/**
 * Load the input CSV file into array of records.
 *
 * @param $inputCSVFileName
 */
function loadCSV($inputCSVFileName){
    $retAry = array();
    $cntLn = 0;
    $i = 0;

    // load PhenX data dictionary
    $file_handle = fopen($inputCSVFileName, "r");

    if ($file_handle == false)
        return null;

    while (!feof($file_handle) ) {
        $lineAry = array();

        $lineOfText = fgetcsv($file_handle, 2048);

        // skip the header
        if ($cntLn === 0){
            $cntLn++;
            continue;
        }


        // load line
        $lineAry['USER_NAME'] = $lineOfText[0];
        $lineAry['REGISTRATION DATE'] = $lineOfText[1];
        $lineAry['NOMBRE'] = $lineOfText[7];
        $lineAry['APELLIDO'] = $lineOfText[0];
        $lineAry['NOMBRE_COMPLETADO'] = $lineOfText[1];
        $lineAry['UUID'] = $lineOfText[7];
        $lineAry['APODO'] = $lineOfText[0];
        $lineAry['CALLE_Y_NUMERO'] = $lineOfText[1];
        $lineAry['PROVINCIA'] = $lineOfText[7];
        $lineAry['MUNICIPIO'] = $lineOfText[0];
        $lineAry['BARRIO'] = $lineOfText[1];
        $lineAry['ES_COLATERAL'] = $lineOfText[7];
        $lineAry['DIA'] = $lineOfText[0];
        $lineAry['MES'] = $lineOfText[1];
        $lineAry['ANO'] = $lineOfText[7];
        $lineAry['SEXO'] = $lineOfText[0];
        $lineAry['CELULAR'] = $lineOfText[1];
        $lineAry['CASA'] = $lineOfText[7];
        $lineAry['CORREO_ELECTONICO'] = $lineOfText[0];
        $lineAry['NOMBRE_DE_ACTIVIDAD'] = $lineOfText[1];
        $lineAry['TIPO'] = $lineOfText[7];
        $lineAry['ADMINISTRATOR_DE_CASSO'] = $lineOfText[0];
        $lineAry['PROGRAMA'] = $lineOfText[1];
        $lineAry['FECHA'] = $lineOfText[7];
        $lineAry['DESCRIPTION'] = $lineOfText[7];

        $retAry[$i++] = $lineAry;
    }

    fclose($file_handle);

    return $retAry;

}

/**
 * Iterate the array and create missing participants.
 *
 * @param $dataAry
 */
function createParticipants($dataAry){
    global $client,  $numProcessed;
    $outputCSVAry = array();
    $outputCSVAry['header'] = '_id,' . 'uuid' . ',' . 'status';

    foreach($dataAry as $valAry) {
        //if uuid exist no ned to create one
        if ($valAry['UUID'] != "")
            continue;

        $createOK = createParticipant($client, $valAry);

        if ($createOK) {
            echo $numProcessed." processed\n";
            $numProcessed++;

        }

    }
    return $outputCSVAry;
}



/**
 * Date need to  be in format 2014-10-23T16:25:16-04:00.
 */
function getCouchCurrentDate(){
  $retDateStr = "";

  // get current date
    $dt = new DateTime();
    $s1 = $dt->format('Y-m-d H:i:s');
    $s2 = substr($s1, 0, 10);
    $s3 = substr($s1, 11);

    $retDateStr = $s2.'T'.$s3.'-04:00';

    return $retDateStr;
}

/*
 * Retrieves UUID from coconut URL.
 *
 */
function getUUID(){

  //  $body = file_get_contents('http://localhost:5984/coconut/_design/coconut/getUUID.html');
    //echo $body;

    /*$obj = json_decode($json);
    echo $obj->access_token;*/

    $req_url = 'http://localhost:5984/coconut/_design/coconut/_view/resultsByQuestionAndCompleteWithCollateral?startkey=%22Participant%20Registration-es%3Atrue%3Az%22&endkey=%22Participant%20Registration-es%3Atrue%22&descending=true&include_docs=false';

    //TBD Uncomment when deploying to prod, the $base_url is not write when deploying on Windows because it has /drupal in the link
    //$req_url = $base_url.':5984/coconut/_design/coconut/_view/resultsByQuestionAndComplete?startkey=%22Participant%20Registration-es%3Atrue%3Az%22&endkey=%22Participant%20Registration-es%3Atrue%22&descending=true&include_docs=false';




    $response = http_get("http://localhost:5984/coconut/_design/coconut/getUUID.html", array("timeout"=>1), $info);

    //$response = http_get_request_body_stream("http://localhost:5984/coconut/_design/coconut/getUUID.html");
// prepare the request options




   //print_r($info);
}
/**
 *
 * Create participant.
 *
 * @param $client
 * @param $newVals
 *
 */
function createParticipant($client, $values){
    $status = true;

    try {
        $doc = new stdClass();
        $doc->_id = "in_the_meantime";
        $doc->lastModifiedAt = getCouchCurrentDate();

        // create document
        $response = $client->storeDoc($doc);

    } catch (Exception $e) {
        echo "Error: ".$e->getMessage()." (errcode=".$e->getCode().")\n";
        $status = false;
    }

    return $status;
}


/**
 *
 * Updates the document with the new values.
 *
 * @param $client
 * @param $newVals
 *
 */
function updateCouchDoc($client, $values){
    $status = true;

    try {
        $doc = $client->getDoc($values['_id']);

        if (array_key_exists('Completado', $values))
            $doc->Completado = "true";
        else
            $doc->question = $values['question'];

        $doc->lastModifiedAt = getCouchCurrentDate();

        $response = $client->storeDoc($doc);
    } catch (Exception $e) {
        if ( $e->code() == 404 ) {
            echo "Document not found\n";
        } else {
            echo "Error: ".$e->getMessage()." (errcode=".$e->getCode().")\n";
        }
        $status = false;
    }

    return $status;
}

function print2file($outputCSVFileName, $outputCSV){
    $file = fopen($outputCSVFileName,"w");
    foreach ($outputCSV as  $line) {
        fwrite($file, $line);
        fwrite($file, "\r\n");
    }
    fclose($file);
}



?>