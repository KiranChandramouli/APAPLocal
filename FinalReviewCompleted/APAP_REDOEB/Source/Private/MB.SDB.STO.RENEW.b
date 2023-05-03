* @ValidationCode : MjoxMzIzNDY4MTg5OkNwMTI1MjoxNjgxOTc5NTk2OTA4OklUU1M6LTE6LTE6MTQ3MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Apr 2023 14:03:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1470
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.STO.RENEW(FT.ID,FT.STATUS)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-APR-2023     Conversion tool    R22 Auto conversion      = to EQ
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.DATES
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.MB.SDB.POST
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_F.MB.SDB.CHARGES
    $INSERT I_F.MB.SDB.STATUS

    GOSUB INITIALISE

    IF NOT(FT.READ.ERR)  THEN
        SDB.NO = TRIM(R.FUNDS.TRANSFER<FT.DEBIT.THEIR.REF>)
        SDB.COMPANY = TRIM(R.FUNDS.TRANSFER<FT.CREDIT.COMP.CODE>)
        MB.SDB.STATUS.ID = SDB.COMPANY:'.':SDB.NO
        R.MB.SDB.STATUS = ''; STATUS.YERR = ''; RETRY = 'P'
        CALL F.READU(FN.MB.SDB.STATUS,MB.SDB.STATUS.ID,R.MB.SDB.STATUS,F.MB.SDB.STATUS,STATUS.YERR,RETRY)
        IF R.MB.SDB.STATUS AND NOT(STATUS.YERR) THEN

            GOSUB READ.MB.SDB.PARAM

            IF R.MB.SDB.STATUS<SDB.STA.RENEW.FREQUENCY> LE R.DATES(EB.DAT.NEXT.WORKING.DAY) THEN
                SV.COMI = COMI
                COMI = R.MB.SDB.STATUS<SDB.STA.RENEW.FREQUENCY>; CALL CFQ
                R.MB.SDB.STATUS<SDB.STA.RENEW.FREQUENCY> = COMI
                COMI = SV.COMI
            END

            R.MB.SDB.STATUS<SDB.STA.LAST.RENEWAL.DATE> = R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>
            R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON> = R.MB.SDB.STATUS<SDB.STA.RENEW.FREQUENCY>[1,8]
            R.MB.SDB.STATUS<SDB.STA.RENT.AMT> = R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>
            COMM.AMT = R.FUNDS.TRANSFER<FT.COMMISSION.AMT,1>
            COMM.AMT = COMM.AMT[4, LEN(COMM.AMT)-3] + 0
            R.MB.SDB.STATUS<SDB.STA.RENT.VAT> = COMM.AMT
            R.MB.SDB.STATUS<SDB.STA.TOTAL.CHARGE.AMT> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT> + R.MB.SDB.STATUS<SDB.STA.RENT.VAT>

            AMORT.AMT = 0
            IF R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT> GT 0 THEN
                AMORT.AMT = R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT>
            END

            IF AMORT.AMT GT 0 AND RENT.ACCT NE RENT.PL THEN
                GOSUB AMORTISE.CHARGES
            END

            IF RENT.ACCT NE RENT.PL THEN
                R.MB.SDB.STATUS<SDB.STA.AMORT.AMT> = 0
                R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
            END ELSE
                R.MB.SDB.STATUS<SDB.STA.AMORT.AMT> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
                R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT> = 0
            END

*     R.MB.SDB.STATUS<SDB.STA.AMORT.AMT> = 0
*     R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>

            CALL F.WRITE(FN.MB.SDB.STATUS,MB.SDB.STATUS.ID,R.MB.SDB.STATUS)

            MB.SDB.CHARGES.ID = MB.SDB.STATUS.ID
            R.MB.SDB.CHARGES = ''; YERR = ''; RETRY = 'P'
            CALL F.READU(FN.MB.SDB.CHARGES,MB.SDB.CHARGES.ID,R.MB.SDB.CHARGES,F.MB.SDB.CHARGES,YERR,RETRY)

            R.MB.SDB.CHARGES<SDB.CHG.TXN.REF,-1> = 'Auto renew-':FT.ID
            R.MB.SDB.CHARGES<SDB.CHG.PERIODIC.RENT,-1> = 0
            R.MB.SDB.CHARGES<SDB.CHG.DISCOUNT.AMT,-1> = 0
            R.MB.SDB.CHARGES<SDB.CHG.VAT.AMOUNT,-1> = 0
            R.MB.SDB.CHARGES<SDB.CHG.DEPOSIT.AMT,-1> = 0
            R.MB.SDB.CHARGES<SDB.CHG.INITIAL.OFFER.AMT,-1> = 0
            R.MB.SDB.CHARGES<SDB.CHG.VAT.OFFER.AMT,-1> = 0
            R.MB.SDB.CHARGES<SDB.CHG.TOTAL.CHARGE.AMT,-1> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT> + R.MB.SDB.STATUS<SDB.STA.RENT.VAT>
            R.MB.SDB.CHARGES<SDB.CHG.REFUND.AMT,-1> = 0
            R.MB.SDB.CHARGES<SDB.CHG.PAY.REASON,-1> = 'Automatic Rent Renewal'
            R.MB.SDB.CHARGES<SDB.CHG.RENT.AMT,-1> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
            R.MB.SDB.CHARGES<SDB.CHG.RENT.VAT,-1> = R.MB.SDB.STATUS<SDB.STA.RENT.VAT>

            CALL F.WRITE(FN.MB.SDB.CHARGES,MB.SDB.CHARGES.ID,R.MB.SDB.CHARGES)
            IF RENEW.ADV THEN
                CALL PRODUCE.DEAL.SLIP(RENEW.ADV)
            END
        END
    END

