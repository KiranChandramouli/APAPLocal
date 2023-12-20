* @ValidationCode : MjotMTEwNzg4ODgyOkNwMTI1MjoxNzAyOTg4MzM4NDUxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:48:58
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
$PACKAGE APAP.LAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            R22 AUTO CODE CONVERSION   T24.BP & TAM.BP REMOVED IN INSERTFILE,F.READ to CACHE.READ , FM to@FM ,VM to@VM,CHAR to CHARX
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION AA.AH.ACTIVITY.ID to AA.AH.ACTIVITY.REF
*14-12-2023       Santosh C                   MANUAL R22 CODE CONVERSION NO CHANGE   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------------------




* @(#) DATA.SEGUROS.SINGLE Ported to jBASE 16:16:50  28 NOV 2017
*-----------------------------------------------------------------------------
SUBROUTINE DATA.SEGUROS.SINGLE
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.CUSTOMER
*   $INSERT I_F.AA.ARRANGEMENT ;*R22 Manual Code Conversion_Utility Check
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.COLLATERAL
*   $INSERT I_F.AA.ACTIVITY.HISTORY ;*R22 Manual Code Conversion_Utility Check
    $INSERT I_F.AA.TERM.AMOUNT
    $USING AA.Framework
    GOSUB MAN.PROCESS
RETURN
MAN.PROCESS:
    GOSUB LOAD.TABLE
    GOSUB GET.LOCAL.FIELD
*COMANDO DE SELECION - PRINCIPAL
    SEL.CMD = "" ; SEL.LIST = "" ; NO.OF.RECS = ""
    SEL.ERR = "" ; SEL.CMD = "SELECT " : FN.IN
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)
*VARIABLE GLOBALES
******************
    Y.FINAL = "" ; Y.IN.ID = "" ; Y.CS.ID = ""
    Y.AR.ID = "" ; Y.AP.ID = ""
*ARCHIVO DE SALIDA
******************
    Y.DIR.NAME = "../interface/T24RIESGO"
    Y.YYYYMMDD = OCONV(DATE(),"DY4") : FMT(OCONV(DATE(),"DM"),"L%2") : FMT(OCONV(DATE(),"DD"),"L%2")
    Y.FILE.NAME = "Reporte de Seguros al " : Y.YYYYMMDD : ".CSV"
    DELETESEQ Y.DIR.NAME, Y.FILE.NAME ELSE NULL
    OPENSEQ Y.DIR.NAME,Y.FILE.NAME TO FV.PTR ELSE
        CREATE FV.PTR ELSE
            CRT "NO SE PUEDE ABRIR ARCHIVO: " : Y.FILE.NAME : " DEL DIRECTORIO: " : Y.DIR.NAME
            STOP
        END
    END
*ESCRIPTURA DE ENCABESZADO
    Y.FINAL = "Nombre_Cliente,Apellido_cliente,Cedula,Pasaporte,Rnc,Fecha_Nacimiento,Edad,Tipo_Poliza,Clase_Poliza,Poliza_Madre,Poliza,Codigo_Cliente,Forma_Pago,Compania,Monto_Asegurado,Monto_Mensual_Pago,Propiedad,Monto_Mensual_Extra_Prima,Monto_Mensual_Total,Monto_Cobrado_Desembolso,Inicio_Original_Poliza,Inicio_Cargo,Fin_Cargo,Prestamo,Sucursal,Estatus_Poliza,Cuenta,Estado_Prestamo,Estatus_prestamo,Product_Line,Product_Group,Product,Product_Description,"
    Y.FINAL := "Tipo,Marca,Modelo,Año,Chasis,Valor"
    WRITESEQ Y.FINAL TO FV.PTR ELSE
        CRT "NO SE PRUEDE ESCRIBIR EN EL ARCHIVO: " : Y.FILE.NAME
    END
    Y.FINAL  = ""
    LOOP
        REMOVE Y.IN.ID FROM SEL.LIST SETTING FI.POS
    WHILE Y.IN.ID DO
        GOSUB GET.APAP.H.INSURANCE.DETAILS
        GOSUB GET.CUSTOMER
        GOSUB GET.AA.ARRANGEMENT
        GOSUB GET.AA.PRODUCT

        IF NOT(COLLATERAL.ID) THEN
            GOSUB GET.TERM.AMOUNT
        END
        GOSUB GET.COLLATERALID
        GOSUB SET.WRITERECORD
        WRITESEQ Y.FINAL TO FV.PTR ELSE
            CRT "NO SE PRUEDE ESCRIBIR EL ARCHIVO: " : Y.FILE.NAME
        END
    REPEAT
    CLOSESEQ FV.PTR
