* @ValidationCode : Mjo0MDE1MTEzNzU6Q3AxMjUyOjE2OTAyNjQ0NTAxNDc6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:24:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.SEC.POS.ASSET.LOAD
*--------------------------------------------------------------------------------------------------
* Description           : This is the Batch Load Routine used to initalize all the required variables
*
* Developed By          : Vijayarani G
*
* Development Reference : 786942(FS-219-OA01)
*
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
* Date                   who                   Reference
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM AND ADD I_TSA.COMMON AND SESSION.NO TO AGENT.NUMBER
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
*
    $INSERT I_TSA.COMMON  ;*R22 AUTO CONVERSTION ADD I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.SEC.POS.ASSET.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_BATCH.FILES
    $INSERT I_SC.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $USING APAP.REDOCHNLS

    GOSUB INITIALISATION
    GOSUB GET.BATCH.VALUE
*
RETURN
*
*--------------
INITIALISATION:
*-------------
*

    FN.MM = ""
    F.MM = ""
    FN.CUSTOMER = ""
    F.CUSTOMER = ""
    FN.CATEG = ""
    F.CATEG = ""
    FN.SEC.POS = ""
    F.SEC.POS = ""
    FN.REDO.CUS.PROV = ""
    F.REDO.CUS.PROV = ""
    Y.REPORT.PARAM.ID = ""
    Y.RCL.ID = ""
    Y.FILE.NAME = ""
    Y.FIELD.NME.ARR = ""
    Y.FIELD.VAL.ARR = ""
    Y.DISP.TEXT.ARR = ""
    Y.ERR.MSG = ""
    R.CATEGORY = ""
    FN.STCK.EXCH = ""
    F.STCK.EXCH = ""

*
    FN.MM = "F.MM.MONEY.MARKET"
    F.MM = ""
    CALL OPF(FN.MM,F.MM)
*
    FN.SEC.POS = "F.SECURITY.POSITION"
    F.SEC.POS = ""
    CALL OPF(FN.SEC.POS,F.SEC.POS)
*
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*

    FN.CATEG = "F.CATEGORY"
    F.CATEG = ""
    CALL OPF(FN.CATEG,F.CATEG)
*
    FN.REDO.CUS.PROV = "F.REDO.H.CUSTOMER.PROVISION"
    F.REDO.CUS.PROV = ""
    CALL OPF(FN.REDO.CUS.PROV,F.REDO.CUS.PROV)
*
    FN.REDO.AZA.DES = "F.REDO.AZACC.DESC"
    F.REDO.AZA.DES = ""
    CALL OPF(FN.REDO.AZA.DES,F.REDO.AZA.DES)
*
    FN.EB.CONT.BAL = "F.EB.CONTRACT.BALANCES"
    F.EB.CONT.BAL = ""
    CALL OPF(FN.EB.CONT.BAL,F.EB.CONT.BAL)
*
    FN.INDUSTRY = "F.INDUSTRY"
    F.INDUSTRY = ""
    CALL OPF(FN.INDUSTRY,F.INDUSTRY)
*
    FN.REDO.CATEG.CUU = "F.REDO.CATEGORY.CIUU"
    F.REDO.CATEG.CUU = ""
    CALL OPF(FN.REDO.CATEG.CUU,F.REDO.CATEG.CUU)
*
    FN.SEC.MAS = "F.SECURITY.MASTER"
    F.SEC.MAS = ""
    CALL OPF(FN.SEC.MAS,F.SEC.MAS)
*
    FN.SEC.ACC.MAS = "F.SEC.ACC.MASTER"
    F.SEC.ACC.MAS = ""
    CALL OPF(FN.SEC.ACC.MAS,F.SEC.ACC.MAS)
*
    FN.SUB.ASSET.TYPE = "F.SUB.ASSET.TYPE"
    F.SUB.ASSET.TYPE = ""
    CALL OPF(FN.SUB.ASSET.TYPE,F.SUB.ASSET.TYPE)
*
    FN.SC.POS.ASSET = "F.SC.POS.ASSET"
    F.SC.POS.ASSET = ""
    CALL OPF(FN.SC.POS.ASSET,F.SC.POS.ASSET)
*

    FN.EB.RATING = "F.EB.RATING"
    F.EB.RATING = ""
    CALL OPF(FN.EB.RATING,F.EB.RATING)
*

    FN.TRN.CON.DATE = ''
    F.TRN.CON.DATE = ''
    FN.TRN.CON.DATE = 'F.TRN.CON.DATE'
    F.TRN.CON.DATE = ''
    CALL OPF(FN.TRN.CON.DATE,F.TRN.CON.DATE)
*
    FN.SEC.TRADE = "F.SEC.TRADE"
    F.SEC.TRADE = ""
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)
*
    FN.STCK.EXCH = "F.STOCK.EXCHANGE"
    F.STCK.EXCH  = ""
    CALL OPF(FN.STCK.EXCH,F.STCK.EXCH)
