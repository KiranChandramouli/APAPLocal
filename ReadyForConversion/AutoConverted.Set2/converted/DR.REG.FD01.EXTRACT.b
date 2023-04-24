SUBROUTINE DR.REG.FD01.EXTRACT(REC.ID)
*----------------------------------------------------------------------------
* Company Name   : APAP
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.FD01.EXTRACT
* Date           : 3-May-2013
*----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the TELLER Details for each Customer.
*----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 31-Jul-2013  Gangadhar.S.V.      PACS00309078 - Date format as DD/MM/YYYY and Remove space between NATION AND LEGAL.ID
* 26-Aug-2013  Gangadhar.S.V.      PACS00309078 - Receipt Number value to be picked from FX is L.FX.FXSN.NUM and for TELLER is L.TT.FXSN.NUM
*                                               - Report TT txns if CURRENCY not equal to DOP.
* 22-Jul-2014  Ashokkumar.V.P      PACS00309078 - Updated to fetch value from virtual table.
* 08-May-2015  Ashokkumar.V.P      PACS00309078 - Changed the rate field to DEAL.RATE.
* 14-May-2015  Ashokkumar.V.P      PACS00309078 - New field added FLD15 & 16.
* 24-Jun-2015  Ashokkumar.V.P      PACS00466000 - Mapping changes - Fetch customer details to avoid blank.
* 15-Jun-2018  Anthony Martinez    CN008702     - Add logic for cases in which the clients of account is of a minor
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TELLER
    $INSERT I_F.FOREX
    $INSERT I_F.COMPANY
    $INSERT I_F.FUNDS.TRANSFER;*PACS00309078
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.POS.MVMT.TODAY
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_DR.REG.FD01.EXTRACT.COMMON
*
    GOSUB PROCESS
RETURN

PROCESS:
*------*
    YTRANS.CODE = ''; R.POS.MVMT.TODAY = ''; ERR.POS.MVMT.TODAY = ''; YPOS.AMTLCY = ''
    CALL F.READ(FN.POS.MVMT.TDY,REC.ID,R.POS.MVMT.TODAY,F.POS.MVMT.TDY,ERR.POS.MVMT.TODAY)
    IF NOT(R.POS.MVMT.TODAY) THEN
        RETURN
    END

    YSYS.ID = R.POS.MVMT.TODAY<PSE.SYSTEM.ID>
    IF YSYS.ID NE 'TT' AND YSYS.ID NE 'FT' THEN
        RETURN
    END

    Y.TT.CCY = R.POS.MVMT.TODAY<PSE.CURRENCY>
    IF Y.TT.CCY EQ LCCY THEN
        RETURN
    END
    TRANS.ID = R.POS.MVMT.TODAY<PSE.OUR.REFERENCE>

    YTXN.CODE = R.POS.MVMT.TODAY<PSE.TRANSACTION.CODE>
    YPOS.AMTLCY = R.POS.MVMT.TODAY<PSE.AMOUNT.LCY>

    BEGIN CASE
        CASE YSYS.ID EQ 'TT'
            GOSUB TELLER.PROCESS
        CASE YSYS.ID EQ 'FT'
            GOSUB FUNDS.TRANSFER.PROCESS
    END CASE
RETURN

