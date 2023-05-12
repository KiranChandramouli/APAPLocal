* @ValidationCode : MjoxOTcxNzM0NTk5OkNwMTI1MjoxNjgyNTk0MzkzMjEyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Apr 2023 16:49:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.MASSIVE.FILE.PROCESS.POST
* Description:
* This routine is a multithreaded routine to save result files of previous process
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Jlobos
* PROGRAM NAME : REDO.MASSIVE.FILE.PROCESS.POST
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE           WHO       REFERENCE          DESCRIPTION
* 2019-07-16     jlobos    PACS00761324       INITIAL CREATION
** 13-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 13-04-2023 Skanda R22 Manual Conversion - Call routine prefix added
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.REDO.MASSIVE.FILE.PATH
    $INSERT I_REDO.MASSIVE.FILE.PROCESS.COMMON
*------------------------------------------------------------------------------------------

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB SAVEREPORTFILES
    GOSUB REMPROCFILES
    GOSUB CLEARCONCATFILES

RETURN

*------------------------------------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------------------------------------
    CALL APAP.TAM.redoMassiveFileProcessLoad ;* R22 Manual conversion

    FN.L.REDO.MASSIVE.CONCAT = 'FBNK.REDO.MASSIVE.CONCAT'
    F.L.REDO.MASSIVE.CONCAT = ''
    CALL OPF(FN.L.REDO.MASSIVE.CONCAT, F.L.REDO.MASSIVE.CONCAT)

    FN.L.REDO.MASSIVE.CONCAT.EX = 'FBNK.REDO.MASSIVE.CONCAT.EX'
    F.L.REDO.MASSIVE.CONCAT.EX = ''
    CALL OPF(FN.L.REDO.MASSIVE.CONCAT.EX, F.L.REDO.MASSIVE.CONCAT.EX)

RETURN

*------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------
    ICOUNT = ''
    SEL.CMD.CONCAT = ''
    RES.CONCAT = ''
    RES.NUM = ''
    RES.ERR = ''
    SEL.CMD.CONCAT.EX = ''
    RES.CONCAT.EX = ''
    RES.NUM.EX = ''
    RES.ERR.EX = ''
    Y.RES.CONCAT.FINAL = ''
    Y.RES.CONCAT.FINAL.EX = ''
    RES.ID = ''
    R.CONCAT.PROCESSED = ''
    R.ERR = ''
    RES.EX.ID = ''
    R.CONCAT.EXCEPTION = ''
    R.EX.ERR = ''

* Process the PROCESSED Ok records
    SEL.CMD.CONCAT = 'SELECT ': FN.L.REDO.MASSIVE.CONCAT
    CALL EB.READLIST(SEL.CMD.CONCAT,RES.CONCAT,'',RES.NUM,RES.ERR)
    Y.RES.CONCAT.FINAL = "ID_PRESTAMO,ID_CLIENTE,TIPO_OPERACION,TASA_MARGEN,TASA_INT_PROPUESTA,NOMBRE_ARCHIVO"
    FOR ICOUNT=1 TO RES.NUM
        RES.ID = RES.CONCAT<ICOUNT>
        CALL F.READ(FN.L.REDO.MASSIVE.CONCAT, RES.ID, R.CONCAT.PROCESSED, F.L.REDO.MASSIVE.CONCAT, R.ERR)
        IF R.ERR EQ '' THEN
*If J.FILENAME is empty, get the filename
            IF J.FILENAME EQ '' THEN
                J.FILENAME = FIELD(R.CONCAT.PROCESSED<1>,',',6)
            END
            Y.RES.CONCAT.FINAL<-1> = R.CONCAT.PROCESSED<1>
        END
    NEXT ICOUNT

* Process the EXCEPTION records
    SEL.CMD.CONCAT.EX = 'SELECT ':FN.L.REDO.MASSIVE.CONCAT.EX
    CALL EB.READLIST(SEL.CMD.CONCAT.EX,RES.CONCAT.EX,'',RES.NUM.EX,RES.ERR.EX)
    Y.RES.CONCAT.FINAL.EX = "ID_PRESTAMO,ID_CLIENTE,TIPO_OPERACION,TASA_MARGEN,TASA_INT_PROPUESTA,NOMBRE_ARCHIVO"
    FOR ICOUNT=1 TO RES.NUM.EX
        RES.EX.ID = RES.CONCAT.EX<ICOUNT>
        CALL F.READ(FN.L.REDO.MASSIVE.CONCAT.EX, RES.EX.ID, R.CONCAT.EXCEPTION, F.L.REDO.MASSIVE.CONCAT.EX, R.EX.ERR)
        IF R.EX.ERR EQ '' THEN
            Y.RES.CONCAT.FINAL.EX<-1> = R.CONCAT.EXCEPTION<1>
        END
    NEXT ICOUNT