RETURN
LOAD.TABLE:
*APERTURA DE ARCHIVOS A UTILIZAR
    FN.IN = "F.APAP.H.INSURANCE.DETAILS"
    FV.IN = ""
    CALL OPF(FN.IN,FV.IN)
    FN.CS = "F.CUSTOMER"
    FV.CS = ""
    CALL OPF(FN.CS,FV.CS)
    FN.AR = "F.AA.ARRANGEMENT"
    FV.AR = ""
    CALL OPF(FN.AR,FV.AR)
    FN.AP = "F.AA.PRODUCT"
    FV.AP = ""
    CALL OPF(FN.AP,FV.AP)
    FN.COLLATERAL = "F.COLLATERAL"
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'; F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)
    FN.AA.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'; F.AA.TERM.AMOUNT = ''
    CALL OPF(FN.AA.TERM.AMOUNT,F.AA.TERM.AMOUNT)
RETURN
GET.LOCAL.FIELD:
****************
    L.COL.SOLAR.NO.POS = ''; L.COL.SEC.DESC.POS = ''
    L.COL.CITY.POS = ''; L.COL.CITY.POS = '' ; L.AA.COL.POS = ''
    Y.APPLN = "COLLATERAL":@FM:"AA.ARR.TERM.AMOUNT"
    Y.FLD = "L.COL.SOLAR.NO":@VM:"L.COL.CAD.DIST":@VM:"L.COL.SEC.DESC":@VM:"L.COL.CITY":@FM:"L.AA.COL"
    Y.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APPLN,Y.FLD,Y.POS)
    L.COL.SOLAR.NO.POS  = Y.POS<1,1>
    L.COL.CAD.DIST.POS = Y.POS<1,2>
    L.COL.SEC.DESC.POS  = Y.POS<1,3>
    L.COL.CITY.POS  = Y.POS<1,4>
    L.AA.COL.POS = Y.POS<2,1>
RETURN
**************************************************
GET.APAP.H.INSURANCE.DETAILS:
**************************************************
    R.IN = ""; IN.ERROR = ""
    CALL F.READ(FN.IN, Y.IN.ID, R.IN, FV.IN, IN.ERROR)
    Y.CS.ID = R.IN<INS.DET.CUSTOMER>
    Y.AR.ID = R.IN<INS.DET.ASSOCIATED.LOAN>
    Y.POLICY.TYPE = R.IN<INS.DET.INS.POLICY.TYPE>
    Y.CLASS.POLICY = R.IN<INS.DET.CLASS.POLICY>
    Y.POLICY.NUMBER = R.IN<INS.DET.POLICY.NUMBER>
    Y.SEN.POLICY.NUMBER = R.IN<INS.DET.SEN.POLICY.NUMBER>
    Y.MANAGEMENT.TYPE = R.IN<INS.DET.MANAGEMENT.TYPE>
    Y.COMPANY = R.IN<INS.DET.INS.COMPANY>
    Y.AMOUNT = R.IN<INS.DET.INS.AMOUNT>
    Y.MON.POL.AMT = R.IN<INS.DET.MON.POL.AMT>
    Y.CHARGE = R.IN<INS.DET.CHARGE>
    Y.EXTRA.AMT = R.IN<INS.DET.EXTRA.AMT>
    Y.MON.TOT.PRE.AMT = R.IN<INS.DET.MON.TOT.PRE.AMT>
    Y.TOTAL.PRE.AMT = R.IN<INS.DET.TOTAL.PRE.AMT>
    Y.POLICY.ORG.DATE = R.IN<INS.DET.POLICY.ORG.DATE>
    Y.POL.START.DATE = R.IN<INS.DET.POL.START.DATE>
    Y.POL.EXP.DATE = R.IN<INS.DET.POL.EXP.DATE>
    Y.CO.CODE = R.IN<INS.DET.CO.CODE>
    Y.POLICY.STATUS = R.IN<INS.DET.POLICY.STATUS>
    COLLATERAL.ID = R.IN<INS.DET.COLLATERAL.ID>
