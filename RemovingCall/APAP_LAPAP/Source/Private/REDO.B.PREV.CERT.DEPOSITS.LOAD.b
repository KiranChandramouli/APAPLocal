$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.PREV.CERT.DEPOSITS.LOAD
* -------------------------------------------------------------------------------------------------
* Description           : This is the Batch Load Routine used to initalize all the required variables
*
* Developed By          : Amaravathi Krithika B
* Development Reference : N10
* Attached To           : NA
* Attached As           : NA
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA

*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.AZ.ACCOUNT ;* R22 Auto conversion
    $INSERT I_F.RE.STAT.REP.LINE ;* R22 Auto conversion
    $INSERT I_F.CUSTOMER ;* R22 Auto conversion
    $INSERT I_F.COMPANY ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_F.COLLATERAL ;* R22 Auto conversion
    $INSERT I_F.ACCOUNT ;* R22 Auto conversion
    $INSERT I_F.EB.CONTRACT.BALANCES ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_REDO.B.PREV.CERT.DEPOSITS.COMMON ;* R22 Auto conversion
    $INSERT I_F.EB.LOOKUP ;* R22 Auto conversion
    $INSERT I_F.REDO.AZACC.DESC ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON ;* R22 Auto conversion
    $INSERT I_F.AZ.ACCT.BAL.HIST ;* R22 Auto conversion
*

    GOSUB INIT
    GOSUB FIND.LOC.REF
    GOSUB PROCESS
RETURN
INIT:
*----
    FN.AZ.ACC = '' F.AZ.ACC = '' R.AZ.ACC = ''
    Y.FILE.NAME = ''
    AZ.ACC.ERR = ''
    Y.COMP = ''
    Y.LST.WORKING = ''
    Y.ALL.IN.PRDT = ''
    Y.MTHD.PAY.INC = ''
    Y.TYP.OF.PAY = ''
    Y.STATUS.I = ''
    Y.STATUS.II =''
    Y.LNK.TYPE = ''
    Y.CATEG.VAL = ''
    Y.ALL.IN.PRDT.NAME = ''
    R.EB.LOOKUP.APP.PRDT = ''
    R.EB.LOOKUP.APP.PAY = ''
    Y.MTHD.OF.PAY.NAME = ''
    R.EB.LOOKUP.APP.TYPE = ''
    Y.TYPE.PAY.NAME = ''
    R.EB.LOOKUP.APP.STA = ''
    Y.STA.NAME = ''
    R.EB.LOOKUP.APP.STA.II = ''
    Y.STA.NAME.II = ''
    R.EB.LOOKUP.APP.LNK = ''
    Y.LNK.TYP.NAME = ''
    R.EB.LOOKUP.APP.CATEG =''
    Y.DATA.VAL.CATEG = ''
    Y.REDO.REP.PARAM.ID = ''
    Y.RCL.ID = ''
    Y.FILE.NAME = ''
    Y.COL.POS = ''
    Y.COL.AVA.POS =''
    Y.AC.INVEST.POS =''
    Y.AC.PAY.MODE.POS = ''
    Y.AC.STATUS.I.POS = ''
    Y.AC.STATUS.II.POS = ''
    Y.VER.CODE.POS = ''
    Y.LOCAL.POS = ''
    Y.APPL = ''
    Y.FLD = ''
    FN.AC.HIS = ''
    F.AC.HIS = ''
    L.CU.FOREIGN.POS = ''
    L.CU.DEBTOR.POS = ''
    L.CU.TIPO.CL.POS = ''
    L.CU.CIDENT.POS = ''
    L.CU.RNC.POS = ''
    Y.NONICO.POS = ''
    Y.ACTANAC.POS =  ''
    Y.L.AZ.METHOD.PAY.POS = ''
    L.APAP.INDUSTRY.POS = ''
