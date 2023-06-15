* @ValidationCode : MjotMTM0MjYxNTIxMzpDcDEyNTI6MTY4MjU5ODAxMzY3OTpzYW1hcjotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:13
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
SUBROUTINE REDO.AZ.AC.PREC.VAL.PENAL.PCNT
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.AC.PREC.VAL.PENAL.PCNT
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a VALIDATION ROUTINE attached to the field L.AZ.PENAL.PER of version
*                    AZ.ACCOUNT,FD.PRECLOSE. It is used to calculate and levy the PENALTY AMOUNT if the
*                    preclosure for the deposit is done not within grace days for roll over deposits and
*                    for the preclosure of deposit which has no roll over
*In Parameter      :
*Out Parameter     :
*Files  Used       : AZ.ACCOUNT               As             I/O          Mode
*                    REDO.AZ.DISCOUNT.RATE
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*  Date              Who                 Reference                  Description
*  ------            ------              -------------              ------------
*  14/06/2010        REKHA S             ODR-2009-10-0336 N.18      Initial Creation
*  11 MAR 2011       H GANESH            PACS00032973  - N.18       Modified as per issue
*  05 MAR 2019       GOPALA KRISHNAN R    PACS00736522               ISSUE FIX
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.AZ.DISCOUNT.RATE
    GOSUB MAIN.PROCESS
RETURN
*--------------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*--------------------------------------------------------------------------------------------------------------

* PACS00736522 - S
    PRINCIPAL.OLD = ""
    PRINCIPAL.OLD = R.NEW.LAST(AZ.ORIG.PRINCIPAL)
    IF PRINCIPAL.OLD THEN
        C$SPARE(399) = R.NEW.LAST(AZ.ORIG.PRINCIPAL)
    END ELSE
        C$SPARE(399) = R.NEW(AZ.PRINCIPAL)
    END
* PACS00736522 - E

    FN.REDO.AZ.DISCOUNT.RATE='F.REDO.AZ.DISCOUNT.RATE'
    F.REDO.AZ.DISCOUNT.RATE=''
    CALL OPF(FN.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE)

    GOSUB GET.LOCAL.FLD.POS
    Y.ROL.DATE   = R.NEW(AZ.ROLLOVER.DATE)
    IF Y.ROL.DATE THEN
        Y.FINAL.DATE = Y.ROL.DATE
    END
    ELSE
        Y.FINAL.DATE = R.NEW(AZ.MATURITY.DATE)
    END
    Y.GR.DAYS    = R.NEW(AZ.LOCAL.REF)<1,LOC.GRACE.DAYS>
    Y.GR.DAYS    = '+':Y.GR.DAYS:'W'
    CALL CDT('',Y.FINAL.DATE,Y.GR.DAYS)

    Y.PENAL.AMT  = R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.AMT>
    Y.PENAL.AMT  = ABS(Y.PENAL.AMT)

    IF Y.ROL.DATE THEN
        IF TODAY LT Y.FINAL.DATE THEN
            IF COMI NE Y.PENAL.AMT THEN
                ETEXT = 'AZ-PENAL.PER.CHECK':@FM:Y.PENAL.AMT
                CALL STORE.END.ERROR
                ETEXT = ''
            END
            RETURN
        END
    END

    GOSUB GET.INT.RATE

    IF COMI GT Y.PENAL.PER THEN
        ETEXT = 'AZ-PENAL.PER.CHECK':@FM:Y.PENAL.PER
        CALL STORE.END.ERROR
        ETEXT=''
        RETURN
    END
    Y.PEN.PERCENT=COMI
*APAP.REDORETAIL.REDO.AZ.PENAL.AMT.CALC(Y.PEN.PERCENT,Y.PREC.DEP.DAYS,PEN.AMT)
    APAP.REDORETAIL.redoAzPenalAmtCalc(Y.PEN.PERCENT,Y.PREC.DEP.DAYS,PEN.AMT);*MANUAL R22 CODE CONVERSION
    R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.AMT>=PEN.AMT

RETURN
*--------------------------------------------------------------------------------------------------------------
GET.INT.RATE:
*--------------------------------------------------------------------------------------------------------------
    Y.PREC.DEP.DAYS=R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PR.DEP.DAY>
    Y.CATEGORY=R.NEW(AZ.CATEGORY)
    CALL F.READ(FN.REDO.AZ.DISCOUNT.RATE,Y.CATEGORY,R.REDO.AZ.DISCOUNT.RATE,F.REDO.AZ.DISCOUNT.RATE,Y.AZ.DIS.ERR)
    IF R.REDO.AZ.DISCOUNT.RATE THEN
        GOSUB GET.PENAL.RATE
    END ELSE
        Y.PENAL.PER=0.00
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
    IF Y.PREC.DEP.DAYS LT Y.START.DATE THEN       ;* If suppose preclosure happens before the pre-defined days in REDO.AZ.DISCOUNT.RATE.(i.e if DATE.RANGE begins from 30 days and preclosure happens with that days)
        Y.PENAL.PER=0.00
        RETURN
    END
    LOOP
    WHILE Y.VAR1 LE Y.DATE.RNG.CNT
        Y.START.DATE=FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',1)
        Y.END.DATE=FIELD(Y.DATE.RANGE<1,Y.VAR1>,'-',2)
        IF Y.VAR1 EQ Y.DATE.RNG.CNT THEN          ;* This is for Default Case at last multivalue of table REDO.AZ.DISCOUNT.RATE
            Y.PENAL.PER=R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.PENAL.PERCENT,Y.VAR1>
        END
        IF Y.PREC.DEP.DAYS GE Y.START.DATE AND Y.PREC.DEP.DAYS LE Y.END.DATE THEN
            Y.PENAL.PER=R.REDO.AZ.DISCOUNT.RATE<REDO.DIS.RATE.PENAL.PERCENT,Y.VAR1>
            Y.VAR1 = Y.DATE.RNG.CNT+1   ;* Instead of Break Statement
        END
        Y.VAR1 += 1
    REPEAT

RETURN

*--------------------------------------------------------------------------------------------------------------
GET.LOCAL.FLD.POS:
******************
    APPL.ARRAY = 'AZ.ACCOUNT'
    FLD.ARRAY  = 'L.AZ.PENAL.AMT':@VM:'L.AZ.PR.DEP.DAY':@VM:'L.AZ.GRACE.DAYS'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.AZ.PENAL.AMT = FLD.POS<1,1>
    LOC.L.AZ.PR.DEP.DAY = FLD.POS<1,2>
    LOC.GRACE.DAYS      = FLD.POS<1,3>

RETURN
*--------------------------------------------------------------------------------------------------------------
END
