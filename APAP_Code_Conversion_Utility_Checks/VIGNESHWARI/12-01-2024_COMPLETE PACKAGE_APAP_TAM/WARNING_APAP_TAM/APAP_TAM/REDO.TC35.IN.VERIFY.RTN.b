* @ValidationCode : MjotMjE0MTc4NTQ4MDpDcDEyNTI6MTcwNTA0Njk3MDE3NzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2024 13:39:30
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
SUBROUTINE REDO.TC35.IN.VERIFY.RTN
*----------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.TC35.IN.VERIFY.RTN
*****************************************************************
*Description:
*----------------
*Incoming TC 25, 26, 27
*This message represents a reversal of transaction (TC 15, 16, 17)
*After the message is stored, the routine should pickup each record and do the following:
*Match the record with TC15, 16, 17 in REDO.VISA.OUTGOING using this routine
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
*--------------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       CALL ROUTINE FORMAT MODIFIED
*-------------------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON



    GOSUB PROCESS

RETURN


*----------
PROCESS:
*---------

* Frame the ATM.REVERSAL id using R.REDO.STLMT.LINE

    CARD.NUMBER= R.REDO.STLMT.LINE<VISA.SETTLE.ACCOUNT.NUMBER>
    CARD.NUM.EXT= R.REDO.STLMT.LINE<VISA.SETTLE.ACCT.NUM.EXT>
    IF CARD.NUM.EXT NE 0 THEN
        CARD.NUMBER = CARD.NUMBER : FMT(CARD.NUM.EXT,"R0%3")
    END
    ATM.REVERSAL.ID = CARD.NUMBER:'.':R.REDO.STLMT.LINE<VISA.SETTLE.ACQR.REF.NUM>
    CALL F.READ(FN.ATM.REVERSAL,ATM.REVERSAL.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,Y.ATM.REV.ERR)
    Y.ID = R.ATM.REVERSAL<AT.REV.VISA.CHGBCK.REF>
    CALL OPF(FN.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING) ;*R22 Manual Conversion
    CALL F.READ(FN.REDO.VISA.OUTGOING,Y.ID,R.ARRAY,F.REDO.VISA.OUTGOING,REDO.VISA.OUTGOING.ERR)

    R.ARRAY<VISA.OUT.STATUS> = "REVERSED"

*CALL APAP.TAM.REDO.VISA.OUTGOING.WRITE(Y.ID,R.ARRAY)   ;*R22 MANUAL CODE CONVERSION
    APAP.TAM.redoVisaOutgoingWrite(Y.ID,R.ARRAY) ;*R22 MANUAL CODE CONVERSION


RETURN

END