RETURN
FIND.LOC.REF:
*-----------
    Y.APPL = 'COLLATERAL':@FM:'ACCOUNT':@FM:'AZ.ACCOUNT':@FM:'CUSTOMER':@FM:'COMPANY'
    Y.FLD = 'L.COL.NUM.INSTR':@VM:'L.COL.VAL.AVA':@FM:'L.AC.REINVESTED':@VM:'L.AC.PAYMT.MODE':@VM:'L.AC.STATUS1':@VM:'L.AC.STATUS2':@FM:'L.AZ.METHOD.PAY':@VM:'L.AZ.SHA1.CODE':@VM:'ORIG.DEP.AMT':@VM:'L.TYPE.INT.PAY':@FM:'L.LOCALIDAD':@VM:'L.CU.FOREIGN':@VM:'L.CU.DEBTOR':@VM:'L.CU.TIPO.CL':@VM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC':@VM:'L.APAP.INDUSTRY':@FM:'L.LOCALIDAD'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FLD,Y.POS)
    Y.COL.POS = Y.POS<1,1>
    Y.COL.AVA.POS = Y.POS<1,2>
    Y.AC.INVEST.POS = Y.POS<2,1>
    Y.AC.PAY.MODE.POS = Y.POS<2,2>
    Y.AC.STATUS.I.POS = Y.POS<2,3>
    Y.AC.STATUS.II.POS = Y.POS<2,4>
    Y.L.AZ.METHOD.PAY.POS = Y.POS<3,1>
    Y.VER.CODE.POS = Y.POS<3,2>
    Y.ORIG.DEP.AMT =Y.POS<3,3>
    L.TYPE.INT.PAY.POS = Y.POS<3,4>
    Y.LOCAL.POS = Y.POS<4,1>
    L.CU.FOREIGN.POS = Y.POS<4,2>
    L.CU.DEBTOR.POS  =Y.POS<4,3>
    L.CU.TIPO.CL.POS = Y.POS<4,4>
    L.CU.CIDENT.POS = Y.POS<4,5>
    L.CU.RNC.POS = Y.POS<4,6>
    Y.NONICO.POS = Y.POS<4,7>
    Y.ACTANAC.POS = Y.POS<4,8>
    L.APAP.INDUSTRY.POS = Y.POS<4,9>
    LCOMP.LOCALIDAD.POS = Y.POS<5,1>
RETURN

PROCESS:
*-------
    FN.AZ.ACC = 'F.AZ.ACCOUNT'
    F.AZ.ACC = ''
    R.AZ.ACC = ''
    AZ.ACC.ERR = ''
    CALL OPF(FN.AZ.ACC,F.AZ.ACC)
*
    FN.AZ.ACC.HIS = 'F.AZ.ACCOUNT$HIS'
    F.AZ.ACC.HIS = ''
    R.AZ.ACC.HIS = ''
    AZ.ACC.HIS.ERR = ''
    CALL OPF(FN.AZ.ACC.HIS,F.AZ.ACC.HIS)
*
    FN.RE.STAT.LNE = 'F.RE.STAT.REP.LINE'
    F.RE.STAT.LNE = ''
    R.RE.STAT.LNE = ''
    RE.STAT.LNE.ERR = ''
    CALL OPF(FN.RE.STAT.LNE,F.RE.STAT.LNE)
*
    FN.CUS.APP = 'F.CUSTOMER'
    F.CUS.APP = ''
    R.CUS.APP = ''
    CUS.APP.ERR = ''
    CALL OPF(FN.CUS.APP,F.CUS.APP)
*
    FN.COMP.APP = 'F.COMPANY'
    F.COMP.APP = ''
    R.COMP.APP = ''
    COMP.APP.ERR = ''
    CALL OPF(FN.COMP.APP,F.COMP.APP)
*
    FN.REDO.REP.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.REP.PARAM = ''
    R.REDO.REP.PARAM = ''
    REDO.REP.PARAM.ERR = ''
    CALL OPF(FN.REDO.REP.PARAM,F.REDO.REP.PARAM)
