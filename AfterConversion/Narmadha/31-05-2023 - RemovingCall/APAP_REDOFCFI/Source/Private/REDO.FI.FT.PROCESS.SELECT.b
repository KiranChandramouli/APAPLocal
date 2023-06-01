* @ValidationCode : Mjo2MjkyNDI4MDpDcDEyNTI6MTY4MTEzNTE2NDQ1ODpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 19:29:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.FT.PROCESS.SELECT
*-------------------------------------------------------------------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.FI.FT.PROCESS.COMMON

    GOSUB PROCESS
RETURN
*-------
PROCESS:
*-------
    Y.SEL.CMD='SELECT ':FN.REDO.TEMP.FI.CONTROL:' WITH STATUS EQ ""'
    CALL EB.READLIST(Y.SEL.CMD,Y.REC.LIST,'',NO.OF.REC,Y.ERR)
    CALL BATCH.BUILD.LIST('',Y.REC.LIST)
RETURN
END
