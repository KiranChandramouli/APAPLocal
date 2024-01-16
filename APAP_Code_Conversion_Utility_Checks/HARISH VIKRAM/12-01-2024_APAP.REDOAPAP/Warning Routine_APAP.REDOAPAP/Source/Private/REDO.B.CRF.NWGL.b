* @ValidationCode : MjotMTI1MzgxNzA5MTpDcDEyNTI6MTcwNTM4MjczNTU4ODozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Jan 2024 10:55:35
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
$PACKAGE APAP.REDOAPAP
*-----------------------------------------------------------------------------
* <Rating>-37</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.CRF.NWGL(ACCT.ID)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
* DATE              NAME                                REFERENCE       �          DESCRIPTION
* 31 JAN 2023     � Edwin Charles D                     ACCOUNTING-CR�             TSR479892
* 20 AUG 2023     � Edwin Charles D           �         ACCOUNTING-CR�             TSR637100
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_REDO.CRF.NWGL.COMMON
    $INSERT I_REDO.PREVAL.STATUS.COMMON



    Y.COMP = ID.COMPANY

****ACCOUNT RECORDS*****
    CALL F.READ(FN.ACCOUNT,ACCT.ID,ACCT.REC,F.ACCOUNT,ACCT.ERR)
    Y.CURRENCY = ACCT.REC<AC.CURRENCY>
    Y.CUSTOMER = ACCT.REC<AC.CUSTOMER>
    Y.COMPANY = ACCT.REC<AC.CO.CODE>
    IF Y.COMP EQ Y.COMPANY THEN

****CUSTOMER RECORD***
        CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
        Y.SECTOR = R.CUSTOMER<EB.CUS.SECTOR>

****ECB CONSOLE *****
        CALL F.READ(FN.ECB,ACCT.ID,R.EB.CONTRACT.BALANCES,F.ECB,EB.CONT.ERROR)
        CONSOLE.KEY = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>

*****CHECK BAL ENTRIES*****
*CALL REDO.V.CHECK.BAL.INT.ENTRIES(ACCT.ID,Y.BALANCE,BAL.CR.AMT,BAL.DR.AMT,Y.ACC.INT,INT.CR.AMT,INT.DR.AMT,Y.BAL.DET,Y.INT.DET)
*R22 MANUAL CONVERSION
        APAP.REDOAPAP.redoVCheckBalIntEntries(ACCT.ID,Y.BALANCE,BAL.CR.AMT,BAL.DR.AMT,Y.ACC.INT,INT.CR.AMT,INT.DR.AMT,Y.BAL.DET,Y.INT.DET)
        Y.BAL.ACC.NO = '' ; Y.BAL.NAME = '' ; Y.DES.BAL.ACC.NO = '' ; Y.INT.ACC.NO = '' ; Y.INT.NAME = '' ; Y.DES.INT.ACC.NO = '' ; Y.SIB.BAL.ACC.NO = '' ; Y.SIB.INT.ACC.NO = '' ; Y.REV.FLAG = ''
        Y.REV.FLAG = FIELD(Y.BAL.DET, '*', 6)
        Y.BAL.ACC.NO = FIELD(Y.BAL.DET, '*', 1)
        Y.BAL.NAME = FIELD(Y.BAL.DET, '*', 2)
        Y.DES.BAL.ACC.NO = FIELD(Y.BAL.DET, '*', 3)
*        Y.SIB.BAL.ACC.NO = FIELD(Y.BAL.DET, '*', 4)         ; * For ACCOUNTING CR, this account is not required
        RE.STAT.REP.ID.BAL = FIELD(Y.BAL.DET, '*', 5)

        Y.INT.ACC.NO = FIELD(Y.INT.DET, '*', 1)
        Y.INT.NAME = FIELD(Y.INT.DET, '*', 2)
        Y.DES.INT.ACC.NO = FIELD(Y.INT.DET, '*', 3)
