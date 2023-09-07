* @ValidationCode : MjoxMTY0MTU5MzExOkNwMTI1MjoxNjkzOTIzOTE2NzA3OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Sep 2023 19:55:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VP.B.MON.FILE.GEN
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 04.30.2013
* Description  : Routine for generating monetary file
* Type         : Batch Routine
* Attached to  : BATCH > REDO.VP.MON.SERVICE
* Dependencies : NA
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
** 19-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 19-04-2023 Skanda R22 Manual Conversion - No changes, CALL routine format modified
*-----------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.VISION.PLUS.PARAM
    $INSERT I_F.REDO.VISION.PLUS.TXN.HDR
    $INSERT I_F.REDO.VISION.PLUS.TXN.DET

*    $INSERT I_RAPID.APP.DEV.COMMON
*    $INSERT I_RAPID.APP.DEV.EQUATE
    $USING APAP.REDOSRTN
    $USING APAP.LAPAP
* </region>

    GOSUB INIT
    GOSUB OPEN.FILES

    GOSUB PROCESS

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************
    FN.REDO.VISION.PLUS.PARAM = 'F.REDO.VISION.PLUS.PARAM'
    F.REDO.VISION.PLUS.PARAM  = ''
    R.REDO.VISION.PLUS.PARAM  = ''
    REDO.VISION.PLUS.PARAM.ID = 'SYSTEM'

    FN.REDO.VISION.PLUS.TXN.HDR = 'F.REDO.VISION.PLUS.TXN.HDR'
    F.REDO.VISION.PLUS.TXN.HDR  = ''
    R.REDO.VISION.PLUS.TXN.HDR  = ''

    Y.ERR = ''

    FN.REDO.VISION.PLUS.TXN.DET = 'F.REDO.VISION.PLUS.TXN.DET'
    F.REDO.VISION.PLUS.TXN.DET  = ''
    R.REDO.VISION.PLUS.TXN.DET  = ''

    HDR.RCL = 'VP.MON.FILE.HDR'
    DET.RCL = 'VP.MON.FILE.DET'
    MAP.FMT = 'O'

    HDR.RET.MSG = ''
    HDR.ERR.MSG = ''

    DET.RET.MSG = ''
    DET.ERR.MSG = ''

    VP.TXN.HDR.SEQ = ''

    VP.DET.LIST = ''
    VP.DET.LIST.NAME = ''
    VP.DET.SELECTED = ''
    VP.DET.RET.CODE = ''

    MON.FILE.DATA = ''
    CRLF = CHARX(13) : CHARX(10)

RETURN

***********************
* Open Files
OPEN.FILES:
***********************
    CALL OPF(FN.REDO.VISION.PLUS.PARAM, F.REDO.VISION.PLUS.PARAM)
    CALL OPF(FN.REDO.VISION.PLUS.TXN.HDR,F.REDO.VISION.PLUS.TXN.HDR)
    CALL OPF(FN.REDO.VISION.PLUS.TXN.DET,F.REDO.VISION.PLUS.TXN.DET)

RETURN

***********************
* Main Process
PROCESS:
***********************
    CALL CACHE.READ(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.REDO.VISION.PLUS.PARAM, Y.ERR)
    PROCESS.DATE = TODAY

    MON.FILE.NAME = R.REDO.VISION.PLUS.PARAM<VP.PARAM.MON.FILE.NAME>
    MON.FILE.NAME = '/' : EREPLACE(MON.FILE.NAME, "<YYYYMMDD>", PROCESS.DATE)

    MON.FILE.PATH = R.REDO.VISION.PLUS.PARAM<VP.PARAM.MON.FILE.PATH>

    VP.TXN.HDR.SEQ = 0

    SELECT.STATEMENT  = 'SSELECT ' : FN.REDO.VISION.PLUS.TXN.HDR : ' BY HEADER.BATCH.NBR'                             ;*PACS00879311