TELLER.PROCESS:
***************
    R.TELLER = ''; TELLER.ERR = ''; RETURN.MSG = ''
    CALL F.READ(FN.TELLER,TRANS.ID,R.TELLER,F.TELLER,TELLER.ERR)
    IF NOT(R.TELLER) THEN
        CALL EB.READ.HISTORY.REC(F.TELLER.HST,TRANS.ID,R.TELLER,TELLER.ERR)
    END
    YREC.STATUS = R.TELLER<TT.TE.RECORD.STATUS>
    IF NOT(R.TELLER) OR YREC.STATUS EQ 'REVE' THEN
        RETURN
    END

    YTRANS.CODE    = R.TELLER<TT.TE.TRANSACTION.CODE>
    ACCOUNT.NO     = R.TELLER<TT.TE.ACCOUNT.2>
    TRANS.LEGAL.ID = R.TELLER<TT.TE.LOCAL.REF,L.TT.LEGAL.ID.POS>

    R.CUSTOMER = ''; CUSTOMER.ERR = ''; CUS.ID = ''
    CUS.IDENT = ''; IDENT.TYPE = ''; CUS.NAME = ''; CUS.TYPE = ''

    IF TRANS.LEGAL.ID THEN
        IDENT.TYPE = FIELD(TRANS.LEGAL.ID,'.',1)
        CUS.IDENT  = FIELD(TRANS.LEGAL.ID,'.',2)
        CUS.NAME   = FIELD(TRANS.LEGAL.ID,'.',3)
        CUS.TYPE   = R.TELLER<TT.TE.LOCAL.REF,L.TT.CLNT.TYPE.POS>
        IDENT.NO   = CUS.IDENT

        IF IDENT.TYPE EQ 'PASAPORTE' THEN
            GOSUB GET.NATIONAL
            IDENT.NO = CUS.IDENT:"-":CUS.NATIONALITY
        END

        CALL LAPAP.GET.CUS.BY.IDENT(R.CUSTOMER, IDENT.NO, IDENT.TYPE, CUS.ID)

        IF CUS.ID EQ '' THEN
            IF IDENT.TYPE EQ 'CEDULA' THEN
                CUS.IDENT = CUS.IDENT[1,3]:'-':CUS.IDENT[4,7]:'-':CUS.IDENT[11,1]
            END
            IF IDENT.TYPE EQ 'RNC' THEN
                CUS.IDENT = CUS.IDENT[1,1]:'-':CUS.IDENT[2,2]:'-':CUS.IDENT[4,5]:'-':CUS.IDENT[9,1]
            END
            IF IDENT.TYPE EQ 'PASAPORTE' THEN
                CUS.IDENT = CUS.NATIONALITY:CUS.IDENT
            END
        END
    END

    IF LEN(ACCOUNT.NO) EQ 10 AND TRANS.LEGAL.ID EQ '' THEN
        CALL LAPAP.CUS.TUTOR.BY.ACCOUNT(ACCOUNT.NO, R.CUSTOMER, CUS.ID)
    END

    IF (R.TELLER<TT.TE.DATE.TIME>[7,4] LE REP.END.DATE) AND (R.TELLER<TT.TE.CURRENCY.1> NE LCCY OR R.TELLER<TT.TE.CURRENCY.2> NE LCCY) THEN
        GOSUB FETCH.TT.FIELDS

        IF FLD7 EQ 0 OR FLD7 EQ '' THEN
            RETURN
        END

        GOSUB UPDATE.WORKFILE
    END
RETURN

GET.FLD1.2.3:
*************
*--R.CUSTOMER = ''; CUSTOMER.ERR = '';
*--CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

    CUS.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
    CUS.GENDER = R.CUSTOMER<EB.CUS.GENDER>
    CU.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
    CUS.INDUST = R.CUSTOMER<EB.CUS.LOCAL.REF,L.APAP.INDUSTRY.POS>     ;*PACS00309078
    CUS.RESIDE = R.CUSTOMER<EB.CUS.RESIDENCE>

    GOSUB GET.RESIDENCE
RETURN
*----------------------------------------------------------------------------
GET.RESIDENCE:
**************
    FLD3 = ''
    COMI = CUS.ID
    CALL DR.REGN16.GET.CUST.TYPE
    FLD3 = COMI
RETURN

GET.FLD5:
*********
    BEGIN CASE
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ 'PERSONA FISICA' ;*-- OR R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ 'CLIENTE MENOR'
            FLD5 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA'
            FLD5 = R.CUSTOMER<EB.CUS.NAME.1>:' ':R.CUSTOMER<EB.CUS.NAME.2>
    END CASE

    IF NOT(FLD5) THEN
        FLD5 = CUS.NAME
    END

RETURN
*----------------------------------------------------------------------------
GET.FLD6:
*********
    BEGIN CASE
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ 'PERSONA FISICA' ;*-- OR R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ 'CLIENTE MENOR'
            FLD6 = R.CUSTOMER<EB.CUS.FAMILY.NAME>
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA'
            FLD6 = R.CUSTOMER<EB.CUS.SHORT.NAME>
    END CASE

    IF NOT(FLD6) THEN
        FLD6 = CUS.NAME
    END

RETURN

