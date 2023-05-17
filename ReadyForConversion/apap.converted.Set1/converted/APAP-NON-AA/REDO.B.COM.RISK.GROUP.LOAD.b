SUBROUTINE REDO.B.COM.RISK.GROUP.LOAD
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Thenmalar T, Capgemini
*
* Development Reference : REGN3-GR01
*
* Attached To           : Batch - BNK/REDO.B.COM.RISK.GROUP
*
* Attached As           : Multi Threaded Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#2 : NA
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* REGN3-GR01             Thenmalar T                     2014-02-20           Initial Draft
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.COM.RISK.GROUP.COMMON
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*-----------------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the program, the files are opened
**
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CUST.DOCUMENT = 'F.CUST.DOCUMENT'
    F.CUST.DOCUMENT  = ''
    CALL OPF(FN.CUST.DOCUMENT,F.CUST.DOCUMENT)

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM  = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.REDO.RISK.GROUP = 'F.REDO.RISK.GROUP'
    F.REDO.RISK.GROUP = ''
    CALL OPF(FN.REDO.RISK.GROUP,F.REDO.RISK.GROUP)

    FN.CUSTOMER.HIS='F.CUSTOMER$HIS'
    F.CUSTOMER.HIS =''
    CALL OPF(FN.CUSTOMER.HIS,F.CUSTOMER.HIS)

    FN.RELATION.CUSTOMER='F.RELATION.CUSTOMER'
    F.RELATION.CUSTOMER =''
    CALL OPF(FN.RELATION.CUSTOMER,F.RELATION.CUSTOMER)

    FN.REDO.GR.REP.CUST='F.REDO.GR.REP.CUST'
    F.REDO.GR.REP.CUST =''
    CALL OPF(FN.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST)

*20140317(S)
    Y.LANG.NAME = ''
    Y.DESC = ''
*20140317(E)

RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    GOSUB GET.MULTI.LOCAL.REF
    GOSUB GET.PARAM.VALUES
    GOSUB OPEN.TEMP.PATH

RETURN
*-----------------------------------------------------------------------------------------------------------------
*****************
GET.PARAM.VALUES:
*****************
* In this para of the program, the values from REDO.H.REPORTS.PARAM are fetched
**
    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>
    GOSUB READ.REDO.H.REPORTS.PARAM

    FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    OUT.DIR   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>

    FILE.NAME = FILE.NAME :"TEMP": AGENT.NUMBER

    LOCATE 'APAP.INDUSTRY' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING APAP.POS THEN
        FIELD.IND.VAL  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,APAP.POS>
        FIELD.IND.DISP = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,APAP.POS>

        FIELD.IND.VAL = RAISE(FIELD.IND.VAL)
        FIELD.IND.VAL = RAISE(FIELD.IND.VAL)

        FIELD.IND.DISP = RAISE(FIELD.IND.DISP)
        FIELD.IND.DISP = RAISE(FIELD.IND.DISP)
    END

    LOCATE 'CUST.DOCUMENT' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING DOC.POS THEN
        FIELD.DOC.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,DOC.POS>
    END

    LOCATE 'REP.GEN.MONTH' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING GEN.FOUND.POS THEN
        FIELD.GEN.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,GEN.FOUND.POS>
        FIELD.GEN.VAL = RAISE(FIELD.GEN.VAL)
        FIELD.GEN.VAL = RAISE(FIELD.GEN.VAL)
    END

    LOCATE 'RELATION.CODE' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING Y.REL.POS THEN
        Y.REL.CODE.LIST=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,Y.REL.POS>
        CHANGE @SM TO @FM IN Y.REL.CODE.LIST
    END

    LOCATE 'REV.REL.CODE' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING Y.REV.REL.POS THEN
        Y.REV.REL.CODE.LIST=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,Y.REV.REL.POS>
        CHANGE @SM TO @FM IN Y.REV.REL.CODE.LIST
    END

    Y.SEL.RGRC.CMD="SSELECT ":FN.REDO.GR.REP.CUST:" WITH @ID LIKE GR01... AND @ID UNLIKE ...":TODAY:"..."
    CALL EB.READLIST(Y.SEL.RGRC.CMD,Y.REP.LIST,'',NO.OF.REC.REP,SEL.ERR)
    Y.REP.CNT=1
    LOOP
    WHILE Y.REP.CNT LE NO.OF.REC.REP
        CALL F.READ(FN.REDO.GR.REP.CUST,Y.REP.LIST<Y.REP.CNT>,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.ERR)
        Y.GR01.REP.LIST<-1>=R.REDO.GR.REP.CUST
        Y.REP.CNT += 1
    REPEAT

    Y.SEL.RGRC2.CMD="SSELECT ":FN.REDO.GR.REP.CUST:" WITH @ID LIKE GR02... AND @ID UNLIKE ...":TODAY:"..."
    CALL EB.READLIST(Y.SEL.RGRC2.CMD,Y.REP2.LIST,'',NO.OF.REC.REP2,SEL2.ERR)
    Y.REP2.CNT=1
    LOOP
    WHILE Y.REP2.CNT LE NO.OF.REC.REP2
        CALL F.READ(FN.REDO.GR.REP.CUST,Y.REP2.LIST<Y.REP2.CNT>,R.REDO.GR.REP2.CUST,F.REDO.GR.REP.CUST,Y.ERR)
        Y.GR02.REP.LIST<-1>=R.REDO.GR.REP2.CUST
        Y.REP2.CNT += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------------------------------------------
***************
OPEN.TEMP.PATH:
***************
* In this para of the program, the TEMP.DIR is opened
**

    OPENSEQ TEMP.PATH,FILE.NAME TO SEQ.PTR ELSE
        INT.CODE = "REP001"
        INT.TYPE = "ONLINE"
        MON.TP   = 04
        REC.CON  = "GR01"
        DESC     = "GR01"
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************************
READ.REDO.H.REPORTS.PARAM:
**************************
* In this para of the program, file REDO.H.REPORTS.PARAM is read
**
    R.REDO.H.REPORTS.PARAM  = ''
    REDO.H.REPORTS.PARAM.ER = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ER)

RETURN
*-----------------------------------------------------------------------------------------------------------------
********************
GET.MULTI.LOCAL.REF:
********************
* In this para of the program, the local reference field positions are extracted
**
    APPL.NAME  = 'CUSTOMER'
    FIELD.NAME = 'L.CU.GRP.RIESGO' :@VM: 'L.CU.RNC' :@VM: 'L.APAP.INDUSTRY' :@VM: 'L.CU.TIPO.CL'
    FIELD.POS  = ''
    CALL MULTI.GET.LOC.REF(APPL.NAME,FIELD.NAME,FIELD.POS)

    L.CU.GRP.RIESGO.POS = FIELD.POS<1,1>
    L.CU.RNC.POS        = FIELD.POS<1,2>
    L.APAP.INDUSTRY.POS = FIELD.POS<1,3>
    L.CU.TIPO.CL.POS    = FIELD.POS<1,4>

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
