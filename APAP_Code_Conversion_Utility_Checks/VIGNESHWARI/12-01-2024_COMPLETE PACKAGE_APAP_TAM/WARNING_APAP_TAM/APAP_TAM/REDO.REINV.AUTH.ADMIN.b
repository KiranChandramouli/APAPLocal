* @ValidationCode : MjoxNDg5Mzg3MTI5OkNwMTI1MjoxNzA0OTY1NzI4NjY3OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jan 2024 15:05:28
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.REINV.AUTH.ADMIN
*-------------------------------------------
* DESCRIPTION: This routine is to update the REDO.TEMP.VERSION.IDS.

*----------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE           DESCRIPTION
* 14-Jul-2011     H Ganesh    PACS00072695 - N.11   Initial Draft.
* 10.04.2023   Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023   Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.TEMP.VERSION.IDS


    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
    F.REDO.TEMP.VERSION.IDS = ''
    CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.VERSION.ID = 'FUNDS.TRANSFER,CHQ.REV.AUTH'
*    CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.VERSION.ID,R.VERSION.IDS,F.REDO.TEMP.VERSION.IDS,VERSION.ERR)
    CALL F.READU(FN.REDO.TEMP.VERSION.IDS,Y.VERSION.ID,R.VERSION.IDS,F.REDO.TEMP.VERSION.IDS,VERSION.ERR,'');* R22 UTILITY AUTO CONVERSION
    LOCATE ID.NEW IN R.VERSION.IDS<REDO.TEM.REV.TXN.ID,1> SETTING POS THEN
        DEL R.VERSION.IDS<REDO.TEM.REV.TXN.ID,POS>
        DEL R.VERSION.IDS<REDO.TEM.REV.TXN.DATE,POS>
        CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.VERSION.ID,R.VERSION.IDS)
    END

RETURN
END
