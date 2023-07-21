* @ValidationCode : MjotMTg1OTgwMjUzMTpDcDEyNTI6MTY4OTg1NjU5Njc5MTpJVFNTMTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Jul 2023 18:06:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE REDO.R.BCR.REPORT.BUILD
*-----------------------------------------------------------------------------
* Esta rutina es la encargada de generar el archivo correspondiente de acuerdo a los datos
* enviados en el par?metro R.REDO.INTERFACE.PARAM. Este contiene los datos correspondientes
* al formato y localizaci?n final del archivo
* @author youremail@temenos.com
* @stereotype subroutine
* @package REDO
*!
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion            INCLUDE TO INSERT, BP removed in INSERT file, CHAR to CHARX, FM TO @FM, VM TO @VM
*13/07/2023      Suresh                     R22 Manual Conversion          Variable initialised
*------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.BCR.REPORT.DATA
    $INSERT I_F.REDO.BCR.REPORT.EXEC
    $INSERT I_REDO.B.BCR.REPORT.BUILD.COMMON
    $INSERT JBC.h  ;*R22 Auto Conversion - End
    
    $USING APAP.REDOCHNLS
*-----------------------------------------------------------------------------

    EQU LF TO CHARX(10) ;*R22 Auto Conversion
    EQU CR TO CHARX(13) ;*R22 Auto Conversion
    E = ''
    GOSUB INITIALISE
    IF E NE '' THEN
        RETURN
    END

    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    K.INT.CODE=Y.INT.CODE
    K.INT.TYPE='BATCH'
    K.BAT.NO=1
    K.BAT.TOT=''
    K.INFO.OR=''
    K.INFO.DE=''
    K.ID.PROC=''
    K.MON.TP='01'
    K.DESC=''
    K.REC.CON=''
    K.EX.USER='OPERATOR'
    K.EX.PC='TNO'

    Y.SEL = 'SELECT ' :FN.BCR
    CALL EB.READLIST(Y.SEL, Y.KEY.LIST, '', SELECTED, SYSTEM.ERR)

    K.BAT.TOT=DCOUNT(Y.KEY.LIST,@FM)

    K.DESC = ""
    LOOP
        REMOVE Y.BCR.ID FROM Y.KEY.LIST SETTING Y.POS
    WHILE Y.BCR.ID:Y.POS
        M.ERR = '';R.BCR = '';R.RETURN.MESSAGE = ''; Y.ERR = ''
        CALL RAD.CONDUIT.LINEAR.TRANSLATION("FORMAT",Y.BCR.TYPE,"F.REDO.BCR.REPORT.DATA",Y.BCR.ID,R.BCR,R.RETURN.MESSAGE,Y.ERR)
        IF Y.ERR EQ '' THEN
            yLine = R.RETURN.MESSAGE
            GOSUB WRITE.LINE
        END
    REPEAT

    WEOFSEQ  F.PROP.FILE.1    ;* Writes an EOF
    CLOSESEQ F.PROP.FILE.1
**---ET-2149
    R.REDO.BCR.REPORT.EXEC<REDO.BCR.REP.EXE.REP.TIME.RANGE> = R.DATES(EB.DAT.LAST.WORKING.DAY)
*--R.REDO.BCR.REPORT.EXEC<REDO.BCR.REP.EXE.REP.TIME.RANGE> = TODAY
    CALL F.WRITE(FN.REDO.BCR.REPORT.EXEC, Y.INT.CODE, R.REDO.BCR.REPORT.EXEC)
RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    FN.BCR = 'F.REDO.BCR.REPORT.DATA'
    F.BCR = ''
    CALL OPF(FN.BCR, F.BCR)

    FN.REDO.INTERFACE.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INTERFACE.PARAM = ''
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)

    FN.REDO.BCR.REPORT.EXEC = 'F.REDO.BCR.REPORT.EXEC'
    F.REDO.BCR.REPORT.EXEC  = ''
    CALL OPF(FN.REDO.BCR.REPORT.EXEC,F.REDO.BCR.REPORT.EXEC)
    Y.INT.CODE = 'BCR001'
    CALL F.READ(FN.REDO.BCR.REPORT.EXEC,Y.INT.CODE,R.REDO.BCR.REPORT.EXEC,F.REDO.BCR.REPORT.EXEC,EXEC.ERR)
    Y.LOAN.PRODUCT = R.REDO.BCR.REPORT.EXEC<REDO.BCR.REP.EXE.LOAN.PRODUCT.GROUP>

    ERR.REDO.INTERFACE.PARAM = ''; R.REDO.INTERFACE.PARAM = ''
    CALL F.READ(FN.REDO.INTERFACE.PARAM,Y.INT.CODE,R.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM,ERR.REDO.INTERFACE.PARAM)
    Y.BCR.TYPE= "BCR.EXTEND"
    yPath=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DIR.PATH>
    yPropFile=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FILE.NAME>
    Y.FILE.NAME1 = yPropFile:'.1'
    Y.FILE.NAME2 = yPropFile:'.2'


    OPENSEQ yPath, Y.FILE.NAME1 TO F.PROP.FILE.1  THEN
        DELETESEQ yPath, Y.FILE.NAME1 THEN
        END ELSE
            NULL    ;* In case if it exisit DELETE, for Safer side
        END
        OPENSEQ yPath, Y.FILE.NAME1 TO F.PROP.FILE.1 ELSE   ;* After DELETE file pointer will be closed, hence reopen the file
            CREATE F.PROP.FILE.1 ELSE
                RETURN
            END
        END
    END ELSE
        CREATE F.PROP.FILE.1 ELSE
            AF = 1
            E    = "ST-REDO.BCR.PROPERTY.NOT.FOUND"
            E<2> = Y.FILE.NAME1 : @VM : yPath
            K.MON.TP='08'
            K.DESC=E
            APAP.REDOCHNLS.redoInterfaceRecAct(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC) ;*R22 Manual Conversion
            RETURN
        END
    END
RETURN

*-----------------------------------------------------------------------------
WRITE.LINE:
*-----------------------------------------------------------------------------
    yLine = yLine
    WRITESEQ yLine TO F.PROP.FILE.1 ELSE
        K.MON.TP='08'
        K.DESC= "ERROR TRYING TO WRITE ON FILE " : yPath : "/" : Y.FILE.NAME1
        APAP.REDOCHNLS.redoInterfaceRecAct(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC) ;*R22 Manual Conversion
        CALL OCOMO("ERROR TRYING TO WRITE TO SEQ-FILE " : K.DESC)
    END
RETURN
*-----------------------------------------------------------------------------
END
