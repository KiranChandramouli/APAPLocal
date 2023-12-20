* @ValidationCode : MjotODA4Njk4NzUzOkNwMTI1MjoxNzAyOTkwOTQ5NzU0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:32:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