GET.FLD4:
*********
    OUT.ARR = ''
    CALL DR.REG.GET.CUST.TYPE(R.CUSTOMER, OUT.ARR)
    FLD3 = OUT.ARR<1>
    FLD4 = OUT.ARR<2>

    IF NOT(FLD3) THEN
        FLD3 = CUS.TYPE
    END

    IF NOT(FLD4) THEN
        FLD4 = CUS.IDENT
    END
*--BEGIN CASE
*--CASE R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS> NE ''
*--    FLD4 = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
*--    FLD4 = FLD4[1,3]:'-':FLD4[4,7]:'-':FLD4[11,1]
*--CASE R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS> NE ''
*--    FLD4 = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
*--    FLD4 = FLD4[1,1]:'-':FLD4[2,2]:'-':FLD4[4,5]:'-':FLD4[9,1]
*--CASE R.CUSTOMER<EB.CUS.LEGAL.ID,1> NE ''
*--    FLD4 = CUS.NATION:R.CUSTOMER<EB.CUS.LEGAL.ID,1>
*--CASE R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS> NE ''          ;*PACS00309078
*--    FLD4 = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>          ;*PACS00309078
*--END CASE
RETURN

*--GET.NC.FLD3.4.5.6:
******************
*--FLD3 = NC.CLNT.TYPE
*--OUT.ARR = ''

*--CALL DR.REG.GET.CUST.TYPE(R.CUSTOMER, OUT.ARR)
*--FLD4 = OUT.ARR<2>

*--FLD5 = LEGAL.VAL.3 ESTO SOBREESCRIBE EL NONMBRE Y APELLIDO DEL CLIENTE
*--FLD6 = LEGAL.VAL.3

*--BEGIN CASE
*--CASE LEGAL.VAL.1 EQ 'CEDULA'
*--    FLD4 = LEGAL.VAL.2[1,3]:'-':LEGAL.VAL.2[4,7]:'-':LEGAL.VAL.2[11,1]
*--CASE LEGAL.VAL.1 EQ 'RNC'
*--    FLD4 = LEGAL.VAL.2[1,1]:'-':LEGAL.VAL.2[2,2]:'-':LEGAL.VAL.2[4,5]:'-':LEGAL.VAL.2[9,1]
*--CASE LEGAL.VAL.1 EQ 'PASAPORTE'
*--    IF LEGAL.VAL.4 EQ '' AND LEGAL.VAL.2 NE '' THEN
*--        CUS.ID = LEGAL.VAL.2
*--        GOSUB GET.CUST.DET
*--    END
*--    IF LEGAL.VAL.4 EQ '' AND LEGAL.VAL.2 NE '' THEN
*--        GOSUB GET.NATIONAL
*--    END
*--    FLD4 = LEGAL.VAL.4:LEGAL.VAL.2
*--END CASE
*--RETURN

GET.NATIONAL:
*************
    FN.REDO.ID.CARD.CHECK = 'F.REDO.ID.CARD.CHECK'; F.REDO.ID.CARD.CHECK = ''
    CALL OPF(FN.REDO.ID.CARD.CHECK,F.REDO.ID.CARD.CHECK)

    SEL.CMD = "SELECT ":FN.REDO.ID.CARD.CHECK:" WITH IDENTITY.NUMBER EQ ":CUS.IDENT
    EXECUTE SEL.CMD RTNLIST PRT.LIST

    PRT.LIST = PRT.LIST<1>
    ERR.REDO.ID.CARD.CHECK = ''; R.REDO.ID.CARD.CHECK = ''
    CALL F.READ(FN.REDO.ID.CARD.CHECK,PRT.LIST,R.REDO.ID.CARD.CHECK,F.REDO.ID.CARD.CHECK,ERR.REDO.ID.CARD.CHECK)
    CUS.NATIONALITY = R.REDO.ID.CARD.CHECK<REDO.CUS.PRF.PASSPORT.COUNTRY>
RETURN

INIT.FLD:
*-------*
    FLD1 = '' ;FLD2 = '' ;FLD3 = '' ;FLD4 = '' ;FLD5 = '' ;FLD6 = '' ;FLD7 = '' ;FLD8 = '' ;FLD9 = ''
    FLD10 = '' ;FLD11 = '' ;FLD12 = '' ;FLD13 = '' ;FLD14 = ''; YFLD1 = ''; YPROCES.DTE = ''; YTXN.TYPE = ''
    NO.APPLY = ''