RETURN
**************************************************
GET.CUSTOMER:
**************************************************
    R.CS = ""; CS.ERROR = ""
    CALL F.READ(FN.CS, Y.CS.ID, R.CS, FV.CS, CS.ERROR)
    Y.GIVEN.NAMES = R.CS<EB.CUS.GIVEN.NAMES>
    Y.FAMILY.NAME = R.CS<EB.CUS.FAMILY.NAME>
    Y.LEGAL.ID = R.CS<EB.CUS.LEGAL.ID>
    Y.DATE.OF.BIRTH = R.CS<EB.CUS.DATE.OF.BIRTH>
    CALL GET.LOC.REF("CUSTOMER","L.CU.CIDENT",CS.POS)
    Y.L.CU.CIDENT = R.CS<EB.CUS.LOCAL.REF,CS.POS>
    CALL GET.LOC.REF("CUSTOMER","L.CU.RNC", CS.POS)
    Y.L.CU.RNC = R.CS<EB.CUS.LOCAL.REF, CS.POS>
    CALL GET.LOC.REF("CUSTOMER","L.CU.AGE", CS.POS)
    Y.L.CU.AGE = R.CS<EB.CUS.LOCAL.REF, CS.POS>
RETURN
**************************************************
GET.AA.ARRANGEMENT:
**************************************************
    R.AR = ""; AR.ERROR = ""
    CALL F.READ(FN.AR, Y.AR.ID, R.AR, FV.AR, AR.ERROR)
*   Y.AP.ID = R.AR<AA.ARR.PRODUCT>
*   Y.LINKED.APPL.ID = R.AR<AA.ARR.LINKED.APPL.ID>
*    Y.ARR.STATUS = R.AR<AA.ARR.ARR.STATUS>
*   Y.PRODUCT.LINE = R.AR<AA.ARR.PRODUCT.LINE>
*   Y.PRODUCT.GROUP = R.AR<AA.ARR.PRODUCT.GROUP>
*   Y.ORIG.CONTRACT.DATE = R.AR<AA.ARR.ORIG.CONTRACT.DATE>
*   Y.START.DATE = R.AR<AA.ARR.START.DATE>
**R22 Manual Code Conversion_Utility Check - Start
    Y.AP.ID = R.AR<AA.Framework.Arrangement.ArrProduct>
    Y.LINKED.APPL.ID = R.AR<AA.Framework.ArrangementSim.ArrLinkedApplId>
    Y.ARR.STATUS = R.AR<AA.Framework.ArrangementSim.ArrArrStatus>
    Y.PRODUCT.LINE =  R.AR<AA.Framework.ArrangementSim.ArrProductLine>
    Y.PRODUCT.GROUP = R.AR<AA.Framework.ArrangementSim.ArrProductGroup>
    Y.ORIG.CONTRACT.DATE = R.AR<AA.Framework.ArrangementSim.ArrOrigContractDate>
    Y.START.DATE = R.AR<AA.Framework.ArrangementSim.ArrStartDate>
**R22 Manual Code Conversion_Utility Check - End
    IF Y.ORIG.CONTRACT.DATE EQ "" THEN
        Y.LOAN.DATE =  Y.START.DATE
    END
    ELSE
        Y.LOAN.DATE = Y.ORIG.CONTRACT.DATE
    END
    Y.AA.ARR.ID = Y.AR.ID
    Y.ESTADO = ''
    ARRANGEMENT.ID = Y.AA.ARR.ID
    R.AA.OVERDUE   = ''
    PROP.CLASS     = ''
    PROP.NAME      = 'APAP.OVERDUE'
    RET.ERR        = ''
    returnConditions = ''
*   CALL AA.GET.ARRANGEMENT.CONDITIONS(ARRANGEMENT.ID,PROP.CLASS,PROP.NAME,'','',returnConditions,RET.ERR)
    AA.Framework.GetArrangementConditions(ARRANGEMENT.ID,PROP.CLASS,PROP.NAME,'','',returnConditions,RET.ERR) ;*R22 Manual Code Conversion_Utility Check
    R.AA.OVERDUE = RAISE(returnConditions)
    OVERDUE      = R.AA.OVERDUE
    CALL GET.LOC.REF("AA.PRD.DES.OVERDUE","L.LOAN.STATUS.1",L.LOAN.STATUS.1.POS)
    Y.ESTADO = R.AA.OVERDUE<AA.OD.LOCAL.REF,L.LOAN.STATUS.1.POS>
RETURN

**************************************************
GET.AA.PRODUCT:
**************************************************
    R.AP = ""; AP.ERROR = ""
    CALL CACHE.READ(FN.AP, Y.AP.ID, R.AP, AP.ERROR);*R22 AUTO CODE CONVERSION

    Y.DESCRIPTION = R.AP<AA.PDT.DESCRIPTION,2>

