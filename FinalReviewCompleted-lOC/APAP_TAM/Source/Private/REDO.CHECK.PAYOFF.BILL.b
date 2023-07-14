* @ValidationCode : MjotMTYxMzQ5OTk0MTpDcDEyNTI6MTY4NDg0MjA4NjUwODpJVFNTOi0xOi0xOjM4NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 385
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             VM TO @VM
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.CHECK.PAYOFF.BILL

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS

MAIN:

    FN.AA.AC = 'F.AA.ACCOUNT.DETAILS'
    F.AA.AC = ''
    CALL OPF(FN.AA.AC,F.AA.AC)

    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    CALL OPF(FN.AC,F.AC)


    Y.AA.ID = R.NEW(FT.CREDIT.ACCT.NO)

    CALL F.READ(FN.AC,Y.AA.ID,R.AC,F.AC,AC.ERR)

    Y.ARR.ID = R.AC<AC.ARRANGEMENT.ID>

    CALL F.READ(FN.AA.AC,Y.ARR.ID,R.AA.AC,F.AA.AC,AA.AC.ERR)
    Y.PAY.METS = R.AA.AC<AA.AD.PAY.METHOD>

    Y.CNT = DCOUNT(Y.PAY.METS,@VM) ; FLG = ''

    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.DT.PAY.MET = Y.PAY.METS<1,FLG>
        LOCATE 'INFO' IN Y.DT.PAY.MET<1,1> SETTING POS THEN
            GOSUB CHECK.DATE
            Y.CNT = 0
        END
        Y.CNT -= 1
    REPEAT

    GOSUB PGM.END

RETURN


CHECK.DATE:

    Y.BILL.DATE = R.AA.AC<AA.AD.BILL.DATE,FLG,POS>

    IF Y.BILL.DATE NE TODAY THEN
        AF = FT.CREDIT.ACCT.NO
        ETEXT = 'EB-PAYOFF.BILL.NT.TODAY'
        CALL STORE.END.ERROR
    END

RETURN

PGM.END:

END
