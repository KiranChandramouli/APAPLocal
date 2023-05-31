* @ValidationCode : MjoxMTgyMDE0OTczOkNwMTI1MjoxNjg0ODU1NjAzMjA5OklUU1M6LTE6LTE6MTE1NzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:56:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1157
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.PACS
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   TAM.BP REMOVED , $INCLUDE to $INSERT
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.CORRECTION.DIRECT.DEBIT(Y.AA.ID)
*------------------------------------------------------------------
*Description: This routine is to correct the concat table - REDO.DIRECT.DEBIT.ACCOUNTS (PACS00475021)
*             where AA.ARR.PAYMENT.SCHEDULE moves to INAO during LENDING-NEW-ARRANGEMENT activity
*             due to the override - REDO.ACC.NOT.OWNR (ACNO).
*------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_REDO.CORRECTION.DIRECT.DEBIT.COMMON
    $USING  APAP.TAM
    CALL OCOMO("Processing the loan":Y.AA.ID)
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------


    GOSUB GET.PAYMENT.SCHEDULE
    GOSUB CHECK.CONCAT.TABLE
    GOSUB CHECK.AA.ARR.FILES


RETURN
*------------------------------------------------------------------
GET.PAYMENT.SCHEDULE:
*------------------------------------------------------------------

    EFF.DATE     = ''
    PROP.CLASS   ='PAYMENT.SCHEDULE'
    PROPERTY     = ''
    R.CONDITION  = ''
    ERR.MSG      = ''
    CALL APAP.TAM.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG) ;*MANUAL R22 CODE ADDING PACKAGE

    IF R.CONDITION<AA.PS.LOCAL.REF,POS.L.AA.PAY.METHD> EQ 'Direct Debit' AND R.CONDITION<AA.PS.LOCAL.REF,POS.L.AA.DEBT.AC> NE '' ELSE
        CALL OCOMO("Not a DD loan, So skipped ":Y.AA.ID)
        GOSUB END1
    END

    Y.DD.DEBIT.ACC = R.CONDITION<AA.PS.LOCAL.REF,POS.L.AA.DEBT.AC>

RETURN

*------------------------------------------------------------------
CHECK.CONCAT.TABLE:
*------------------------------------------------------------------
    Y.ACC.ID = ""
    CALL F.READU(FN.REDO.DIRECT.DEBIT.ACCOUNTS,Y.DD.DEBIT.ACC,R.REDO.DIRECT.DEBIT.ACCOUNTS,F.REDO.DIRECT.DEBIT.ACCOUNTS,CNCT.ERR,"")

    LOCATE Y.AA.ID IN R.REDO.DIRECT.DEBIT.ACCOUNTS<1> SETTING POS.ACC THEN
        CALL OCOMO("DD account available in table, so skipped":Y.AA.ID)
        GOSUB END1
    END
    R.REDO.DIRECT.DEBIT.ACCOUNTS<-1> = Y.AA.ID
    CALL F.WRITE(FN.REDO.DIRECT.DEBIT.ACCOUNTS,Y.DD.DEBIT.ACC,R.REDO.DIRECT.DEBIT.ACCOUNTS)
    CALL F.RELEASE(FN.REDO.DIRECT.DEBIT.ACCOUNTS,Y.DD.DEBIT.ACC,F.REDO.DIRECT.DEBIT.ACCOUNTS)


