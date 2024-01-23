* @ValidationCode : MjozNTA5MzY1NTc6Q3AxMjUyOjE3MDM1ODM5MzI2Mjc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Dec 2023 15:15:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.EIR.MTHD(Y.ID)
*-----------------------------------------------------------------------------
* DESCRIPTION : This BATCH routine will look for the own book records from SC.TRADING.POSITION to reverse the CATEG.ENTRY and re-calculate interest accrual based on
*               effective interest rate method and raise accounting entries
*-----------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.B.EIR
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference           Description
* 23 Oct 2010      Naveen Kumar N     ODR-2010-07-0081    Initial creation
* 04-APR-2023     Conversion tool   R22 Auto conversion   -- to -=
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*26/12/2023         Suresh          R22 Manual Conversion    CALL routine modified
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.SC.TRADING.POSITION
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.CATEG.ENTRY
*   $INSERT I_F.SC.TRADING.POSITION ;*R22 Auto conversion
    $INSERT I_F.REDO.APAP.L.CONTRACT.BALANCES
    $INSERT I_REDO.B.EIR.MTHD.COMMON
    
    $USING AC.API ;*R22 Manual Conversion

    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-------

    Y.SING.ID = Y.ID

    CALL F.READ(FN.CATEG.ENTRY,Y.SING.ID,R.CATEG.ENTRY,F.CATEG.ENTRY,E.CATEG.ENTRY)

    IF R.CATEG.ENTRY<AC.CAT.NARRATIVE> NE 'ACCRUAL.ADJ' THEN
        GOSUB PROCESS1
    END

RETURN
*-----------------------------------------------------------------------------
PROCESS1:
*--------
    Y.SUB.ASSEST.TYPE = ''
    Y.SEC.TRADE.ID      = R.CATEG.ENTRY<AC.CAT.OUR.REFERENCE>
    Y.SEC.CODE          = FIELD(Y.SEC.TRADE.ID,".",2)

    CALL F.READ(FN.SECURITY.MASTER,Y.SEC.CODE,R.SECURITY.MASTER,F.SECURITY.MASTER,E.SECURITY.MASTER)

    IF R.SECURITY.MASTER THEN
        Y.SUB.ASSEST.TYPE   = R.SECURITY.MASTER<SC.SCM.SUB.ASSET.TYPE>
        Y.SM.PAR.VALUE      = R.SECURITY.MASTER<SC.SCM.PAR.VALUE>
    END

    IF Y.SUB.ASSEST.TYPE THEN
        LOCATE Y.SUB.ASSEST.TYPE IN SUB.ASSET.TYPE.TABLE.VAL<1,1> SETTING POS THEN
            IF R.CATEG.ENTRY<AC.CAT.NARRATIVE> NE 'ACCRUAL.ADJ' THEN
                GOSUB REVERSAL.ENTRY
                GOSUB CALCULATIONS
            END ELSE
                GOSUB REVERSAL.ENTRY
                GOSUB CALL.EB.ACCOUNTING
            END
        END
    END

RETURN
*-----------------------------------------------------------------------------
REVERSAL.ENTRY:
*--------------

    GOSUB FORM.CATEG.1

    COMMON.ARRAY = ''
    COMMON.ARRAY = LOWER(R.CATEG.ENT)

RETURN
*-----------------------------------------------------------------------------
CALCULATIONS:
*------------

    CALL F.READ(FN.SC.TRADING.POSITION,Y.SEC.TRADE.ID,R.SC.TRADING.POSITION,F.SC.TRADING.POSITION,E.SC.TRADING.POSITION)

    FACE.VALUE = R.SC.TRADING.POSITION<SC.TRP.CURRENT.POSITION>*Y.SM.PAR.VALUE

    INTEREST.RATE                                           = R.SECURITY.MASTER<SC.SCM.INTEREST.RATE>
    BASE.1                                                  = R.SECURITY.MASTER<SC.SCM.INTEREST.DAY.BASIS>
    BASE                                                    = BASE.1[3,3]
    ACCRUAL.START.DATE                                      = R.SECURITY.MASTER<SC.SCM.ACCRUAL.START.DATE>
    REGION.CODE                                             = ""

    COUPON.TENOR = "C"
    DAYS = "C"

    CALL CDD(REGION.CODE,ACCRUAL.START.DATE,TODAY,COUPON.TENOR)
    COUPON.TENOR += 1

    CALL CDD(REGION.CODE,ACCRUAL.START.DATE,TODAY,DAYS)
    DAYS += 1

    CALC1          = DROUND(INTEREST.RATE/BASE,6)
    CALC2          = (CALC1 * COUPON.TENOR)
    CALC3          = (1 + CALC2)

    CALC.EXP1      = (DAYS/COUPON.TENOR)

    CALC4          = PWR(CALC3,CALC.EXP1)
    EFF.RATE       = (CALC4 - 1)
    EFFECTIVE.RATE = (EFF.RATE / 100)
    EFFECTIVE.RATE = DROUND(EFFECTIVE.RATE,6)

    INT.ACCRUAL.VAL  = (FACE.VALUE*EFFECTIVE.RATE)
    INT.ACCRUAL.VAL  = DROUND(INT.ACCRUAL.VAL, 2)

