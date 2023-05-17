*-----------------------------------------------------------------------------
* <Rating>-39</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VP.UTIL.LOG(FILE.NAME, FILE.PATH, LOG.MSG)
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 04.30.2013
* Description  : Utilitary routine for generating log file
* Type         : Util Routine
* Attached to  : -
* Dependencies : NA
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
*-----------------------------------------------------------------------------

* <region name="INSERTS">

$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_F.REDO.VISION.PLUS.PARAM

* </region>

  GOSUB INIT
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************

  RETURN

***********************
* Open Files
OPEN.FILES:
***********************

  RETURN

***********************
* Main Process
PROCESS:
***********************
* Open File Directory
  OPEN FILE.PATH ELSE
 
    CRT 'ERROR IN OPENING LOG FILE PATH!'
    RETURN
  END

* Open File
  FILE.PATH := '/' : FILE.NAME
  OPENSEQ FILE.PATH TO LOG.FILE THEN
    CRT 'LOG FILE ALREADY EXISTS ' : FILE.PATH
    WEOFSEQ LOG.FILE
  END

* Write File
  LOOP
    REMOVE Y.LINE FROM LOG.MSG SETTING Y.LINE.POS
  WHILE Y.LINE:Y.LINE.POS
    WRITESEQ Y.LINE TO LOG.FILE ELSE
      CRT 'UNABLE TO WRITE IN LOG FILE ' : FILE.PATH
      BREAK
    END
  REPEAT

* Close File
  CLOSESEQ LOG.FILE

  RETURN

* </region>

END
