* @ValidationCode : MjotODA4Njk4NzUzOkNwMTI1MjoxNzAyODc3NTA0Mjg4OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Dec 2023 11:01:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.FT.PROCESS.SELECT
*-------------------------------------------------------------------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*17-12-2023          VIGNESHWARI           MANUAL R22 CODE CONVERSION                   CALL RTN MODIFIED
*-------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.FI.FT.PROCESS.COMMON
    $USING EB.Service
    GOSUB PROCESS
RETURN
*-------
PROCESS:
*-------
    Y.SEL.CMD='SELECT ':FN.REDO.TEMP.FI.CONTROL:' WITH STATUS EQ ""'
    CALL EB.READLIST(Y.SEL.CMD,Y.REC.LIST,'',NO.OF.REC,Y.ERR)
 *   CALL BATCH.BUILD.LIST('',Y.REC.LIST);* MANUAL R22 CODE CONVERSION -CALL RTN MODIFIED
 EB.Service.BatchBuildList('',Y.REC.LIST)
RETURN
END
