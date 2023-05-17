* @ValidationCode : MjotMTYyMzA0NjUwNjpDcDEyNTI6MTY4NDIyMjc4MzQ0NDpJVFNTOi0xOi0xOjE5NTk6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1959
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.AR013.REPORT
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INSERT TAM.BP TO $INSERT AND F.READ TO CACHE.READ AND REMOVED FV.DATE AND FM TO @FM AND VAR1+ TO +=
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -CALL RTN FORMAT MODIFIED
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STMT.ACCT.CR
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM

    GOSUB LOAD.TABLE.OBJ
    GOSUB SET.CONSTANT.VAR
    GOSUB WRITE.FINAL.FILE

LOAD.TABLE.OBJ:
*--------------
    FN.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"; F.H.REPORTS.PARAM = ""; R.H.REPORTS.PARAM = ""; H.PARAM.ERR = ""
    CALL OPF(FN.H.REPORTS.PARAM, F.H.REPORTS.PARAM)

    FN.CUS = "F.CUSTOMER"; FV.CUS = ""; R.CUS = ""; CUS.ERR = ""
    CALL OPF(FN.CUS, FV.CUS)

    FN.ACC = "F.ACCOUNT"; FV.ACC = ""; R.ACC = ""; ACC.ERR = ""
    CALL OPF(FN.ACC, FV.ACC)

    FN.AZ.ACC = "F.AZ.ACCOUNT"; FV.AZ.ACC = ""; R.AZ.ACC = ""; AZ.ACC.ERR = ""
    CALL OPF(FN.AZ.ACC, FV.AZ.ACC)

    FN.STMT = "F.STMT.ACCT.CR"; FV.STMT = ""; R.STMT = ""; STMT.ERR = ""
    CALL OPF(FN.STMT, FV.STMT)

    FN.DATE = "F.DATES"; FV.DATE = ""; R.DATE = ""; ERR.DATE = ""
    CALL OPF(FN.DATE, FV.DATE)

    FN.TT = "F.TELLER$HIS"; FV.TT = ""; R.TT = ""; TT.ERR = ""
    CALL OPF(FN.TT, FV.TT)

    FN.FT = "F.FUNDS.TRANSFER$HIS"; FV.FT = ""; R.FT = ""; FT.ERR = ""
    CALL OPF(FN.FT, FV.FT)

    FN.IF.PARAM = 'F.REDO.APAP.INSTIT.FINANC.PARAM'; FV.IF.PARAM = ""; R.IF.PARAM = ""; IF.PARAM.ERR = ""
    CALL OPF(FN.IF.PARAM,FV.IF.PARAM)
*--------------

INIT:
*----
    Y.FD.1  = 0;   Y.FD.2  = ""; Y.FD.3  = ""; Y.FD.4   = ""; Y.FD.5  = ""; Y.FD.6  = ""; Y.FD.7   = ""
    Y.FD.8  = "";  Y.FD.9  = ""; Y.FD.10 = ""; Y.FD.11  = ""; Y.FD.12 = ""; Y.FD.13 = ""; Y.FD.14  = ""
    Y.FD.15 = "";  Y.FD.16 = ""; Y.FD.17 = "";  Y.FD.18 = ""; Y.FD.19 = ""

RETURN
*----

