* @ValidationCode : MjotNTc4OTkwMjEyOkNwMTI1MjoxNjgxMTA5NzQ4ODk5OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 12:25:48
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
SUBROUTINE REDO.B.COMP.SHARE.GROUP.LOAD
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Kalyani L K, Capgemini
*
* Development Reference : REGN3-GR02
*
* Attached To           : Batch - BNK/REDO.B.COMP.SHARE.GROUP
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
* REGN3-GR02             Kalyani L K                     2014-02-19           Initial Draft
* Date                   who                   Reference              
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND ++ TO += 1 AND SESSION.NO TO AGENT.NUMBER AND ADDING I_TSA.COMMON
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_TSA.COMMON  ;*R22 AUTO ADDING I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.COMP.SHARE.GROUP.COMMON
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

    FN.CUSTOMER.HIS='F.CUSTOMER$HIS'
    F.CUSTOMER.HIS =''
    CALL OPF(FN.CUSTOMER.HIS,F.CUSTOMER.HIS)

    FN.REDO.GR.REP.CUST='F.REDO.GR.REP.CUST'
    F.REDO.GR.REP.CUST =''
    CALL OPF(FN.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST)

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

    FILE.NAME = FILE.NAME :"TEMP": AGENT.NUMBER  ;*R22 AUTO SESSION.NO TO AGENT.NUMBER

    LOCATE 'RELATION.CODE' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING REL.POS THEN
        FIELD.REL.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,REL.POS>
        FIELD.REL.VAL = RAISE(FIELD.REL.VAL)
        FIELD.REL.VAL = RAISE(FIELD.REL.VAL)
    END


    LOCATE 'REV.RELATION.CODE' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING REV.REL.POS THEN
        FIELD.REV.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,REV.REL.POS>
        FIELD.REV.VAL = RAISE(FIELD.REV.VAL)
        FIELD.REV.VAL = RAISE(FIELD.REV.VAL)
    END

    LOCATE 'CUST.DOCUMENT' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING DOC.POS THEN
        FIELD.DOC.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,DOC.POS>
    END

    LOCATE 'ROLE' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING ROLE.POS THEN
        FIELD.ROLE.VAL  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,ROLE.POS>
        FIELD.ROLE.DISP = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,ROLE.POS>

        FIELD.ROLE.VAL = RAISE(FIELD.ROLE.VAL)
        FIELD.ROLE.VAL = RAISE(FIELD.ROLE.VAL)

        FIELD.ROLE.DISP = RAISE(FIELD.ROLE.DISP)
        FIELD.ROLE.DISP = RAISE(FIELD.ROLE.DISP)
    END

    LOCATE 'LEG.REV.REL' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING LEGAL.POS THEN
        FIELD.LEGAL.VAL =R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,LEGAL.POS>
    END
*    LOCATE 'LAST.GEN.DATE' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING LST.GEN.POS THEN
*        LST.GEN.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,LST.GEN.POS>
*    END
    LOCATE 'REP.GEN.MONTH' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING GEN.FOUND.POS THEN
        FIELD.GEN.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,GEN.FOUND.POS>
        FIELD.GEN.VAL = RAISE(FIELD.GEN.VAL)
        FIELD.GEN.VAL = RAISE(FIELD.GEN.VAL)
    END

    Y.SEL.RGRC.CMD="SSELECT ":FN.REDO.GR.REP.CUST:" WITH @ID LIKE GR02... AND @ID UNLIKE ...":TODAY:"..."
    CALL EB.READLIST(Y.SEL.RGRC.CMD,Y.REP.LIST,'',NO.OF.REC.REP,SEL.ERR)
    Y.REP.CNT=1
    LOOP
    WHILE Y.REP.CNT LE NO.OF.REC.REP
        CALL F.READ(FN.REDO.GR.REP.CUST,Y.REP.LIST<Y.REP.CNT>,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.ERR)
        Y.GR02.REP.LIST<-1>=R.REDO.GR.REP.CUST
        Y.REP.CNT += 1
    REPEAT

    Y.SEL.RGRC.GR01.CMD="SSELECT ":FN.REDO.GR.REP.CUST:" WITH @ID LIKE GR01..."

    CALL EB.READLIST(Y.SEL.RGRC.GR01.CMD,Y.REP.GR01.LIST,'',NO.OF.REC.REP.GR01,SEL.ERR)
    Y.GR01.TOD.ID=Y.REP.GR01.LIST<NO.OF.REC.REP.GR01>
    CALL F.READ(FN.REDO.GR.REP.CUST,Y.GR01.TOD.ID,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,ERR)
    Y.GR01.REP.LIST=FIELDS(R.REDO.GR.REP.CUST,'*',1)

RETURN
*-----------------------------------------------------------------------------------------------------------------
***************
OPEN.TEMP.PATH:
***************
* In this para of the program, the TEMP.DIR is opened
**
    OPENSEQ TEMP.PATH,FILE.NAME TO SEQ.PTR ELSE
        CREATE SEQ.PTR ELSE
            INT.CODE = "REP001"
            INT.TYPE = "ONLINE"
            MON.TP   = 04
            REC.CON  = "GR02"
            DESC     = "GR02"
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END
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
    FIELD.NAME = 'L.CU.GRP.RIESGO' :@VM: 'L.CU.CIDENT' :@VM: 'L.CU.RNC' :@VM: 'L.CU.FOREIGN' :@VM: 'L.CU.TIPO.CL' :@VM: 'L.CU.DEBTOR' :@VM: 'L.TIP.CLI' :@VM: 'L.APAP.INDUSTRY'
    FIELD.POS  = ''
    CALL MULTI.GET.LOC.REF(APPL.NAME,FIELD.NAME,FIELD.POS)

    L.CU.GRP.RIESGO.POS = FIELD.POS<1,1>
    L.CU.CIDENT.POS     = FIELD.POS<1,2>
    L.CU.RNC.POS        = FIELD.POS<1,3>
    L.CU.FOREIGN.POS    = FIELD.POS<1,4>
    L.CU.TIPO.CL.POS    = FIELD.POS<1,5>
    L.CU.DEBTOR.POS     = FIELD.POS<1,6>
    L.TIP.CLI.POS       = FIELD.POS<1,7>
    L.APAP.INDUSTRY.POS = FIELD.POS<1,8>

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
