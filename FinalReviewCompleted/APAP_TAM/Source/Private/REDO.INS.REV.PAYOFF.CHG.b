* @ValidationCode : MjotMTU1MjYwOTkyMTpDcDEyNTI6MTY4NDQ5MTAzNTk5MzpJVFNTOi0xOi0xOjU5MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 590
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.INS.REV.PAYOFF.CHG
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT

MAIN:

    FN.INSURANCE = 'F.APAP.H.INSURANCE.DETAILS'
    F.INSURANCE = ''
    CALL OPF(FN.INSURANCE,F.INSURANCE)

    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    CALL OPF(FN.AC,F.AC)

    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AAA = ''
    CALL OPF(FN.AAA,F.AAA)


    IF R.NEW(FT.RECORD.STATUS) EQ 'RNAU' OR (R.NEW(FT.RECORD.STATUS) EQ 'RNAU' AND V$FUNCTION EQ 'D')  OR R.NEW(FT.RECORD.STATUS) EQ 'RNAO' THEN
        GOSUB PROCESS.REV.CHG
    END

RETURN

PROCESS.REV.CHG:

    Y.AC.ID = R.NEW(FT.CREDIT.ACCT.NO)

    CALL F.READ(FN.AC,Y.AC.ID,R.AC,F.AC,AC.ERR)

    Y.AA.ID = R.AC<AC.ARRANGEMENT.ID>


    SEL.CMD = 'SELECT ':FN.INSURANCE:' WITH ASSOCIATED.LOAN EQ "':Y.AA.ID:'"'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,REC.ERR) ; Y.DUM = NO.OF.REC

    Y.LP.CNT = DCOUNT(SEL.LIST,@FM) ; FLGD = ''
    LOOP
    WHILE Y.LP.CNT GT 0 DO
        FLGD += 1
        Y.ID = SEL.LIST<FLGD>

        CALL F.READ(FN.INSURANCE,Y.ID,R.INSURANCE,F.INSURANCE,INS.ERR)
        Y.CHG = R.INSURANCE<INS.DET.CHARGE>

        Y.ACT = 'LENDING-CHANGE-':Y.CHG

        Y.AAA.REQ<AA.ARR.ACT.ARRANGEMENT> = Y.AA.ID
        Y.AAA.REQ<AA.ARR.ACT.ACTIVITY> = Y.ACT
        Y.AAA.REQ<AA.ARR.ACT.EFFECTIVE.DATE> = TODAY
        Y.AAA.REQ<AA.ARR.ACT.PROPERTY,1> = Y.CHG
        Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'FIXED.AMOUNT'
        Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = '0.00'
        Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'STATUS.POLICY'
        Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = 'VIGENTE'

        APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
        IN.FUNCTION = 'I'
        VERSION.NAME = 'AA.ARRANGEMENT.ACTIVITY,ZERO.AUTH'

        CALL OFS.BUILD.RECORD(APP.NAME, IN.FUNCTION, "PROCESS", VERSION.NAME, "", "0", AAA.ID, Y.AAA.REQ, PROCESS.MSG)

        OFS.MSG.ID = ''
        OFS.SOURCE = 'TRIGGER.INSURANCE'
        OFS.ERR = ''

        CALL OFS.POST.MESSAGE(PROCESS.MSG,OFS.MSG.ID,OFS.SOURCE,OFS.ERR)

        R.INSURANCE<INS.DET.POLICY.STATUS> = 'VIGENTE'
        CALL F.WRITE(FN.INSURANCE,Y.ID,R.INSURANCE)

        Y.LP.CNT -= 1
    REPEAT

RETURN


END