*    CALL F.READ(FN.REDO.APAP.L.CONTRACT.BALANCES,Y.SEC.TRADE.ID,R.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES,E.REDO.APAP.L.CONTRACT.BALANCES)
    CALL F.READU(FN.REDO.APAP.L.CONTRACT.BALANCES,Y.SEC.TRADE.ID,R.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES,E.REDO.APAP.L.CONTRACT.BALANCES,"") ;*R22 Manual Conversion
  
    IF R.REDO.APAP.L.CONTRACT.BALANCES THEN
        R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.ACC.DATE>   = TODAY
        R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.EFF.RATE>   = DROUND(EFFECTIVE.RATE*100,4)
        ACCRUE.TO.DATE                                          = R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE>
        INT.ACCRUAL.VAL -= ACCRUE.TO.DATE
        TOT.VAL                                                 = (INT.ACCRUAL.VAL+ACCRUE.TO.DATE)
        R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.AMT>     = INT.ACCRUAL.VAL
        R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE> = TOT.VAL
    END ELSE
        GOSUB CALC.AS.OF.STERDAY
        R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE> = INT.ACCRUAL.VAL
        INT.ACCRUAL.VAL -= INT.ACCRUAL.VAL.STR
        R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.ACC.DATE>   = TODAY
        R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.EFF.RATE>   = DROUND(EFFECTIVE.RATE*100,4)
        R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.AMT>     = INT.ACCRUAL.VAL
    END

    CALL F.WRITE(FN.REDO.APAP.L.CONTRACT.BALANCES,Y.SEC.TRADE.ID,R.REDO.APAP.L.CONTRACT.BALANCES)

    GOSUB RAISE.ANOTHER.ENTRY

RETURN
*-----------------------------------------------------------------------------
CALC.AS.OF.STERDAY:
*------------------

    Y.DAY.BEFORE = TODAY
    CALL CDT('', Y.DAY.BEFORE, '-1C')

    COUPON.TENOR1 = "C"
    DAYS1 = "C"

    CALL CDD(REGION.CODE,ACCRUAL.START.DATE,Y.DAY.BEFORE,COUPON.TENOR1)
    COUPON.TENOR1 += 1

    CALL CDD(REGION.CODE,ACCRUAL.START.DATE,Y.DAY.BEFORE,DAYS1)
    DAYS1 += 1

    CALC1          = (INTEREST.RATE / BASE)
    CALC2          = (CALC1 * COUPON.TENOR1)
    CALC3          = (1 + CALC2)

    CALC.EXP1      = (DAYS1/COUPON.TENOR1)

    CALC4          = PWR(CALC3,CALC.EXP1)
    EFF.RATE       = (CALC4 - 1)
    EFFECTIVE.RATE1 = (EFF.RATE / 100)

    INT.ACCRUAL.VAL.STR  = (FACE.VALUE*EFFECTIVE.RATE1)
    INT.ACCRUAL.VAL.STR  = DROUND(INT.ACCRUAL.VAL.STR, 2)

RETURN
*-----------------------------------------------------------------------------
RAISE.ANOTHER.ENTRY:
*-------------------

    GOSUB FORM.CATEG
    COMMON.ARRAY<-1> =  LOWER(R.CATEG.ENT)

    GOSUB CALL.EB.ACCOUNTING

RETURN
*-----------------------------------------------------------------------------
CALL.EB.ACCOUNTING:
*------------------

