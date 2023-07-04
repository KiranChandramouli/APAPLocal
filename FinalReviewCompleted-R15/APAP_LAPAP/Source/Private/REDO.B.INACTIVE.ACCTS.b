* @ValidationCode : MjotNDQ3MTI2MjY1OkNwMTI1MjoxNjg2Njc0MjcwNjY0OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:07:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.INACTIVE.ACCTS(Y.ACCT.ID)
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine is used to write the final report array to REDO.REPORT.TEMP
*
*
* Developed By          : Nowful Rahman M
*
* Development Reference : 199_CA02
*
* Attached To           : BATCH>BNK/REDO.B.INACTIVE.ACCTS
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : Y.ACCT.ID
* Argument#2 : NA
* Argument#3 : NA
*-----------------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
*XXXX                   G.Vijayarani                                         Mofication done for format the fields
*                                                                            Y.CUS.CIDENT,Y.CUS.RNC
*                       GK                              20140619             CUS.RNC not populated is fixed
* PACS00353060          Ashokkumar.V.P                  07/11/2014           Changes based on mapping.
*                       Ghayathri                       18/05/2023           R22 Manual Conversion - Call routine modified, Y.CCAP.VAL.ARR and Y.CINT.VAL.ARR variable Added in I_REDO.B.INACTIVE.ACCTS.COMMON file
*                       Conversion Tool                24/05/2023            R22 Auto Conversion - Changed T24.BP in insert, SM to @SM, VM to @VM, <= to LE and ++ to +=1
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_REDO.B.INACTIVE.ACCTS.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.REDO.AZACC.DESC
    $USING APAP.REDOCHNLS
    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------------------------------------------
*Intialize the varaiables
*-----------------------------------------------------------------------------------------------------------------
    Y.CUS.IND = ''; Y.CUS.NAT = ''; Y.CUS.GEN = ''; Y.CUS.TIPO.CL = ''; Y.CUS.CIDENT = ''
    Y.CUS.RNC = ''; Y.CUS.NONICO = ''; Y.CUS.ACTANAC = ''; Y.CUS.LEGAL.ID = ''; Y.CUS.STREET = ''
    Y.CUS.TWN.CNT = ''; Y.CUS.NO = ''; Y.AC.STATUS1 = ''; Y.AC.CAT = ''; Y.AC.OPN.DT = ''
    Y.AC.DT.LAST.DR = ''; Y.AC.DT.LAST.CR = ''; Y.CUS.ACRONYM = ''; Y.DT.OF.ISS = ''; Y.PREV.ACCOUNT = ''
    Y.DT.LAST.TXN = ''; Y.AC.BAL = ''; Y.STATUS = ''; Y.CUS.NAME = ''; Y.TYP.INST = ''
    Y.ECB.TYP.SYSDT = ''; Y.ECB.OPN.BAL   = ''; Y.ECB.CR.MVMT   = ''; Y.ECB.DR.MVMT   = ''
    Y.SYS.DT = ''; Y.INT.BAL = 0; Y.ASSET.TYPE = ''; Y.DESC = ''; Y.ACCT.AC = ''; Y.ACCT.AC.INT = ''
    Y.CUST.TYPE = ''; Y.CUS.IDEN  = ''; Y.CUST.NAME = ''; Y.CUST.GN.NAME = ''; Y.OUT.ARR = ''
    R.REDO.REPORT.TEMP = ''; R.REDO.AZACC.DESC = ''; Y.AC.STATUS2 = ''
    R.RETURN.MSG = ''; Y.ECB.ASST.TYPE = ''; YACCT.JOINT = ''; Y.REL.CODE = ''
    C$SPARE(451) = ''; C$SPARE(452) = ''; C$SPARE(453) = ''; C$SPARE(454) = ''; C$SPARE(455) = ''
    C$SPARE(456) = ''; C$SPARE(457) = ''; C$SPARE(458) = ''; C$SPARE(459) = ''; C$SPARE(460) = ''
    C$SPARE(461) = ''; C$SPARE(462) = ''; C$SPARE(463) = ''
RETURN

