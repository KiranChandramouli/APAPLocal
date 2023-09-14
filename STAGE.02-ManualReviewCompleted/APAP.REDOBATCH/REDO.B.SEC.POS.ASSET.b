* @ValidationCode : MjoxNzc0NDEwNDI6Q3AxMjUyOjE2ODEzNjA5MzMyOTM6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 10:12:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.SEC.POS.ASSET(Y.FINAL.ARR)
*-----------------------------------------------------------------------------
*
* Developed By            : Vijayarani G
*
* Developed On            : 25-NOV-2013
*
* Development Reference   : 786942(FS-219-OA01)
*
* Development Description : This report has to be generated at the end of every month to report the investments made by the bank.
*                           The output is based on the securities investments and the Money Market placements made by the Bank.
*
* Attached To             : BATCH>BNK/REDO.B.SEC.POS.ASSET
*
* Attached As             : COB Routine
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* NA                     Thenmalar T                     18-Feb-2013                   Updated mapping positions
* Date                  who                   Reference
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM AND COMMENTED I_REDO.B.SEC.POS.ASSET.COMMON
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION - ADDING PACKAGE NAME FOR CALL ROUTINE
*-----------------------------------------------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_BATCH.FILES
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.SECURITY.POSITION
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.SEC.ACC.MASTER
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.SEC.POS.ASSET.COMMON
    $INSERT I_F.REDO.H.CUSTOMER.PROVISION
    $INSERT I_F.REDO.AZACC.DESC
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CATEGORY
    $INSERT I_F.DATES
    $INSERT I_F.SUB.ASSET.TYPE
    $INSERT I_F.SC.POS.ASSET
    $INSERT I_F.SEC.TRADE
*   $INSERT I_REDO.B.SEC.POS.ASSET.COMMON  ;*R22 AUTO CONVERSTION COMMENTED I_REDO.B.SEC.POS.ASSET.COMMON
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.REDO.CATEGORY.CIUU
    $INSERT I_F.STOCK.EXCHANGE
    $INSERT I_SC.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON


* </region>
*-----------------------------------------------------------------------------
*
*
    C$SPARE(451) = ''
    C$SPARE(452) = ''
    C$SPARE(453) = ''
    C$SPARE(454) = ''
    C$SPARE(455) = ''
    C$SPARE(456) = ''
    C$SPARE(457) = ''
    C$SPARE(458) = ''
    C$SPARE(459) = ''
    C$SPARE(460) = ''
    C$SPARE(461) = ''
    C$SPARE(462) = ''
    C$SPARE(463) = ''
    C$SPARE(465) = ''
    C$SPARE(466) = ''
    C$SPARE(467) = ''
    C$SPARE(468) = ''
    C$SPARE(469) = ''
    C$SPARE(470) = ''
    C$SPARE(471) = ''
    C$SPARE(472) = ''
    C$SPARE(473) = ''
    C$SPARE(474) = ''
    C$SPARE(476) = ''
    C$SPARE(477) = ''
    C$SPARE(478) = ''
    C$SPARE(479) = ''
    C$SPARE(480) = ''
    C$SPARE(481) = ''
    C$SPARE(482) = ''
    C$SPARE(483) = ''
    C$SPARE(484) = ''
    C$SPARE(485) = ''
    C$SPARE(486) = ''
    C$SPARE(487) = ''
    C$SPARE(488) = ''
    C$SPARE(489) = ''
    C$SPARE(490) = ''
    C$SPARE(491) = ''
    C$SPARE(464) = ''
    C$SPARE(475) = ''
    Y.PROV.INV = ''
*

    Y.LANG.CODE = R.COMPANY(EB.COM.LANGUAGE.CODE)

    Y.INV.DET = Y.FINAL.ARR
    Y.DEAL.TICKET = RIGHT(Y.INV.DET,10)

    IF Y.INV.DET[1,2] EQ "MM" THEN
        C$SPARE(463) = ''
        C$SPARE(474) = ''
        GOSUB MAIN.PROCESS.MM
    END ELSE

        CALL APAP.REDOBATCH.REDO.B.SEC.ASSET(Y.INV.DET) ;*R22 MANUAL CONVERSTION ADDING THE PACKAGE NAME
    END
*
RETURN

