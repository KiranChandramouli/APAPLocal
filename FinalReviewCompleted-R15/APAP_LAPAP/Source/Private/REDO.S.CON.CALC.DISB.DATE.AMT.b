* @ValidationCode : MjoxNzEwOTA0MDQxOkNwMTI1MjoxNjg1OTUyMjM3NzMyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jun 2023 13:33:57
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
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------

SUBROUTINE REDO.S.CON.CALC.DISB.DATE.AMT(IN.REC.VAL,OUT.REC.VAL)
*--------------------------------------------------------------------------------------------------
*
* Description           : This is the Common Routine for Calculating the Disburse Amount and Date
* *
* Developed On          : 23-Sep-2013
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : DE15
*
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
*                        Krishnaveni G                  20131206            Disburseamount field corrected
* PACS00355150           Ashokkumar.V.P                 06/03/2015          Added new fields based on mapping
*
* 21-APR-2023        Conversion tool       AUTO R22 CODE CONVERSION      FM TO @FM, VM TO @VM,BP Removed in Insert File
* 21-APR-2023         Harishvikram C         Manual R22 conversion        CALL routine format modified, AA.AH.ACTIVITY.ID to AA.AH.ACTIVITY.REF


*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------

    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.LIMIT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CURRENCY
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.CCY.HISTORY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PRODUCT.GROUP
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ACTIVITY.CHARGES
    $INSERT I_F.AA.PRODUCT.DESIGNER
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.SCHEDULED.ACTIVITY
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_REDO.B.MG.LNS.BY.DEBTOR.COMMON ;*AUTO R22 CODE CONVERSION - end
*
    $USING APAP.TAM

    GOSUB GET.IN.REC.VAL
    GOSUB DISB.AMT.CHECK
    GOSUB AA.TERM.AMOUNT.CHK
    GOSUB FORM.VALUES
RETURN

GET.IN.REC.VAL:
*--------------
    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'; F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)
    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'; F.AA.ARR.TERM.AMOUNT = ''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)
    Y.AA.ARR.ID = FIELD(IN.REC.VAL,"#",1)
    Y.CUSTOMER.ID  = FIELD(IN.REC.VAL,"#",2)
    Y.CURRENCY   = FIELD(IN.REC.VAL,"#",3)
    Y.L.LOAN.STATUS.1 = FIELD(IN.REC.VAL,"#",4)
    R.AA.TERM.AMOUNT = FIELD(IN.REC.VAL,"#",5)
    R.AA.ACCOUNT.DETAILS = FIELD(IN.REC.VAL,"#",6)
    R.AA.OVERDUE = FIELD(IN.REC.VAL,"#",7)
    Y.ACCT.NO = FIELD(IN.REC.VAL,"#",8)
    R.AA.LIMIT = FIELD(IN.REC.VAL,"#",9)
    R.AA.ACCOUNT = FIELD(IN.REC.VAL,"#",10)
    R.AA.ARRANGEMENT = ''; AA.ARRANGEMENT.ERR = ''; R.AA.PRODUCT.GROUP = ''; ERR.AA.PRODUCT.GROUP = ''
    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)
RETURN

DISB.AMT.CHECK:
*-------------
    Y.COMMITED.AMT = 0; Y.DISBURSE.DATE = ''
    APAP.TAM.redoGetDisbursementDetails(Y.AA.ARR.ID,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB) ;*MANUAL R22 CODE CONVERSION
    Y.DISBURSE.AMT = R.DISB.DETAILS<3>
    Y.DISBURSE.DATE= R.DISB.DETAILS<1>
    IF Y.DISBURSE.DATE THEN
        Y.DISBURSE.DATE.DIS = Y.DISBURSE.DATE[7,2]:"/":Y.DISBURSE.DATE[5,2]:"/":Y.DISBURSE.DATE[1,4]
    END
RETURN