RETURN

*--GET.CUST.DET:
*************
*--    ERR.CUSTOMER.L.CU.CIDENT = ''; R.CUSTOMER.L.CU.CIDENT = ''
*--    CALL F.READ(FN.CUSTOMER.L.CU.CIDENT,CUS.ID,R.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT,ERR.CUSTOMER.L.CU.CIDENT)
*--    IF R.CUSTOMER.L.CU.CIDENT THEN
*--        CUS.ID = R.CUSTOMER.L.CU.CIDENT
*--        RETURN
*--    END
*--    ERR.CUSTOMER.L.CU.RNC = ''; R.CUSTOMER.L.CU.RNC = ''
*--    CALL F.READ(FN.CUSTOMER.L.CU.RNC,CUS.ID,R.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC,ERR.CUSTOMER.L.CU.RNC)
*--    IF R.CUSTOMER.L.CU.RNC THEN
*--        CUS.ID = R.CUSTOMER.L.CU.RNC
*--        RETURN
*--    END
*--    ERR.CUSTOMER.L.CU.PASS.NAT = ''; R.CUSTOMER.L.CU.PASS.NAT = ''
*--    CALL F.READ(FN.CUSTOMER.L.CU.PASS.NAT,CUS.ID,R.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT,ERR.CUSTOMER.L.CU.PASS.NAT)
*--    IF R.CUSTOMER.L.CU.PASS.NAT THEN
*--        CUS.ID = R.CUSTOMER.L.CU.PASS.NAT
*--        RETURN
*--    END
*--    RETURN

*----------------------------------------------------------------------------
FETCH.TT.FIELDS:
****************
*
    GOSUB INIT.FLD
    YFLD1 = R.TELLER<TT.TE.LOCAL.REF,L.TT.FXSN.NUM.POS>
    FLD1 = TRIM(YFLD1,'-','A')
    DTE2 = R.TELLER<TT.TE.VALUE.DATE.1>
    Y.GDAYS = 1
    FLD2 = DTE2[7,2]:'/':DTE2[5,2]:'/':DTE2[1,4]
*--CUS.ID = ''
*--CUS.ID = R.TELLER<TT.TE.CUSTOMER.1>
*--IF CUS.ID THEN
*--    CUS.ID = CUS.ID
*--END ELSE
*--    CUS.ID = R.TELLER<TT.TE.CUSTOMER.2>
*--END

*--NC.CLNT.TYPE = R.TELLER<TT.TE.LOCAL.REF,L.TT.CLNT.TYPE.POS>
*--TT.LEGAL.VAL = R.TELLER<TT.TE.LOCAL.REF,L.TT.LEGAL.ID.POS>
*--LEGAL.VAL.1 = FIELD(TT.LEGAL.VAL,'.',1)
*--LEGAL.VAL.2 = FIELD(TT.LEGAL.VAL,'.',2)
*--LEGAL.VAL.3 = FIELD(TT.LEGAL.VAL,'.',3)
*--LEGAL.VAL.4 = FIELD(TT.LEGAL.VAL,".",4)

    GOSUB GET.FLD1.2.3
    GOSUB GET.FLD4
    GOSUB GET.FLD5
    GOSUB GET.FLD6

*--IF CUS.ID EQ '' THEN
*--    GOSUB GET.NC.FLD3.4.5.6
*--END
*--IF NOT(FLD4) THEN
*--    YLEG.TT.DOC.DESC = R.TELLER<TT.TE.LOCAL.REF,L.TT.DOC.DESC.POS>
*--    CUS.ID = R.TELLER<TT.TE.LOCAL.REF,L.TT.DOC.NUM.POS>
*--    GOSUB GET.CUST.DET
*--    GOSUB GET.FLD1.2.3
*--    IF NOT(FLD2) THEN
*--        FLD2 = R.TELLER<TT.TE.LOCAL.REF,L.TT.CLIENT.NME.POS>
*--    END
*--    GOSUB GET.FLD4
*--    GOSUB GET.FLD5
*--    GOSUB GET.FLD6
*--END

    GOSUB GET.TT.FLD7.8.9
    GOSUB GET.TT.FLD10
    GOSUB GET.TT.FLD11
    GOSUB GET.TT.FLD12
