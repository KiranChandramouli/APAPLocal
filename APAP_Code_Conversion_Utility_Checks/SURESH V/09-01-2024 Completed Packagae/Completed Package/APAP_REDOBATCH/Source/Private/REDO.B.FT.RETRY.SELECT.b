* @ValidationCode : MjotNDg4ODA5NDg6Q3AxMjUyOjE3MDM1OTQ5MjcwNTg6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Dec 2023 18:18:47
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
SUBROUTINE REDO.B.FT.RETRY.SELECT
*-------------------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is the SELECT routine of the batch job REDO.B.UPD.STO.CUR.AMT
*   which updates the local table REDO.STO.PENDING.RESUBMISSION
* This routine selects the arrangement ids from REDO.RESUBMIT.FT.DET for which FT retry needs to be done
* ------------------------------------------------------------------------------------------------------
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
*   Date               who           Reference                     Description
* 03-JUN-2010   N.Satheesh Kumar  TAM-ODR-2009-10-0331           Initial Creation
* Date                  who                   Reference
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion    CALL routine modified
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.FT.RETRY.COMMON
    
    $USING EB.Service ;*R22 Manual Conversion

    SEL.CMD = 'SELECT ':FN.REDO.RESUBMIT.FT.DET
    CALL EB.READLIST(SEL.CMD,ARR.SEL.LST,'',NO.REC,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',ARR.SEL.LST)
    EB.Service.BatchBuildList('',ARR.SEL.LST) ;*R22 Manual Conversion
RETURN
END