*---------------------
AA.ACTIVITY.HIST.READ:
**--------------------
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ARR.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,AA.ACTIVITY.HISTORY.ERR)
    Y.ACTIVITY      = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
    Y.ACT.REFERENCE = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF>
    Y.ACT.STATUS    = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.STATUS>
    Y.ACT.AMT       = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.AMT>
    Y.ACT.DATE      = R.AA.ACTIVITY.HISTORY<AA.AH.SYSTEM.DATE>
    Y.EFF.DATE.ACT = R.AA.ACTIVITY.HISTORY<AA.AH.EFFECTIVE.DATE>
    CHANGE @VM TO @FM IN Y.ACTIVITY
    CHANGE @VM TO @FM IN Y.ACT.REFERENCE
    CHANGE @VM TO @FM IN Y.ACT.STATUS
    CHANGE @VM TO @FM IN Y.ACT.AMT
    CHANGE @VM TO @FM IN Y.ACT.DATE
    CHANGE @VM TO @FM IN Y.EFF.DATE.ACT
RETURN

AA.TERM.AMOUNT.CHK:
*-----------------
    Y.L.STATUS.CHG.DT   = R.AA.OVERDUE<AA.OD.LOCAL.REF,Y.L.STATUS.CHG.DT.POS>
    IF Y.L.LOAN.STATUS.1 EQ "Restructured" THEN
        Y.RESTRUCT.DATE = Y.L.STATUS.CHG.DT
    END
    Y.RESTRUCT.DATE.DIS = ''
    IF Y.RESTRUCT.DATE THEN
        Y.RESTRUCT.DATE.DIS  = Y.RESTRUCT.DATE[7,2]:"/":Y.RESTRUCT.DATE[5,2]:"/":Y.RESTRUCT.DATE[1,4]
    END
    GOSUB CHK.LN.STATUS.TERM.AMT
    GOSUB EARLY.PAY.OFF
RETURN
CHK.LN.STATUS.TERM.AMT:
*---------------------
    YPRCT.GROUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    CALL F.READ(FN.AA.PRODUCT.GROUP,YPRCT.GROUP,R.AA.PRODUCT.GROUP,F.AA.PRODUCT.GROUP,ERR.AA.PRODUCT.GROUP)
    LOCATE 'TERM.AMOUNT' IN R.AA.PRODUCT.GROUP<AA.PG.PROPERTY.CLASS,1> SETTING PROP.POS THEN
        PROPERTY.VAL = R.AA.PRODUCT.GROUP<AA.PG.PROPERTY,PROP.POS>
    END
    YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF> ;*Manual R22 conversion

    Y.RENEWAL.DATE = ''
    IF Y.L.LOAN.STATUS.1 EQ "Normal" OR Y.L.LOAN.STATUS.1 EQ "" THEN
        LOCATE "LENDING-CHANGE.TERM-COMMITMENT" IN YACT.ID.ARR<1,1> SETTING CHG.POSN THEN
            YACT.DTE.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.DATE,CHG.POSN,1>
            Y.RENEWAL.DATE = YACT.DTE.ID
        END
    END
    Y.RENEWAL.DATE.DIS = ''
    IF Y.RENEWAL.DATE THEN
        Y.RENEWAL.DATE.DIS = Y.RENEWAL.DATE[7,2]:"/":Y.RENEWAL.DATE[5,2]:"/":Y.RENEWAL.DATE[1,4]
    END
RETURN
EARLY.PAY.OFF:
*------------
    Y.L.AA.PART.ALLOW  = R.AA.TERM.AMOUNT<AA.AMT.LOCAL.REF,Y.L.AA.PART.ALLOW.POS>
    IF Y.L.AA.PART.ALLOW EQ "YES" THEN
        Y.EARLY.PAY.OFF = "S"
    END ELSE
        Y.EARLY.PAY.OFF = "N"
    END
RETURN

AA.ARR.TERM.AMT.READ:
**-------------------
    AA.TERM.AMT.ERR   = ""; R.AA.ARR.TERM.AMT = ""
    CALL F.READ(FN.AA.ARR.TERM.AMOUNT,TERM.AMT.ID,R.AA.ARR.TERM.AMT,F.AA.ARR.TERM.AMOUNT,AA.TERM.AMT.ERR)
RETURN

FORM.VALUES:
*----------
    Y.COMP.CODE = ''
    OUT.REC.VAL = Y.DISBURSE.DATE.DIS:"#":Y.DISBURSE.AMT:'#':Y.COMP.CODE:"#":Y.RESTRUCT.DATE.DIS:"#":Y.RENEWAL.DATE.DIS:"#":Y.EARLY.PAY.OFF:"#":Y.COMMITED.AMT
RETURN
END
