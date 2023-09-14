* @ValidationCode : MjotNTQ2MzM5NzU2OkNwMTI1MjoxNjgxMzY0NzM3OTM2OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 11:15:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
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
* Date                  who                   Reference              
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
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
