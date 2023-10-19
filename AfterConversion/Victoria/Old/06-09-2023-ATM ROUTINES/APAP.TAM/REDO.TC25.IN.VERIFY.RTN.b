* @ValidationCode : MjotMjA3MTM1MDI2NTpDcDEyNTI6MTY4MTA5NzczNDA5NjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 09:05:34
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
SUBROUTINE REDO.TC25.IN.VERIFY.RTN
*----------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.TC25.IN.VERIFY.RTN
*****************************************************************
*Description:
*----------------
*Incoming TC 25, 26, 27
*This message represents a reversal of transaction (TC05, 06, 07)
*After the message is stored, the routine should pickup each record and do the following:
*Match the record with TC05, 06, 07 in REDO.VISA.SETTLEMENT using this routine
*-----------------------------------------------------------------------------------------------------
*Linked with :-/-
*In Parameter : None
*Out Paramter : None
********************************************************************
*Modification History:
************************
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   2-12-2010       DHAMU S              ODR-2010-08-0469         Initial Creation
*   10.04.2023      Conversion Tool       R22                     Auto Conversion     - No changes
*   10.04.2023      Shanmugapriya M       R22                     Manual Conversion   - No changes
*
*--------------------------------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON



    GOSUB PROCESS

RETURN
*-------------------------------------------------------
PROCESS:
*-------------------------------------------------------

* Frame the ATM.REVERSAL id using R.REDO.STLMT.LINE

    CARD.NUMBER = R.REDO.STLMT.LINE<VISA.SETTLE.ACCOUNT.NUMBER>
    CARD.NUM.EXT = R.REDO.STLMT.LINE<VISA.SETTLE.ACCT.NUM.EXT>
    IF CARD.NUM.EXT NE 0 THEN
        CARD.NUMBER = CARD.NUMBER:FMT(CARD.NUM.EXT,"R0%3")
    END
    ATM.REVERSAL.ID = CARD.NUMBER:'.':R.REDO.STLMT.LINE<VISA.SETTLE.AUTH.CODE>
    CALL F.READ(FN.ATM.REVERSAL,ATM.REVERSAL.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,Y.ATM.REV.ERR)
    Y.ID = R.ATM.REVERSAL<AT.REV.VISA.STLMT.REF>
*    IF Y.ID NE '' THEN
*        CALL F.READ(FN.REDO.VISA.STLMT.05TO37,Y.ID,R.ARRAY,F.REDO.VISA.STLMT.05TO37,REDO.VISA.STLMT.05TO37.ERR)
*        R.ARRAY<VISA.SETTLE.FINAL.STATUS> = "REJECTED"
*        CALL REDO.VISA.SETTLE.WRITE(Y.ID,R.ARRAY)
*    END
RETURN

END