SET.CONSTANT.VAR:
*----------------
    GOSUB GET.FECHA.CORTE

    Y.REPORT.PARAM.ID = "REDO.AR013"
    FT.TXN.TYPE = ""
    TT.TXN.CODE = ""
    Y.DIR.NAME = ""

    CALL CACHE.READ(FN.H.REPORTS.PARAM, Y.REPORT.PARAM.ID, R.H.REPORTS.PARAM, H.PARAM.ERR)

    IF R.H.REPORTS.PARAM THEN
        Y.DIR.NAME = R.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.OUT.FILE.NAME = R.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NME.ARR = R.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>

        Y.CANT.RECS = DCOUNT(Y.FIELD.NME.ARR, @VM)

        FOR A = 1 TO Y.CANT.RECS STEP 1
            IF Y.FIELD.NME.ARR<1, A> EQ "FT.TXN.TYPE" THEN
                FT.TXN.TYPE =  FT.TXN.TYPE : " " :Y.FIELD.VAL.ARR<1, A>
            END

            IF Y.FIELD.NME.ARR<1, A> EQ "TT.TXN.CODE" THEN
                TT.TXN.CODE = TT.TXN.CODE : " " : Y.FIELD.VAL.ARR<1, A>
            END
        NEXT A
    END

    Y.DDMMYYYY  = Y.FECHA.CORTE[7,2]:Y.FECHA.CORTE[5,2]:Y.FECHA.CORTE[1,4]
    Y.FILE.NAME = Y.OUT.FILE.NAME : Y.DDMMYYYY : ".TXT"
    Y.REC.COUNT = 0
    Y.SECTOR = 7
RETURN
*----------------

GET.FECHA.CORTE:
*---------------
    CALL CACHE.READ(FN.DATE, "DO0010001", R.DATE, ERR.DATE) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED FV.DATE
    Y.FECHA.CORTE = R.DATE<EB.DAT.LAST.WORKING.DAY>
*--Y.FECHA.CORTE = TODAY

    Y.FECHA.VENC = Y.FECHA.CORTE
    CALL CDT('', Y.FECHA.VENC, "+1C")
    Y.FECHA.VENC = Y.FECHA.VENC[7,2]:"/":Y.FECHA.VENC[5,2]:"/":Y.FECHA.VENC[1,4]
    Y.FECHA.CORTE.R = Y.FECHA.CORTE[7,2]:"/":Y.FECHA.CORTE[5,2]:"/":Y.FECHA.CORTE[1,4]
RETURN
*---------------

WRITE.FINAL.FILE:
*----------------
    SEL.CMD = " SELECT " : FN.CUS : " WITH L.CU.TIPO.CL EQ 'PERSONA JURIDICA' '' AND SECTOR EQ '5003' '3005' '3003' '3002' '3004' '3102' '3110' "
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)

    OPENSEQ Y.DIR.NAME, Y.FILE.NAME TO FV.PTR ELSE
        CREATE FV.PTR ELSE
            CRT "CANNOT OPEN DIR ": Y.DIR.NAME
            STOP
        END
    END

    LOOP
        REMOVE Y.CUS.ID FROM SEL.LIST SETTING RTE.POS
    WHILE Y.CUS.ID DO
        CALL F.READ(FN.CUS, Y.CUS.ID, R.CUS, FV.CUS, CUS.ERR)

        CALL GET.LOC.REF("CUSTOMER", "L.CU.RNC", L.CU.RNC.POS)
        Y.CUS.RNC = R.CUS<EB.CUS.LOCAL.REF, L.CU.RNC.POS>
        Y.GRUPO.CONTRAPARTE = R.CUS<EB.CUS.SECTOR>

        GOSUB GET.FT.TRANSACTION

    REPEAT

    CLOSESEQ FV.PTR

RETURN
*----------------

