* @ValidationCode : Mjo1NDY1MTIzNDg6Q3AxMjUyOjE2ODI0MTIzNjQ4MDg6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.ST.BUY.SEL
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This routine is used as input routine to the versions SEC.TRADE,APAP.BUY.OWN.BOOK
*               and SEC.TRADE,APAP.SELL.OWN.BOOK
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.V.VAL.ST.BUY.SELL
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 10-Aug-2010      Naveenkumar N     ODR-2010-07-0082            Initial creation
* 28-Mar-2011      Pradeep S         PACS00051213                Mapping changed for Actual Coupon date
* 01-Apr-2011      Pradeep S         PACS00052348                Mapping changed for Actual Coupon date
* 27-Apr-2011      Pradeep S         PACS00056285                Moved the logic for actual coupon days from auth
*                                                                routine
*----------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion          VM TO @VM
*17-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER

    IF V$FUNCTION EQ 'I' THEN
        GOSUB INIT
        GOSUB ACD.CALC
        GOSUB PROCESS
    END
RETURN

*****
INIT:
*****

    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''

    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)

    FN.SEC.TRADE='F.SEC.TRADE'
    F.SEC.TRADE=''
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)

    LOC.REF.APPLICATION = 'SEC.TRADE'
    LOC.REF.FIELDS = 'L.ST.ACTCOUPDAY':@VM:'L.ST.HOLD.REF':@VM:'L.ST.CPTY.NAME'

    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,FIELD.POS)

    POS.ACTCOUPDAY = FIELD.POS<1,1>
    POS.HOLD.REF = FIELD.POS<1,2>
    L.ST.CPTY.NAME.POS = FIELD.POS<1,3>

RETURN


**********
ACD.CALC:
**********

    SM.SEC.CODE = R.NEW(SC.SBS.SECURITY.CODE)
    ST.INT.DAYS = R.NEW(SC.SBS.INTEREST.DAYS)

    CALL F.READ(FN.SECURITY.MASTER,SM.SEC.CODE,R.SECURITY.MASTER,F.SECURITY.MASTER,SECURITY.MASTER.ERR)
    IF R.SECURITY.MASTER NE '' THEN
        ACC.ST.DATE = R.SECURITY.MASTER<SC.SCM.ACCRUAL.START.DATE>

        BEGIN CASE
            CASE ACC.ST.DATE NE ''
                GOSUB ACC.ST.DATE.PROCESS

            CASE ACC.ST.DATE EQ ''
                GOSUB ACC.ST.DATE.PROCESS1
        END CASE

    END


RETURN

********************
ACC.ST.DATE.PROCESS:
********************

    INT.PAY.DATE = R.SECURITY.MASTER<SC.SCM.INT.PAYMENT.DATE>
    ACC.ST.DATE = R.SECURITY.MASTER<SC.SCM.ACCRUAL.START.DATE>
    NOF.DAYS = "C"
    INT.PAY.DATE='00000000'
    CALL CDD("",INT.PAY.DATE,ACC.ST.DATE,NOF.DAYS)

*PACS00051213 - S
* ST.ACT.COUP.DAYS.TEMP = NOF.DAYS
* Y.ACTODA = ST.INT.DAYS - ST.ACT.COUP.DAYS.TEMP

    ST.ACT.COUP.DAYS.TEMP = ABS(NOF.DAYS)
* Y.ACTODA = ST.ACT.COUP.DAYS.TEMP - ST.INT.DAYS ;*PACS00052348 - S/E
*PACS00051213 - E

    R.NEW(SC.SBS.LOCAL.REF)<1,POS.ACTCOUPDAY> = ST.ACT.COUP.DAYS.TEMP

RETURN

**********************
ACC.ST.DATE.PROCESS1:
**********************

    INT.PAY.DATE = R.SECURITY.MASTER<SC.SCM.INT.PAYMENT.DATE>
    ISS.DATE = R.NEW(SC.SBS.ISSUE.DATE)
    NOF.DAYS1 = "C"
    CALL CDD("",INT.PAY.DATE,ISS.DATE,NOF.DAYS1)
    ST.ACT.COUP.DAYS.TEMP = ABS(NOF.DAYS1)          ;*PACS00051213 - S/E

    R.NEW(SC.SBS.LOCAL.REF)<1,POS.ACTCOUPDAY> = ST.ACT.COUP.DAYS.TEMP

RETURN

*******
PROCESS:
********
* Check for Validation error
*
    Y.BROKER.TYPE = R.NEW(SC.SBS.BROKER.TYPE)
    Y.L.ST.CPTY.NAME = R.NEW(SC.SBS.LOCAL.REF)<1,L.ST.CPTY.NAME.POS>
*
    IF Y.BROKER.TYPE EQ "COUNTERPARTY" AND Y.L.ST.CPTY.NAME NE "" THEN
        AF = SC.SBS.BROKER.TYPE
        TEXT = "EB-INP.NOT.ALLOWED"
        CALL STORE.END.ERROR
    END

RETURN

END
