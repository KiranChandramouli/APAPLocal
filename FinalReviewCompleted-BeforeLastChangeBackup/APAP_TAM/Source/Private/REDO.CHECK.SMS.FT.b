* @ValidationCode : MjoyMTE1Mzc4NTcwOkNwMTI1MjoxNjgwNjU4NDQ3MTc4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 07:04:07
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
SUBROUTINE REDO.CHECK.SMS.FT
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================

* Date             Who                   Reference      Description
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, F TO CACHE
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER

MAIN:

    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    CALL OPF(FN.AC,F.AC)

    FN.USER = 'F.USER'
    F.USER = ''
    CALL OPF(FN.USER,F.USER)

    POS.SS = ''
    Y.FLDS = 'L.TELR.LOAN':@VM:'L.ALLOW.ACTS'
    Y.APPLNS = 'USER'
    CALL MULTI.GET.LOC.REF(Y.APPLNS,Y.FLDS,POS.SS)
    Y.POS.TRL = POS.SS<1,1>
    Y.POS.ALW.ACT = POS.SS<1,2>


    Y.ARR.ID = R.NEW(FT.DEBIT.ACCT.NO)

    CALL F.READ(FN.AC,Y.ARR.ID,R.AC,F.AC,AC.ERR)
    Y.AA.ID = R.AC<AC.ARRANGEMENT.ID>

    IF Y.AA.ID THEN
        GOSUB PROCESS
    END ELSE
        RETURN
    END


PROCESS:

    Y.USR = OPERATOR
    CALL CACHE.READ(FN.USER, Y.USR, R.USR, ERR.US)     ;** R22 Auto conversion - F TO CACHE

    IF R.USR<EB.USE.LOCAL.REF,Y.POS.TRL> EQ 'TELLER' OR R.USR<EB.USE.LOCAL.REF,Y.POS.TRL> EQ 'OTHERS' THEN
        AF = FT.TRANSACTION.TYPE
        ETEXT = 'EB-ACTIVITY.NOT.ALLOW'
        CALL STORE.END.ERROR
        CALL TRANSACTION.ABORT
    END

RETURN

END
