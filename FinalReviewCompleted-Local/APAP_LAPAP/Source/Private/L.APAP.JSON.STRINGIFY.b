$PACKAGE APAP.LAPAP
SUBROUTINE  L.APAP.JSON.STRINGIFY(JSON.IN, JSON.OUT)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - Include to Insert , CHAR to CHARX and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

*STRINGIFY subroutine.
*----------------------------------------------------------------------------------------------------------------------------------------------------
    JSON.OUT = JSON.IN
*TAB
    CHANGE CHARX(09) TO ''  IN JSON.OUT
*LINE FEED
    CHANGE CHARX(10) TO ''  IN JSON.OUT
*CARRIAGE RETURN
    CHANGE CHARX(13) TO ''  IN JSON.OUT
*REMOVE EXTRA SPACES
    JSON.OUT = TRIM(JSON.OUT, ' ','R')
*DELETE SPACES
    CHANGE '" : "' TO '":"'  IN JSON.OUT
    CHANGE '" , "' TO '","'  IN JSON.OUT

    CHANGE '": "' TO '":"'  IN JSON.OUT
    CHANGE '", "' TO '","'  IN JSON.OUT

    CHANGE '" :"' TO '":"'  IN JSON.OUT
    CHANGE '" ,"' TO '","'  IN JSON.OUT

    CHANGE '" : {' TO '":{'  IN JSON.OUT
    CHANGE '" : [' TO '":['  IN JSON.OUT

    CHANGE '": {' TO '":{'  IN JSON.OUT
    CHANGE '": [' TO '":['  IN JSON.OUT

    CHANGE '" :{' TO '":{'  IN JSON.OUT
    CHANGE '" :[' TO '":['  IN JSON.OUT

    CHANGE '} , "' TO '},"'  IN JSON.OUT
    CHANGE '] , "' TO '],"'  IN JSON.OUT

    CHANGE '}, "' TO '},"'  IN JSON.OUT
    CHANGE '], "' TO '],"'  IN JSON.OUT

    CHANGE '} ,"' TO '},"'  IN JSON.OUT
    CHANGE '] ,"' TO '],"'  IN JSON.OUT

    CHANGE '{ ""' TO '{""'   IN JSON.OUT
    CHANGE '" }' TO '"}""'   IN JSON.OUT

    CHANGE '[ ""' TO '[""'   IN JSON.OUT
    CHANGE '" "]' TO '"]""'   IN JSON.OUT
RETURN
END