*
*    FLD13 = R.COMPANY(EB.COM.NAME.ADDRESS)<1,3>    ;*PACS00309078
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,L.LOCALIDAD.POS> THEN
        FLD13 = R.CUSTOMER<EB.CUS.LOCAL.REF,L.LOCALIDAD.POS>
    END ELSE
        LOCATE R.TELLER<TT.TE.CO.CODE> IN Y.CMPTXN.VAL.ARR<1,1> SETTING TXNCMP2.POS THEN
            FLD13 = Y.CMPTXN.DIS.ARR<1,TXNCMP2.POS>
        END
    END
*
    GOSUB GET.TT.FLD14
RETURN

GET.TT.FLD7.8.9:
****************
    YTT.RATE = ''
    YTT.RATE = R.TELLER<TT.TE.DEAL.RATE>
    IF NOT(YTT.RATE) THEN
        YTT.RATE = R.TELLER<TT.TE.RATE.1>
    END
    IF NOT(YTT.RATE) THEN
        YTT.RATE = R.TELLER<TT.TE.RATE.2>
    END
    FLD8 = YTT.RATE
RETURN

GET.TT.FLD10:
*************
    YMARKER = R.TELLER<TT.TE.DR.CR.MARKER>
    BEGIN CASE
        CASE R.TELLER<TT.TE.CURRENCY.1> NE LCCY AND YMARKER EQ 'CREDIT' AND YPOS.AMTLCY[1,1] NE '-'
            FLD10 = "V"
            FLD9 = R.TELLER<TT.TE.CURRENCY.1>
            FLD7 = R.TELLER<TT.TE.AMOUNT.FCY.1>
        CASE R.TELLER<TT.TE.CURRENCY.1> NE LCCY AND YMARKER EQ 'DEBIT' AND YPOS.AMTLCY[1,1] EQ '-'
            FLD10 = "C"
            FLD9 = R.TELLER<TT.TE.CURRENCY.1>
            FLD7 = R.TELLER<TT.TE.AMOUNT.FCY.1>
        CASE R.TELLER<TT.TE.CURRENCY.2> NE LCCY AND YMARKER EQ 'DEBIT' AND YPOS.AMTLCY[1,1] NE '-'
            FLD10 = "V"
            FLD9 = R.TELLER<TT.TE.CURRENCY.2>
            FLD7 = R.TELLER<TT.TE.AMOUNT.FCY.2>
        CASE R.TELLER<TT.TE.CURRENCY.2> NE LCCY AND YMARKER EQ 'CREDIT' AND YPOS.AMTLCY[1,1] EQ '-'
            FLD10 = "C"
            FLD9 = R.TELLER<TT.TE.CURRENCY.2>
            FLD7 = R.TELLER<TT.TE.AMOUNT.FCY.2>
    END CASE

RETURN

GET.TT.FLD11:
*************
    TT.BUY = R.TELLER<TT.TE.LOCAL.REF,L.TT.FX.BUY.SRC.POS>
    TT.SEL = R.TELLER<TT.TE.LOCAL.REF,L.TT.FX.SEL.DST.POS>
    IF TT.BUY THEN
        FLD11 = TT.BUY[1,3]
    END ELSE
        FLD11 = TT.SEL[1,3]
    END