**************************************************
*FORMATEO DE FECHAS
**************************************************
    IF LEN(Y.DATE.OF.BIRTH) EQ 8 THEN
        Y.DATE.OF.BIRTH = Y.DATE.OF.BIRTH[7,2] : "-" :  Y.DATE.OF.BIRTH[5,2] : "-" :  Y.DATE.OF.BIRTH[1,4]
    END

    IF LEN(Y.POLICY.ORG.DATE) EQ 8 THEN
        Y.POLICY.ORG.DATE = Y.POLICY.ORG.DATE[7,2] : "-" :  Y.POLICY.ORG.DATE[5,2] : "-" :  Y.POLICY.ORG.DATE[1,4]
    END

    IF LEN(Y.POL.START.DATE) EQ 8 THEN
        Y.POL.START.DATE = Y.POL.START.DATE[7,2] : "-" :  Y.POL.START.DATE[5,2] : "-" :  Y.POL.START.DATE[1,4]
    END

    IF LEN(Y.POL.EXP.DATE) EQ 8 THEN
        Y.POL.EXP.DATE = Y.POL.EXP.DATE[7,2] : "-" :  Y.POL.EXP.DATE[5,2] : "-" :  Y.POL.EXP.DATE [1,4]
    END
RETURN
GET.TERM.AMOUNT:

    PROP.CLASS = 'TERM.AMOUNT';    PROP.NAME  = ''; returnConditions = ''; RET.ERR = ''
    COLLATERAL.ID = ''; YL.AA.COL.VAL = '' ; ARR.ID = Y.AR.ID
*   CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID,PROP.CLASS,PROP.NAME,'','',returnConditions,ERR.COND)
    AA.Framework.GetArrangementConditions(ARR.ID,PROP.CLASS,PROP.NAME,'','',returnConditions,ERR.COND) ;*R22 Manual Code Conversion_Utility Check
    R.AA.TERM.AMOUNT = RAISE(returnConditions)
    COLLATERAL.ID = R.AA.TERM.AMOUNT<AA.AMT.LOCAL.REF,L.AA.COL.POS>
    IF NOT(COLLATERAL.ID) THEN
        GOSUB FIND.COLL.VAL
        COLLATERAL.ID = R.AA.TERM.AMOUNT<AA.AMT.LOCAL.REF,L.AA.COL.POS>
    END
RETURN
FIND.COLL.VAL:
**************
    ERR.AA.ACTIVITY.HISTORY = ''; R.AA.ACTIVITY.HISTORY = ''; YACT.DTE.ID = ''; ID.COM3 = ''
*   CALL F.READ(FN.AA.ACTIVITY.HISTORY,ARR.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ERR.AA.ACTIVITY.HISTORY)
    R.AA.ACTIVITY.HISTORY = AA.Framework.ActivityHistory.Read(ARR.ID, ERR.AA.ACTIVITY.HISTORY) ;*R22 Manual Code Conversion_Utility Check
    IF R.AA.ACTIVITY.HISTORY THEN
*       YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF> ;*MANUAL R22 CODE CONVERSION
        YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistory.AhActivityRef> ;*R22 Manual Code Conversion_Utility Check
    END
    YACT.DTE.ID = ''
    LOCATE "LENDING-TAKEOVER-ARRANGEMENT" IN YACT.ID.ARR<1,1> SETTING CHG.POSN.1 THEN
*       YACT.DTE.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.DATE,CHG.POSN.1,1>
        YACT.DTE.ID = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistory.AhActDate,CHG.POSN.1,1> ;*R22 Manual Code Conversion_Utility Check
        TERM.AMT.ID = ARR.ID:'-COMMITMENT-':YACT.DTE.ID:'.1'
        GOSUB READ.TERM.AMT
    END

    YACT.DTE.ID = ''
    LOCATE "LENDING-NEW-ARRANGEMENT" IN YACT.ID.ARR<1,1> SETTING CHG.POSN.2 THEN
*       YACT.DTE.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.DATE,CHG.POSN.2,1>
        YACT.DTE.ID = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistory.AhActDate,CHG.POSN.2,1> ;*R22 Manual Code Conversion_Utility Check
        TERM.AMT.ID = ARR.ID:'-COMMITMENT-':YACT.DTE.ID:'.1'
        GOSUB READ.TERM.AMT
    END
RETURN
READ.TERM.AMT:
**************
    AA.ARR.TERM.AMOUNT.ERR = ''; R.AA.ARR.TERM.AMOUNT = ''
    CALL F.READ(FN.AA.TERM.AMOUNT,TERM.AMT.ID,R.AA.TERM.AMOUNT,F.AA.TERM.AMOUNT,AA.ARR.TERM.AMOUNT.ERR)
