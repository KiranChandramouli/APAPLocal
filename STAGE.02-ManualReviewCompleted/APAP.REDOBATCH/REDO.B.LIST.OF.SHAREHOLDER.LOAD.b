* @ValidationCode : MjotNDMwNzIwOTQyOkNwMTI1MjoxNjgxMTk0MjgwMTg1OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:54:40
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
SUBROUTINE REDO.B.LIST.OF.SHAREHOLDER.LOAD
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This is an batch routine used to process the records from CUSTOMER file with required
**                        selection and generate report in the parameterized out folder
*
* Developed By          : Shiva Prasad Y, Capgemini
*
* Development Reference : 786922-217-MV32
*
* Attached To           : Batch - BNK/REDO.B.LIST.OF.SHAREHOLDER
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
* Date                   who                   Reference              
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - VM TO @VM AND SESSION.NO TO AGENT.NUMBER AND ADDING I_TSA.COMMON
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_TSA.COMMON  ;*R22 AUTO CONVERSTION ADDING I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.LIST.OF.SHAREHOLDER.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
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

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM  = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    GOSUB GET.PARAM.DETAILS
    GOSUB GET.RELATION.CODES
    GOSUB GET.REPORT.GEN.MONTH
    GOSUB OPEN.TEMP.PATH
    GOSUB GET.MULTI.LOCAL.REF

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

    FILE.NAME = FILE.NAME :'TEMP': AGENT.NUMBER  ;*R22 AUTO CONVERSTION SESSION.NO TO AGENT.NUMBER

RETURN
*-----------------------------------------------------------------------------------------------------------------
*******************
GET.RELATION.CODES:
*******************
* In this para of the program, the relation codes from param table are fetched
**
    LOCATE 'FL.SEL.CODES' IN FIELD.NAME<1,1> SETTING FL.FOUND.POS THEN
        FL.PARAM.SEL.CODES  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,FL.FOUND.POS>
        FL.PARAM.DISP.CODES = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,FL.FOUND.POS>
    END

    LOCATE 'SL.SEL.CODES' IN FIELD.NAME<1,1> SETTING SL.FOUND.POS THEN
        SL.PARAM.SEL.CODES = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,SL.FOUND.POS>
    END


    LOCATE 'TL.SEL.CODES' IN FIELD.NAME<1,1> SETTING TL.FOUND.POS THEN
        TL.PARAM.SEL.CODES = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,TL.FOUND.POS>
    END

    LOCATE 'APAP.CUST.NO' IN FIELD.NAME<1,1> SETTING CU.FOUND.POS THEN
        Y.APAP.CUST.NO=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,CU.FOUND.POS>
    END

    LOCATE 'LINK.REL' IN FIELD.NAME<1,1> SETTING LI.FOUND.POS THEN
        Y.LINK.REL.CODES=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,LI.FOUND.POS>
        Y.LINK.REL.DISP =R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,LI.FOUND.POS>
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
        REC.CON  = 'MV32-':ERR.MSG
        DESC     = 'MV32-':ERR.MSG
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
    FIELD.NAME = 'L.CU.CIDENT' :@VM: 'L.CU.RNC' :@VM: 'L.CU.FOREIGN' :@VM: 'L.CU.TIPO.CL' :@VM: 'L.CU.DEBTOR' :@VM: 'L.TIP.CLI' :@VM: 'L.APAP.INDUSTRY'
    FIELD.POS  = ''
    CALL MULTI.GET.LOC.REF(APPL.NAME,FIELD.NAME,FIELD.POS)

    L.CU.CIDENT.POS     = FIELD.POS<1,1>
    L.CU.RNC.POS        = FIELD.POS<1,2>
    L.CU.FOREIGN.POS    = FIELD.POS<1,3>
    L.CU.TIPO.CL.POS    = FIELD.POS<1,4>
    L.CU.DEBTOR.POS     = FIELD.POS<1,5>
    L.TIP.CLI.POS       = FIELD.POS<1,6>
    L.APAP.INDUSTRY.POS = FIELD.POS<1,7>

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
