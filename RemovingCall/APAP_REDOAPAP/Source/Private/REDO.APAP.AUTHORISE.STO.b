* @ValidationCode : MjotMTQ5Mzk0ODc0MDpDcDEyNTI6MTY4NDgzNjAzMzQzNTpJVFNTOi0xOi0xOjUzOToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 539
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   IF STATEMENT ADDED , VM to @VM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.AUTHORISE.STO
*----------------------------------------------------------------------------------------------------*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.DATES
    $INSERT I_F.REDO.APAP.STO.DUPLICATE
    $INSERT I_F.STANDING.ORDER
    $INSERT I_System
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.BENEFICIARY
*----------------------------------------------------------------------------------------------------*

    FN.STANDING.ORDER = 'F.STANDING.ORDER'
    F.STANDING.ORDER = ''
    CALL OPF(FN.STANDING.ORDER,F.STANDING.ORDER)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'

    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY  = ''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

    FN.AI.REDO.OFS.QUEUE = 'F.AI.REDO.OFS.QUEUE'
    F.AI.REDO.OFS.QUEUE  = ''
    CALL OPF(FN.AI.REDO.OFS.QUEUE,F.AI.REDO.OFS.QUEUE)

    LOC.REF.APP = 'STANDING.ORDER'
    LOC.REF.FIELD = 'L.STO.START.DTE':@VM:'L.STO.COMP.ID':@VM:'L.STO.CON.NO'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)
    Y.STO.START.DTE.POS = LOC.REF.POS<1,1>
    Y.STO.COMP.ID.POS   = LOC.REF.POS<1,2>
    Y.STO.CON.NO        = LOC.REF.POS<1,3>

    CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,ERR.MPAR)
    VAR.CURRENCY  = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.CCARD.CUR>
    VAR.INT.ACCT  = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.CCARD.INT.ACCT>
    VAR.LOAN.ACCT = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.ACCOUNT.NO>
    VAR.TXN.CODE  = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.TRANSACTION.CODE>



    CUST.ID = System.getVariable("EXT.CUSTOMER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
        CUST.ID = ""
    END                     ;*R22 AUTO CODE CONVERSION - END


    Y.ORIGIN.ACCT.NO        =  R.NEW(REDO.SO.ORIGIN.ACCT.NO)
    Y.STO.START.DATE        =  R.NEW(REDO.SO.STO.START.DATE)
    Y.CURRENT.END.DATE      =  R.NEW(REDO.SO.CURRENT.END.DATE)
    Y.CURRENT.AMOUNT.BAL    =  R.NEW(REDO.SO.CURRENT.AMOUNT.BAL)
    Y.STO.CURRENT.FREQUENCY =  R.NEW(REDO.SO.CURRENT.FREQUENCY)
    Y.PAYMENT.DETAILS       =  R.NEW(REDO.SO.PAYMENT.DETAILS)
    Y.CURRENCY              =  R.NEW(REDO.SO.CURRENCY)
    Y.COMPANY.NAME          =  R.NEW(REDO.SO.COMPANY.NAME)
    Y.CONTRACT.NO           =  R.NEW(REDO.SO.CONTRACT.NO)
    Y.LOAN.ACCT.NO          =  R.NEW(REDO.SO.LOAN.ACCT.NO)

    OFS.FUNCTION = 'I'
    PROCESS.ACTIVITY.ID = Y.ORIGIN.ACCT.NO
    APP.NAME = "STANDING.ORDER"
    OFSVERSION = ''

    CALL F.READ(FN.ACCOUNT,Y.ORIGIN.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR)
    Y.COMPANY.CODE=R.ACCOUNT<AC.CO.CODE>

    IF PGM.VERSION EQ ',AI.REDO.LOAN.PMT.CONFIRM' THEN
        Y.CPTY.ACCT.NO = System.getVariable('CURRENT.CREDIT.ACCT.NO')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CPTY.ACCT.NO = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.CPTY.ACCT.NO> = Y.CPTY.ACCT.NO
        Y.BEN.ID = System.getVariable('CURRENT.BEN.ID')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.BEN.ID = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.BENEFICIARY.ID> = Y.BEN.ID
        R.STANDING.ORDER<STO.CURRENT.AMOUNT.BAL>  = Y.CURRENT.AMOUNT.BAL
        R.STANDING.ORDER<STO.CURRENT.END.DATE> = Y.CURRENT.END.DATE
        R.STANDING.ORDER<STO.LOCAL.REF,Y.STO.START.DTE.POS> = Y.STO.START.DATE
        R.STANDING.ORDER<STO.CURRENT.FREQUENCY> = Y.STO.CURRENT.FREQUENCY
        R.STANDING.ORDER<STO.CURRENCY>          = Y.CURRENCY
        R.STANDING.ORDER<STO.PAYMENT.DETAILS>   = Y.PAYMENT.DETAILS
        R.STANDING.ORDER<STO.SIGNATORY>         = CUST.ID
        OFSVERSION = APP.NAME:",AI.REDO.APAP.BEN.PAYMENT"       ;* Set it to the application:"," as Build Record doesn't use APP.NAME
        NO.OF.AUTH = 0
    END

    IF PGM.VERSION EQ ',AI.REDO.LOAN.OWN.CONFIRM' THEN
        Y.CURRENT.UNP.BILL = System.getVariable('CURRENT.UNP.BILL')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.UNP.BILL = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,1> = Y.CURRENT.UNP.BILL
        Y.CURRENT.ARR.AMT  = System.getVariable('CURRENT.ARR.AMT')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.ARR.AMT = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,2> = Y.CURRENT.ARR.AMT
        Y.CURRENT.PART.AMT = System.getVariable('CURRENT.PART.AMT')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.PART.AMT = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,3> = Y.CURRENT.PART.AMT
        Y.CPTY.ACCT.NO = System.getVariable('CURRENT.CREDIT.ACCT.NO')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CPTY.ACCT.NO = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.CPTY.ACCT.NO> = Y.CPTY.ACCT.NO
        R.STANDING.ORDER<STO.CURRENT.AMOUNT.BAL>  = Y.CURRENT.AMOUNT.BAL
        R.STANDING.ORDER<STO.CURRENT.END.DATE> = Y.CURRENT.END.DATE
        R.STANDING.ORDER<STO.LOCAL.REF,Y.STO.START.DTE.POS> = Y.STO.START.DATE
        R.STANDING.ORDER<STO.CURRENT.FREQUENCY> = Y.STO.CURRENT.FREQUENCY
        R.STANDING.ORDER<STO.CURRENCY>          = Y.CURRENCY
        R.STANDING.ORDER<STO.PAYMENT.DETAILS>   = Y.PAYMENT.DETAILS
        R.STANDING.ORDER<STO.SIGNATORY>         = CUST.ID
        OFSVERSION = APP.NAME:",AI.REDO.OWN.ACCT.PAYMENT"       ;* Set it to the application:"," as Build Record doesn't use APP.NAME
        NO.OF.AUTH = 0
    END

    IF PGM.VERSION EQ ',AI.REDO.LOAN.OT.CONFIRM' THEN


        Y.CURRENT.BEN.NAME = System.getVariable('CURRENT.BEN.NAME')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.BEN.NAME = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,1> = Y.CURRENT.BEN.NAME
        Y.CURRENT.BEN.CEDULA  = System.getVariable('CURRENT.BEN.CEDULA')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.BEN.CEDULA = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,2> = Y.CURRENT.BEN.CEDULA
        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,3> = Y.LOAN.ACCT.NO
        Y.CURRENT.BEN.BNK = System.getVariable('CURRENT.BEN.BNK')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.BEN.BNK = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,4> = Y.CURRENT.BEN.BNK

        Y.BEN.ID = System.getVariable('CURRENT.BEN.ID')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.BEN.ID = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.BENEFICIARY.ID> = Y.BEN.ID


        R.STANDING.ORDER<STO.CURRENT.AMOUNT.BAL>  = Y.CURRENT.AMOUNT.BAL
        R.STANDING.ORDER<STO.CURRENT.END.DATE> = Y.CURRENT.END.DATE
        R.STANDING.ORDER<STO.LOCAL.REF,Y.STO.START.DTE.POS> = Y.STO.START.DATE
        R.STANDING.ORDER<STO.CURRENT.FREQUENCY> = Y.STO.CURRENT.FREQUENCY
        R.STANDING.ORDER<STO.CURRENCY>          = Y.CURRENCY
        R.STANDING.ORDER<STO.PAYMENT.DETAILS>   = Y.PAYMENT.DETAILS
        R.STANDING.ORDER<STO.SIGNATORY>         = CUST.ID
        OFSVERSION = APP.NAME:",AI.REDO.OTHER.BNK.PYMT"         ;* Set it to the application:"," as Build Record doesn't use APP.NAME
        NO.OF.AUTH = 0
    END


    IF PGM.VERSION EQ ',AI.REDO.PYMT.TP.CONFIRM' THEN

        Y.CURRENT.COMPANY = System.getVariable('CURRENT.COMPANY')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.COMPANY = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,1> = Y.CURRENT.COMPANY
*        Y.CURRENT.BILL.TYPE  = System.getVariable('CURRENT.BILL.TYPE')
*        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,2> = Y.CURRENT.BILL.TYPE
*        Y.CURRENT.BILL.COND = System.getVariable('CURRENT.BILL.COND')
*        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,3> = Y.CURRENT.BILL.COND
        Y.CURRENT.CONTRACT.NO = System.getVariable('CURRENT.CONTRACT.NO')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.CONTRACT.NO = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,4> = Y.CURRENT.CONTRACT.NO
        Y.CURRENT.CLIENT.NAME = System.getVariable('CURRENT.CLIENT.NAME')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.CLIENT.NAME = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,5> = Y.CURRENT.CLIENT.NAME
        Y.CURRENT.COMP.NAME = System.getVariable('CURRENT.COMP.NAME')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.COMP.NAME = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,7> = Y.CURRENT.COMP.NAME
        Y.CURRENT.MSD = System.getVariable('CURRENT.MSD')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.MSD = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,8> = Y.CURRENT.MSD

        R.STANDING.ORDER<STO.CURRENT.AMOUNT.BAL>  = Y.CURRENT.AMOUNT.BAL
        R.STANDING.ORDER<STO.CURRENT.END.DATE> = Y.CURRENT.END.DATE
        R.STANDING.ORDER<STO.LOCAL.REF,Y.STO.START.DTE.POS> = Y.STO.START.DATE
        R.STANDING.ORDER<STO.LOCAL.REF,Y.STO.COMP.ID.POS>  = Y.COMPANY.NAME
        R.STANDING.ORDER<STO.LOCAL.REF,Y.STO.CON.NO>       = Y.CONTRACT.NO
        R.STANDING.ORDER<STO.CURRENT.FREQUENCY> = Y.STO.CURRENT.FREQUENCY
        R.STANDING.ORDER<STO.CURRENCY>          = Y.CURRENCY
        R.STANDING.ORDER<STO.PAYMENT.DETAILS>   = Y.PAYMENT.DETAILS
        R.STANDING.ORDER<STO.SIGNATORY>         = CUST.ID
        OFSVERSION = APP.NAME:",AI.REDO.THIRD.PARTY.PYMT"       ;* Set it to the application:"," as Build Record doesn't use APP.NAME
        NO.OF.AUTH = 0
    END

    IF PGM.VERSION EQ ',AI.REDO.CARD.OT.CONFIRM' THEN
        Y.CURRENT.BEN.NAME = System.getVariable('CURRENT.BEN.NAME')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.BEN.NAME = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,1> = Y.CURRENT.BEN.NAME
        Y.CURRENT.BEN.CEDULA  = System.getVariable('CURRENT.BEN.CEDULA')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.BEN.CEDULA = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,2> = Y.CURRENT.BEN.CEDULA
        Y.CURRENT.CCARD.STR = System.getVariable('CURRENT.CCARD.STR')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.CCARD.STR = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,3> = Y.CURRENT.CCARD.STR
        Y.CURRENT.BEN.BNK = System.getVariable('CURRENT.BEN.BNK')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.BEN.BNK = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,4> = Y.CURRENT.BEN.BNK
        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,6> = R.NEW(REDO.SO.CARD.DISP.NO)

        Y.BEN.ID = System.getVariable('CURRENT.BEN.ID')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.BEN.ID = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.BENEFICIARY.ID> = Y.BEN.ID
        R.STANDING.ORDER<STO.CURRENT.AMOUNT.BAL>  = Y.CURRENT.AMOUNT.BAL
        R.STANDING.ORDER<STO.CURRENT.END.DATE> = Y.CURRENT.END.DATE
        R.STANDING.ORDER<STO.LOCAL.REF,Y.STO.START.DTE.POS> = Y.STO.START.DATE
        R.STANDING.ORDER<STO.CURRENT.FREQUENCY> = Y.STO.CURRENT.FREQUENCY
        R.STANDING.ORDER<STO.CURRENCY>          = Y.CURRENCY
        R.STANDING.ORDER<STO.PAYMENT.DETAILS>   = Y.PAYMENT.DETAILS
        R.STANDING.ORDER<STO.SIGNATORY>         = CUST.ID
        OFSVERSION = APP.NAME:",AI.REDO.OTHER.BNK.CARD.PYMT"    ;* Set it to the app
        NO.OF.AUTH = 0
    END

    IF PGM.VERSION EQ ',AI.REDO.CARD.PMT.CONFIRM' OR PGM.VERSION EQ ',AI.REDO.CARD.BEN.PMT.CONFIRM' THEN

        Y.CURRENT.CCARD.STR = System.getVariable('CURRENT.CARD.ORG.NO')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
            Y.CURRENT.CCARD.STR = ""
        END ;*R22 AUTO CODE CONVERSION - END

        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,1> = Y.CURRENT.CCARD.STR
        R.STANDING.ORDER<STO.FT.LOC.REF.DATA,4>=R.NEW(REDO.SO.CARD.DISP.NO)
        R.STANDING.ORDER<STO.CURRENCY>          = Y.CURRENCY
        IF PGM.VERSION EQ ',AI.REDO.CARD.BEN.PMT.CONFIRM' THEN
            Y.BEN.ID = System.getVariable('CURRENT.BEN.ID')
            IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
                Y.BEN.ID = ""
            END ;*R22 AUTO CODE CONVERSION - END

            R.STANDING.ORDER<STO.BENEFICIARY.ID> = Y.BEN.ID
        END
        R.STANDING.ORDER<STO.SIGNATORY>         = CUST.ID
        R.STANDING.ORDER<STO.CURRENT.AMOUNT.BAL>  = Y.CURRENT.AMOUNT.BAL
        R.STANDING.ORDER<STO.CURRENT.END.DATE> = Y.CURRENT.END.DATE
        R.STANDING.ORDER<STO.LOCAL.REF,Y.STO.START.DTE.POS> = Y.STO.START.DATE
        R.STANDING.ORDER<STO.CURRENT.FREQUENCY> = Y.STO.CURRENT.FREQUENCY
        R.STANDING.ORDER<STO.PAYMENT.DETAILS>   = Y.PAYMENT.DETAILS
        OFSVERSION = APP.NAME:",AI.REDO.CARD.PAYMENT.RD"        ;* Set it to the app
        IF PGM.VERSION EQ ',AI.REDO.CARD.BEN.PMT.CONFIRM' THEN
            OFSVERSION = APP.NAME:",AI.REDO.CARD.PAYMENT.RD.BEN"
        END
        NO.OF.AUTH = 0
    END
    ID.CMP.TEMP=ID.COMPANY
    ID.COMPANY=Y.COMPANY.CODE
    CALL OFS.BUILD.RECORD(APP.NAME, OFS.FUNCTION, "PROCESS", OFSVERSION, GTS.MODE, NO.OF.AUTH, PROCESS.ACTIVITY.ID, R.STANDING.ORDER, OFS.RECORD)
    ID.COMPANY=ID.CMP.TEMP

    OFS.SOURCE.ID = "OFSUPDATE"
*    CALL OFS.CALL.BULK.MANAGER(OFS.SOURCE.ID, OFS.RECORD, OFS.RESPONSE, TXN.COMMITED)
*    CALL OFS.POST.MESSAGE(OFS.RECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    ARC.OFS.ID = ID.NEW:'.':UNIQUE.TIME

*  WRITE OFS.RECORD TO F.AI.REDO.OFS.QUEUE,ARC.OFS.ID ;*Tus Start
    CALL F.WRITE(FN.AI.REDO.OFS.QUEUE,ARC.OFS.ID,OFS.RECORD) ;*Tus End

RETURN

END
