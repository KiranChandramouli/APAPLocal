* @ValidationCode : MjotMTI2NTc5MDMxMTpDcDEyNTI6MTY4NDg1NDM4MTAwNDpJVFNTOi0xOi0xOjU0NzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 547
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.AZ.ACC.BAL(ACCOUNT.ID)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.AZ.ACC.BAL
*-------------------------------------------------------------------------

* Description : This multithread routine REDO.B.AZ.ACC.BAL will be executed during COB
* It will monitor the interest rate of the new deposit account.Get the customer id
* and select those AZ.ACCOUNT balance consolidated field is set as'Y'.Add respective
* principal amount with the new deposit account principal Compare the consolidated balance with the
* amount slab in PI table. Respective offer rate in the table will be defaulted
* to the new deposit account interest rate field
* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                   who                   Reference              
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM AND ++ TO += 1
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.CUSTOMER
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_REDO.B.AZ.ACC.BAL.COMMON

    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.JOINT.NUM = ''
    R.AZ.RECORD = ''
    Y.DEPOSIT.ID = ACCOUNT.ID

    CALL F.READ(FN.AZ.ACCOUNT,Y.DEPOSIT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)

    Y.APP.ID = R.AZ.ACCOUNT<AZ.ALL.IN.ONE.PRODUCT>
    CALL CACHE.READ(FN.AZ.PRODUCT.PARAMETER,Y.APP.ID,R.APP,APP.ERR)
    Y.RENEW.KEY = R.APP<AZ.APP.LOCAL.REF,POS.L.AP.RENEW.KEY>
    IF Y.RENEW.KEY THEN
        Y.PERIODIC.KEY = Y.RENEW.KEY
    END ELSE
        Y.PERIODIC.KEY = R.APP<AZ.APP.PERIODIC.RATE.KEY>
    END

    IF Y.PERIODIC.KEY EQ '' THEN
        RETURN
    END

    IF R.AZ.ACCOUNT<AZ.MATURITY.INSTR> EQ 'AUTOMATIC ROLLOVER'  THEN
        IF R.AZ.ACCOUNT<AZ.LOCAL.REF,LREF.POS> EQ 'Y' THEN
            GOSUB CHECK.NEXT
        END
        IF R.AZ.ACCOUNT<AZ.LOCAL.REF,LREF.POS> EQ 'N' THEN
            GOSUB CHECK.RATE
        END
    END

RETURN
*-----------------------------------------------------------------------------
CHECK.NEXT:
*-----------------------------------------------------------------------------

    Y.AZ.CUSTOMER.ID = R.AZ.ACCOUNT<AZ.CUSTOMER>
    Y.CONS.BAL       = R.AZ.ACCOUNT<AZ.PRINCIPAL>
    GOSUB GET.JOINT.DEPOSIT
    CALL F.READ(FN.AZ.CUSTOMER,Y.AZ.CUSTOMER.ID,R.AZ.CUSTOMER,F.AZ.CUSTOMER,AZ.CUS.ERR)
    R.AZ.CUSTOMER = R.AZ.CUSTOMER:@FM:Y.JOINT.NUM
    GOSUB CALC.CONSOL.BAL
    GOSUB CALC.INTEREST

    IF R.AZ.ACCOUNT<AZ.INTEREST.RATE> NE AZ.INT.RATE THEN
        GOSUB POST.OFS
    END

RETURN
*-----------------------------------------------------------------------------
GET.JOINT.DEPOSIT:
*-----------------------------------------------------------------------------

    CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.DEPOSIT.ID,R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF,JOIN.XREF.ERR)
    NO.OF.JOINT.ACCOUNT=DCOUNT(R.JOINT.CONTRACTS.XREF,@FM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE NO.OF.JOINT.ACCOUNT

        Y.ACC.NO=R.JOINT.CONTRACTS.XREF<Y.VAR1>
        CALL F.READ(FN.ACCOUNT,Y.ACC.NO,R.ACC,F.ACCOUNT,ACC.ERR)
        Y.JOINT.HOLD=R.ACC<AC.JOINT.HOLDER>
        LOCATE Y.AZ.CUSTOMER.ID IN Y.JOINT.HOLD<1,1> SETTING POS1 THEN
            Y.RELATION.CODE=R.ACC<AC.RELATION.CODE,POS1>
            IF (Y.RELATION.CODE GE 500 AND Y.RELATION.CODE LE 509) OR (Y.RELATION.CODE GE 600 AND Y.RELATION.CODE LE 609) THEN
                R.AZ=''
                CALL F.READ(FN.AZ.ACCOUNT,Y.ACC.NO,R.AZ,F.AZ.ACCOUNT,AZ.ERR)
                IF R.AZ NE '' AND R.AZ<AZ.CURRENCY> EQ R.AZ.ACCOUNT<AZ.CURRENCY> AND R.AZ<AZ.LOCAL.REF,LREF.POS> EQ 'Y' THEN
                    Y.JOINT.NUM<-1>=Y.ACC.NO
                END
            END
        END

        Y.VAR1 += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
CALC.CONSOL.BAL:
*-----------------------------------------------------------------------------

    Y.ACC.CNT=DCOUNT(R.AZ.CUSTOMER,@FM)
    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE Y.ACC.CNT
        Y.AZ.ID=R.AZ.CUSTOMER<Y.VAR2>
        IF Y.AZ.ID EQ '' OR Y.AZ.ID EQ Y.DEPOSIT.ID ELSE
            R.AZ = ''
            CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ,F.AZ.ACCOUNT,AZ.ERR)
            IF R.AZ.ACCOUNT<AZ.CURRENCY> EQ R.AZ<AZ.CURRENCY> AND R.AZ<AZ.LOCAL.REF,LREF.POS> EQ 'Y' THEN
                Y.CONS.BAL+=R.AZ<AZ.LOCAL.REF,POS.ORIG.DEP.AMT>
            END
        END
        Y.VAR2 += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------