*
    FN.REDO.AZACC = 'F.REDO.AZACC.DESC'
    F.REDO.AZACC = ''
    R.REDO.AZACC = ''
    REDO.AZACC.ERR = ''
    CALL OPF(FN.REDO.AZACC,F.REDO.AZACC)
*
    FN.CUS.COLL = 'F.CUSTOMER.COLLATERAL'
    F.CUS.COLL = ''
    R.CUS.COLL = ''
    CUS.COLL.ERR = ''
    CALL OPF(FN.CUS.COLL,F.CUS.COLL)
*
    FN.COLL.RGHT = 'F.RIGHT.COLLATERAL'
    F.COLL.RGHT = ''
    R.COLL.RGHT = ''
    COLL.RGHT.ERR = ''
    CALL OPF(FN.COLL.RGHT,F.COLL.RGHT)
*
    FN.COLL.APP = 'F.COLLATERAL'
    F.COLL.APP = ''
    R.COLL.APP = ''
    COLL.APP.ERR = ''
    CALL OPF(FN.COLL.APP,F.COLL.APP)
*
    FN.EB.CON.BAL = 'F.EB.CONTRACT.BALANCES'
    F.EB.CON.BAL = ''
    R.EB.CON.BAL = ''
    EB.CON.BAL.ERR = ''
    CALL OPF(FN.EB.CON.BAL,F.EB.CON.BAL)
*
    FN.ACC.APP = 'F.ACCOUNT'
    F.ACC.APP = ''
    R.ACC.APP = ''
    ACC.APP.ERR = ''
    CALL OPF(FN.ACC.APP,F.ACC.APP)
*
    FN.EB.LOOKUP.APP = 'F.EB.LOOKUP'
    F.EB.LOOKUP.APP = ''
    R.EB.LOOKUP.APP = ''
    EB.LOOKUP.ERR = ''
*
    FN.AZ.ACC.BAL.HIST = 'F.AZ.ACCT.BAL.HIST'
    F.AZ.ACC.BAL.HIST = ''
    R.AZ.ACC.BAL.HIST = ''
    CALL OPF(FN.AZ.ACC.BAL.HIST,F.AZ.ACC.BAL.HIST)
*
    FN.AC.HIS = "F.ACCOUNT$HIS"
    F.AC.HIS = ''
    R.AC.HIS = ''
    AC.HIS.ERR = ''
    CALL OPF(FN.AC.HIS,F.AC.HIS)

    FN.DR.REG.CA01.WORKFILE = 'F.DR.REG.CA01.WORKFILE'
    F.DR.REG.CA01.WORKFILE = ''
    CALL OPF(FN.DR.REG.CA01.WORKFILE,F.DR.REG.CA01.WORKFILE)
*
    Y.LST.WORKING = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.STAT.MONTH = Y.LST.WORKING[1,6]:"01"
    YTODAY.DAT = TODAY
    CALL CDT('',YTODAY.DAT,'-1C')
    IF Y.LST.WORKING[5,2] NE YTODAY.DAT[5,2] THEN
        COMI = Y.STAT.MONTH
        CALL LAST.DAY.OF.THIS.MONTH
        YTODAY.DAT = COMI
    END

    FN.REDO.APAP.CUST.SWIFT.CONCAT = 'F.REDO.APAP.CUST.SWIFT.CONCAT'
    F.REDO.APAP.CUST.SWIFT.CONCAT = ''
    CALL OPF(FN.REDO.APAP.CUST.SWIFT.CONCAT,F.REDO.APAP.CUST.SWIFT.CONCAT)
    GOSUB PROCESS.2
RETURN

PROCESS.2:
**********
*This is for call routine*------------------
    FN.EB.CONT.BAL.CA='F.EB.CONTRACT.BALANCES'
    F.EB.CONT.BAL.CA =''
    CALL OPF(FN.EB.CONT.BAL.CA,F.EB.CONT.BAL.CA)

    FN.RE.STAT.REP.LINE='F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE =''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)
