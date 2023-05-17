*-----------------------------------------------------------------------------
* <Rating>-99</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.REC.ACCT.LIST.POST
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
* Attached As           : Post Routine
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
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
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

    GOSUB GET.REPORT.LINES

    RETURN
*-----------------------------------------------------------------------------------------------------------------
******************
GET.PARAM.DETAILS:
******************
* In this para of the program, the values from REDO.H.REPORTS.PARAM are fetched
**
    REDO.H.REPORTS.PARAM.ID = 'RECONRPT'
    GOSUB READ.REDO.H.REPORTS.PARAM

    FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    OUT.PATH  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>

    FINAL.OUT.FILE.NAME = FILE.NAME:'_':R.DATES(EB.DAT.LAST.WORKING.DAY):'.csv'
    GOSUB OPEN.SEQ.FILE

    RETURN
*-----------------------------------------------------------------------------------------------------------------
*****************
GET.REPORT.LINES:
*****************
* In this para of the program, the report lines are fecthed from TEMP directory
**
    OPEN TEMP.PATH TO TEMP.PTR ELSE
        ERR.MSG  = "Unable to open:'":TEMP.PATH:"'"
        INT.CODE = 'REP001'
        INT.TYPE = 'ONLINE'
        MON.TP   = 04
        REC.CON  = 'MV33-':ERR.MSG
        DESC     = 'MV33-':ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

    SEL.CMD = 'SSELECT ':TEMP.PATH:' LIKE ':FILE.NAME:'...'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    IF NOT(SEL.LIST) THEN
        RETURN
    END

    Y.DLM=","
    REPORT.LINES="ID Cuenta":Y.DLM:"Sucursal debito":Y.DLM:"Sucursal credito":Y.DLM:"Fecha transaccion":Y.DLM
    REPORT.LINES=REPORT.LINES:"Fecha valor":Y.DLM:"Moneda":Y.DLM:"Monto transaccion":Y.DLM:"Debito/Credito":Y.DLM
    REPORT.LINES=REPORT.LINES:"Antiguedad a la fecha":Y.DLM:"Tipo transaccion":Y.DLM:"Codigo cliente":Y.DLM
    REPORT.LINES=REPORT.LINES:"Version":Y.DLM:"Comentarios":Y.DLM:"Referencia transaccion":Y.DLM
    REPORT.LINES=REPORT.LINES:"Arrangement ID":Y.DLM:"STM NOS.1":Y.DLM:"Our Reference":Y.DLM:"Their reference":Y.DLM
    REPORT.LINES=REPORT.LINES:"Narrative":Y.DLM:"Delivery Out Ref":Y.DLM:"Statement Entry ID":Y.DLM
    REPORT.LINES=REPORT.LINES:"Usuario Input":Y.DLM:"Usuario Autoriza"
    GOSUB WRITE.TO.FILE

    LOOP
        REMOVE REC.ID FROM SEL.LIST SETTING REC.POS
    WHILE REC.ID : REC.POS
        R.TEMP.PATH = '';ERR.MSG = ''
        CALL F.READ(TEMP.PATH,REC.ID,R.TEMP.PATH,TEMP.PTR,ERR.MSG)
        IF ERR.MSG NE '' THEN
            ERR.MSG  = "Unable to read rcord :'":REC.ID:"'"
            INT.CODE = 'REP001'
            INT.TYPE = 'ONLINE'
            MON.TP   = 04
            REC.CON  = 'MV33-':ERR.MSG
            DESC     = 'MV33-':ERR.MSG
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END

        REPORT.LINES = R.TEMP.PATH
        GOSUB WRITE.TO.FILE

        CALL F.DELETE(TEMP.PATH,REC.ID)

    REPEAT

    RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
OPEN.SEQ.FILE:
**************
* In this para of the program, the OUT FILE is opened
**
    IF OUT.PATH AND FINAL.OUT.FILE.NAME THEN
        OPENSEQ OUT.PATH,FINAL.OUT.FILE.NAME TO FINAL.SEQ.PTR  ELSE
            CREATE FINAL.SEQ.PTR ELSE
                GOSUB C22.LOG
            END
        END
    END
    ELSE
        GOSUB C22.LOG
    END
    RETURN

********
C22.LOG:
********
    ERR.MSG  = "Unable to open '":FINAL.OUT.FILE.NAME:"'"
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    MON.TP   = 04
    REC.CON  = 'RECONRPT':ERR.MSG
    DESC     = 'RECONRPT':ERR.MSG
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
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
**************
WRITE.TO.FILE:
**************
* In this para of the program, the final array is written to the file
**
    CHANGE FM TO CHARX(13):CHARX(10) IN REPORT.LINES
    WRITESEQ REPORT.LINES APPEND TO FINAL.SEQ.PTR ELSE
        ERR.MSG  = "Unable to write '":FINAL.OUT.FILE.NAME:"'"
        INT.CODE = 'REP001'
        INT.TYPE = 'ONLINE'
        MON.TP   = 04
        REC.CON  = 'RECONRPT':ERR.MSG
        DESC     = 'RECONRPT':ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

    RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
