* @ValidationCode : MjoxMDA1NTUwMTM0OkNwMTI1MjoxNjgyNTk4MDE0NDA3OnNhbWFyOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
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
SUBROUTINE REDO.AZ.TT.VAL.PENALPC
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.TT.VAL.PENALPC
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a VALIDATION ROUTINE attached to the field L.TT.PENAL.PER of version
*                    TELLER,AZ.DEP.PART. It is used to calculate and levy the PENALTY AMOUNT if the
*                    preclosure for the deposit is done not within grace days for roll over deposits and
*                    for the preclosure of deposit which has no roll over
*In Parameter      :
*Out Parameter     :
*Files  Used       : AZ.ACCOUNT               As             I/O          Mode
*                    REDO.AZ.DISCOUNT.RATE
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  14/06/2010       REKHA S            ODR-2009-10-0336 N.18      Initial Creation
* 11 MAR 2011       H GANESH            PACS00032973  - N.18     Modified as per issue
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.AZ.DISCOUNT.RATE

    GOSUB INIT
    GOSUB MAIN.PROCESS
RETURN
*--------------------------------------------------------------------------------------------------------
INIT:
*****
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.REDO.AZ.DISCOUNT.RATE = 'F.REDO.AZ.DISCOUNT.RATE'
    F.REDO.AZ.DISCOUNT.RATE = ''
    CALL OPF(FN.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE)

RETURN
*--------------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*************

    GOSUB GET.LOCAL.FLD.POS
    GOSUB GET.INT.RATE
    IF COMI GT Y.PENAL.PER THEN
        ETEXT = 'AZ-PENAL.PER.CHECK':@FM:Y.PENAL.PER
        CALL STORE.END.ERROR
        ETEXT=''
        RETURN
    END
    Y.PENAL.PERCENT=COMI
*CALL APAP.REDORETAIL.REDO.AZ.PENAL.AMT.CALC(Y.PENAL.PERCENT,Y.PREC.DEP.DAYS,PEN.AMT)
    CALL APAP.REDORETAIL.redoAzPenalAmtCalc(Y.PENAL.PERCENT,Y.PREC.DEP.DAYS,PEN.AMT);* MANUAL R22 CODE CONVERSION
    R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PENAL.AMT>=PEN.AMT
    R.NEW(TT.TE.AMOUNT.LOCAL.1)= R.AZ.ACCOUNT<AZ.PRINCIPAL>-PEN.AMT
RETURN
*----------------------------------------------------------------
GET.INT.RATE:
*----------------------------------------------------------------
    Y.DEPOSIT.ID = R.NEW(TT.TE.ACCOUNT.1)
    CALL F.READ(FN.AZ.ACCOUNT,Y.DEPOSIT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.AZ.ERR)
    Y.PREC.DEP.DAYS=R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.PR.DEP.DAY>
    Y.CATEGORY = R.AZ.ACCOUNT<AZ.CATEGORY>
    CALL F.READ(FN.REDO.AZ.DISCOUNT.RATE,Y.CATEGORY,R.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE,Y.AZ.DIS.ERR)
    IF R.REDO.AZ.DISCOUNT.RATE THEN
        GOSUB GET.PENAL.RATE
    END ELSE
        Y.PENAL.PER=0
        RETURN
    END

RETURN

*--------------------------------------------------------------------------------------------------------------
GET.PENAL.RATE:
*--------------------------------------------------------------------------------------------------------------

    Y.DATE.RANGE =R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.DATE.RANGE>
    Y.DATE.RNG.CNT=DCOUNT(Y.DATE.RANGE,@VM)
    Y.VAR1=1
    Y.START.DATE=FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',1)
    IF Y.PREC.DEP.DAYS LT Y.START.DATE THEN         ;* If suppose preclosure happens before the pre-defined days in REDO.AZ.DISCOUNT.RATE.(i.e if DATE.RANGE begins from 30 days and preclosure happens with that days)
        Y.PENAL.PER=0
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

RETURN
*--------------------------------------------------------------------------------------------------------------
GET.LOCAL.FLD.POS:
******************
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.TT.PENAL.AMT':@VM:'L.TT.PR.DEP.DAY'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.PENAL.AMT = FLD.POS<1,1>
    LOC.L.TT.PR.DEP.DAY = FLD.POS<1,2>

RETURN
*--------------------------------------------------------------------------------------------------------------
END