*    CALL EB.ACCOUNTING("CHQ","SAO",COMMON.ARRAY,'')
    AC.API.EbAccounting("CHQ","SAO",COMMON.ARRAY,'') ;*R22 Manual Conversion

RETURN
*-----------------------------------------------------------------------------
FORM.CATEG.1:
*------------

    R.CATEG.ENT = ''
    R.CATEG.ENT<AC.CAT.ACCOUNT.NUMBER> = ''
    R.CATEG.ENT<AC.CAT.COMPANY.CODE> = ID.COMPANY
    R.CATEG.ENT<AC.CAT.AMOUNT.LCY> = R.CATEG.ENTRY<AC.CAT.AMOUNT.LCY> * -1
    R.CATEG.ENT<AC.CAT.NARRATIVE> = "Accrued"
    R.CATEG.ENT<AC.CAT.DEPARTMENT.CODE> = R.CATEG.ENTRY<AC.CAT.DEPARTMENT.CODE>
    R.CATEG.ENT<AC.CAT.ACCOUNT.OFFICER> = R.CATEG.ENTRY<AC.CAT.ACCOUNT.OFFICER>
    R.CATEG.ENT<AC.CAT.PL.CATEGORY> = R.CATEG.ENTRY<AC.CAT.PL.CATEGORY>
    R.CATEG.ENT<AC.CAT.PRODUCT.CATEGORY> = R.CATEG.ENTRY<AC.CAT.PRODUCT.CATEGORY>
    R.CATEG.ENT<AC.CAT.VALUE.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.CURRENCY> = R.CATEG.ENTRY<AC.CAT.CURRENCY>
    R.CATEG.ENT<AC.CAT.OUR.REFERENCE> = R.CATEG.ENTRY<AC.CAT.OUR.REFERENCE>
    R.CATEG.ENT<AC.CAT.TRANS.REFERENCE> = R.CATEG.ENTRY<AC.CAT.TRANS.REFERENCE>
    R.CATEG.ENT<AC.CAT.SYSTEM.ID> = R.CATEG.ENTRY<AC.CAT.SYSTEM.ID>
    R.CATEG.ENT<AC.CAT.BOOKING.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.EXPOSURE.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.VALUE.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.CURRENCY.MARKET> = R.CATEG.ENTRY<AC.CAT.CURRENCY.MARKET>

RETURN
*-----------------------------------------------------------------------------
FORM.CATEG:
*----------

    R.CATEG.ENT = ''
    R.CATEG.ENT<AC.CAT.ACCOUNT.NUMBER> = ''
    R.CATEG.ENT<AC.CAT.COMPANY.CODE> = ID.COMPANY
    R.CATEG.ENT<AC.CAT.AMOUNT.LCY> = INT.ACCRUAL.VAL
    R.CATEG.ENT<AC.CAT.NARRATIVE> = "Accrued"
    R.CATEG.ENT<AC.CAT.DEPARTMENT.CODE> = R.CATEG.ENTRY<AC.CAT.DEPARTMENT.CODE>
    R.CATEG.ENT<AC.CAT.ACCOUNT.OFFICER> = R.CATEG.ENTRY<AC.CAT.ACCOUNT.OFFICER>
    R.CATEG.ENT<AC.CAT.PL.CATEGORY> = R.CATEG.ENTRY<AC.CAT.PL.CATEGORY>
    R.CATEG.ENT<AC.CAT.PRODUCT.CATEGORY> = R.CATEG.ENTRY<AC.CAT.PRODUCT.CATEGORY>
    R.CATEG.ENT<AC.CAT.VALUE.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.CURRENCY> = R.CATEG.ENTRY<AC.CAT.CURRENCY>
    R.CATEG.ENT<AC.CAT.OUR.REFERENCE> = R.CATEG.ENTRY<AC.CAT.OUR.REFERENCE>
    R.CATEG.ENT<AC.CAT.TRANS.REFERENCE> = R.CATEG.ENTRY<AC.CAT.TRANS.REFERENCE>
    R.CATEG.ENT<AC.CAT.SYSTEM.ID> = R.CATEG.ENTRY<AC.CAT.SYSTEM.ID>
    R.CATEG.ENT<AC.CAT.BOOKING.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.EXPOSURE.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.VALUE.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.CURRENCY.MARKET> = R.CATEG.ENTRY<AC.CAT.CURRENCY.MARKET>

RETURN
*-----------------------------------------------------------------------------
END