GET.FT.TRANSACTION:
*------------------
    SEL.CMD1 = " SELECT " : FN.FT : " WITH CHARGED.CUSTOMER EQ " : Y.CUS.ID : " AND AUTH.DATE EQ " : Y.FECHA.CORTE : " AND TRANSACTION.TYPE EQ " : FT.TXN.TYPE
    CALL EB.READLIST(SEL.CMD1, SEL.LIST1, "", NO.OF.REC1, SEL.ERR1)

    LOOP
        REMOVE Y.FT.ID FROM SEL.LIST1 SETTING RTE.POS1
    WHILE Y.FT.ID DO

        CALL F.READ(FN.FT, Y.FT.ID, R.FT, FV.FT, FT.ERR)
        CALL F.READ(FN.ACC, R.FT<FT.DEBIT.ACCT.NO>, R.ACC, FV.ACC, ACC.ERR)
        Y.CUS.ID = R.ACC<AC.CUSTOMER>
        Y.CATEG = R.ACC<AC.CATEGORY>

        GOSUB GET.CATEGORY.ACC

        IF Y.TIPO.OPERACION EQ 2 THEN
            CALL F.READ(FN.ACC, R.FT<FT.CREDIT.ACCT.NO>, R.ACC, FV.ACC, ACC.ERR)
            Y.CATEG = R.ACC<AC.CATEGORY>
            GOSUB GET.CATEGORY.ACC

            IF Y.TIPO.OPERACION EQ 2 THEN
                Y.CUS.ID = R.ACC<AC.CUSTOMER>
            END ELSE
                RETURN
            END
        END

        IF Y.CATEG EQ '5010' AND R.FT<FT.RECORD.STATUS> NE 'REVE' THEN

            CALL F.READ(FN.CUS, Y.CUS.ID, R.CUS, FV.CUS, CUS.ERR)

            CALL GET.LOC.REF("CUSTOMER", "L.CU.RNC", L.CU.RNC.POS)
            Y.CUS.RNC = R.CUS<EB.CUS.LOCAL.REF, L.CU.RNC.POS>
            Y.GRUPO.CONTRAPARTE = R.CUS<EB.CUS.SECTOR>

            Y.REC.COUNT += 1
            Y.ACC.ID = R.FT<FT.DEBIT.ACCT.NO>
            Y.CR.INT.RATE = ""
            Y.TYPE.RATE = "TF"
            Y.TERM.IN.DAYS = 0

            FT.AMOUNT = R.FT<FT.CREDIT.AMOUNT>

            IF FT.AMOUNT EQ '' OR FT.AMOUNT EQ 0 THEN
                FT.AMOUNT = R.FT<FT.DEBIT.AMOUNT>
            END

*CALL L.APAP.INT.RATE.ACC(Y.ACC.ID, R.ACC, Y.CR.INT.RATE) ;*R22 MANAUAL CODE CONVERSION
            CALL APAP.LAPAP.lApapIntRateAcc(Y.ACC.ID, R.ACC, Y.CR.INT.RATE) ;*R22 MANAUAL CODE CONVERSION

            IF Y.CR.INT.RATE EQ 0 OR Y.CR.INT.RATE EQ "" THEN
                Y.TYPE.RATE = "NA"
            END

            GOSUB INIT
            GOSUB GET.GRUPO.CONTRAPARTE
            GOSUB GET.IF.PARAM
            GOSUB GET.TERM.CODE

            IF Y.TIPO.OPERACION EQ 2 THEN
                Y.SECTOR = 9
            END

            Y.FD.1  = Y.REC.COUNT
            Y.FD.2  = Y.CONTRAPARTE
            Y.FD.3  = "R"
            Y.FD.4  = "S"
            Y.FD.5  = Y.FECHA.CORTE.R
            Y.FD.6  = Y.FECHA.VENC
            Y.FD.7  = Y.FECHA.CORTE.R
            Y.FD.8  = "N"
            Y.FD.9  = "NA"
            Y.FD.10 = R.FT<FT.CREDIT.CURRENCY>
            Y.FD.11 = FMT(FT.AMOUNT,'R2%12')
            Y.FD.12 = DROUND(Y.CR.INT.RATE, 4)
            Y.FD.13 = Y.TYPE.RATE