*
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    FN.APPL = "CUSTOMER":@FM:"MM.MONEY.MARKET":@FM:"INDUSTRY":@FM:"SECURITY.MASTER":@FM:"SEC.TRADE"
    Y.FLD = "L.CU.RNC":@VM:"L.RISK.CAT.INV":@VM:"L.ISSUER.TYPE":@VM:"L.CU.TIPO.CL":@VM:"L.APAP.INDUSTRY":@FM:"L.INV.FACILITY":@VM:"L.COUPON.TYPE":@VM:"L.COLL.ISSUE":@VM:"L.ISIN.CODE":@FM:"L.AA.CATEG"
    Y.FLD : = @FM:"L.INV.FACILITY":@VM:"L.PARTICIP.RATE":@VM:"L.COLL.ISSUE":@FM:"L.SC.TRN.YIELD":@VM:"L.COUPON.TYPE"
    Y.POS = ""
    CALL MULTI.GET.LOC.REF(FN.APPL,Y.FLD,Y.POS)
    L.CU.RNC.POS = Y.POS<1,1>
    L.RISK.CAT.INV.POS = Y.POS<1,2>
    L.ISSUER.TYPE.POS = Y.POS<1,3>
    L.CU.TIPO.CL.POS = Y.POS<1,4>
    L.APAP.INDUSTRY.POS = Y.POS<1,5>
    L.INV.FACILITY.POS = Y.POS<2,1>
    L.COUPON.TYPE.POS = Y.POS<2,2>
    L.COLL.ISSUE.POS = Y.POS<2,3>
    L.ISIN.CODE.POS = Y.POS<2,4>
    L.AA.CATEG.POS = Y.POS<3,1>
    L.SEC.INV.FACILITY.POS = Y.POS<4,1>
    L.PARTICIP.RATE.POS = Y.POS<4,2>
    L.SEC.COLL.ISSUE.POS = Y.POS<4,3>
    L.SC.TRN.YIELD.POS = Y.POS<5,1>
    L.SEC.COUPON.TYPE.POS = Y.POS<5,2>
*
RETURN
*
*---------------
GET.BATCH.VALUE:
*---------------
*
    Y.REPORT.PARAM.ID = BATCH.DETAILS<3,1,1>
    Y.RCL.ID          = BATCH.DETAILS<3,1,2>
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
        Y.FILE.NAME = Y.FILE.NAME:".TEMP.":AGENT.NUMBER  ;*R22 AUTO CONVERSTION SESSION.NO TO AGENT.NUMBER
        Y.FILE.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
*
        LOCATE 'AZA.TYPE' IN Y.FIELD.NME.ARR<1,1> SETTING Y.AZA.POS THEN
            Y.ACCT.CODE = Y.FIELD.VAL.ARR<1,Y.AZA.POS>
        END

        LOCATE 'AZA.AMT' IN Y.FIELD.NME.ARR<1,1> SETTING Y.AZA.AMT.POS THEN
            Y.AZA.AMT = Y.FIELD.VAL.ARR<1,Y.AZA.AMT.POS>
        END

        LOCATE "INT.SCHEDULE" IN Y.FIELD.NME.ARR<1,1> SETTING SCH.POS THEN
            Y.SCH.VAL.ARR = Y.FIELD.VAL.ARR<1,SCH.POS>
            Y.SCH.DIS.ARR = Y.DISP.TEXT.ARR<1,SCH.POS>
        END

        LOCATE "RELATION.CODE" IN Y.FIELD.NME.ARR<1,1> SETTING REL.POS THEN
            Y.REL.VAL.ARR = Y.FIELD.VAL.ARR<1,REL.POS>
            Y.REL.DIS.ARR = Y.DISP.TEXT.ARR<1,REL.POS>
        END

        LOCATE "ASSET.TYPE" IN Y.FIELD.NME.ARR<1,1> SETTING ASSET.POS THEN
            Y.ASSET.VAL = Y.FIELD.VAL.ARR<1,ASSET.POS>
        END

        LOCATE "INT.SCHEDULE" IN Y.FIELD.NME.ARR<1,1> SETTING SCH.POS THEN
            Y.MM.SCH.VAL.ARR = Y.FIELD.VAL.ARR<1,SCH.POS>
            Y.MM.SCH.DIS.ARR = Y.DISP.TEXT.ARR<1,SCH.POS>
        END
        Y.MM.SCH.VAL.ARR = CHANGE(Y.MM.SCH.VAL.ARR,@SM,@VM)
        Y.MM.SCH.DIS.ARR = CHANGE(Y.MM.SCH.DIS.ARR,@SM,@VM)

        LOCATE "NO.OF.PAYMENTS" IN Y.FIELD.NME.ARR<1,1> SETTING SCH.POS THEN
            Y.SCH.VAL.ARR = Y.FIELD.VAL.ARR<1,SCH.POS>
            Y.SCH.DIS.ARR = Y.DISP.TEXT.ARR<1,SCH.POS>
        END
        Y.SCH.VAL.ARR = CHANGE(Y.SCH.VAL.ARR,@SM,@VM)
        Y.SCH.DIS.ARR = CHANGE(Y.SCH.DIS.ARR,@SM,@VM)


        CHANGE @VM TO '' IN Y.FILE.DIR
        OPENSEQ Y.FILE.DIR,Y.FILE.NAME TO Y$.SEQFILE.PTR ELSE
            CREATE Y.FILE.NAME ELSE
                Y.ERR.MSG   = "Unable to Open '":Y.FILE.NAME:"'"
                GOSUB RAISE.ERR.C.22
                RETURN
            END
        END
    END
*
RETURN
*
RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling Fatal error to halt the process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP    = "01"
    Y.ERR.MSG = Y.ERR.MSG
    REC.CON   = "OA01-LOAD-":Y.ERR.MSG
    DESC      = "OA01-LOAD-":Y.ERR.MSG
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
*    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
*
RETURN
END
