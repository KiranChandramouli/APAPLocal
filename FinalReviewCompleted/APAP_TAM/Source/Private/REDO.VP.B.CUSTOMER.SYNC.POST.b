* @ValidationCode : MjotNzQzNjc3ODIxOkNwMTI1MjoxNjg0ODQyMTUyNDc1OklUU1M6LTE6LTE6MjY2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 266
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VP.B.CUSTOMER.SYNC.POST
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine read and generates a log file
*
* Developed By          : Prabhu
*
* Development Reference : v+ fix
*
* Attached To           :
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
* v+ fix             Prabhu N                             2015-09-01           Initial Draft
*-----------------------------------------------------------------------------------------------------------------
* Include files
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.VISION.PLUS.PARAM
    $USING APAP.REDOSRTN
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
**

    GOSUB OPEN.PARA

RETURN
*-----------------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
    PROCESS.DATE=TODAY
    FN.REDO.VISION.PLUS.PARAM = 'F.REDO.VISION.PLUS.PARAM'
    F.REDO.VISION.PLUS.PARAM  = ''
    REDO.VISION.PLUS.PARAM.ID = 'SYSTEM'

    CALL CACHE.READ(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.REDO.VISION.PLUS.PARAM, Y.ERR)

    CS.PATH = TRIM(R.REDO.VISION.PLUS.PARAM<VP.PARAM.CS.FILE.PATH>,' ','B')
    CS.FILE = TRIM(R.REDO.VISION.PLUS.PARAM<VP.PARAM.CS.FILE.NAME>,' ','B')

    CS.FILE= EREPLACE(CS.FILE, "<YYYYMMDD>", PROCESS.DATE)

    OPEN CS.PATH TO Y.PTR THEN

        GOSUB PROCESS.PARA
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
**

    SEL.CMD = "SELECT " :CS.PATH: " LIKE " :'CS':PROCESS.DATE: ".temp..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    IF NOT(SEL.LIST) THEN
        RETURN
    END

    SHELL.CMD ='SH -c '
    EXEC.COM="cat "
    OLD.OUT.FILES = 'CS':PROCESS.DATE:'.temp*'
    LOG.FILE.NAME = 'CS':PROCESS.DATE:'.log'

    EXE.CAT = "cat ":CS.PATH:"/":OLD.OUT.FILES:" >> ":CS.PATH:"/":LOG.FILE.NAME
    EXE.RM="rm ":CS.PATH:"/":OLD.OUT.FILES

    DAEMON.CMD = SHELL.CMD:EXE.CAT
    DAEMON.REM.CMD = SHELL.CMD:EXE.RM

    EXECUTE DAEMON.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CAT.VALUE
    EXECUTE DAEMON.REM.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.REM.VALUE

    GOSUB WRITE.PARA
RETURN

**************
WRITE.PARA:
**************
**
    Y.ERR.LOG = ' [CON ERRORES] '
*CALL REDO.S.NOTIFY.INTERFACE.ACT ('VPL006', 'BATCH', '07', 'EMAIL SINCRONIZACION DE CLIENTES', 'FIN' : Y.ERR.LOG : '- SINCRONIZACION DE CLIENTES A LAS ' : TIMEDATE() : ' - LOG EN ' : CS.PATH : '\' : LOG.FILE.NAME, '', '', '', '', '', OPERATOR, '')
** R22 Manual conversion
    APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL006', 'BATCH', '07', 'EMAIL SINCRONIZACION DE CLIENTES', 'FIN' : Y.ERR.LOG : '- SINCRONIZACION DE CLIENTES A LAS ' : TIMEDATE() : ' - LOG EN ' : CS.PATH : '\' : LOG.FILE.NAME, '', '', '', '', '', OPERATOR, '')
RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