MAIN.PROCESS.MM:
*---------------
    Y.FINAL.MSG = ''
    GOSUB READ.MM.RECORD
    GOSUB READ.CUS.RECORD
    GOSUB READ.REDO.AZACC.DESC
*
    GOSUB ASSIGN.ISS.ID
    GOSUB FIND.CATGORY.VAL
    GOSUB DATE.OF.ACQUIS
    GOSUB FIND.MAT.DATE
    GOSUB CALC.MONTH.CNT
    GOSUB CALC.INT.SCH
    GOSUB FIND.EARLY.RET
    GOSUB FIND.PROV.INV
    GOSUB FIND.INT.RECEIVABLE
    GOSUB TYPE.OF.CUSTOMER

    Y.INVST.STATUS = "V"
    Y.PENALTY.RET = "0"
    Y.RATING = ''

    GOSUB FIND.LINK.TYPE

    IF Y.RELATION.CODE EQ '' THEN
        Y.LINK.TYPE = ''
        GOSUB ASSING.FIN.VAR
        GOSUB ASSING.FIN.VAL
        GOSUB READ.REDO.REPORT.TEMP
    END
*
RETURN


ASSIGN.NULL.VAL:
*---------------
    C$SPARE(480) = ''
    C$SPARE(481) = ''
    C$SPARE(482) = ''
    C$SPARE(483) = ''
    C$SPARE(484) = ''
*
RETURN

READ.MM.RECORD:
*--------------
    CALL F.READ(FN.MM,Y.INV.DET,R.MM,F.MM,MM.ERR)
    IF R.MM THEN
        Y.MAT.DATE = R.MM<MM.MATURITY.DATE>
        Y.CUSTOMER = R.MM<MM.CUSTOMER.ID>
        Y.ISSUE.DATE = R.MM<MM.VALUE.DATE>
        Y.INT.RATE = R.MM<MM.INTEREST.RATE>
        Y.BOOK.VALUE = R.MM<MM.PRINCIPAL>
        Y.CURRENCY = R.MM<MM.CURRENCY>
        Y.STATUS = R.MM<MM.STATUS>
        Y.COLL.ISS = R.MM<MM.LOCAL.REF,L.COLL.ISSUE.POS>
        Y.ISIN.CODE = R.MM<MM.LOCAL.REF,L.ISIN.CODE.POS>
        Y.COUPON.TYPE = R.MM<MM.LOCAL.REF,L.COUPON.TYPE.POS>
        Y.L.INV.FACILITY = R.MM<MM.LOCAL.REF,L.INV.FACILITY.POS>
    END ELSE
        GOSUB ASSIGN.NULL.VAL
    END

*
RETURN

READ.CUS.RECORD:
*---------------
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
    IF R.CUSTOMER THEN
        Y.RISK.CAT.INV = R.CUSTOMER<EB.CUS.LOCAL.REF,L.RISK.CAT.INV.POS>
        Y.MNTHLY.OUT = R.CUSTOMER<EB.CUS.NET.MONTHLY.OUT>
        Y.ISSUER.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,L.ISSUER.TYPE.POS>
        Y.L.CU.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
        Y.NATIONALITY = R.CUSTOMER<EB.CUS.NATIONALITY>
*20140317(S)
        NAME.1 = R.CUSTOMER<EB.CUS.NAME.1,Y.LANG.CODE>
        NAME.2 = R.CUSTOMER<EB.CUS.NAME.2,Y.LANG.CODE>

        IF NAME.1 EQ '' THEN
            NAME.1 = R.CUSTOMER<EB.CUS.NAME.1,1>
        END

        IF NAME.2 EQ '' THEN
            NAME.2 = R.CUSTOMER<EB.CUS.NAME.2,1>
        END

        Y.ISSUER.DES = NAME.1:" ":NAME.2
*20140317(E)

    END
*
RETURN

ASSIGN.ISS.ID:
*--------------
*
    IF Y.L.CU.RNC EQ '' THEN
        Y.LGL.ID = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
        Y.ISSUER.ID  = Y.NATIONALITY:Y.LGL.ID
    END ELSE
        Y.ISSUER.ID = Y.L.CU.RNC
    END
*
RETURN

