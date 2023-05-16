* @ValidationCode : MjoxMzA0MDUzNjA4OlVURi04OjE2ODQyMjI4MjQ3NDc6SVRTUzotMTotMToxOTQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:24
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 194
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.LIST.AFFI.FOR.INDIV.LOAD
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This is an batch routine used to process the records from CUSTOMER file with required
**                        selection and generate report in the parameterized out folder
*
* Developed By          : Shiva Prasad Y, Capgemini
*
* Development Reference : 786892-218-MV33
*
* Attached To           : Batch - BNK/REDO.B.LIST.AFFI.FOR.INDIV
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
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - Call method format changed
*-----------------------------------------------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_TSA.COMMON ;* R22 Auto conversion
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_REDO.B.LIST.AFFI.FOR.INDIV.COMMON ;* R22 Auto conversion
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON ;* R22 Auto conversion
    $USING APAP.REDOCHNLS
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
    REDO.H.REPORTS.PARAM.ID = "REDO.MV32"
    GOSUB READ.REDO.H.REPORTS.PARAM

    FIELD.NAME   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    FIELD.VALUE  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>

    GOSUB MV.GET.RELATION.CODES

    REDO.H.REPORTS.PARAM.ID = "REDO.MV33"
    GOSUB READ.REDO.H.REPORTS.PARAM

    FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    OUT.PATH  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>

    FIELD.NAME   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    FIELD.VALUE  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    DISPLAY.TEXT = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>

    FILE.NAME = FILE.NAME :'TEMP': AGENT.NUMBER ;* R22 Auto conversion

RETURN
*-----------------------------------------------------------------------------------------------------------------
**********************
MV.GET.RELATION.CODES:
**********************
* In this para of the program, the relation codes for reports MV31 and MV32 are fetched
**
    LOCATE 'FL.SEL.CODES' IN FIELD.NAME<1,1> SETTING FL.FOUND.POS THEN
        MV.FL.PARAM.SEL.CODES = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,FL.FOUND.POS>
    END

    LOCATE 'SL.SEL.CODES' IN FIELD.NAME<1,1> SETTING SL.FOUND.POS THEN
        MV.SL.PARAM.SEL.CODES = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,SL.FOUND.POS>
    END
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
        SL.PARAM.DISP.CODES= R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,SL.FOUND.POS>
    END

    LOCATE 'APAP.CUST.NO' IN FIELD.NAME<1,1> SETTING CU.FOUND.POS THEN
        Y.APAP.CUST.NO=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,CU.FOUND.POS>
    END

    LOCATE 'REL.REP' IN FIELD.NAME<1,1> SETTING REL.REP.POS THEN
        Y.REL.REP=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,REL.REP.POS>
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

    IF TEMP.PATH AND FILE.NAME THEN
        OPENSEQ TEMP.PATH,FILE.NAME TO SEQ.PTR ELSE
            CREATE SEQ.PTR ELSE
                GOSUB LOG.C22
            END
        END
    END
    ELSE
        GOSUB LOG.C22
    END
RETURN

********
LOG.C22:
********
    ERR.MSG  = "Unable to open '":FILE.NAME:"'"
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    MON.TP   = 04
    REC.CON  = 'MV33-':ERR.MSG
    DESC     = 'MV33-':ERR.MSG
    CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 Manual Conversion

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************************
READ.REDO.H.REPORTS.PARAM:
**************************
* In this para of the program, file REDO.H.REPORTS.PARAM is read
**
    R.REDO.H.REPORTS.PARAM  = ''; REDO.H.REPORTS.PARAM.ER = ''
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