*    SELECT.STATEMENT  = 'SSELECT ' : FN.REDO.VISION.PLUS.TXN.HDR : ' BY EVAL ':'"':'FIELD(@ID,':"'.'":',4)':'"'       ;*PACS00879311
    VP.HDR.LIST = ''
    VP.HDR.LIST.NAME = ''
    VP.HDR.SELECTED = ''
    VP.HDR.RET.CODE = ''

    CALL EB.READLIST(SELECT.STATEMENT, VP.HDR.LIST, VP.HDR.LIST.NAME, VP.HDR.SELECTED, VP.HDR.RET.CODE)
    LOOP
        REMOVE VP.TXN.HDR.ID FROM VP.HDR.LIST SETTING VP.TXN.HDR.POS
    WHILE VP.TXN.HDR.ID:VP.TXN.HDR.POS
        CALL F.READ(FN.REDO.VISION.PLUS.TXN.HDR, VP.TXN.HDR.ID, R.REDO.VISION.PLUS.TXN.HDR, F.REDO.VISION.PLUS.TXN.HDR, Y.ERR)
        CRT 'R.REDO.VISION.PLUS.TXN.HDR GET' : R.REDO.VISION.PLUS.TXN.HDR
        CRT 'MAP.FMT' : MAP.FMT
        CRT 'HDR.RCL' : HDR.RCL
        CRT 'FN.REDO.VISION.PLUS.TXN.HDR' : FN.REDO.VISION.PLUS.TXN.HDR
        CRT 'VP.TXN.HDR.ID' : VP.TXN.HDR.ID
        CRT 'HDR.RET.MSG' : HDR.RET.MSG
        CRT 'HDR.ERR.MSG' : HDR.ERR.MSG

* Apply RAD Mapping to header
*        CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT, HDR.RCL, FN.REDO.VISION.PLUS.TXN.HDR, VP.TXN.HDR.ID, R.REDO.VISION.PLUS.TXN.HDR, HDR.RET.MSG, HDR.ERR.MSG) SJ commented for test
*CALL REDO.CONDUIT.LINEAR.TRANSLATION(MAP.FMT, HDR.RCL, FN.REDO.VISION.PLUS.TXN.HDR, VP.TXN.HDR.ID, R.REDO.VISION.PLUS.TXN.HDR, HDR.RET.MSG, HDR.ERR.MSG) ;*R22 MANUAL CONVERSION
        APAP.LAPAP.redoConduitLinearTranslation(MAP.FMT, HDR.RCL, FN.REDO.VISION.PLUS.TXN.HDR, VP.TXN.HDR.ID, R.REDO.VISION.PLUS.TXN.HDR, HDR.RET.MSG, HDR.ERR.MSG);* R22 Manual conversion
        HDR.RET.MSG = EREPLACE(HDR.RET.MSG,";","")
        HDR.RET.MSG = EREPLACE(HDR.RET.MSG,"*"," ")

        MON.FILE.DATA<-1> = HDR.RET.MSG
***************************+GOSUB DETALLES ************************************************++
        GOSUB BUCLE.DETAILS
***************************+END GOSUB DETALLES ************************************************++
    REPEAT

    IF MON.FILE.DATA THEN
        GOSUB WRITE.MON.FILE
    END

* Update Process Date & Sequential in REDO.VISION.PLUS.PARAM
    CALL CDT('', PROCESS.DATE, '+1W')
    R.REDO.VISION.PLUS.PARAM<VP.PARAM.PROCESS.DATE> = PROCESS.DATE
    R.REDO.VISION.PLUS.PARAM<VP.PARAM.VP.TXN.SEQ> = 0
    CALL F.WRITE(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.REDO.VISION.PLUS.PARAM)

* Clear CONCAT files
    CALL EB.CLEAR.FILE(FN.REDO.VISION.PLUS.TXN.HDR,F.REDO.VISION.PLUS.TXN.HDR)
    CALL EB.CLEAR.FILE(FN.REDO.VISION.PLUS.TXN.DET,F.REDO.VISION.PLUS.TXN.DET)