*        Y.SIB.INT.ACC.NO = FIELD(Y.INT.DET, '*', 4)           ; * For ACCOUNTING CR, this account is not required
        RE.STAT.REP.ID.INT = FIELD(Y.INT.DET, '*', 5)

		IF Y.REV.FLAG THEN                                      ; * For ACCOUNTING CR, CR-DR accounts to be swapped
			Y.BAL.ACC.NO = FIELD(Y.BAL.DET, '*', 3)
			Y.DES.BAL.ACC.NO = FIELD(Y.BAL.DET, '*', 1)
            Y.INT.ACC.NO = FIELD(Y.INT.DET, '*', 3)
			Y.DES.INT.ACC.NO = FIELD(Y.INT.DET, '*', 1)
        END

        Y.DESC1 = '' ; Y.DESC2 = '' ; Y.DESC3 = ''          ;*TSR637100
        IF BAL.DR.AMT THEN
            Y.CRF.ID = RE.STAT.REP.ID.BAL:'.':Y.COMPANY:'*':Y.CURRENCY:'*':CONSOLE.KEY:'*':ACCT.ID:'*':'DEBIT'
            Y.DESC1 = Y.SIB.BAL.ACC.NO  ;*TSR637100
            Y.DESC2 = Y.BAL.NAME
            Y.DESC3 = Y.BAL.ACC.NO      ;*TSR637100
            Y.DEAL.BAL = BAL.DR.AMT
            Y.D.L.BAL = BAL.DR.AMT
            GOSUB DELETE.OLD.CREDIT.BAL
            GOSUB UPDATE.CRF.VALUES
        END
        Y.DESC1 = '' ; Y.DESC2 = '' ; Y.DESC3 = ''          ;*TSR637100

        IF BAL.CR.AMT THEN
            Y.CRF.ID = RE.STAT.REP.ID.BAL:'.':Y.COMPANY:'*':Y.CURRENCY:'*':CONSOLE.KEY:'*':ACCT.ID:'*':'CREDIT'
            Y.DESC1 = Y.SIB.BAL.ACC.NO
            Y.DESC2 = Y.BAL.NAME
            Y.DESC3 = Y.DES.BAL.ACC.NO  ;*TSR637100

            Y.DEAL.BAL = BAL.CR.AMT
            Y.D.L.BAL = BAL.CR.AMT

            GOSUB DELETE.OLD.CREDIT.BAL
            GOSUB UPDATE.CRF.VALUES
        END

        Y.DESC1 = '' ; Y.DESC2 = '' ; Y.DESC3 = ''          ;*TSR637100
        IF INT.DR.AMT THEN
            Y.CRF.ID = RE.STAT.REP.ID.INT:'.':Y.COMPANY:'*':Y.CURRENCY:'*':CONSOLE.KEY:'*':ACCT.ID:'*':'ACCCRINTERESTDEBIT'
            Y.DESC1 = Y.SIB.INT.ACC.NO  ;*TSR637100
            Y.DESC2 = Y.INT.NAME
            Y.DESC3 = Y.INT.ACC.NO      ;*TSR637100
            Y.DEAL.BAL = INT.DR.AMT
            Y.D.L.BAL = INT.DR.AMT
            GOSUB DELETE.OLD.CREDIT.INT
            GOSUB UPDATE.CRF.VALUES
        END
        Y.DESC1 = '' ; Y.DESC2 = '' ; Y.DESC3 = ''          ;*TSR637100
        IF INT.CR.AMT THEN
            Y.CRF.ID = RE.STAT.REP.ID.INT:'.':Y.COMPANY:'*':Y.CURRENCY:'*':CONSOLE.KEY:'*':ACCT.ID:'*':'ACCCRINTEREST'
            Y.DESC1 = Y.SIB.INT.ACC.NO  ;*TSR637100
            Y.DESC2 = Y.INT.NAME
            Y.DESC3 = Y.DES.INT.ACC.NO  ;*TSR637100

            Y.DEAL.BAL = INT.CR.AMT
            Y.D.L.BAL = INT.CR.AMT
            GOSUB DELETE.OLD.CREDIT.INT
            GOSUB UPDATE.CRF.VALUES
        END



        RETURN

DELETE.OLD.CREDIT.BAL:
**********************
        SEL.CMD  = "SELECT ":FN.RE.CRF.NWGL:" LIKE ...*":ACCT.ID:"*CREDIT"
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
        IF NO.OF.REC EQ 1 THEN
            DELETE F.RE.CRF.NWGL,SEL.LIST
        END
        RETURN

DELETE.OLD.CREDIT.INT:
**********************
        SEL.CMD  = "SELECT ":FN.RE.CRF.NWGL:" LIKE ...*":ACCT.ID:"*50000"
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
        IF NO.OF.REC EQ 1 THEN
            DELETE F.RE.CRF.NWGL,SEL.LIST
        END
        RETURN

UPDATE.CRF.VALUES:
******************

        R.RE.CRF.NWGL = '' ; RE.CRF.ERR = ''
*        CALL F.READ(FN.RE.CRF.NWGL,Y.CRF.ID,R.RE.CRF.NWGL,F.RE.CRF.NWGL,RE.CRF.ERR)
        CALL F.READU(FN.RE.CRF.NWGL,Y.CRF.ID,R.RE.CRF.NWGL,F.RE.CRF.NWGL,RE.CRF.ERR,'');* R22 UTILITY AUTO CONVERSION
        R.RE.CRF.NWGL<1> = Y.CURRENCY
        R.RE.CRF.NWGL<2> = Y.DESC1      ;*TSR637100
        R.RE.CRF.NWGL<3> = Y.DESC2
        R.RE.CRF.NWGL<4> = Y.DESC3      ;*TSR637100
        R.RE.CRF.NWGL<5> = Y.SECTOR
        R.RE.CRF.NWGL<11> = CONSOLE.KEY
        R.RE.CRF.NWGL<12> = Y.CUSTOMER
        R.RE.CRF.NWGL<13> = Y.DEAL.BAL
        R.RE.CRF.NWGL<14> = Y.D.L.BAL
        R.RE.CRF.NWGL<15> = '0.000'
        R.RE.CRF.NWGL<16> = TODAY
        CALL F.WRITE(FN.RE.CRF.NWGL,Y.CRF.ID,R.RE.CRF.NWGL)
        Y.DEAL.BAL = '' ; Y.D.L.BAL = ''          ;*TSR637100
        RETURN
    END