*Y.FD.14 = Y.TIPO.OPERACION
            Y.FD.14 = 'IE'
            Y.FD.15 = "NA"
            Y.FD.16 = 1
            Y.FD.17 = 0
            Y.FD.18 = 0
            Y.FD.19 = 0

            R.AR011 = Y.FD.1:"|":Y.FD.2:"|":Y.FD.3:"|":Y.FD.4:"|":Y.FD.5:"|":Y.FD.6:"|":Y.FD.7:"|":Y.FD.8:"|":Y.FD.9:"|":Y.FD.10:"|":Y.FD.11:"|":Y.FD.12:"|":Y.FD.13:"|":Y.FD.14:"|":Y.FD.15:"|":Y.FD.16:"|":Y.FD.17:"|":Y.FD.18:"|":Y.FD.19:"|"

            WRITESEQ R.AR011 TO FV.PTR ELSE
                CRT "UNABLE TO WRITE TO FILE"
            END
        END

    REPEAT

RETURN
*------------------

GET.IF.PARAM:
*-----------------------
    Y.CO.INST  = ''; Y.NO.INST = '' ; Y.CONTRAPARTE = ''
    CALL F.READ(FN.IF.PARAM, Y.CUS.RNC, R.IF.PARAM, FV.IF.PARAM, IF.PARAM.ERR)
    IF (R.IF.PARAM) THEN
        Y.CO.INST  = R.IF.PARAM<3>
        Y.NO.INST = R.IF.PARAM<4>
        Y.CONTRAPARTE = R.IF.PARAM<2>
    END ELSE
        CALL F.READ(FN.IF.PARAM, Y.CUS.ID, R.IF.PARAM, FV.IF.PARAM, IF.PARAM.ERR)
        IF (R.IF.PARAM) THEN
            Y.CO.INST  = R.IF.PARAM<3>
            Y.NO.INST = R.IF.PARAM<4>
            Y.CONTRAPARTE = R.IF.PARAM<2>
        END ELSE
            Y.CO.INST  = 'NA'
            Y.NO.INST = '1'
            Y.CONTRAPARTE = R.CUS<EB.CUS.NAME.1>
        END
    END

RETURN
*-----------------------

GET.GRUPO.CONTRAPARTE:
*---------------------
    Y.SECTOR1 = Y.GRUPO.CONTRAPARTE
    IF Y.SECTOR1 EQ "3002" OR Y.SECTOR1 EQ "3003" OR Y.SECTOR1 EQ "3004" OR Y.SECTOR1 EQ "3005" OR Y.SECTOR1 EQ "3001" OR Y.SECTOR1 EQ "3102" THEN
        Y.GRUPO.CONTRAPARTE = "EIF"
    END
    IF Y.SECTOR1 EQ "3110" THEN
        Y.GRUPO.CONTRAPARTE = "IPU"
    END
    IF Y.SECTOR1 EQ "5003" THEN
        Y.GRUPO.CONTRAPARTE = "EFE"
    END

RETURN
*---------------------

GET.CATEGORY.ACC:
*----------------
    Y.CATEGORIES = "5010":@FM:"5001":@FM:"5030":@FM:"5002":@FM:"5032"
    LOCATE Y.CATEG IN Y.CATEGORIES<1> SETTING Y.LINKED.POS THEN
        Y.TIPO.OPERACION = 1
    END ELSE
        Y.TIPO.OPERACION = 2
    END

RETURN
*----------------

*------------
GET.TERM.CODE:
    BEGIN CASE
        CASE Y.TERM.IN.DAYS LE '90'
            Y.TERM.CODE = 1
        CASE Y.TERM.IN.DAYS GE '91' AND Y.TERM.IN.DAYS LE '180'
            Y.TERM.CODE = 2
        CASE Y.TERM.IN.DAYS GE '181' AND Y.TERM.IN.DAYS LE '360'
            Y.TERM.CODE = 3
        CASE Y.TERM.IN.DAYS GE '361' AND Y.TERM.IN.DAYS LE '720'
            Y.TERM.CODE = 4
        CASE Y.TERM.IN.DAYS GE '721' AND Y.TERM.IN.DAYS LE '1800'
            Y.TERM.CODE = 5
        CASE Y.TERM.IN.DAYS GE '1801'
            Y.TERM.CODE = 6
    END CASE

RETURN
*------------

END
