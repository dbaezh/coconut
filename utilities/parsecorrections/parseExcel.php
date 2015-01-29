<?php
/**
 * Created by IntelliJ IDEA.
 * User: vbakalov
 * Date: 6/26/2014
 * Time: 3:18 PM
 */

/** Include path **/
set_include_path(get_include_path() . PATH_SEPARATOR . 'Classes/');

/** PHPExcel_IOFactory */
include 'PHPExcel/IOFactory.php';




/*****************PARSED INPUT FILES******************************/
$inputFileName = 'inputdata/Accion_Callejera.xlsx';
//$inputFileName = 'inputdata/Caminante.xlsx';
//$inputFileName = 'inputdata/Casa_Abierta.xlsx';
//$inputFileName = 'inputdata/CEFASA.xlsx';
//$inputFileName = 'inputdata/Ceprosh.xlsx';
//$inputFileName = 'inputdata/Children.xlsx';
//$inputFileName = 'inputdata/Profamilia.xlsx';
//$inputFileName = 'inputdata/Grupo_Clara.xlsx';


$UUID_COL_NUM = 1; // this should indicate the column number +1; for some files the uuid is in column 1 for others
                      // in column 2

//echo 'Loading file ',pathinfo($inputFileName,PATHINFO_BASENAME),' using IOFactory to identify the format<br />';
try {
    $objPHPExcel = PHPExcel_IOFactory::load($inputFileName);
} catch(Exception $e) {
    die('Error loading file "'.pathinfo($inputFileName,PATHINFO_BASENAME).'": '.$e->getMessage());
}





$correctionsAry =  dataToJSONArry($objPHPExcel->getActiveSheet(),  'A1', null, true, true, false, $UUID_COL_NUM);

print2file($correctionsAry);

exit();
//print corrections to a file
//print2file($correctionsAry);

/**
 * Extended by Vessie to print corrections, e.g. the green filled values only as json object.
 *
 * Create corrections array from a range of cells in format [uuid]={{"9Dóndenaciste":"República Dominicana"}} //corrections in json key value pair
 *
 * @param	string	$pRange					Range of cells (i.e. "A1:B10"), or just one cell (i.e. "A1")
 * @param	mixed	$nullValue				Value returned in the array entry if a cell doesn't exist
 * @param	boolean	$calculateFormulas		Should formulas be calculated?
 * @param	boolean	$formatData				Should formatting be applied to cell values?
 * @param	boolean	$returnCellRef			False - Return a simple array of rows and columns indexed by number counting from zero
 *											True - Return rows and columns indexed by their actual row and column IDs
 *
 * @return retCorrectionsAry in format [uuid]={{"9Dóndenaciste":"República Dominicana"}} //corrections in json key value pair
 */
function dataToJSONArry($sheet, $pRange = 'A1', $nullValue = null, $calculateFormulas = true, $formatData = true, $returnCellRef = false, $uuidColNum) {


    // Returnvalue
    $returnValue = array();
    // store header values, index is the name of the column , e.g. AA, AB
    $headers = array();
    $retCorrectionsAry = array(); // index is the uuid and value is the json object for corrections, e.g. {"provider_name":"xyz"}

    //	Identify the range that we need to extract from the worksheet
    list($rangeStart, $rangeEnd) = PHPExcel_Cell::rangeBoundaries($pRange);
    $minCol = PHPExcel_Cell::stringFromColumnIndex($rangeStart[0] -1);
    $minRow = $rangeStart[1];

    // Garbage collect...
    $sheet->garbageCollect();

    //	Identify the range that we need to extract from the worksheet
    $maxCol = $sheet->getHighestColumn();
    $maxRow = $sheet->getHighestRow();

    //$maxCol = PHPExcel_Cell::stringFromColumnIndex($rangeEnd[0] -1);
    //$maxRow = $rangeEnd[1];

    $maxCol++;



    // Loop through rows
    $r = -1;
    for ($row = $minRow; $row <= $maxRow; ++$row) {
        $rRef = ($returnCellRef) ? $row : ++$r;
        $c = -1;

        $correctionsAryForCell = array();

        // Loop through columns in the current row
        for ($col = $minCol; $col != $maxCol; ++$col) {
            $cRef = ($returnCellRef) ? $col : ++$c;

            //	Using getCell() will create a new cell if it doesn't already exist. We don't want that to happen
            //		so we test and retrieve directly against _cellCollection
            if ($sheet->getCellCacheController()->isDataSet($col.$row)) {
                // Cell exists
                $cell = $sheet->getCellCacheController()->getCacheData($col.$row);
                if ($cell->getValue() !== null) {
                    if ($cell->getValue() instanceof PHPExcel_RichText) {
                        $returnValue[$rRef][$cRef] = $cell->getValue()->getPlainText();
                    } else {
                        if ($calculateFormulas) {
                            $returnValue[$rRef][$cRef] = $cell->getCalculatedValue();
                        } else {
                            $returnValue[$rRef][$cRef] = $cell->getValue();
                        }
                    }

                    if ($formatData) {
                        $style = $sheet->getParent()->getCellXfByIndex($cell->getXfIndex());
                        $returnValue[$rRef][$cRef] = PHPExcel_Style_NumberFormat::toFormattedString($returnValue[$rRef][$cRef], $style->getNumberFormat()->getFormatCode());
                    }
                } else {
                    // Cell holds a NULL
                    $returnValue[$rRef][$cRef] = $nullValue;
                }

                if ($row == 1){
                    //save the header value
                    $headers[$col] = $returnValue[$rRef][$cRef];
                }else{


                    $fill = $sheet->getParent()->getCellXfByIndex($cell->getXfIndex())->getFill();
                    $fillType = $fill->getFillType();
                    $startColor = "";
                    $endColor = "";

                    if ($fillType != "none") {
                        $startColor = $fill->getStartColor()->getARGB();
                        $endColor = $fill->getEndColor()->getARGB();
                    }

                    // green fill
                    if ($fillType == "solid" && $startColor == "FF00FF00" && $endColor == "FFFFFFFF"){
                        echo 'found record in row:'.$row." and column ".$col."\n";
                        $colName = $headers[$col];
                        $correctionsAryForCell[$colName] = $returnValue[$rRef][$cRef];
                    }
                }
            } else {
                // Cell doesn't exist
                $returnValue[$rRef][$cRef] = $nullValue;
            }

        }

        //save the corrections values for the uuid if any
        if (!empty($correctionsAryForCell)){
            $uuidVal = $returnValue[$rRef][$uuidColNum];
            $retCorrectionsAry[$uuidVal] = json_encode($correctionsAryForCell, JSON_UNESCAPED_UNICODE);
        }
    }

    // Return corrections array
    return $retCorrectionsAry;
}


function print2file($correctionsAry){
    $file = fopen("outputdata/Accion_Callejera.txt","w");
    foreach ($correctionsAry as $uuid => $value) {
        //corrections['002BADVDP'] = '{"pr
        $line = "corrections['".$uuid."']='".$value."';\n";
        echo fwrite($file, $line);
    }
    fclose($file);
}

?>