READ.REDO.AZACC.DESC:
*-------------------

    CALL F.READ(FN.REDO.AZA.DES,Y.INV.DET,R.REDO.AZA.DES,F.REDO.AZA.DES,ERR.REDO.AZA.DES)
    IF R.REDO.AZA.DES THEN
        AZ.DES.POS1 = '';AZ.DES.POS2 = '';AZ.DES.POS3 = ''
        Y.AZ.ASSET.TYPE = R.REDO.AZA.DES<AZACC.ASSET.TYPE>
        FINDSTR Y.ACCT.CODE IN R.REDO.AZA.DES<AZACC.ASSET.TYPE> SETTING AZ.DES.POS1,AZ.DES.POS2,AZ.DES.POS3 THEN

            Y.ACCT.CODE.VAL  = R.REDO.AZA.DES<AZACC.DESC><AZ.DES.POS1,AZ.DES.POS2>
        END
        AMT.POS1 = '';AMT.POS2 = '';AMT.POS3 = ''
        FINDSTR Y.AZA.AMT IN R.REDO.AZA.DES<AZACC.ASSET.TYPE> SETTING AMT.POS1,AMT.POS2,AMT.POS3 THEN

            Y.ACCT.INT = R.REDO.AZA.DES<AZACC.DESC><AMT.POS1,AMT.POS2>
        END
    END
*
RETURN

ASSING.FIN.VAR:
*--------------
    C$SPARE(451) = Y.ISSUER.ID
    C$SPARE(452) = Y.ISSUER.DES
    C$SPARE(453) = Y.ACCT.CODE.VAL
    C$SPARE(454) = Y.L.INV.FACILITY
    C$SPARE(455) = Y.CAT.DESC
    C$SPARE(456) = Y.FIN.AC.OPN.DT
    C$SPARE(457) = Y.FIN.MT.OPN.DT
    C$SPARE(458) = Y.INT.RATE
    C$SPARE(459) = NO.OF.MONTHS
    C$SPARE(460) = Y.VAL.REPORT
    C$SPARE(461) = Y.BOOK.VALUE
    C$SPARE(462) = Y.BOOK.VALUE
    C$SPARE(464) = Y.CURRENCY
    C$SPARE(465) = Y.INVST.STATUS
    C$SPARE(466) = Y.RISK.CAT.INV
    C$SPARE(467) = Y.PROV.INV
    C$SPARE(468) = Y.MNTHLY.OUT
    C$SPARE(469) = Y.ISSUE.DATE
    C$SPARE(470) = Y.LINK.TYPE
    C$SPARE(471) = Y.EARLY.RET
    C$SPARE(472) = Y.PENALTY.RET
    C$SPARE(473) = Y.PROV.INV
    C$SPARE(475) = Y.INT.RECEIVABLE
    C$SPARE(476) = Y.ACCT.INT
    C$SPARE(477) = Y.MAT.DATE
    C$SPARE(478) = Y.RATING

    C$SPARE(479) = Y.DEAL.TICKET
    C$SPARE(485) = Y.CUST.TYPE
    C$SPARE(486) = Y.ISSUER.TYPE
    C$SPARE(487) = Y.NATIONALITY
    C$SPARE(488) = Y.COUPON.TYPE
    C$SPARE(489) = Y.COLL.ISS
    C$SPARE(490) = Y.INT.RATE
    C$SPARE(491) = Y.ISIN.CODE
*

RETURN


TYPE.OF.CUSTOMER:
*----------------

*
    Y.PROG.GRP = ''
    Y.REL.REQ = ''
    OUT.ARR = ''
    CALL REDO.S.REP.CUSTOMER.EXTRACT(Y.CUSTOMER,Y.PROG.GRP,Y.REL.REQ,OUT.ARR)
    Y.CUST.TYPE.VAL = FIELD(OUT.ARR,@FM,2)
    Y.CUST.TYPE = Y.CUST.TYPE.VAL[1,2]

*
RETURN

