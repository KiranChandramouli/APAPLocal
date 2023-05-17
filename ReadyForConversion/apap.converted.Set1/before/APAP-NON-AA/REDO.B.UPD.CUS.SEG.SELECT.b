*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.UPD.CUS.SEG.SELECT
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This select routine read the data from external file and sends it to the record routine
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 03-MAY-2010   N.Satheesh Kumar   ODR-2009-12-0281      Initial Creation
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE

  GOSUB OPEN.FILE
  GOSUB READ.DATA
  RETURN

*---------
OPEN.FILE:
*---------
*------------------------------------------------------------------------------------------------------------------
* This section initialises the necessary variables and open the file or directory where the external file is stored
*------------------------------------------------------------------------------------------------------------------

  FN.FILE.PATH = '.' ; REC.ID = 'APAP.SEGMENT.MARKS.csv'
  OPEN FN.FILE.PATH TO F.FILE.PATH ELSE

    ERR.MSG = "Error in opening : ":FN.FILE.PATH
    CALL DISPLAY.MESSAGE(ERR.MSG,1)
    RETURN
  END
  RETURN

*---------
READ.DATA:
*---------
*-------------------------------------------------------------------------------------------------------------------
* This section reads the data from the external file and deletes the header and sends the data to the record routine
*-------------------------------------------------------------------------------------------------------------------

  READ FILE.CONTENT FROM F.FILE.PATH,REC.ID THEN
 
    DEL FILE.CONTENT<1>       ;* Deleting the header
    CALL BATCH.BUILD.LIST('',FILE.CONTENT)
  END  ELSE
    ERR.MSG = "Error in reading : ":REC.ID
    CALL DISPLAY.MESSAGE(ERR.MSG,1)
  END
  RETURN

END