RETURN

*------------------------------------------------------------------------------------------
SAVEREPORTFILES:
*------------------------------------------------------------------------------------------
    IF J.FILENAME EQ '' THEN
        J.FILENAME = "FILES_PROCESSED_" : TODAY
    END

    Y.PROCESS.PATH = R.FILE.DETAILS<MASS.FILE.PROCESSED.PATH>
    OPEN Y.PROCESS.PATH TO F.PROCESS.PATH THEN
        IF Y.RES.CONCAT.FINAL NE "" THEN
            WRITE Y.RES.CONCAT.FINAL TO F.PROCESS.PATH,J.FILENAME
        END
    END ELSE
        CALL OCOMO(J.FILENAME:" File not available in path ":F.PROCESS.PATH)
    END

    Y.EXCEPTION.PATH = R.FILE.DETAILS<MASS.FILE.EXCEPTION.PATH>
    OPEN Y.EXCEPTION.PATH TO F.EXCEPTION.PATH THEN
        IF Y.RES.CONCAT.FINAL.EX NE "" THEN
            WRITE Y.RES.CONCAT.FINAL.EX TO F.EXCEPTION.PATH,J.FILENAME
        END
    END ELSE
        CALL OCOMO(J.FILENAME:" File not available in path ":F.EXCEPTION.PATH)
    END

RETURN

*------------------------------------------------------------------------------------------
REMPROCFILES:
*------------------------------------------------------------------------------------------
*GETS LIST OF FILENAMES
    Y.FILE.NAME = ''
    Y.FILENAMES = ''
    NUM.ELEM = ''
    NUM.ELEM.EX = ''

    NUM.ELEM = DCOUNT(Y.RES.CONCAT.FINAL,@FM)
    FOR ICOUNT=1 TO NUM.ELEM
        Y.FILE.NAME = FIELD(Y.RES.CONCAT.FINAL<ICOUNT>,',',6)
        FINDSTR Y.FILE.NAME IN  Y.FILENAMES SETTING VAR.POS ELSE
            Y.FILENAMES<-1> = Y.FILE.NAME
        END
    NEXT ICOUNT

    NUM.ELEM.EX = DCOUNT(Y.RES.CONCAT.FINAL.EX,@FM)
    FOR ICOUNT=1 TO NUM.ELEM.EX
        Y.FILE.NAME = FIELD(Y.RES.CONCAT.FINAL.EX<ICOUNT>,',',6)
        FINDSTR Y.FILE.NAME IN  Y.FILENAMES SETTING VAR.POS ELSE
            Y.FILENAMES<-1> = Y.FILE.NAME
        END
    NEXT ICOUNT

* REMOVES THE FILES FROM UNPROCESSED PATH
    Y.FILE.PATH = R.FILE.DETAILS<MASS.FILE.UNPROCESSED.PATH>
    CNT = DCOUNT(Y.FILENAMES,@FM) ;* R22 Auto conversion
    FOR ICOUNT = 1 TO CNT ;* R22 Auto conversion
        Y.FILE.NAME = Y.FILENAMES<ICOUNT>
        IF Y.FILE.NAME NE '' AND Y.FILE.NAME NE 'NOMBRE_ARCHIVO' THEN
            REMOVE.CMD = "rm -r " : Y.FILE.PATH:"/":Y.FILE.NAME
            CALL OCOMO("REMOVE.CMD = ": REMOVE.CMD)
            EXECUTE REMOVE.CMD
        END
    NEXT ICOUNT

RETURN

*------------------------------------------------------------------------------------------
CLEARCONCATFILES:
*------------------------------------------------------------------------------------------
*Clean the contents of Concat temp file
    J.CLEAR.COMMAND = ''
    J.CLEAR.COMMAND = 'CLEAR-FILE ':FN.L.REDO.MASSIVE.CONCAT
    CALL OCOMO("J.CLEAR.COMMAND DE PROCESS = ":J.CLEAR.COMMAND)
    EXECUTE J.CLEAR.COMMAND

    J.CLEAR.COMMAND = 'CLEAR-FILE ':FN.L.REDO.MASSIVE.CONCAT.EX
    CALL OCOMO ("J.CLEAR.COMMAND DE EXCEPTION = ":J.CLEAR.COMMAND)
    EXECUTE J.CLEAR.COMMAND

RETURN

END