* Log writing: process completed
    APAP.REDOSRTN.redoSNotifyInterfaceAct ('VPL001', 'BATCH', '07', 'EMAIL ARCHIVO MONETARIO', 'FIN - PROCESO MONETARIO A LAS ' : TIMEDATE(), '', '', '', '', '', OPERATOR, '') ;*MANUAL R22 CODE CONVERSION

RETURN
***********************
* Write Monetary File
BUCLE.DETAILS:
***********************
    SELECT.STATEMENT  = 'SSELECT ' : FN.REDO.VISION.PLUS.TXN.DET
    SELECT.STATEMENT := ' WITH @ID LIKE ' : VP.TXN.HDR.ID : '...'

    VP.DET.LIST = ''
    VP.DET.LIST.NAME = ''
    VP.DET.SELECTED = ''
    VP.DET.RET.CODE = ''

    CALL EB.READLIST(SELECT.STATEMENT, VP.DET.LIST, VP.DET.LIST.NAME, VP.DET.SELECTED, VP.DET.RET.CODE)

    LOOP
        REMOVE VP.TXN.DET.ID FROM VP.DET.LIST SETTING VP.TXN.DET.POS
    WHILE VP.TXN.DET.ID:VP.TXN.DET.POS
        CALL F.READ(FN.REDO.VISION.PLUS.TXN.DET, VP.TXN.DET.ID, R.REDO.VISION.PLUS.TXN.DET, F.REDO.VISION.PLUS.TXN.DET, Y.ERR)
        CRT 'R.REDO.VISION.PLUS.TXN.DET GET' : R.REDO.VISION.PLUS.TXN.DET
* Apply RAD Mapping to header
*        CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT, DET.RCL, FN.REDO.VISION.PLUS.TXN.DET, VP.TXN.HDR.ID, R.REDO.VISION.PLUS.TXN.DET, DET.RET.MSG, DET.ERR.MSG)  SJ commented for test
*CALL REDO.CONDUIT.LINEAR.TRANSLATION(MAP.FMT, DET.RCL, FN.REDO.VISION.PLUS.TXN.DET, VP.TXN.HDR.ID, R.REDO.VISION.PLUS.TXN.DET, DET.RET.MSG, DET.ERR.MSG) ;*R22 MANUAL CONVERSION
        APAP.LAPAP.redoConduitLinearTranslation(MAP.FMT, DET.RCL, FN.REDO.VISION.PLUS.TXN.DET, VP.TXN.HDR.ID, R.REDO.VISION.PLUS.TXN.DET, DET.RET.MSG, DET.ERR.MSG);* R22 Manual conversion
        DET.RET.MSG = EREPLACE(DET.RET.MSG,";","")
        DET.RET.MSG = EREPLACE(DET.RET.MSG,"*"," ")

        MON.FILE.DATA<-1> = DET.RET.MSG
    REPEAT

RETURN

***********************
* Write Monetary File
WRITE.MON.FILE:
***********************
    MON.FILE.DATA = CHANGE(MON.FILE.DATA,@FM,CRLF)

* Open File Directory
    OPEN MON.FILE.PATH ELSE

        CRT 'ERROR IN MONETARY FILE PATH!'
        RETURN
    END

* Open File
    MON.FILE.PATH := MON.FILE.NAME
    OPENSEQ MON.FILE.PATH TO MON.FILE THEN
        CRT 'FILE ALREADY EXISTS ' : MON.FILE.PATH
        WEOFSEQ MON.FILE
    END

* Write File
    LOOP
        REMOVE Y.LINE FROM MON.FILE.DATA SETTING Y.LINE.POS
    WHILE Y.LINE:Y.LINE.POS
        WRITESEQ Y.LINE TO MON.FILE ELSE
            CRT 'UNABLE TO WRITE IN FILE ' : MON.FILE.PATH
            BREAK
        END
    REPEAT

* Close File
    CLOSESEQ MON.FILE

RETURN

* </region>

END
