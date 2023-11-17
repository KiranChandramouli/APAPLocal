* @ValidationCode : MjotMjYzMTI5MTAwOkNwMTI1MjoxNjgxMDU2NDg1MjkzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
    CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.VERSION.ID,R.VERSION.IDS,F.REDO.TEMP.VERSION.IDS,VERSION.ERR)
    LOCATE ID.NEW IN R.VERSION.IDS<REDO.TEM.REV.TXN.ID,1> SETTING POS THEN
        DEL R.VERSION.IDS<REDO.TEM.REV.TXN.ID,POS>
        DEL R.VERSION.IDS<REDO.TEM.REV.TXN.DATE,POS>
        CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.VERSION.ID,R.VERSION.IDS)
    END

RETURN
END