RETURN
*----------------------------------------------------------------------------
GET.TT.FLD12:
*************
    TT.PAY.METHOD = R.TELLER<TT.TE.LOCAL.REF,L.TT.PAY.METHOD.POS>
    TT.REV.M = R.TELLER<TT.TE.LOCAL.REF,L.TT.RCEP.MTHD.POS>
    IF TT.PAY.METHOD THEN
        TT.PAY.METHOD.VAL = "L.TT.PAY.METHOD*":TT.PAY.METHOD
        CALL F.READ(FN.EB.LOOKUP,TT.PAY.METHOD.VAL,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
        IF R.EB.LOOKUP THEN
            FLD12 = FIELD(R.EB.LOOKUP<EB.LU.DESCRIPTION,2>,'-',1)
        END
    END ELSE
        TT.REV.M.VAL = "L.TT.RCEP.MTHD*":TT.REV.M
        CALL F.READ(FN.EB.LOOKUP,TT.REV.M.VAL,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
        IF R.EB.LOOKUP THEN
            FLD12 = FIELD(R.EB.LOOKUP<EB.LU.DESCRIPTION,2>,'-',1)
        END
    END
RETURN

GET.TT.FLD14:
*************
    TT.PAY.METHOD = R.TELLER<TT.TE.LOCAL.REF,L.TT.PAY.METHOD.POS>
    IF TT.PAY.METHOD THEN
        TT.PAY.METHOD.VAL = "L.TT.PAY.METHOD*":TT.PAY.METHOD
        CALL F.READ(FN.EB.LOOKUP,TT.PAY.METHOD.VAL,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
        IF R.EB.LOOKUP THEN
            FLD14 = FIELD(R.EB.LOOKUP<EB.LU.DESCRIPTION,2>,'-',1)
        END
    END
RETURN

FUNDS.TRANSFER.PROCESS:
***********************
    R.FUNDS.TRANSFER = ''; RETURN.MSG = ''; FUNDS.TRANSFER.ERR = ''
    CALL F.READ(FN.FUNDS.TRANSFER,TRANS.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
    IF NOT(R.FUNDS.TRANSFER) THEN
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HST,TRANS.ID,R.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
    END
    YREC.STATUS = R.FUNDS.TRANSFER<FT.RECORD.STATUS>
    IF NOT(R.FUNDS.TRANSFER) OR YREC.STATUS EQ 'REVE' THEN
        RETURN
    END

    YTRANS.CODE    = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
    ACCOUNT.NO     = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
    TRANS.LEGAL.ID = R.FUNDS.TRANSFER<FT.LOCAL.REF, L.FT.LEGAL.ID.POS>

    R.CUSTOMER = ''; CUSTOMER.ERR = ''; CUS.ID = ''
    CUS.IDENT = ''; IDENT.TYPE = ''; CUS.NAME = ''; CUS.TYPE = ''

    IF TRANS.LEGAL.ID THEN
        IDENT.TYPE = FIELD(TRANS.LEGAL.ID,'.',1)
        CUS.IDENT  = FIELD(TRANS.LEGAL.ID,'.',2)
        CUS.NAME   = FIELD(TRANS.LEGAL.ID,'.',3)
        CUS.TYPE   = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.CLNT.TYPE.POS>

        CALL GET.LOC.REF("FUNDS.TRANSFER", "L.PAIS", L.PAIS.POS)
        CUS.COUNTRY = R.FUNDS.TRANSFER<FT.LOCAL.REF, L.PAIS.POS>

        CALL LAPAP.GET.CUS.BY.IDENT(R.CUSTOMER, CUS.IDENT, IDENT.TYPE, CUS.ID)

        IF CUS.ID EQ '' THEN
            IF IDENT.TYPE EQ 'CEDULA' THEN
                CUS.IDENT = CUS.IDENT[1,3]:'-':CUS.IDENT[4,7]:'-':CUS.IDENT[11,1]
            END
            IF IDENT.TYPE EQ 'RNC' THEN
                CUS.IDENT = CUS.IDENT[1,1]:'-':CUS.IDENT[2,2]:'-':CUS.IDENT[4,5]:'-':CUS.IDENT[9,1]
            END
            IF IDENT.TYPE EQ 'PASAPORTE' THEN
                CUS.IDENT = CUS.COUNTRY:CUS.IDENT
            END
        END
    END

    IF LEN(ACCOUNT.NO) EQ 10 AND TRANS.LEGAL.ID EQ '' THEN
        CALL LAPAP.CUS.TUTOR.BY.ACCOUNT(ACCOUNT.NO, R.CUSTOMER, CUS.ID)
    END

    IF R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY> EQ R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY> THEN
        RETURN
    END

    IF R.TELLER<TT.TE.DATE.TIME>[7,4] LE REP.END.DATE THEN
        GOSUB FETCH.FT.FIELDS

        IF FLD7 EQ 0 OR FLD7 EQ '' THEN
            RETURN
        END

        GOSUB UPDATE.WORKFILE
    END
RETURN

FETCH.FT.FIELDS:
****************
*
    GOSUB INIT.FLD
    YFLD1 = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.FXSN.NUM.POS>
    FLD1 = TRIM(YFLD1,'-','A')
    DTE1 = R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>
    YPROCES.DTE = R.FUNDS.TRANSFER<FT.PROCESSING.DATE>
    IF DTE1 AND YPROCES.DTE THEN
        Y.GDAYS = 'C'
        CALL CDD('',DTE1,YPROCES.DTE,Y.GDAYS)
    END
    FLD2 = DTE1[7,2]:'/':DTE1[5,2]:'/':DTE1[1,4]
    FT.TXN.TYPE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>

*--CUS.ID = ''
*--NC.CLNT.TYPE = ''; FT.LEGAL.VAL = ''
    BEGIN CASE
        CASE R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY> NE LCCY AND R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY> NE '' AND YPOS.AMTLCY[1,1] EQ '-'
            FLD10 =  "C"
*--CUS.ID = R.FUNDS.TRANSFER<FT.DEBIT.CUSTOMER>
            FLD7 = R.FUNDS.TRANSFER<FT.AMOUNT.DEBITED>[4,99]
            FLD9 = R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>
        CASE R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY> NE LCCY AND R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY> NE '' AND YPOS.AMTLCY[1,1] NE '-'
            FLD10 =  "V"
*--CUS.ID = R.FUNDS.TRANSFER<FT.CREDIT.CUSTOMER>
            FLD7 = R.FUNDS.TRANSFER<FT.AMOUNT.CREDITED>[4,99]
            FLD9 = R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>
    END CASE

*--NC.CLNT.TYPE = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.CLNT.TYPE.POS>
*--FT.LEGAL.VAL = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.LEGAL.ID.POS>
*--LEGAL.VAL.1 = FIELD(FT.LEGAL.VAL,'.',1)
*--LEGAL.VAL.2 = FIELD(FT.LEGAL.VAL,'.',2)
*--LEGAL.VAL.3 = FIELD(FT.LEGAL.VAL,'.',3)
*--LEGAL.VAL.4 = FIELD(FT.LEGAL.VAL,".",4)

*--IF LEGAL.VAL.1 EQ 'PASAPORTE' AND R.FUNDS.TRANSFER<FT.CREDIT.CUSTOMER> THEN
*--    CUS.ID = R.FUNDS.TRANSFER<FT.CREDIT.CUSTOMER>
*--END

    GOSUB GET.FLD1.2.3
    GOSUB GET.FLD4
    GOSUB GET.FLD5
    GOSUB GET.FLD6

*--IF CUS.ID EQ '' THEN
*--    GOSUB GET.NC.FLD3.4.5.6
*--END

*--IF NOT(CUS.ID) AND NOT(NC.CLNT.TYPE) AND NOT(FT.LEGAL.VAL) THEN
*--    CUS.ID = R.FUNDS.TRANSFER<FT.CHARGED.CUSTOMER>
*--    GOSUB GET.FLD1.2.3
*--    GOSUB GET.FLD4
*--    GOSUB GET.FLD5
*--    GOSUB GET.FLD6
*--END

*-- GOSUB GET.FT.FLD10
    GOSUB GET.FT.FLD8
    GOSUB GET.FT.FLD11
    GOSUB GET.FT.FLD12
*--
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,L.LOCALIDAD.POS> NE '' THEN
        FLD13 = R.CUSTOMER<EB.CUS.LOCAL.REF,L.LOCALIDAD.POS>
    END ELSE
        LOCATE R.FUNDS.TRANSFER<FT.CO.CODE> IN Y.CMPTXN.VAL.ARR<1,1> SETTING TXNCMP1.POS THEN
            FLD13 = Y.CMPTXN.DIS.ARR<1,TXNCMP1.POS>
        END
    END
    GOSUB GET.FT.FLD14
    ERR.FTTC = ''; R.FT.TXN.TYPE.CONDITION = ''; YTXN.COND = '';YFT.CHANEL = ''
    CALL F.READ(FN.FT.TXN.TYPE.CONDITION,FT.TXN.TYPE,R.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION,ERR.FTTC)
    IF R.FT.TXN.TYPE.CONDITION THEN
        YTXN.COND = R.FT.TXN.TYPE.CONDITION<FT6.LOCAL.REF,L.FTTC.CHANNELS.POS>
    END
    YFT.CHANEL = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.CHANNELS.POS>
    IF (YTXN.COND EQ 'ARC' OR YFT.CHANEL EQ 'BM') THEN
        FLD11 = "TCI"
        FLD12 = "TX"
        FLD14 = "TX"
    END
RETURN

GET.FT.FLD8:
************
    FLD8 = R.FUNDS.TRANSFER<FT.CUSTOMER.RATE>
    IF NOT(FLD8) THEN
        FLD8 = R.FUNDS.TRANSFER<FT.TREASURY.RATE>
    END
RETURN

GET.FT.FLD11:
*************
    FT.BUY = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.FX.BUY.SRC.POS>
    FT.SEL = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.FX.SEL.DST.POS>
    IF FT.BUY THEN
        FLD11 = FT.BUY[1,3]
    END ELSE
        FLD11 = FT.SEL[1,3]
    END
RETURN

GET.FT.FLD12:
*************
    FT.PAY.METHOD.ID = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.PAY.METHOD.POS>
    FT.REV.METHOD = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.RCEP.MTHD.POS>
    IF FT.PAY.METHOD.ID THEN
        FT.PAY.METHOD.VAL = "L.TT.PAY.METHOD*":FT.PAY.METHOD.ID       ;* S/E PACS00309078
        CALL F.READ(FN.EB.LOOKUP,FT.PAY.METHOD.VAL,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
        IF R.EB.LOOKUP THEN
            FLD12 = FIELD(R.EB.LOOKUP<EB.LU.DESCRIPTION,2>,'-',1)
        END
    END ELSE
        FT.REV.METHOD.VAL = "L.TT.RCEP.MTHD*":FT.REV.METHOD ;* S/E PACS00309078
        CALL F.READ(FN.EB.LOOKUP,FT.REV.METHOD.VAL,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
        IF R.EB.LOOKUP THEN
            FLD12 = FIELD(R.EB.LOOKUP<EB.LU.DESCRIPTION,2>,'-',1)
        END
    END
RETURN

GET.FT.FLD14:
*************
    FT.PAY.METHOD.ID = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.PAY.METHOD.POS>
    IF FT.PAY.METHOD.ID THEN
        FT.PAY.METHOD.VAL = "L.TT.PAY.METHOD*":FT.PAY.METHOD.ID       ;* S/E PACS00309078
        CALL F.READ(FN.EB.LOOKUP,FT.PAY.METHOD.VAL,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
        IF R.EB.LOOKUP THEN
            FLD14 = FIELD(R.EB.LOOKUP<EB.LU.DESCRIPTION,2>,'-',1)
        END
    END
RETURN

DAYS.FLD15:
***********
    IF Y.GDAYS LE '5' THEN
        FLD15 = 'SP'
    END
    IF Y.GDAYS GT '5' AND Y.GDAYS LE '365' THEN
        FLD15 = 'FD'
    END
    IF Y.GDAYS GT '365' THEN
        FLD15 = 'SW'
    END
    FLD16 = 'N'
RETURN

UPDATE.WORKFILE:
***************
    GOSUB DAYS.FLD15
    IF NOT(FLD1) THEN
        RETURN
    END
    FLD1 = FMT(FLD1,'R%15')
    FLD2 = FMT(FLD2,'L#10')
    FLD3 = FMT(FLD3,'L#2')
    FLD4 = FMT(FLD4,'L#27')
    FLD5 = FMT(FLD5,'L#40')
    FLD6 = FMT(FLD6,'L#40')
    FLD7 = FMT(FLD7,'R2%15')
    FLD8 = FMT(FLD8,'R4%7')
    FLD9 = FMT(FLD9,'L#3')
    FLD10 = FMT(FLD10,'L#1')
    FLD11 = FMT(FLD11,'L#3')
    FLD12 = FMT(FLD12,'L#2')
    FLD13 = FMT(FLD13,'L#6')
    FLD14 = FMT(FLD14,'L#2')
    FLD15 = FMT(FLD15,'L#2')
    FLD16 = FMT(FLD16,'L#1')
*
    RETURN.MSG = FLD1:FLD2:FLD3:FLD4:FLD5:FLD6:FLD7:FLD8:FLD9:FLD10:FLD11:FLD12:FLD13:FLD14:FLD15:FLD16
    IF RETURN.MSG THEN
        CALL F.WRITE(FN.DR.REG.FD01.TDYWORKFILE, REC.ID, RETURN.MSG)
    END
RETURN
*----------------------------------------------------------------------------
END