* @ValidationCode : MjoxNTAyMDY1MDYxOkNwMTI1MjoxNjg0ODQyMTUxMDM4OklUU1M6LTE6LTE6MTA3MToxOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1071
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VISA.INITIAL.PROCESS(STLMT.FILE)
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.INITIAL.PROCESS
*Date              : 23.11.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*23/11/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*06 Oct 2011     Balagurunathan              PACS00126440            Added File validation
*------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion         LINE.COUNT+1 to +=1
*19-04-2023       Samaran T               R22 Manual Code Conversion       CALL ROUTINE FORMAT MODIFIED
*------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.VISA.PROCESS.INFO
    $INSERT I_REDO.VISA.INITIAL.PROCESS.COMMON
    $USING APAP.REDOCHNLS

    GOSUB MAIN.PARA

    PATH.BCK=BATCH.DETAILS<3,1,1>

    MOVE.CMD="mv " : FILE.PATH:"/":FILE.NAME : " " :PATH.BCK : "/BCK." : FILE.NAME
    EXECUTE MOVE.CMD


RETURN
*-------------------------------------------------------------------------
MAIN.PARA:
*-------------------------------------------------------------------------
    LINE.COUNT.PREV=0
    FILE.PATH= FIELD(STLMT.FILE,"*",2)
    FILE.NAME=FIELD(STLMT.FILE,"*",1)
    SHELL.CMD ='SH -c '
    FILE.NAME.TMP=FILE.NAME:'TMP'
    EXE.DUX = "dos2unix -n ":FILE.PATH:"/":FILE.NAME:" ":FILE.PATH:"/":FILE.NAME.TMP
    DAEMON.DUX = SHELL.CMD:EXE.DUX
    EXECUTE DAEMON.DUX RETURNING RETURN.VALUE CAPTURING CAPTURE.DUX.VALUE

    MOVE.CMD="mv -f " : FILE.PATH:"/":FILE.NAME.TMP : " " : FILE.PATH:"/":FILE.NAME
    EXECUTE MOVE.CMD

    OPENSEQ FILE.PATH,FILE.NAME TO F.FILE.PATH ELSE
        CALL OCOMO(FILE.NAME:"FILE NOT AVAILABLE IN PATH ":FILE.PATH)
        MON.TP  ='03'
        REC.CON =FILE.NAME:"FILE NOT AVAILABLE IN PATH ":FILE.PATH
        DESC    = FILE.NAME
        GOSUB LOG.ERROR.C22
        RETURN
    END



    CALL F.READ(FN.REDO.VISA.PROCESS.INFO,FILE.NAME,R.REDO.VISA.PROCESS.INFO,F.REDO.VISA.PROCESS.INFO,Y.PROC.ERR)


    IF R.REDO.VISA.PROCESS.INFO NE ''  THEN

        Y.STATUS=R.REDO.VISA.PROCESS.INFO<PROCE.INFO.STATUS>
        IF Y.STATUS EQ 'PROCESSED' THEN
            CALL OCOMO(FILE.NAME : " CANNOT PROCESS TWICE")

            MON.TP='03'
            REC.CON =FILE.NAME : " CANNOT BE PROCESSED TWICE"
            DESC = FILE.NAME
            GOSUB LOG.ERROR.C22


            RETURN
        END
    END

    GOSUB CHK.FILEDATE

    CALL F.READ(FN.REDO.VISA.PROCESS.INFO,STLMT.FILE.DATE,R.REDO.VISA.PROCESS.INFO.DATE,F.REDO.VISA.PROCESS.INFO,Y.PROC.ERR)

    IF R.REDO.VISA.PROCESS.INFO.DATE THEN
        CALL OCOMO(FILE.NAME : " TWO FILES WITH SAME BATCH DATE CANNOT BE PROCESSED" )

        MON.TP='03'
        REC.CON = "TWO FILES WITH SAME BATCH DATE CANNOT BE PROCESSED"
        DESC = FILE.NAME
        GOSUB LOG.ERROR.C22

        RETURN
    END

    SEEK F.FILE.PATH,0, 0 ELSE

        CALL OCOMO(FILE.NAME : "FILE CANNOT PROCESS")
        MON.TP='03'
        REC.CON =FILE.NAME : "FILE CANNOT PROCESS"
        DESC = FILE.NAME
        GOSUB LOG.ERROR.C22
    END

    IF R.REDO.VISA.PROCESS.INFO NE ''  THEN
        Y.STATUS=R.REDO.VISA.PROCESS.INFO<PROCE.INFO.STATUS>
        IF Y.STATUS NE 'PROCESSED' THEN
            LINE.COUNT.PREV= R.REDO.VISA.PROCESS.INFO<PROCE.INFO.LAST.LINE.PROCESS>
        END ELSE
            CALL OCOMO(FILE.NAME : " CANNOT PROCESS TWICE")

            MON.TP='03'
            REC.CON =FILE.NAME : " CANNOT BE PROCESSED TWICE"
            DESC = FILE.NAME
            GOSUB LOG.ERROR.C22


            RETURN
        END
    END ELSE
        R.REDO.VISA.PROCESS.INFO<PROCE.INFO.STATUS>='PROCESSING'
    END
    LINE.COUNT=0


    STLMT.LINES=''
    LINE.FLAG=0

    FILE.BRK=1
    LOOP
    WHILE FILE.BRK
        LINE.COUNT += 1
        READSEQ READ.LINE FROM F.FILE.PATH ELSE

            R.REDO.VISA.PROCESS.INFO<PROCE.INFO.STATUS>='PROCESSED'
            R.PUR.DATE=STLMT.LINES[11,5]
            CALL F.WRITE(FN.REDO.VISA.CNCT.DATE,FILE.NAME,R.PUR.DATE)
            CALL F.WRITE(FN.REDO.VISA.PROCESS.INFO,STLMT.FILE.DATE,'PROCESSED')

            GOSUB WRITE.LINES
            FILE.BRK=0
        END
        IF LINE.COUNT.PREV NE 0 AND  LINE.COUNT LE LINE.COUNT.PREV THEN
            Y.VAL.CONT="CONTINUE PROCESS"
        END ELSE
            GOSUB WRITE.LINES

        END
    REPEAT
