* @ValidationCode : Mjo0OTUwMzgwMjY6Q3AxMjUyOjE2ODExMDk0NzI2NjE6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 12:21:12
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
SUBROUTINE REDO.B.COMP.OWN.RISK.GROUP.LOAD
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This is an batch routine used to process the records from CUSTOMER file with required
**                        selection and generate report in the parameterized out folder
*
* Developed By          : Shiva Prasad Y, Capgemini
*
* Development Reference : 786777-REGN7-GR99
*
* Attached To           : Batch - BNK/REDO.B.COMP.OWN.RISK.GROUP
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
* PACS00361958           Ashokkumar.V.P                  23/02/2015           Optimized the relation between the customer
* Date                   who                   Reference              
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND SESSION.NO TO AGENT.NUMBER
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.COMP.OWN.RISK.GROUP.COMMON
    $INSERT I_TSA.COMMON
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

    FN.REDO.GR.REP.CUST = 'F.REDO.GR.REP.CUST'
    F.REDO.GR.REP.CUST = ''
    CALL OPF(FN.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST)
RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    GOSUB GET.PARAM.DETAILS
    GOSUB GET.RELATION.CODES
    GOSUB GET.ROLE.IND.DOC.ID
    GOSUB GET.REPORT.GEN.MONTH
    GOSUB OPEN.TEMP.PATH
    GOSUB GET.MULTI.LOCAL.REF
    GOSUB READ.CONCAT.FILE
RETURN
*-----------------------------------------------------------------------------------------------------------------
******************
GET.PARAM.DETAILS:
******************
* In this para of the program, the values from REDO.H.REPORTS.PARAM are fetched
**
    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>
    GOSUB READ.REDO.H.REPORTS.PARAM

    FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    OUT.PATH  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>

    FIELD.NAME   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    FIELD.VALUE  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    DISPLAY.TEXT = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>

    FILE.NAME = FILE.NAME:".TEMP.":AGENT.NUMBER:".":SERVER.NAME ;*R22 AUTO CONVERSTION SESSION.NO TO AGENT.NUMBER

RETURN
*-----------------------------------------------------------------------------------------------------------------
*******************
GET.RELATION.CODES:
*******************
* In this para of the program, the relation codes from param table are fetched
**
    LOCATE 'SL.F.SEL.CODES' IN FIELD.NAME<1,1> SETTING SL.F.FOUND.POS THEN
        SL.F.PARAM.SEL.CODES = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,SL.F.FOUND.POS>
    END

    LOCATE 'SL.S.SEL.CODES' IN FIELD.NAME<1,1> SETTING SL.S.FOUND.POS THEN
        SL.S.PARAM.SEL.CODES = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,SL.S.FOUND.POS>
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
********************
GET.ROLE.IND.DOC.ID:
********************
* In this para of the program, the other parameter values are fetched from param table
**
    LOCATE 'ROLE.MORE.INFO' IN FIELD.NAME<1,1> SETTING ROLE.FOUND.POS THEN
        PARAM.ROLE.INFO.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,ROLE.FOUND.POS>
    END

    LOCATE 'APAP.IND' IN FIELD.NAME<1,1> SETTING IND.FOUND.POS THEN
        PARAM.APAP.IND.VALUES = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,IND.FOUND.POS>
    END

    LOCATE 'DOC.ID' IN FIELD.NAME<1,1> SETTING DOC.FOUND.POS THEN
        PARAM.DOC.ID = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,DOC.FOUND.POS>
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
GET.REPORT.GEN.MONTH:
*********************
* In this para of the program, the months on which the report needs to be generated is fetched for param table
**
    LOCATE 'REP.GEN.MONTH' IN FIELD.NAME<1,1> SETTING GEN.FOUND.POS THEN
        REP.GEN.MONTHS = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,GEN.FOUND.POS>
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
***************
OPEN.TEMP.PATH:
***************
* In this para of the program, the TEMP.PATH is opened
**
    OPENSEQ TEMP.PATH,FILE.NAME TO SEQ.PTR ELSE
        ERR.MSG  = "Unable to open '":FILE.NAME:"'"
        INT.CODE = 'REP001'
        INT.TYPE = 'ONLINE'
        MON.TP   = 04
        REC.CON  = 'GR99-':ERR.MSG
        DESC     = 'GR99-':ERR.MSG
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
    FIELD.NAME = 'L.CU.CIDENT' :@VM: 'L.CU.RNC' :@VM: 'L.CU.FOREIGN' :@VM: 'L.CU.GRP.RIESGO' :@VM: 'L.APAP.INDUSTRY'
    FIELD.POS  = ''
    CALL MULTI.GET.LOC.REF(APPL.NAME,FIELD.NAME,FIELD.POS)

    L.CU.CIDENT.POS     = FIELD.POS<1,1>
    L.CU.RNC.POS        = FIELD.POS<1,2>
    L.CU.FOREIGN.POS    = FIELD.POS<1,3>
    L.CU.GRP.RIESGO.POS = FIELD.POS<1,4>
    L.APAP.INDUSTRY.POS = FIELD.POS<1,5>

RETURN

READ.CONCAT.FILE:
*****************
    YLWRK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    REPORT.NAME = "GR99"
    REDO.GR.REP.CUST.ID = REPORT.NAME:YLWRK.DATE
RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