RETURN
*------------------------------------------------------------------
CHECK.AA.ARR.FILES:
*------------------------------------------------------------------


    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ACH.ERR)

    FINDSTR "LENDING-NEW-ARRANGEMENT" IN R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY> SETTING POS.AF,POS.AV,POS.AS THEN
        Y.AAA.REF  = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,POS.AV,POS.AS>
        Y.EFF.DATE = R.AA.ACTIVITY.HISTORY<AA.AH.EFFECTIVE.DATE,POS.AV>

    END ELSE
        CALL OCOMO("Not a new arrangement, so skipped":Y.AA.ID)
        GOSUB END1
    END

    CALL F.READ(FN.AAA,Y.AAA.REF,R.AAA,F.AAA,AAA.ERR)
    CALL F.READ(FN.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS,Y.AA.ID,R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS,F.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS,DET.ERR)
    R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS<1,-1> = Y.AAA.REF
    R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS<2,-1> = Y.EFF.DATE
    R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS<3,-1> = FIELD(R.AAA<AA.ARR.ACT.INPUTTER>,"_",2,1)
    CALL F.WRITE(FN.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS,Y.AA.ID,R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS)

    IF R.AAA ELSE
        CALL OCOMO("AAA doesnt exist, so skipped":Y.AA.ID)
        GOSUB END1
    END

    Y.STRING = Y.AA.ID:"-":"REPAYMENT.SCHEDULE"
    FINDSTR Y.STRING IN R.AAA<AA.ARR.ACT.PROCESS.DETAIL> SETTING POS.STR.AF,POS.STR.AV,POS.STR.AS THEN
        Y.AA.ARR.REC.ID = FIELD (R.AAA<AA.ARR.ACT.PROCESS.DETAIL,POS.STR.AV>," ",3,1)
    END ELSE
        CALL OCOMO("AA.ARR.PAYMENT.SCHEDULE NOT LOCATED, so skipped":Y.AA.ID)
        GOSUB END1
    END

    CALL F.READ(FN.AA.ARR.PAYMENT.SCHEDULE$NAU,Y.AA.ARR.REC.ID,R.AA.ARR.PAYMENT.SCHEDULE,F.AA.ARR.PAYMENT.SCHEDULE$NAU,PAY.ERR)

    IF R.AA.ARR.PAYMENT.SCHEDULE THEN
        R.AA.ARR.PAYMENT.SCHEDULE<AA.PS.RECORD.STATUS> = "" ;* Moved to Live
        CALL F.WRITE(FN.AA.ARR.PAYMENT.SCHEDULE,Y.AA.ARR.REC.ID,R.AA.ARR.PAYMENT.SCHEDULE)
        CALL F.DELETE(FN.AA.ARR.PAYMENT.SCHEDULE$NAU,Y.AA.ARR.REC.ID)
        GOSUB UPDATE.DATED.XREF
    END ELSE
        CALL OCOMO("AA.ARR.PAYMENT.SCHEDULE NOT IN INAU, so skipped":Y.AA.ID)
        GOSUB END1
    END

RETURN
*------------------------------------------------------------------
UPDATE.DATED.XREF:
*------------------------------------------------------------------

    CALL F.READ(FN.AA.ARRANGEMENT.DATED.XREF,Y.AA.ID,R.AA.ARRANGEMENT.DATED.XREF,F.AA.ARRANGEMENT.DATED.XREF,XREF.ERR)
    IF R.AA.ARRANGEMENT.DATED.XREF ELSE
        CALL OCOMO("DATED XREF MISSING, so skipped":Y.AA.ID)
        GOSUB END1
    END

    LOCATE "REPAYMENT.SCHEDULE" IN R.AA.ARRANGEMENT.DATED.XREF<1,1> SETTING POS.XREF THEN
        Y.NEW.DATE = FIELD(Y.AA.ARR.REC.ID,"-",3)
        LOCATE Y.NEW.DATE IN R.AA.ARRANGEMENT.DATED.XREF<3,POS.XREF,1> SETTING PP.POS THEN
            R.AA.ARRANGEMENT.DATED.XREF<3,POS.XREF,PP.POS> = ""
            R.AA.ARRANGEMENT.DATED.XREF<2,POS.XREF,-1>     = Y.NEW.DATE
            CALL F.WRITE(FN.AA.ARRANGEMENT.DATED.XREF,Y.AA.ID,R.AA.ARRANGEMENT.DATED.XREF)
            CALL OCOMO("ALL DETAILS UPDATE ": Y.AA.ID)
        END
    END

RETURN
*------------------------------------------------------------------
END1:
END
