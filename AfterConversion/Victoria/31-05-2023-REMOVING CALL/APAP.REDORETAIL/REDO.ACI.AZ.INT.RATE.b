* @ValidationCode : Mjo0Mjk5MjMzMzk6Q3AxMjUyOjE2ODEyODM5MzY1ODA6SVRTUzotMTotMToxMzMxOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:48:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1331
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.ACI.AZ.INT.RATE(Y.AZ.ACCOUNT.ID,Y.ACI.OFS.ARRAY,Y.MATURITY.DATE,VAR.INT.RATE)
****************************************************************
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : RIYAS J
* Program Name  : REDO.ACI.AZ.INT.RATE
*-----------------------------------------------------------------------------

* Description :This call routine REDO.ACI.AZ.INT.RATE which will be executed during
* commit stage .It will default the interest rate of the new deposit az account.Get the
* customer id and select those AZ.ACCOUNT balance consolidated field is set as'Y'.Add respective
* principal amount with the new deposit account principal
* Compare the consolidated balance with the amount field in PI table. Respective offer rate
* in the table will be defaulted to the new deposit account interest rate field
* Linked with: AZ.ACCOUNT,INT
* In parameter : None
* out parameter : None

*---------------------------------------------------------------------------------
* Modification History :
*-----------------------
*
*  DATE             WHO           REFERENCE               DESCRIPTION
* 28 03 2012       RIYAS J        PACS00188349            INITIAL CREATION
* 09-Nov-2017      Gopal R        PACS00632061            Updation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 FM TO @FM, VM TO @VM
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.CUSTOMER
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.PERIODIC.INTEREST
    $INSERT I_F.ACCOUNT.CREDIT.INT
*

    GOSUB INIT
    GOSUB PROCESS

RETURN
*
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
*
    Y.JOINT.NUM=''

    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.AZ.CUSTOMER='F.AZ.CUSTOMER'
    F.AZ.CUSTOMER=''
    CALL OPF(FN.AZ.CUSTOMER,F.AZ.CUSTOMER)

    FN.PERIODIC.INTEREST='F.PERIODIC.INTEREST'
    F.PERIODIC.INTEREST=''
    CALL OPF(FN.PERIODIC.INTEREST,F.PERIODIC.INTEREST)

    FN.AZ.PRODUCT.PARAMETER='F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER=''
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.CREDIT.INT = 'F.ACCOUNT.CREDIT.INT'
    F.ACCOUNT.CREDIT.INT = ''
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

    FN.JOINT.CONTRACTS.XREF='F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF=''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)


    OFS.ACCT.CAP = ''
    Y.OFS.POST.ARRAY = ''
    VAR.INT.RATE = ''
    OFS.SRC.ID = 'REINV.DEPOSIT'

    LREF.APP='AZ.ACCOUNT':@FM:'AZ.PRODUCT.PARAMETER'
    LREF.FIELD='L.AZ.BAL.CONSOL':@VM:'ORIG.DEP.AMT':@FM:'L.AP.RENEW.KEY'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    POS.L.AZ.BAL.CONSOL = LREF.POS<1,1>
    POS.ORIG.DEP.AMT = LREF.POS<1,2>
    POS.L.AP.RENEW.KEY = LREF.POS<2,1>

RETURN
*
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
**************************
* New Deposit Account
**************************
*

    Y.CONSAL.COND=''

    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ACCOUNT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,ERR.AZ.ACCOUNT)
    Y.CUR=R.AZ.ACCOUNT<AZ.CURRENCY>
    Y.INT.LIQ.ACC = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
    Y.PRINCIPAL=R.AZ.ACCOUNT<AZ.PRINCIPAL>
    VAR1.INT.RATE = R.AZ.ACCOUNT<AZ.INTEREST.RATE>
    Y.AZ.PRODUCT.PARAMETER.ID=R.AZ.ACCOUNT<AZ.ALL.IN.ONE.PRODUCT>
    R.AZ.PRODUCT.PARAMETER=''
    CALL CACHE.READ(FN.AZ.PRODUCT.PARAMETER,Y.AZ.PRODUCT.PARAMETER.ID,R.AZ.PRODUCT.PARAMETER,PARA.ERR)
    Y.PERIODIC.KEY = R.AZ.PRODUCT.PARAMETER<AZ.APP.LOCAL.REF,POS.L.AP.RENEW.KEY>
    IF Y.PERIODIC.KEY EQ '' THEN
        RETURN
    END
    VAR.CONS.BAL =  R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.AZ.BAL.CONSOL>
*Based on the L.AZ.CONS.BAL value to calculate the consolidated amount from previous initial deposit
    IF VAR.CONS.BAL EQ 'Y' THEN
        Y.CONS.BAL = Y.PRINCIPAL
        GOSUB CHECK.CUSTOMER
        GOSUB CALC.CONSOL.BAL
    END ELSE
        Y.CONS.BAL = Y.PRINCIPAL
    END


    GOSUB PI.TABLE
    GOSUB OFS.FORMATION

RETURN