*End of definition for call routine

    Y.ALL.IN.PRDT = 'REDO.AZ.ACCOUNT*ALL.IN.PRDT'
    Y.MTHD.PAY.INC = "REDO.AZ.ACCOUNT*MTHD.PAY.INC"
    Y.TYP.OF.PAY = "REDO.AZ.ACCOUNT*TYPE.PAY"
    Y.STATUS.I = "REDO.AZ.ACCOUNT*STATUS"
    Y.STATUS.II = "REDO.AZ.ACCOUNT*STATUS.II"
    Y.LNK.TYPE = "REDO.CONSUMO.LOAN*VINCATION"
    Y.CATEG.VAL = "REDO.AZ.ACCOUNT*CATEG"
*
    CALL F.READ(FN.EB.LOOKUP.APP,Y.ALL.IN.PRDT,R.EB.LOOKUP.APP.PRDT,F.EB.LOOKUP.APP,EB.LOOKUP.ERR)
    Y.ALL.IN.PRDT.NAME = R.EB.LOOKUP.APP.PRDT<EB.LU.DATA.NAME>
*
    CALL F.READ(FN.EB.LOOKUP.APP,Y.MTHD.PAY.INC,R.EB.LOOKUP.APP.PAY,F.EB.LOOKUP.APP,EB.LOOKUP.ERR)
    Y.MTHD.OF.PAY.NAME = R.EB.LOOKUP.APP.PAY<EB.LU.DATA.NAME>
*
    CALL F.READ(FN.EB.LOOKUP.APP,Y.TYP.OF.PAY,R.EB.LOOKUP.APP.TYPE,F.EB.LOOKUP.APP,EB.LOOKUP.ERR)
    Y.TYPE.PAY.NAME = R.EB.LOOKUP.APP.TYPE<EB.LU.DATA.NAME>
*
    CALL F.READ(FN.EB.LOOKUP.APP,Y.STATUS.I,R.EB.LOOKUP.APP.STA,F.EB.LOOKUP.APP,EB.LOOKUP.ERR)
    Y.STA.NAME = R.EB.LOOKUP.APP.STA<EB.LU.DATA.NAME>
*
    CALL F.READ(FN.EB.LOOKUP.APP,Y.STATUS.II,R.EB.LOOKUP.APP.STA.II,F.EB.LOOKUP.APP,EB.LOOKUP.ERR)
    Y.STA.NAME.II = R.EB.LOOKUP.APP.STA.II<EB.LU.DATA.NAME>
*
    CALL F.READ(FN.EB.LOOKUP.APP,Y.LNK.TYPE,R.EB.LOOKUP.APP.LNK,F.EB.LOOKUP.APP,EB.LOOKUP.ERR)
    Y.LNK.TYP.NAME = R.EB.LOOKUP.APP.LNK<EB.LU.DATA.NAME>
*
    CALL F.READ(FN.EB.LOOKUP.APP,Y.CATEG.VAL,R.EB.LOOKUP.APP.CATEG,F.EB.LOOKUP.APP,EB.LOOKUP.ERR)
    Y.DATA.VAL.CATEG = R.EB.LOOKUP.APP.CATEG<EB.LU.DATA.NAME>
*

    Y.REDO.REP.PARAM.ID = "REDO.CA01"
    Y.RCL.ID = "REDO.RCL.CA01"
*
    CALL CACHE.READ(FN.REDO.REP.PARAM,Y.REDO.REP.PARAM.ID,R.REDO.REP.PARAM,F.REDO.REP.PARAM)
    IF R.REDO.REP.PARAM THEN
*        Y.OUTPUT.DIR = R.REDO.REP.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.FILE.NAME = R.REDO.REP.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    END
RETURN
END
