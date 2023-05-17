SUBROUTINE REDO.B.RISK.GROUP.MEMBERS.LOAD
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Kalyani L K, Capgemini
*
* Development Reference : REGN4-GR03
*
* Attached To           : Batch - BNK/REDO.B.RISK.GROUP.MEMBERS
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
* REGN4-GR03             Kalyani L K                     2014-02-14           Initial Draft
*                        Thenmalar T                     2014-03-18           Fixes done as per the changes suggested
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES

    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.RISK.GROUP.MEMBERS.COMMON

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
    FN.RELATION.CUSTOMER = 'F.RELATION.CUSTOMER'
    F.RELATION.CUSTOMER  = ''
    CALL OPF(FN.RELATION.CUSTOMER,F.RELATION.CUSTOMER)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CUST.DOCUMENT = 'F.CUST.DOCUMENT'
    F.CUST.DOCUMENT  = ''
    CALL OPF(FN.CUST.DOCUMENT,F.CUST.DOCUMENT)

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM  = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.REDO.GR.REP.CUST='F.REDO.GR.REP.CUST'
    F.REDO.GR.REP.CUST =''
    CALL OPF(FN.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST)

*20140318(S)
    Y.LANG.NAME = ''
    Y.DOC.END.DATE = ''
*20140318(E)

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

    LOCATE 'RELATION.CODE' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING REL.POS THEN
        FIELD.REL.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,REL.POS>
        FIELD.REL.VAL = RAISE(FIELD.REL.VAL)
        FIELD.REL.VAL = RAISE(FIELD.REL.VAL)
    END

    LOCATE 'REV.REL.CODE' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING REL.POS THEN
        FIELD.REV.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,REL.POS>
        FIELD.REV.VAL = RAISE(FIELD.REV.VAL)
        FIELD.REV.VAL = RAISE(FIELD.REV.VAL)
    END

    LOCATE 'APAP.INDUSTRY' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING IND.POS THEN
        FIELD.IND.VAL  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,IND.POS>
        FIELD.IND.DISP = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,IND.POS>

        FIELD.IND.VAL = RAISE(FIELD.IND.VAL)
        FIELD.IND.VAL = RAISE(FIELD.IND.VAL)

        FIELD.IND.DISP = RAISE(FIELD.IND.DISP)
        FIELD.IND.DISP = RAISE(FIELD.IND.DISP)
    END

    LOCATE 'CUST.DOCUMENT' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING DOC.POS THEN
        FIELD.DOC.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,DOC.POS>
        FIELD.DOC.VAL = RAISE(FIELD.DOC.VAL)
        FIELD.DOC.VAL = RAISE(FIELD.DOC.VAL)
    END

    LOCATE 'ROLE' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING ROLE.POS THEN
        FIELD.ROLE.VAL  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,ROLE.POS>
        FIELD.ROLE.DISP = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,ROLE.POS>

        FIELD.ROLE.VAL = RAISE(FIELD.ROLE.VAL)
        FIELD.ROLE.VAL = RAISE(FIELD.ROLE.VAL)

        FIELD.ROLE.DISP = RAISE(FIELD.ROLE.DISP)
        FIELD.ROLE.DISP = RAISE(FIELD.ROLE.DISP)
    END

    LOCATE 'REP.GEN.MONTH' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING GEN.FOUND.POS THEN
        FIELD.GEN.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,GEN.FOUND.POS>
        FIELD.GEN.VAL = RAISE(FIELD.GEN.VAL)
        FIELD.GEN.VAL = RAISE(FIELD.GEN.VAL)
    END

    LOCATE 'GR.REPORT' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING GR.FOUND.POS THEN
        FIELD.GR.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,GR.FOUND.POS>
        FIELD.GR.VAL = RAISE(FIELD.GR.VAL)
        FIELD.GR.VAL = RAISE(FIELD.GR.VAL)
    END

    Y.SEL.RGRC.CMD="SSELECT ":FN.REDO.GR.REP.CUST:" WITH @ID LIKE GR03... AND @ID UNLIKE ...":TODAY:"..."
    CALL EB.READLIST(Y.SEL.RGRC.CMD,Y.REP.LIST,'',NO.OF.REC.REP,SEL.ERR)

    Y.REP.CNT=1
    LOOP
    WHILE Y.REP.CNT LE NO.OF.REC.REP
        CALL F.READ(FN.REDO.GR.REP.CUST,Y.REP.LIST<Y.REP.CNT>,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.ERR)
        Y.GR03.REP.LIST<-1>=R.REDO.GR.REP.CUST
        Y.REP.CNT += 1
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
        REC.CON  = "GR03"
        DESC     = "GR03"
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
    FIELD.NAME = 'L.CU.GRP.RIESGO' :@VM:'L.CU.CIDENT' :@VM: 'L.CU.RNC' :@VM: 'L.CU.FOREIGN' :@VM: 'L.APAP.INDUSTRY'
    FIELD.POS  = ''
    CALL MULTI.GET.LOC.REF(APPL.NAME,FIELD.NAME,FIELD.POS)

    L.CU.GRP.RIESGO.POS = FIELD.POS<1,1>
    L.CU.CIDENT.POS     = FIELD.POS<1,2>
    L.CU.RNC.POS        = FIELD.POS<1,3>
    L.CU.FOREIGN.POS    = FIELD.POS<1,4>
    L.APAP.INDUSTRY.POS = FIELD.POS<1,5>

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
