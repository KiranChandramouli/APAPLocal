* @ValidationCode : MjotMTgwMDY0Mjk1NzpDcDEyNTI6MTY4MTczMzg1NTE4ODpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Apr 2023 17:47:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.ST.BUY.SELL
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
* 07-May-2011      Pradeep S         PACS00037714                CDD validation ammended
* 10-Jun-2011      RIYAS             PACS00074324                COMMENT TE LINE 149-154
* 24-Jun-2011      Pradeep S         PACS00062662                PACS00074324 Changes reverted

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
*

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

    LOC.REF.APPLICATION = 'SEC.TRADE'
    LOC.REF.FIELDS = 'L.ST.ACTCOUPDAY':@VM:'L.ST.HOLD.REF':@VM:'L.ST.CPTY.NAME':@VM:'L.ST.CPTY'

    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,FIELD.POS)

    POS.ACTCOUPDAY = FIELD.POS<1,1>
    POS.HOLD.REF = FIELD.POS<1,2>
    L.ST.CPTY.NAME.POS = FIELD.POS<1,3>
    L.ST.CPTY.POS = FIELD.POS<1,4>

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

*PACS00037714 - S
    NOF.DAYS = ''
    IF INT.PAY.DATE NE '' AND ACC.ST.DATE NE '' THEN
        NOF.DAYS = "C"
        CALL CDD ("",INT.PAY.DATE,ACC.ST.DATE,NOF.DAYS)
    END
*PACS00037714 - E

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

*PACS00037714 - S
    NOF.DAYS1 = ''
    IF INT.PAY.DATE NE '' AND ISS.DATE NE '' THEN
        NOF.DAYS1 = "C"
        CALL CDD ("",INT.PAY.DATE,ISS.DATE,NOF.DAYS1)
    END
*PACS00037714 - E

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
    Y.L.ST.CPTY = R.NEW(SC.SBS.LOCAL.REF)<1,L.ST.CPTY.POS>
*PACS00074324-S
*PACS00062662-S
    IF Y.BROKER.TYPE EQ "COUNTERPARTY" AND Y.L.ST.CPTY NE "" THEN
        AF = SC.SBS.LOCAL.REF
        AV = L.ST.CPTY.POS
        ETEXT = "EB-INP.NOT.ALLOWED"
        CALL STORE.END.ERROR
    END
*PACS00062662-E
*PACS00074324-E
RETURN

END
