* @ValidationCode : Mjo1NDU3ODAzMjk6Q3AxMjUyOjE2ODEyODYyNzU3MzE6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 13:27:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.REV.ISSUED
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine will be executed at the Input level for the Following versions
* of CERTIFIED.CHEQUE.DETAILS,STOP.PAYMENT and CERTIFIED.CHEQUE.DETAILS,REVOKE.PAYMENT. This
* Routine will be used for Allowing Stop Payment of the Certified Cheques. This Routine is
* used to check the status of the Cheque whether it is "ISSUED" in case of reversing
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* ---------------------------
* IN : -NA-
* OUT : -NA-
* Linked With : TELLER
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.INP.REV.ISSUED
*------------------------------------------------------------------------------------------
* Modification History :
*-------------------------------------
* DATE WHO REFERENCE DESCRIPTION
* 22.03.2010 SUDHARSANAN S ODR-2009-10-0319 INITIAL CREATION
* ----------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*12-04-2023       Conversion Tool        R22 Auto Code conversion         VM TO @VM
*12-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*---------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.CERTIFIED.CHEQUE.DETAILS
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
    FN.CERTIFIED.CHEQUE.DETAILS='F.CERTIFIED.CHEQUE.DETAILS'
    F.CERTIFIED.CHEQUE.DETAILS=''
    CALL OPF(FN.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS)
    LREF.APP='TELLER'
    LREF.FIELD='CERT.CHEQUE.NO'
    LREF.POS=''
    CALL GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*The override has raised when the status other than issued
    Y.CERT.CHEQ.NO = ID.NEW
    CALL F.READ(FN.CERTIFIED.CHEQUE.DETAILS,Y.CERT.CHEQ.NO,R.CERT.CHEQ.DET,F.CERTIFIED.CHEQUE.DETAILS,DET.ERR)
    Y.STATUS = R.CERT.CHEQ.DET<CERT.DET.STATUS>
    IF PGM.VERSION EQ ',STOP.PAYMENT' THEN
        IF Y.STATUS NE 'ISSUED' THEN
            CURR.NO=''
            CURR.NO=DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM) + 1
            TEXT='TT.CERT.CHEQUE.STOP'
            CALL STORE.OVERRIDE(CURR.NO)
        END
    END
    IF PGM.VERSION EQ ',REVOKE.PAYMENT' THEN
        IF R.NEW(CERT.DET.STATUS) NE 'ISSUED' THEN
            CURR.NO=''
            CURR.NO=DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM) + 1
            TEXT='TT.CERT.CHEQUE.STOP'
            CALL STORE.OVERRIDE(CURR.NO)
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

END
