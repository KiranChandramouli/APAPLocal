* @ValidationCode : MjoxOTg5NDQ0MjU6Q3AxMjUyOjE3MDQ0NDU5NzAxNDc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2024 14:42:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
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
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   CALL routine Modified
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.Service
    $USING EB.OverrideProcessing

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
*        CALL DISPLAY.MESSAGE(ERR.MSG,1)
        EB.OverrideProcessing.DisplayMessage(ERR.MSG,1);* R22 UTILITY AUTO CONVERSION
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
*        CALL BATCH.BUILD.LIST('',FILE.CONTENT)
        EB.Service.BatchBuildList('',FILE.CONTENT);* R22 UTILITY AUTO CONVERSION
    END  ELSE
        ERR.MSG = "Error in reading : ":REC.ID
*        CALL DISPLAY.MESSAGE(ERR.MSG,1)
        EB.OverrideProcessing.DisplayMessage(ERR.MSG,1);* R22 UTILITY AUTO CONVERSION
    END
RETURN

END
