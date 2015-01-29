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


// $couch_dsn = "http://localhost:5984/";

$couch_dsn = "http://107.20.181.244:5984/";
$couch_db = "coconut";

require_once "./lib/couch.php";
require_once "./lib/couchClient.php";
require_once "./lib/couchDocument.php";

// open client connection with couchDB
$client = new couchClient($couch_dsn,$couch_db);

// test update couch doc
//testUpdateCouchDoc($client);

$inputCSVFileName = 'input/missingRegFields_10-23-2014.csv';

$outputCSVFileName = 'output/missingRegFields_10-23-2014_PROCESSED.csv';

$outputCSVAry = array();

$numProcessed = 0;

echo "START PROCESSING.....";

// set timezone to user timezone
date_default_timezone_set("EST");

$inputCSVAry = loadCSV($inputCSVFileName);

if ($inputCSVAry != null) {
    $outputCSVAry= updateDocs($inputCSVAry);

    print2file($outputCSVFileName, $outputCSVAry);
}

echo $numProcessed."DATA SUCCESSFULLY PROCESSED....."."/n";

/**
 * Load the input CSV file into array of records. We need just the  3 columns, the
 * "Decision", the _id and the uuid (last for the output file).
 *
 * [0][[Decision][_id]]
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
        // first column is the protocol id, second is the protocol name
        $lineAry['DECISION'] = $lineOfText[0];
        $lineAry['_id'] = $lineOfText[1];
        $lineAry['uuid'] = $lineOfText[7];

        $retAry[$i++] = $lineAry;
    }

    fclose($file_handle);

    return $retAry;

}

/**
 * Iterate the array and update depending of the "Decision" value.
 *
 * @param $dataAry
 */
function updateDocs($dataAry){
    global $client,  $numProcessed;
    $outputCSVAry = array();
    $outputCSVAry['header'] = '_id,' . 'uuid' . ',' . 'status';

    foreach($dataAry as $valAry) {
        $values2Update = array();
        $status = processDecision($valAry['DECISION']);

        if ($status == ""){
            echo "Coudn't mke decision about doc uuid:".$valAry['uuid']."\n";
            $resultCSVLine = $valAry['_id'] . ',' . $valAry['uuid'] . ',' . 'NOT PROCESSED';
            $outputCSVAry[$valAry['uuid']] = $resultCSVLine;
            continue;
        }


        if ($status == "Complete") {
            $values2Update['Completado'] = "true";
        } else {
            $values2Update['question'] = $status;
        }

        $values2Update['_id'] = $valAry['_id'];

        if ($valAry['_id'] == "" || $valAry['_id'] == null)
            break;

        $updateOK = updateCouchDoc($client, $values2Update);


        if ($updateOK) {
            echo $numProcessed." processed\n";
            $numProcessed++;
            if ($status == "Complete")
                $resultCSVLine = $valAry['_id'] . ',' . $valAry['uuid'] . ',' . 'COMPLETED';
            else
                $resultCSVLine = $valAry['_id'] . ',' . $valAry['uuid'] . ',' . $status;

            $outputCSVAry[$valAry['uuid']] = $resultCSVLine;
        }

    }
    return $outputCSVAry;
}

/**
 * Depending on decision returns different question type.
 *
 *
 * @param $decision
 * @return string
 */
function processDecision($decision){
    $retQuestion = "";

    // first convert to lower case
    $decisionLower = strtolower($decision);

    // check for "duplicate"
    $pos = strrpos($decisionLower, 'duplicated');
    if ($pos !== false){
        return "Participant Registration-es-DUPLICATE-BY-PHP";
    }


    // check for "eliminate"
    $pos = stripos($decisionLower, 'eliminate');
    if ($pos !== false){
        return "Participant Registration-es-ELIMINATE-BY-PHP";
    }


    // check for "complete"
    $pos = stripos($decisionLower, 'complete');
    if ($pos !== false){
        return "Complete";
    }

    // check for "complete"
    $pos = stripos($decisionLower, 'to visualize');
    if ($pos !== false){
        return "Complete";
    }

    return "";
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