RETURN

********************************************************************************************
INITIALISE:

    FN.MB.SDB.PARAM = 'F.MB.SDB.PARAM'
    F.MB.SDB.PARAM = ''
    CALL OPF(FN.MB.SDB.PARAM,F.MB.SDB.PARAM)

    FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'
    F.MB.SDB.STATUS = ''
    CALL OPF(FN.MB.SDB.STATUS,F.MB.SDB.STATUS)

    FN.MB.SDB.CHARGES = 'F.MB.SDB.CHARGES'
    F.MB.SDB.CHARGES = ''
    CALL OPF(FN.MB.SDB.CHARGES,F.MB.SDB.CHARGES)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    R.FUNDS.TRANSFER = ''; FT.READ.ERR = ''
    CALL F.READ(FN.FUNDS.TRANSFER,FT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.READ.ERR)

RETURN

********************************************************************************************
AMORTISE.CHARGES:


    FT.OFS.STR = ''
    FT.OFS.HEADER = 'FUNDS.TRANSFER,MB.SDB.TRF,,'
    FT.OFS.STR = ',TRANSACTION.TYPE::="AC"'
    FT.OFS.STR := ',DEBIT.ACCT.NO::=':DQUOTE(RENT.ACCT)
    FT.OFS.STR := ',DEBIT.CURRENCY::=':DQUOTE(LCCY)
    FT.OFS.STR := ',DEBIT.AMOUNT::=':DQUOTE(AMORT.AMT)
    FT.OFS.STR := ',DEBIT.THEIR.REF::=' : DQUOTE(SDB.NO)
    FT.OFS.STR := ',CREDIT.THEIR.REF::=' : DQUOTE(SDB.NO)
    FT.OFS.STR := ',CREDIT.ACCT.NO::=' : DQUOTE(RENT.PL)
    FT.OFS.STR := ',CREDIT.CURRENCY::=' : DQUOTE(LCCY)
    FT.OFS.STR := ',ORDERING.CUST::="999999"'
    SDB.OFS.STR = FT.OFS.HEADER:FT.OFS.STR

    GOSUB CALL.OGM
    IF OFS.ERR.MSG THEN
        TEXT = OFS.ERR.MSG
        CALL FATAL.ERROR('MB.SDB.STO.RENEW')
    END

RETURN


********************************************************************************************
READ.MB.SDB.PARAM:

    MB.SDB.PARAM.ID = SDB.COMPANY; R.MB.SDB.PARAM = ''; PARAM.YERR = ''
    CALL F.READ(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM,F.MB.SDB.PARAM,PARAM.YERR)

    RENT.ACCT = R.MB.SDB.PARAM<SDB.PAR.ADV.RENT.ACCT>
    RENT.PL = 'PL':R.MB.SDB.PARAM<SDB.PAR.RENT.PL>
    RENEW.ADV = R.MB.SDB.PARAM<SDB.PAR.RENEW.ADV>
    SDB.OFS.SOURCE = R.MB.SDB.PARAM<SDB.PAR.OFS.SOURCE>
    IF NOT(RENT.ACCT) THEN
        RENT.ACCT = RENT.PL
    END

RETURN

********************************************************************************************
CALL.OGM:

    OFS.SRC.ID = SDB.OFS.SOURCE; OFS.TXN.ID = ''; OFS.ERROR = ''; OFS.ERR.MSG = ''
    SDB.OFS1 = FIELD(SDB.OFS.STR, ',', 1, 2); SDB.OFS2 = FIELD(SDB.OFS.STR, ',', 4,9999)
    SDB.OFS.STR = SDB.OFS1 : ",//" : SDB.COMPANY : "," : SDB.OFS2
    SV.RUNNING.UNDER.BATCH = RUNNING.UNDER.BATCH
    RUNNING.UNDER.BATCH = 'YES'
    OFS.RESP   = ""; TXN.COMMIT = "" ;* R22 Manual conversion - Start
*CALL OFS.GLOBUS.MANAGER(OFS.SRC.ID, SDB.OFS.STR)
    CALL OFS.CALL.BULK.MANAGER(OFS.SRC.ID, SDB.OFS.STR, OFS.RESP, TXN.COMMIT) ;* R22 Manual conversion - End
    RUNNING.UNDER.BATCH = SV.RUNNING.UNDER.BATCH
    OFS.TXN.ID = FIELD(SDB.OFS.STR,'/',1)
    OFS.ERROR = FIELD(SDB.OFS.STR,'/',3,1)
    IF OFS.ERROR EQ '-1' THEN
        OFS.ERR.MSG = FIELD(SDB.OFS.STR,'/',4)[4,LEN(SDB.OFS.STR)]
    END

RETURN

********************************************************************************************
PROGRAM.END:

RETURN

END