FIND.INT.RECEIVABLE:
*-------------------

    R.EB.CONT.BAL = ""
    ERR.EB.CONT.BAL = ""
    CALL F.READ(FN.EB.CONT.BAL,Y.INV.DET,R.EB.CONT.BAL,F.EB.CONT.BAL,ERR.EB.CONT.BAL)
    IF R.EB.CONT.BAL THEN
        Y.TYP.SYS = R.EB.CONT.BAL<ECB.TYPE.SYSDATE>
        Y.TYP.SYS.CNT = DCOUNT(Y.TYP.SYS,@VM)
        START.TYP.CNT = "1"
        LOOP
        WHILE START.TYP.CNT LE Y.TYP.SYS.CNT
            Y.ASSET.TYPE = R.EB.CONT.BAL<ECB.TYPE.SYSDATE,START.TYP.CNT>
            Y.ASSET.TYPE = FIELD(Y.ASSET.TYPE,"-",1)
            IF Y.ASSET.TYPE EQ Y.ASSET.VAL THEN
                Y.OPEN.BAL = ''
                Y.CREDIT.MVMT =''
                Y.DEBIT.MVMT = ''
                Y.OPEN.BAL.VAL = R.EB.CONT.BAL<ECB.OPEN.BALANCE,START.TYP.CNT>
                Y.OPEN.BAL = SUM(Y.OPEN.BAL.VAL)
                Y.CREDIT.MVMT.VAL = R.EB.CONT.BAL<ECB.CREDIT.MVMT,START.TYP.CNT>
                Y.CREDIT.MVMT = SUM(Y.CREDIT.MVMT.VAL)
                Y.DEBIT.MVMT.VAL = R.EB.CONT.BAL<ECB.DEBIT.MVMT,START.TYP.CNT>
                Y.DEBIT.MVMT = SUM(Y.DEBIT.MVMT.VAL)
                IF Y.OPEN.BAL OR Y.CREDIT.MVMT OR Y.DEBIT.MVMT THEN
                    Y.INT.REC = ''
                    Y.INT.REC = Y.OPEN.BAL + Y.CREDIT.MVMT + Y.DEBIT.MVMT
                    IF Y.INT.REC THEN
                        Y.INT.RECEIVABLE += Y.INT.REC
                    END
                END
            END
            START.TYP.CNT += 1
        REPEAT
    END
*
RETURN

FIND.PROV.INV:
*------------

    CALL F.READ(FN.REDO.CUS.PROV,Y.CUSTOMER,R.REDO.CUS.PROV,F.REDO.CUS.PROV,ERR.REDO.CUS.PROV)
    Y.MM.CONT.ID = R.REDO.CUS.PROV<CUS.PROV.MM.CONT.ID>
    CHANGE @VM TO @FM IN Y.MM.CONT.ID
    IF R.REDO.CUS.PROV THEN
        LOCATE Y.INV.DET IN Y.MM.CONT.ID<1> SETTING PROV.POS THEN
            Y.MM.CAP = R.REDO.CUS.PROV<CUS.PROV.MM.CAP.PROV,PROV.POS>
            Y.MM.CAP.PROV = TRIM(Y.MM.CAP,",","A")

            Y.MM.INT = R.REDO.CUS.PROV<CUS.PROV.MM.INT.PROV,PROV.POS>
            Y.MM.INT.PROV = TRIM(Y.MM.INT,",","A")

            Y.PROV.INV = Y.MM.CAP.PROV + Y.MM.INT.PROV
        END
    END
*
RETURN

FIND.LINK.TYPE:
*--------------
    Y.RELATION.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>
    Y.RELATION.CODE.CNT = DCOUNT(Y.RELATION.CODE,@VM)
    Y.START.REL = "1"

    LOOP
    WHILE Y.START.REL LE Y.RELATION.CODE.CNT
        Y.REL.ACT.VAL.ARR = CHANGE(Y.REL.VAL.ARR,@SM,@VM)
        Y.REL.ACT.DIS.ARR = CHANGE(Y.REL.DIS.ARR,@SM,@VM)
        LOCATE Y.RELATION.CODE<1,Y.START.REL> IN Y.REL.ACT.VAL.ARR<1,1> SETTING L.REL.POS THEN
            Y.LINK.TYPE = Y.REL.ACT.DIS.ARR<1,L.REL.POS>

            GOSUB ASSING.FIN.VAR
            GOSUB ASSING.FIN.VAL
            GOSUB READ.REDO.REPORT.TEMP

        END
        Y.START.REL += 1
    REPEAT
*
RETURN

FIND.EARLY.RET:
*--------------
    IF Y.MAT.DATE MATCHES "8N" THEN
        Y.EARLY.RET = "S"
    END ELSE
        Y.EARLY.RET = "N"
    END
