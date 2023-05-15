* @ValidationCode : MjotMTI1MTU5OTI1NDpDcDEyNTI6MTY4MjQzMDA0MjI5MTpJVFNTOi0xOi0xOjE4NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 19:10:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 186
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.V.AA.CHEQU.DISB
*
* Description: Auth routine to validate the cheque duplication for Loans
* Attached to: FUNDS.TRANSFER,CHQ.OTHERS.LOAN.DUM
* Dev by     : V.P.Ashokkumar
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
*DATE           WHO                 REFERENCE               DESCRIPTION
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE

*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.REDO.MTS.DISBURSE ;*AUTO R22 CODE CONVERSION END

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
******
    FT.ID = ''; ERR.REDO.MTS.DISBURSE = ''; R.REDO.MTS.DISBURSE = ''; YREF.ID = ''
    FN.REDO.MTS.DISBURSE = 'F.REDO.MTS.DISBURSE'; F.REDO.MTS.DISBURSE = ''
    CALL OPF(FN.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE)
RETURN

PROCESS:
********
    FT.ID = System.getVariable('CURRENT.FT')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION START
        FT.ID = ""
    END ;*MANUAL R22 CODE CONVERSION END
    IF NOT(FT.ID) THEN
        RETURN
    END

    CALL F.READ(FN.REDO.MTS.DISBURSE,FT.ID,R.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE,ERR.REDO.MTS.DISBURSE)
    YREF.ID = R.REDO.MTS.DISBURSE<MT.REF.ID>
    IF YREF.ID THEN
        ETEXT = "FT-DUP"
        CALL STORE.END.ERROR
    END

RETURN
END