RETURN
GET.COLLATERALID:
******************************************************
***************DATOS DE LA GARANTIA
******************************************************
    R.COLLATERAL = ''; ERR.COLLATERAL = ''; Y.TIPO = ''; Y.MARCA = ''; Y.MODELO = ''
    Y.YEAR = ''; Y.CHASIS = ''; Y.VALOR = ''
    FINDSTR "VEH" IN Y.AP.ID SETTING Ap, Vp THEN
        CALL F.READ(FN.COLLATERAL,COLLATERAL.ID,R.COLLATERAL,F.COLLATERAL,ERR.COLLATERAL)
        Y.TIPO = R.COLLATERAL<COLL.ADDRESS>
        Y.MARCA = R.COLLATERAL<COLL.LOCAL.REF,L.COL.SOLAR.NO.POS>
        Y.MODELO = R.COLLATERAL<COLL.LOCAL.REF,L.COL.CAD.DIST.POS>
        Y.YEAR =  R.COLLATERAL<COLL.LOCAL.REF,L.COL.SEC.DESC.POS>
        Y.CHASIS = R.COLLATERAL<COLL.LOCAL.REF,L.COL.CITY.POS>
        Y.VALOR = R.COLLATERAL<COLL.NOMINAL.VALUE>
    END
RETURN
SET.WRITERECORD:
**************************************************
*REGISTRO
**************************************************
    Y.FINAL = ""
    Y.FINAL = Y.GIVEN.NAMES : ","
    Y.FINAL = Y.FINAL : Y.FAMILY.NAME : ","
    Y.FINAL = Y.FINAL : Y.L.CU.CIDENT : ","
    Y.FINAL = Y.FINAL : Y.LEGAL.ID : ","
    Y.FINAL = Y.FINAL : Y.L.CU.RNC : ","
    Y.FINAL = Y.FINAL : Y.DATE.OF.BIRTH : ","
    Y.FINAL = Y.FINAL : Y.L.CU.AGE : ","
    Y.FINAL = Y.FINAL : Y.POLICY.TYPE : ","
    Y.FINAL = Y.FINAL : Y.CLASS.POLICY : ","
    Y.FINAL = Y.FINAL : Y.POLICY.NUMBER : ","
    Y.FINAL = Y.FINAL : Y.SEN.POLICY.NUMBER : ","
    Y.FINAL = Y.FINAL : Y.CS.ID : ","
    Y.FINAL = Y.FINAL : Y.MANAGEMENT.TYPE : ","
    Y.FINAL = Y.FINAL : Y.COMPANY : ","
    Y.FINAL = Y.FINAL : Y.AMOUNT : ","
    Y.FINAL = Y.FINAL : Y.MON.POL.AMT : ","
    Y.FINAL = Y.FINAL : Y.CHARGE : ","
    Y.FINAL = Y.FINAL : Y.EXTRA.AMT  : ","
    Y.FINAL = Y.FINAL : Y.MON.TOT.PRE.AMT : ","
    Y.FINAL = Y.FINAL : Y.TOTAL.PRE.AMT: ","
    Y.FINAL = Y.FINAL : Y.POLICY.ORG.DATE : ","
    Y.FINAL = Y.FINAL : Y.POL.START.DATE : ","
    Y.FINAL = Y.FINAL : Y.POL.EXP.DATE  : ","
    Y.FINAL = Y.FINAL : Y.AR.ID : ","
    Y.FINAL = Y.FINAL : Y.CO.CODE : ","
    Y.FINAL = Y.FINAL : Y.POLICY.STATUS : ","
    Y.FINAL = Y.FINAL : Y.LINKED.APPL.ID : ","
    Y.FINAL = Y.FINAL : Y.ARR.STATUS : ","
    Y.FINAL = Y.FINAL : Y.ESTADO : ","
    Y.FINAL = Y.FINAL : Y.PRODUCT.LINE : ","
    Y.FINAL = Y.FINAL : Y.PRODUCT.GROUP : ","
    Y.FINAL = Y.FINAL : Y.AP.ID : ","
    Y.FINAL = Y.FINAL : Y.DESCRIPTION : ","
    Y.FINAL = Y.FINAL : Y.TIPO : ","
    Y.FINAL = Y.FINAL : Y.MARCA : ","
    Y.FINAL = Y.FINAL : Y.MODELO : ","
    Y.FINAL = Y.FINAL : Y.YEAR : ","
    Y.FINAL = Y.FINAL : Y.CHASIS : ","
    Y.FINAL = Y.FINAL : Y.VALOR : CHARX(13)
RETURN
END
