SUBROUTINE REDO.V.INP.REV.ISSTOP
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine will be executed at the Input level for the Following
* versions of TELLER,REVERSE.CERTIFIED.CHEQUES. This Routine will be used for
* reversing the Certified Cheques. This Routine is used in reversal of Certified Cheques
* it will check whether the Status of the Cheque is ISSUED  or STOP.PAID
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* ---------------------------
* IN     : -NA-
* OUT    : -NA-
* Linked With : TELLER
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.INP.REV.ISSTOP
*------------------------------------------------------------------------------------------
* Modification History :
*-------------------------------------
* DATE               WHO          REFERENCE         DESCRIPTION
* 16.03.2010  SUDHARSANAN S     ODR-2009-10-0319  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
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
    LREF.FIELD='CERT.CHEQUE.NO':@VM:'L.COMMENTS'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    POS.CERT.CHEQUE = LREF.POS<1,1>
    POS.COMMENTS = LREF.POS<1,2>
RETURN
*---------------------------------------------------------------------------------
PROCESS:
    Y.CERT.CHEQ.NO = R.NEW(TT.TE.LOCAL.REF)<1,POS.CERT.CHEQUE>
    R.NEW(TT.TE.LOCAL.REF)<1,POS.COMMENTS> = 'REVERSE.CHEQUE'
    CALL F.READ(FN.CERTIFIED.CHEQUE.DETAILS,Y.CERT.CHEQ.NO,R.CERT.CHEQ.DET,F.CERTIFIED.CHEQUE.DETAILS,DET.ERR)
    Y.STATUS = R.CERT.CHEQ.DET<CERT.DET.STATUS>
    IF Y.STATUS NE 'ISSUED' AND Y.STATUS NE 'STOP.PAID' THEN
        CURR.NO=''
        CURR.NO=DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM) + 1
        TEXT='TT.CERT.CHEQUE.REVERSAL'
        CALL STORE.OVERRIDE(CURR.NO)
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
END