*------------------------------------------------------------------------
CHECK.CUSTOMER:
*-------------------------------------------------------------------------
* Read AZ.CUSTOMER to get other AZ.ACCOUNT
**********************************************
    Y.AZ.CUSTOMER.ID=R.AZ.ACCOUNT<AZ.CUSTOMER>
    R.AZ.CUSTOMER=''
    CALL F.READ(FN.AZ.CUSTOMER,Y.AZ.CUSTOMER.ID,R.AZ.CUSTOMER,F.AZ.CUSTOMER,AZ.CUS.ERR)
    GOSUB GET.JOINT.DEPOSIT
    R.AZ.CUSTOMER=R.AZ.CUSTOMER:@FM:Y.JOINT.NUM
RETURN
*
*-----------------------------------------------------------------------------
GET.JOINT.DEPOSIT:
*-----------------------------------------------------------------------------
* Gets the ID of AZ.ACCOUNT of this customer where he is a joint holder of that account
* This Gosub has been added for the PACS issue ref PACS00032518 - B.163

    CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.AZ.CUSTOMER.ID,R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF,XREF.ERR)
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
                IF R.AZ NE '' THEN
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
* Here we will calculating for consolidated principal amount when the L.AZ.BAL.CONSOL is not equal to 'N'
* for all the previous initial deposit for that customer under fall the same currency. In the authorization
* level to change the L.AZ.BAL.CONSOL as 'Y' in the previous deposit field
    Y.ACC.CNT=DCOUNT(R.AZ.CUSTOMER,@FM)
    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE Y.ACC.CNT
        Y.AZ.ID=R.AZ.CUSTOMER<Y.VAR2>
        IF Y.AZ.ID EQ '' OR Y.AZ.ID EQ ID.NEW ELSE
            CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ,F.AZ.ACCOUNT,AZ.ERR)
            IF R.AZ.ACCOUNT<AZ.CURRENCY> EQ R.AZ<AZ.CURRENCY> THEN
                Y.CONS.BAL+=R.AZ<AZ.LOCAL.REF,POS.ORIG.DEP.AMT>
            END
        END
        Y.VAR2 += 1
    REPEAT
RETURN
*---------------------------------------------------------------------------------
PI.TABLE:
*-----------------------------------------------------------------------------------


    LOAN.DEPOSIT = R.AZ.PRODUCT.PARAMETER<AZ.APP.LOAN.DEPOSIT>
    AMOUNT = Y.CONS.BAL
    CURRENCY= R.AZ.ACCOUNT<AZ.CURRENCY>
    PI.KEY = Y.PERIODIC.KEY
    PI.METHOD = R.AZ.PRODUCT.PARAMETER<AZ.APP.PI.METHOD>
    BI.KEY = ''
    BI.SPREAD = ''
    BI.OPERAND = ''
    BI.PERCENT = ''
    FIXED.RATE = ''
    START.DATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>
    END.DATE =   R.AZ.ACCOUNT<AZ.MATURITY.DATE>
*PACS00632061 - S
    IF RUNNING.UNDER.BATCH THEN
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
    END
*PACS00632061 - E
    AZ.INT.RATE = ''
    CALL EB.CALC.INTEREST.RATE(LOAN.DEPOSIT,AMOUNT,CURRENCY,PI.KEY,PI.METHOD,BI.KEY,BI.SPREAD,BI.OPERAND,BI.PERCENT,FIXED.RATE,START.DATE,END.DATE,AZ.INT.RATE)
    VAR.INT.RATE = DROUND(AZ.INT.RATE,2)
    Y.ACI.OFS.ARRAY<IC.ACI.CR.INT.RATE> = VAR.INT.RATE
RETURN
*---------------------------------------------------------------------------------
OFS.FORMATION:
*---------------------------------------------------------------------------------

    ACTUAL.APP.NAME1 = 'ACCOUNT.CREDIT.INT'
    OFS.FUNCTION1 = 'I'
    PROCESS1 = 'PROCESS'
    OFS.VERSION1 = ''
    GTSMODE1 = ''
    NO.OF.AUTH1 = '0'
    TRANSACTION.ID1 =  Y.INT.LIQ.ACC:'-':Y.MATURITY.DATE
    OFS.RECORD1 = ''
    VERSION1 = 'ACCOUNT.CREDIT.INT,RE'
    MSG.ID1 = ''
    OPTION1 = ''
    CALL OFS.BUILD.RECORD(ACTUAL.APP.NAME1,OFS.FUNCTION1,PROCESS1,VERSION1,GTSMODE1,NO.OF.AUTH1,TRANSACTION.ID1,Y.ACI.OFS.ARRAY,OFS.ACI)

    IF Y.ACI.OFS.ARRAY THEN
        Y.OFS.POST.ARRAY<-1> = OFS.ACI
    END

    IF Y.OFS.POST.ARRAY THEN
        MSG.ID = ''
        ERR.OFS = ''
        CALL OFS.POST.MESSAGE(Y.OFS.POST.ARRAY,MSG.ID,OFS.SRC.ID,ERR.OFS)
    END
RETURN
*---------------------------------------------------------------------------------
END