CHECK.RATE:
*-----------------------------------------------------------------------------
    Y.CONS.BAL = R.AZ.ACCOUNT<AZ.PRINCIPAL>
    GOSUB CALC.INTEREST

    IF R.AZ.ACCOUNT<AZ.INTEREST.RATE> NE AZ.INT.RATE THEN
        GOSUB POST.OFS
    END

RETURN
*-----------------------------------------------------------------------------
CALC.INTEREST:
*-----------------------------------------------------------------------------

    LOAN.DEPOSIT = R.APP<AZ.APP.LOAN.DEPOSIT>
    AMOUNT = Y.CONS.BAL
    CURRENCY= R.AZ.ACCOUNT<AZ.CURRENCY>
    PI.KEY = Y.PERIODIC.KEY
    PI.METHOD = R.APP<AZ.APP.PI.METHOD>
    BI.KEY = ''
    BI.SPREAD = ''
    BI.OPERAND = ''
    BI.PERCENT = ''
    FIXED.RATE = ''

* Fix for PACS00383928 [Interest rate to be calculated based on the revised renewal date's]

*    START.DATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>
    END.DATE =   R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    GET.ROLL.TERM = R.AZ.ACCOUNT<AZ.ROLLOVER.TERM>
    SIGN = '+'

    CALL CDT('',END.DATE,'+1C')
    START.DATE = END.DATE

    IF GET.ROLL.TERM NE '' THEN
        CALL CALENDAR.DAY(END.DATE,SIGN,GET.ROLL.TERM)
        END.DATE = GET.ROLL.TERM
    END ELSE

* End else case is added to calculate the period when TERM is not specified

        OLD.START.DATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>
        OLD.END.DATE =   R.AZ.ACCOUNT<AZ.MATURITY.DATE>
        YDIFF.DAYS = 'C'
        CALL AZ.GET.REGION(GET.AZ.REGION)
        CALL CDD(GET.AZ.REGION,OLD.START.DATE,OLD.END.DATE,YDIFF.DAYS)
        CALL CDT(GET.AZ.REGION,END.DATE,'+':YDIFF.DAYS:'C')
    END

* End of Fix

    AZ.INT.RATE = ''
    CALL EB.CALC.INTEREST.RATE(LOAN.DEPOSIT,AMOUNT,CURRENCY,PI.KEY,PI.METHOD,BI.KEY,BI.SPREAD,BI.OPERAND,BI.PERCENT,FIXED.RATE,START.DATE,END.DATE,AZ.INT.RATE)

RETURN

*-----------------------------------------------------------------------------
POST.OFS:
*-----------------------------------------------------------------------------

    OFS.SOURCE.ID = 'REDO.OFS.AZ.UPDATE'
    APPLICATION.NAME = 'AZ.ACCOUNT'
    TRANS.FUNC.VAL = 'I'
    TRANS.OPER.VAL = 'PROCESS'
    APPLICATION.NAME.VERSION = 'AZ.ACCOUNT,REDO.AZ.UPDATE'
    NO.AUT = '0'
    OFS.MSG.ID = ''
    APPLICATION.ID = Y.DEPOSIT.ID
    OFS.POST.MSG = ''
    R.AZ.RECORD<AZ.ROLLOVER.INT.RATE> = DROUND(AZ.INT.RATE,2)
    OFS.ERR = ''
    CALL OFS.BUILD.RECORD(APPLICATION.NAME,TRANS.FUNC.VAL,TRANS.OPER.VAL,APPLICATION.NAME.VERSION,"",NO.AUT,APPLICATION.ID,R.AZ.RECORD,OFS.REQ.MSG)
    CALL OFS.POST.MESSAGE(OFS.REQ.MSG,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN
END