PROCESS:
*-----------------------------------------------------------------------------------------------------------------
*Read Account and if record found thenget the value of fields CUSTOMER,L.AC.STATUS,CATEGORY,OPENING.DATE,
* DATE.LAST.DR.CUST & DATE.LAST.CR.CUST
*Else Raise Fatal Error
*-----------------------------------------------------------------------------------------------------------------
    R.ACCOUNT = ''; AC.ERR = ''; YOPEN.ACT.B = 0; Y.AC.STATUS2 = ''; YCATEGORY = ''; STAT2.CNT = 0
    Y.ALT.ACCT.TYPE = ''; Y.ALT.ACCT.ID = ''; Y.PREV.ACCOUNT = ''; YACCT.GRP.ID = ''; YAC2.FLG = 0
    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,AC.ERR)
    Y.AC.STATUS2 = R.ACCOUNT<AC.LOCAL.REF,Y.AC.STATUS.POS2>
    Y.AC.CAT = R.ACCOUNT<AC.CATEGORY>
    LOCATE Y.AC.CAT IN Y.CAT.VAL.ARR<1,1> SETTING CAT.POS THEN
        Y.TYP.INST = Y.CAT.DIS.ARR<1,CAT.POS>
    END ELSE
        RETURN
    END
    STAT2.CNT = DCOUNT(Y.AC.STATUS2,@SM)
    IF STAT2.CNT GE 2 THEN
        GOSUB GET.STATUS.MULTIVAL
        IF YAC2.FLG EQ 1 THEN
            RETURN
        END
    END ELSE
        LOCATE Y.AC.STATUS2 IN Y.RMS.VAL.ARR<1,1> SETTING TXNCE.POS THEN
            RETURN
        END
    END
    Y.CUS.NO = R.ACCOUNT<AC.CUSTOMER>
    Y.AC.STATUS1 = R.ACCOUNT<AC.LOCAL.REF,Y.AC.STATUS.POS1>
*    Y.AC.OPN.DT = ICONV(R.ACCOUNT<AC.OPENING.DATE>,"D")
    Y.AC.OPN.DT = R.ACCOUNT<AC.OPENING.DATE>
    Y.AC.DT.LAST.DR = R.ACCOUNT<AC.DATE.LAST.DR.CUST>
    Y.AC.DT.LAST.CR = R.ACCOUNT<AC.DATE.LAST.CR.CUST>
    YACCT.JOINT = R.ACCOUNT<AC.JOINT.HOLDER>
    YOPEN.ACT.B = R.ACCOUNT<AC.OPEN.ACTUAL.BAL>
    Y.ALT.ACCT.TYPE=R.ACCOUNT<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.ID=R.ACCOUNT<AC.ALT.ACCT.ID>
*   LOCATE 'ALTERNO1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
*       Y.PREV.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>
*   END
*   YACCT.GRP.ID = Y.ACCT.ID
*   IF Y.PREV.ACCOUNT THEN
*       YACCT.GRP.ID = Y.PREV.ACCOUNT
*   END
    C$SPARE(463) = Y.ACCT.ID
    GOSUB READ.CUST
    GOSUB MAP.FIELD.RCL
RETURN

GET.STATUS.MULTIVAL:
********************
    YCNT = 1
    FOR I.VAR = 1 TO STAT2.CNT
        Y.AC.STATUS2 = R.ACCOUNT<AC.LOCAL.REF,Y.AC.STATUS.POS2,YCNT>
        LOCATE Y.AC.STATUS2 IN Y.RMS.VAL.ARR<1,1> SETTING TXNCE.POS THEN
            YAC2.FLG = 1
            RETURN
        END
        YCNT += 1
    NEXT I.VAR
RETURN

