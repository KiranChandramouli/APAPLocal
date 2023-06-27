* @ValidationCode : MjotMTIwNjA5NDY2ODpDcDEyNTI6MTY4MjU5ODAxNDM3MzpzYW1hcjotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.AZ.TT.PREC.REC
*-----------------------------------------------------------------------------
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.TT.PREC.REC
*-----------------------------------------------------------------------------
*Description       : This routine is used Check Record Rotuine of TELLER, AZ.DEP.PART
*-----------------------------------------------------------------------------
*Modification Details:
*-----------------------------------------------------------------------------
*    Date            Who           Reference                 Description
*   ------         ------          -------------             -------------
*  09/07/2010       SAKTHI S       ODR-2009-10-0336 N.18     Initial Creation
* 11 MAR 2011       H GANESH       PACS00032973  - N.18     Modified as per issue
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.AZ.DISCOUNT.RATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.TT.ACCT.NO = R.NEW(TT.TE.ACCOUNT.1)
    PEN.AMT=0
    Y.PENAL.PER=0

    FN.AZ.ACCOUNT = "F.AZ.ACCOUNT"
    F.AZ.ACCOUNT = ""
    R.AZ.ACCOUNT = ""

    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.REDO.AZ.DISCOUNT.RATE  = "F.REDO.AZ.DISCOUNT.RATE"
    F.REDO.AZ.DISCOUNT.RATE = ""
    R.REDO.AZ.DISCOUNT.RATE = ""

    CALL OPF(FN.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE)

    Y.LOC.REF.APPLN = "TELLER":@FM:'AZ.ACCOUNT'
    Y.LOC.REF.FIELDS = "L.TT.PR.DEP.DAY":@VM:"L.TT.DEP.AMT":@VM:"L.TT.PENAL.AMT":@VM:'L.TT.PENAL.PER':@FM:"L.AZ.GRACE.DAYS"
    Y.LOC.REF.POS = ""
    CALL MULTI.GET.LOC.REF(Y.LOC.REF.APPLN,Y.LOC.REF.FIELDS,Y.LOC.REF.POS)

    LOC.L.TT.PR.DEP.DAY = Y.LOC.REF.POS<1,1>
    LOC.L.TT.DEP.AMT = Y.LOC.REF.POS<1,2>
    LOC.L.TT.PENAL.AMT = Y.LOC.REF.POS<1,3>
    LOC.L.TT.PENAL.PER = Y.LOC.REF.POS<1,4>
    POS.L.AZ.GRACE.DAYS = Y.LOC.REF.POS<2,1>


RETURN
*--------------------------------------------------------------------------------------------------------------
PROCESS:
*************

    CALL F.READ(FN.AZ.ACCOUNT,Y.TT.ACCT.NO,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.AZ.ERR)
    IF R.AZ.ACCOUNT EQ '' THEN
        RETURN
    END
    ROLLOVER.DATE = R.AZ.ACCOUNT<AZ.ROLLOVER.DATE>
    R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.DEP.AMT> = R.AZ.ACCOUNT<AZ.PRINCIPAL>

    IF ROLLOVER.DATE THEN
        YDATE = ROLLOVER.DATE
        YDATE2 = TODAY
        Y.PREC.DEP.DAYS = 'C'
        CALL CDD('',YDATE,YDATE2,Y.PREC.DEP.DAYS)
        R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PR.DEP.DAY> = Y.PREC.DEP.DAYS
        GOSUB CHECK.FOR.PENALTY   ;* This Para checks whether to calculate penalty or not
    END  ELSE
        YDATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>
        YDATE2 = TODAY
        Y.PREC.DEP.DAYS = 'C'
        CALL CDD('',YDATE,YDATE2,Y.PREC.DEP.DAYS)
        R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PR.DEP.DAY> = Y.PREC.DEP.DAYS
        GOSUB BEF.ROLLOVER
    END

    R.NEW(TT.TE.AMOUNT.LOCAL.1) = R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.DEP.AMT> - PEN.AMT