*
RETURN

FIND.CATGORY.VAL:
*----------------
    Y.CATEGORY = R.MM<MM.CATEGORY>
    CALL F.READ(FN.CATEG,Y.CATEGORY,R.CATEG,F.CATEG,ERR.CATEG)
    IF R.CATEG THEN
        Y.CAT.DESC = R.CATEG<EB.CAT.DESCRIPTION>
    END
*
RETURN

FIND.MAT.DATE:
*-------------
    Y.MATURITY.DATE = R.MM<MM.MATURITY.DATE>
    IF Y.MATURITY.DATE THEN
        Y.MT.OPN.DT.YY = Y.MATURITY.DATE[1,4]
        Y.MT.OPN.DT.MM = Y.MATURITY.DATE[5,2]
        Y.MT.OPN.DT.DT = Y.MATURITY.DATE[7,2]
        Y.FIN.MT.OPN.DT = Y.MT.OPN.DT.DT:"/":Y.MT.OPN.DT.MM:"/":Y.MT.OPN.DT.YY
    END ELSE
        Y.FIN.MT.OPN.DT = ""
    END
*
RETURN

DATE.OF.ACQUIS:
*--------------
    Y.ACQU.DATE = R.MM<MM.ORIG.START.DATE>
    IF Y.ACQU.DATE THEN
        Y.AC.OPN.DT.YY = Y.ACQU.DATE[1,4]
        Y.AC.OPN.DT.MM = Y.ACQU.DATE[5,2]
        Y.AC.OPN.DT.DT = Y.ACQU.DATE[7,2]
        Y.FIN.AC.OPN.DT = Y.AC.OPN.DT.DT:"/":Y.AC.OPN.DT.MM:"/":Y.AC.OPN.DT.YY
    END ELSE
        Y.FIN.AC.OPN.DT = ""
    END
*
RETURN

CALC.INT.SCH:
*------------

    Y.VAL.REPORT  = ''
    Y.INT.SCH = R.MM<MM.INT.SCHEDULE>
    Y.INT.SCH = Y.INT.SCH[9,3]

    LOCATE Y.INT.SCH IN Y.MM.SCH.VAL.ARR<1,1> SETTING L.SCH.POS THEN
        Y.VAL.REPORT = Y.MM.SCH.DIS.ARR<1,L.SCH.POS>
    END ELSE
        Y.VAL.REPORT = 'V'
    END


*
RETURN

CALC.MONTH.CNT:
*--------------

    Y.LAST.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

    CALL EB.NO.OF.MONTHS(Y.LAST.DAY,Y.MATURITY.DATE,NO.OF.MONTHS)
*
RETURN

ASSING.FIN.VAL:
*--------------
* Pass arguments to RCL and get the return message
*-------------------------------------------------

    R.RETURN.MSG = ""
    RCL.ID  = Y.RCL.ID
    MAP.FMT = "MAP"
    APP     = FN.MM
    R.APP   = R.MM
    CALL RAD.CONDUIT.LINEAR.TRANSLATION (MAP.FMT,RCL.ID,APP,Y.AA.ARR.ID,R.APP,R.RETURN.MSG,ERR.MSG)
    Y.FINAL.MSG = R.RETURN.MSG
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
READ.REDO.REPORT.TEMP:
*-----------------------------------------------------------------------------------------------------------------
*Read REDO.REPORT.TEMP
*If Record exits then append R.RETURN.MSG  to R.REDO.REPORT.TEMP
*Else assign R.RETURN.MSG to R.REDO.REPORT.TEMP
*-----------------------------------------------------------------------------------------------------------------
    R.REDO.REPORT.TEMP = ""

    IF Y.FINAL.MSG THEN
        WRITESEQ Y.FINAL.MSG APPEND TO Y$.SEQFILE.PTR ELSE
            Y.ERR.MSG = "Unable to Write '":Y.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
        END
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling Fatal error to halt the process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP    = "01"
    Y.ERR.MSG = "Record not found"
    REC.CON   = "OA01-":Y.AA.ARR.ID:Y.ERR.MSG
    DESC      = "OA01-":Y.AA.ARR.ID:Y.ERR.MSG
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*
RETURN
*------------------------------------------------------------------Final End-------------------------------------------
END