RETURN
*-------------------------------------------------------------------------
WRITE.LINES:
*-------------------------------------------------------------------------


    IF READ.LINE[4,1] EQ 0 AND STLMT.LINES NE '' THEN

        CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
        UNIQUE.TIME=FILE.NAME:'*':UNIQUE.TIME
        WRITE STLMT.LINES TO F.REDO.STLMT.CNCT.PROCESS,UNIQUE.TIME ON ERROR

            CALL OCOMO(FILE.NAME:" FILE NOT ABLE TO WRITE ON PATH ":FILE.PATH)

        END
        R.REDO.VISA.PROCESS.INFO<PROCE.INFO.LAST.LINE.PROCESS>=LINE.COUNT
        WRITE R.REDO.VISA.PROCESS.INFO TO F.REDO.VISA.PROCESS.INFO,FILE.NAME ON ERROR

            CALL OCOMO(FILE.NAME:" FILE NOT ABLE TO WRITE ON PATH ":FILE.PATH)

        END

        STLMT.LINES=''
        STLMT.LINES<-1> = READ.LINE


    END ELSE
        STLMT.LINES<-1> = READ.LINE

    END

RETURN

*----------------------------------------------------------------------------
CHK.FILEDATE:

*----------------------------------------------------------------------------
    FILE.END=1
    LOOP
    WHILE FILE.END

        READSEQ READ.LINE FROM F.FILE.PATH THEN
            IF READ.LINE[1,2] EQ 92 THEN
                STLMT.FILE.DATE=READ.LINE[11,5]
            END

        END ELSE
            FILE.END=0
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
LOG.ERROR.C22:
*-----------------------------------------------------------------------------
    MON.TP='04'
    INT.CODE = 'VIS001'
    INT.TYPE = 'BATCH'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''


    CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)    ;*R22 MANUAL CODE CONVERSION

RETURN

END