RETURN
********************
BEF.ROLLOVER:
********************
* This part raises a penalty for preclosure before maturity(Deposit Not Rolled Over)

    CATEGORY = R.AZ.ACCOUNT<AZ.CATEGORY>
    CALL F.READ(FN.REDO.AZ.DISCOUNT.RATE,CATEGORY,R.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE,Y.AZ.DIS.ERR)
    IF R.REDO.AZ.DISCOUNT.RATE THEN
        GOSUB GET.PENAL.RATE
    END ELSE
        R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PENAL.PER> =0
*APAP.REDORETAIL.REDO.AZ.PENAL.AMT.CALC('0',Y.PREC.DEP.DAYS,PEN.AMT)
        APAP.REDORETAIL.redoAzPenalAmtCalc('0',Y.PREC.DEP.DAYS,PEN.AMT);*MANUAL R22 CONVERSION
        R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PENAL.AMT> =PEN.AMT
        RETURN
    END

RETURN

********************
GET.PENAL.RATE:
********************

    Y.DATE.RANGE =R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.DATE.RANGE>
    Y.DATE.RNG.CNT=DCOUNT(Y.DATE.RANGE,@VM)
    Y.VAR1=1
    Y.START.DATE=FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',1)
    IF Y.PREC.DEP.DAYS LT Y.START.DATE THEN         ;* If suppose preclosure happens before the pre-defined days in REDO.AZ.DISCOUNT.RATE.(i.e if DATE.RANGE begins from 30 days and preclosure happens with that days)
        R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PENAL.PER> =0
*APAP.REDORETAIL.REDO.AZ.PENAL.AMT.CALC('0',Y.PREC.DEP.DAYS,PEN.AMT)
        APAP.REDORETAIL.redoAzPenalAmtCalc('0',Y.PREC.DEP.DAYS,PEN.AMT);*MANUAL R22 CONVERSION
        R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PENAL.AMT> =PEN.AMT
        RETURN
    END
    LOOP
    WHILE Y.VAR1 LE Y.DATE.RNG.CNT
        Y.START.DATE=FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',1)
        Y.END.DATE=FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',2)
        IF Y.VAR1 EQ Y.DATE.RNG.CNT THEN    ;* This is for Default Case at last multivalue of table REDO.AZ.DISCOUNT.RATE
            Y.PENAL.PER=R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.PENAL.PERCENT,Y.VAR1>
        END
        IF Y.PREC.DEP.DAYS GE Y.START.DATE AND Y.PREC.DEP.DAYS LE Y.END.DATE THEN
            Y.PENAL.PER=R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.PENAL.PERCENT,Y.VAR1>
            BREAK
        END
        Y.VAR1 += 1
    REPEAT
    R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PENAL.PER> =Y.PENAL.PER
*APAP.REDORETAIL.REDO.AZ.PENAL.AMT.CALC(Y.PENAL.PER,Y.PREC.DEP.DAYS,PEN.AMT)
    APAP.REDORETAIL.redoAzPenalAmtCalc(Y.PENAL.PER,Y.PREC.DEP.DAYS,PEN.AMT);*MANUAL R22 CONVERSION
    R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PENAL.AMT> =PEN.AMT

RETURN
*******************
CHECK.FOR.PENALTY:
*******************
    Y.NO.OF.GRC.DAYS=R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.AZ.GRACE.DAYS>
    Y.NO.OF.GRC.DAYS='+':Y.NO.OF.GRC.DAYS:'W'
    Y.GRACE.END.DATE=ROLLOVER.DATE
    CALL CDT('',Y.GRACE.END.DATE,Y.NO.OF.GRC.DAYS)
    IF TODAY GE ROLLOVER.DATE AND TODAY LE Y.GRACE.END.DATE THEN
        R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PENAL.PER> =0
*APAP.REDORETAIL.REDO.AZ.PENAL.AMT.CALC('0',Y.PREC.DEP.DAYS,PEN.AMT)
        APAP.REDORETAIL.redoAzPenalAmtCalc('0',Y.PREC.DEP.DAYS,PEN.AMT);*MANUAL R22 CONVERSION
        R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PENAL.AMT> =PEN.AMT
    END ELSE
        GOSUB BEF.ROLLOVER
    END

RETURN

END