READ.CUST:
*---------
    R.CUSTOMER = ''; CUS.ERR = ''
    CALL F.READ(FN.CUSTOMER,Y.CUS.NO,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER NE '' THEN
        Y.CUS.NAT = R.CUSTOMER<EB.CUS.NATIONALITY>
        Y.CUS.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
        Y.CUS.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
        Y.CUS.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
        Y.CUS.NONICO = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.NONICO.POS>
        Y.CUS.ACTANAC = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.ACTANAC.POS>
        Y.CUS.LEGAL.ID = R.CUSTOMER<EB.CUS.LEGAL.ID>
        Y.CUS.STREET = R.CUSTOMER<EB.CUS.STREET>
        Y.CUS.TWN.CNT = R.CUSTOMER<EB.CUS.TOWN.COUNTRY>
    END
RETURN

MAP.FIELD.RCL:
*-----------------------------------------------------------------------------------------------------------------
* Mapping Fields to common varaible C$SPARE for RCL record
*-----------------------------------------------------------------------------------------------------------------
    Y.PROD.GRP = ""; Y.REL.CODE = ''; Y.OUT.ARR = ''
    IF YACCT.JOINT THEN
        Y.REL.CODE = "Y"
    END
* CRT "BEFORE GEN RTN CUSTOMER RTN CALL*":TIMEDATE()
    APAP.LAPAP.redoSRegCustomerExtract(Y.CUS.NO,Y.PROD.GRP,Y.REL.CODE,Y.OUT.ARR);*R22 Manual Conversion
* CRT "AFTER GEN RTN CUSTOMER RTN CALL*":TIMEDATE()
*    Y.CUST.TYPE = Y.OUT.ARR<2>
    Y.CUST.NAME = Y.OUT.ARR<3>
    Y.CUST.GN.NAME = Y.OUT.ARR<4>
    OUT.ARR = ''
*    CALL DR.REG.GET.CUST.TYPE(R.CUSTOMER,OUT.ARR)
    APAP.LAPAP.drRegGetCustType(R.CUSTOMER,OUT.ARR) ;* R22 Manual Conversion
*------------------------------------------
* Tipo de Persona Cliente(Type of customer)
*------------------------------------------
    C$SPARE(451) = OUT.ARR<1>
*--------------------------------------------------------
*Identificador Cliente Principal(Customer Identification)
*--------------------------------------------------------
    GOSUB DEF.CUS.INDT
    C$SPARE(452) = Y.CUS.IDEN ;* (S/E) 20140619 incorrect variable passed is corrected now
*--------------------------------------------------------------------
*Nombre o Razocial del Cliente Principal(Name of Customer or company)
*--------------------------------------------------------------------
    IF Y.CUST.NAME EQ '' THEN
        Y.CUST.NAME = "DESCONOCIDO"
    END
    C$SPARE(453) = Y.CUST.NAME
*-----------------------------------------------------------------
*Apellidos o Sigla del Cliente Principal(customer name or acronym)
*-----------------------------------------------------------------
    C$SPARE(454) = Y.CUST.GN.NAME
*-----------------------------------------------
*Direcciel Titular ee la cuenta (Cleint address)
*-----------------------------------------------
    IF Y.CUS.STREET NE '' OR Y.CUS.TWN.CNT NE '' THEN
        Y.CLI.ADD = Y.CUS.STREET:' ':Y.CUS.TWN.CNT
    END ELSE
        Y.CLI.ADD = "DESCONOCIDO"
    END
    C$SPARE(455) = Y.CLI.ADD
*----------------------------------------
*Tipo de Instrumento (Type of instrument)
*----------------------------------------
    C$SPARE(456) = Y.TYP.INST
*-------------------------------
*Fecha de Emision(Date of ISSUE)
*-------------------------------
    Y.AC.OPN.DT.YY = Y.AC.OPN.DT[1,4]
    Y.AC.OPN.DT.MM = Y.AC.OPN.DT[5,2]
    Y.AC.OPN.DT.DT = Y.AC.OPN.DT[7,2]
    Y.FIN.AC.OPN.DT = Y.AC.OPN.DT.DT:"/":Y.AC.OPN.DT.MM:"/":Y.AC.OPN.DT.YY
    C$SPARE(457) = Y.FIN.AC.OPN.DT
*-----------------------------------------------
*Fecha Ultima Transaccion(Date Last Transaction)
*-----------------------------------------------
    IF Y.AC.DT.LAST.DR GT Y.AC.DT.LAST.CR THEN
        Y.DT.LAST.TXN = Y.AC.DT.LAST.DR
    END ELSE
        Y.DT.LAST.TXN = Y.AC.DT.LAST.CR
    END
    Y.AC.DT.LAST.DR.YY = Y.DT.LAST.TXN[1,4]
    Y.AC.DT.LAST.DR.MM = Y.DT.LAST.TXN[5,2]
    Y.AC.DT.LAST.DR.DT = Y.DT.LAST.TXN[7,2]
    Y.FIN.AC.DT.LAST.DR.DT = Y.AC.DT.LAST.DR.DT:"/":Y.AC.DT.LAST.DR.MM:"/":Y.AC.DT.LAST.DR.YY
    C$SPARE(458) = Y.FIN.AC.DT.LAST.DR.DT
*-------------------------------------
*Monto de Intereses( interest balance)
*-------------------------------------
    Y.INT.BAL = 0
    GOSUB READ.EB.CONT.BAL
    IF (YOPEN.ACT.B EQ 0 OR YOPEN.ACT.B EQ '') THEN
        IF (Y.INT.BAL EQ 0 OR Y.INT.BAL EQ '') THEN
            RETURN
        END
    END
    C$SPARE(459) = Y.INT.BAL
*----------------
*Estatus (Status)
*----------------
    GOSUB DEF.AC.STATUS
    C$SPARE(460) = Y.STATUS
*--------------------------------------------
*Cuenta Contable Capital (Accountant Account)
*--------------------------------------------
    GOSUB READ.REDO.AZACC.DESC
    C$SPARE(461) = Y.ACCT.AC[1,14]
*------------------------------------------------------------------
*Cuenta Contable de los Intereses(Accountant Acccount for Interest)
*------------------------------------------------------------------
    C$SPARE(462) = Y.ACCT.AC.INT[1,17]
*-------------------------------------------------
*Pass arguments to RCL and get the return message
*-------------------------------------------------
    MAP.FMT = "MAP"
    ID.RCON.L = "REDO.RCL.CA02"
    APP = FN.ACCOUNT
    R.APP = R.ACCOUNT
    ID.APP = Y.ACCT.ID
* CRT "BEFORE RCL CALL*":TIMEDATE()
    CALL RAD.CONDUIT.LINEAR.TRANSLATION (MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
* CRT "AFTER RCL CALL*":TIMEDATE()
    YFIN.ID = ''; YFIN.ID = Y.DT.LAST.TXN:'-':Y.ACCT.ID
    CALL F.WRITE(FN.DR.REG.CA02.WORKFILE,YFIN.ID,R.RETURN.MSG)
RETURN
*-----------------------------------------------------------------------------------------------------------------
DEF.CUS.INDT:
*-----------------------------------------------------------------------------------------------------------------
*Defaluting Customer Identification depending upon the values
*-----------------------------------------------------------------------------------------------------------------
    BEGIN CASE
        CASE Y.CUS.CIDENT NE ''
*-------Format Change (S)---------------*
            Y.CUS.IDEN = FMT(Y.CUS.CIDENT, "R(###-#######-#)")
        CASE Y.CUS.RNC NE ''
            Y.CUS.IDEN = FMT(Y.CUS.RNC, "R(#-##-#####-#)")
*-------Format Change (E)---------------*
        CASE Y.CUS.NONICO NE ''
            Y.CUS.IDEN = Y.CUS.NONICO
        CASE Y.CUS.ACTANAC NE ''
            Y.CUS.IDEN = Y.CUS.ACTANAC
        CASE Y.CUS.CIDENT EQ'' AND Y.CUS.RNC EQ '' AND Y.CUS.NONICO EQ '' AND Y.CUS.ACTANAC EQ ''
            Y.CUS.IDEN = Y.CUS.NAT:Y.CUS.LEGAL.ID
    END CASE
RETURN

DEF.AC.STATUS:
*-----------------------------------------------------------------------------------------------------------------
*Defaluting Status of Account
*-----------------------------------------------------------------------------------------------------------------
    LOCATE "STATUS" IN Y.FIELD.NME.ARR<1,1> SETTING POS.NME THEN
        Y.STAT.VAL.ARR = Y.FIELD.VAL.ARR<1,POS.NME>
        Y.STAT.DIS.ARR = Y.DISP.TEXT.ARR<1,POS.NME>
    END
    Y.STAT.VAL.ARR = CHANGE(Y.STAT.VAL.ARR,@SM,@VM)
    Y.STAT.DIS.ARR = CHANGE(Y.STAT.DIS.ARR,@SM,@VM)
    LOCATE Y.AC.STATUS1 IN Y.STAT.VAL.ARR<1,1> SETTING STAT.POS THEN
        Y.STATUS = Y.STAT.DIS.ARR<1,STAT.POS>
    END
RETURN

READ.EB.CONT.BAL:
*-----------------------------------------------------------------------------------------------------------------
*Read EB.CONTRACT.BALANCES and get the value of the fields TYPE.SYSDATE, OPEN.BALANCE, CREDIT.MVMT & DEBIT.MVMT
*-----------------------------------------------------------------------------------------------------------------
    R.EB.CONTRACT.BALANCES = ''; ECB.ERR = ''
    CALL F.READ(FN.EB.CONTRACT.BALANCES,Y.ACCT.ID,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,ECB.ERR)
    IF R.EB.CONTRACT.BALANCES NE '' THEN
        Y.ECB.TYP.SYSDT = R.EB.CONTRACT.BALANCES<ECB.TYPE.SYSDATE>
        Y.ECB.OPN.BAL   = R.EB.CONTRACT.BALANCES<ECB.OPEN.BALANCE>
        Y.ECB.CR.MVMT   = R.EB.CONTRACT.BALANCES<ECB.CREDIT.MVMT>
        Y.ECB.DR.MVMT   = R.EB.CONTRACT.BALANCES<ECB.DEBIT.MVMT>
        Y.ECB.ASST.TYPE = R.EB.CONTRACT.BALANCES<ECB.OPEN.ASSET.TYPE>
        GOSUB DEF.INT.BAL
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
DEF.INT.BAL:
*-----------------------------------------------------------------------------------------------------------------
*Frame loop and calculate the interest balance
*-----------------------------------------------------------------------------------------------------------------
    Y.DT.CNT = DCOUNT(Y.ECB.TYP.SYSDT,@VM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.DT.CNT
        Y.SYS.DT = Y.ECB.TYP.SYSDT<1,Y.CNT>
        Y.SYS.DT = FIELD(Y.SYS.DT,"-",1)
        SYS.DATE = FIELD(Y.SYS.DT,'-',2)
        IF (Y.SYS.DT EQ '50000' AND SYS.DATE LE YLAST.DATE) THEN
            Y.INT.BAL = Y.INT.BAL+Y.ECB.OPN.BAL<1,Y.CNT>+Y.ECB.CR.MVMT<1,Y.CNT>+Y.ECB.DR.MVMT<1,Y.CNT>
        END
        Y.CNT += 1
    REPEAT
RETURN

DEF.DESC.CRF.DC:
****************
    Y.REGULATORY.AC.ACC = ''; Y.IN.CONSOL.KEY = ''
    IF R.EB.CONTRACT.BALANCES THEN
        Y.CONSOL.KEY = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
        Y.CONSOL.PART = FIELD(Y.CONSOL.KEY,'.',1,16)
        Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':Y.ECB.ASST.TYPE
        Y.VARIABLE = ''; Y.RPRTS = ''; Y.LINES = ''
        CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
        Y.LINE = Y.RPRTS:'.':Y.LINES
        CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
        Y.REGULATORY.ACC.NO = R.LINE<RE.SRL.DESC,1>
    END
RETURN

READ.REDO.AZACC.DESC:
*-----------------------------------------------------------------------------------------------------------------
* Read REDO.AZACC.DESC and get the value of the fields ASSET.TYPE & DESC
*-----------------------------------------------------------------------------------------------------------------
    IF Y.ECB.ASST.TYPE THEN
        GOSUB DEF.DESC.CRF.DC
        Y.ACCT.AC = Y.REGULATORY.ACC.NO
    END
    IF NOT(Y.ACCT.AC) THEN
        Y.ACCT.AC = Y.CCAP.VAL.ARR;* R22 Manual conversion Y.CCAP.VAL.ARR variable Added in I_REDO.B.INACTIVE.ACCTS.COMMON file
    END
    Y.ECB.ASST.TYPE = "50000"
    GOSUB DEF.DESC.CRF.DC
    Y.ACCT.AC.INT = Y.REGULATORY.ACC.NO
    IF NOT(Y.ACCT.AC.INT) THEN
        Y.ACCT.AC = Y.CINT.VAL.ARR;* R22 Manual conversion Y.CINT.VAL.ARR variable Added in I_REDO.B.INACTIVE.ACCTS.COMMON file
    END
RETURN

RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling error process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP = "04"
    Y.ERR.MSG = "Record not found"
    REC.CON = "CA02.":Y.ACCT.ID:Y.ERR.MSG
    DESC = "CA02.":Y.ACCT.ID:Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
*CRT "BEFORE C.22 CALL*":TIMEDATE()
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);* R22 Manual Conversion
*CRT "AFTER C.22 CALL*":TIMEDATE()
RETURN
*------------------------------------------------------------------Final End-------------------------------------------
END
