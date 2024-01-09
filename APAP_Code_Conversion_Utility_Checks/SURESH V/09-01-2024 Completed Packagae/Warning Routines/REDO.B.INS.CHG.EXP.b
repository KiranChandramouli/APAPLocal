* @ValidationCode : MjoxNjUxODU4MDg2OkNwMTI1MjoxNzAzNjczMzQ1ODUxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Dec 2023 16:05:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.INS.CHG.EXP(Y.ID)
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.INS.CHG.EXP.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion   Change F.READ to F.READU
*-------------------------------------------------------------------------------------
MAIN:


*    CALL F.READ(FN.INSURANCE,Y.ID,R.INSURANCE,F.INSURANCE,INS.ERR)
    CALL F.READU(FN.INSURANCE,Y.ID,R.INSURANCE,F.INSURANCE,INS.ERR,"") ;*R22 Manual Conversion
    
    Y.AA.ID = R.INSURANCE<INS.DET.ASSOCIATED.LOAN>

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARR,F.AA.ARRANGEMENT,AA.ERR)
    IF R.AA.ARR THEN
        GOSUB PROCESS.AA.INS
    END

RETURN

PROCESS.AA.INS:

    R.INSURANCE<INS.DET.POLICY.STATUS> = 'VENCIDA'
    CALL F.WRITE(FN.INSURANCE,Y.ID,R.INSURANCE)

    Y.CHG = R.INSURANCE<INS.DET.CHARGE>
    Y.ACT = 'LENDING-CHANGE-':Y.CHG

    Y.AAA.REQ<AA.ARR.ACT.ARRANGEMENT> = Y.AA.ID
    Y.AAA.REQ<AA.ARR.ACT.ACTIVITY> = Y.ACT
    Y.AAA.REQ<AA.ARR.ACT.EFFECTIVE.DATE> = TODAY
    Y.AAA.REQ<AA.ARR.ACT.PROPERTY,1> = Y.CHG
    Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'FIXED.AMOUNT'
    Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = '0.00'
    Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'STATUS.POLICY'
    Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = 'VENCIDA'

    APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
    IN.FUNCTION = 'I'
    VERSION.NAME = 'AA.ARRANGEMENT.ACTIVITY,ZERO.AUTH'

    CALL OFS.BUILD.RECORD(APP.NAME, IN.FUNCTION, "PROCESS", VERSION.NAME, "", "0", AAA.ID, Y.AAA.REQ, PROCESS.MSG)

    OFS.MSG.ID = ''
    OFS.SOURCE = 'TRIGGER.INSURANCE'
    OFS.ERR = ''

    CALL OFS.POST.MESSAGE(PROCESS.MSG,OFS.MSG.ID,OFS.SOURCE,OFS.ERR)

    CALL OCOMO("INSURANCE PROCESSED - ":Y.ID)

RETURN

END
