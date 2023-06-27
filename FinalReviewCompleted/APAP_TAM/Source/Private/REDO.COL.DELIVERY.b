* @ValidationCode : MjotNDk3NDk2NDI1OkNwMTI1MjoxNjg1OTUzNTcwNjgyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jun 2023 13:56:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.COL.DELIVERY(Y.TABLE.ID)
*-----------------------------------------------------------------------------
* REDO COLLECTOR INTERFACE
* 1. Take FROM the QUEUE the list of DMLS TO be processed
* 2. Open DB Connection using java routine, and mark it as setAutoCommit = false
* 3. Process each entry into the queue and call java routine to make the INSERT
* 4. IF everything ok, then remove the Y.TABLE.ID from the tracer record,
*       and delete all records from the queue
* 5. ELSE copy the entry to the QUEUE.ERROR
*-----------------------------------------------------------------------------
*
* Modification History:
*
*    2010-11-15 : APAP-C.1 hpasquel@temenos.com
*  2013-06-28 : Fixing issues mgudino
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - CALL RTN FORMAT MODIFIED
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.COL.DELIVERY.COMMON
    $USING APAP.REDORETAIL

*-----------------------------------------------------------------------------

    GOSUB INITIALISE

    IF Y.ERROR THEN
        RETURN
    END

    IF Y.REDO.COL.QUEUE.LIST NE "" THEN
        GOSUB PROCESS
    END

    GOSUB DELETE.ENTRY

RETURN
*-----------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------
    Y.CONTADOR = 0
* C.22 START OF PROCESS
    C.MON.TP='06'
    C.ID.PROC = REDO.INTERFACE.PARAM.ID
*CALL REDO.INTERFACE.REC.ACT(C.INT.CODE,C.INT.TYPE,Y.CONTADOR,Y.NUM.TO.PROCESS,C.INFO.OR,C.INFO.DE,C.ID.PROC,C.MON.TP,C.DESC,C.REC.CON,C.EX.USER,C.EX.PC)


    LOOP
        Y.REQUEST = ''


* for each RECORD in the queue, how many batch to be process
* We pass more than 1 instruction each time to Java improving the performance
        I.VAR = 0 ;* R22 Auto conversion
        Y.DETAILS.REC = ""
        LOOP
            REMOVE REDO.COL.QUEUE.ID FROM Y.REDO.COL.QUEUE.LIST SETTING REDO.COL.QUEUE.MARK
            IF NOT(REDO.COL.QUEUE.ID : REDO.COL.QUEUE.MARK) THEN
                BREAK       ;* There were not more insert to be process
            END
            R.REDO.COL.QUEUE = ''
            Y.ERR = ''
            CALL F.READ(FN.REDO.COL.QUEUE,REDO.COL.QUEUE.ID,R.REDO.COL.QUEUE,F.REDO.COL.QUEUE,Y.ERR)
            IF Y.ERR NE '' THEN
                TEXT = Y.ERR
                GOSUB TRACE.ERROR
                RETURN
            END
            Y.REQUEST<-1>     = REDO.COL.QUEUE.ID : @VM : R.REDO.COL.QUEUE<2>
            Y.DETAILS.REC<1,-1> = REDO.COL.QUEUE.ID
            Y.DETAILS.REC<2,-1> = R.REDO.COL.QUEUE<4>   ;* Campo 4 contiene el detalle
        WHILE I.VAR LT DB.BATCH.SIZE ;* R22 Auto conversion
            I.VAR += 1 ;* R22 Auto conversion
        REPEAT

* something to process ??
        IF Y.REQUEST NE '' THEN
            Y.RESPONSE    = ''
* Execute the insert into Data Base
            GOSUB PROCESS.RECORD
            IF Y.ERROR THEN
                RETURN
            END
        END

        Y.CONTADOR += DB.BATCH.SIZE

    WHILE REDO.COL.QUEUE.ID : REDO.COL.QUEUE.MARK
    REPEAT

* Commit
    Y.EB.API.ID = "REDO.COL.DB.COMMIT"
    Y.REQUEST     = ''
    GOSUB CALL.JAVA
    IF Y.ERROR THEN
        RETURN
    END

* Close connection
    Y.EB.API.ID = "REDO.COL.DB.CLOSE"
    Y.REQUEST     = ''
    GOSUB CALL.JAVA
    IF Y.ERROR THEN
* Don't care, the commit was done OK
        Y.ERROR = 0
        CALL OCOMO("JAVA EXCEPTION TRYING TO CLOSE THE CONNECTION, PLEASE CHECK")
    END

* Remove the entries from QUEUE
    IF Y.REDO.COL.QUEUE.LIST NE '' THEN
        DELETE.STATEMENT = "DELETE " : FN.REDO.COL.QUEUE
        CALL OCOMO(DELETE.STATEMENT)
        EXECUTE DELETE.STATEMENT PASSLIST Y.REDO.COL.QUEUE.LIST CAPTURING Y.CAP RETURNING Y.RET
        CALL OCOMO(Y.CAP)
    END


RETURN

*-----------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------
* C.22

    Y.MUST.DELETE = 1
    C.INT.CODE = 'COL001'
    C.INT.TYPE = 'BATCH'
    C.BAT.NO = 1
    C.BAT.TOT = 0
    C.INFO.OR = ''
    C.INFO.DE = ''
*C.ID.PROC = C.BAT.NO
    C.MON.TP = '01'
    C.DESC = 'INICIO DEL PROCESO EN REDO.COL.DELIVERY'
    C.REC.CON = ''
    C.EX.USER = OPERATOR
    C.EX.PC = C$T24.SESSION.NO ;* R22 Auto conversion

* Error Flag
    Y.ERROR = 0

    CALL OCOMO("PORCESSING " : Y.TABLE.ID)

    Y.SEL.STMT = 'SELECT ':FN.REDO.COL.QUEUE : " WITH F1 EQ '" : Y.TABLE.ID : "' BY @ID"
    Y.REDO.COL.QUEUE.LIST = ''
    LIST.NAME = ''
    Y.NUM.TO.PROCESS = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(Y.SEL.STMT,Y.REDO.COL.QUEUE.LIST,LIST.NAME,Y.NUM.TO.PROCESS,SYSTEM.RETURN.CODE)

    IF Y.NUM.TO.PROCESS LT 0 OR Y.REDO.COL.QUEUE.LIST EQ '' THEN
        CALL OCOMO("NOTHING TO PROCESS, FOR TABLE " : Y.TABLE.ID)
        Y.ERROR = 1     ;* Please don't go to next process
        RETURN
    END

* Open Data Base Connection
    Y.EB.API.ID = "REDO.COL.DB.OPEN"
    Y.REQUEST     = DB.COL.CONNECTION
    GOSUB CALL.JAVA
    IF Y.ERROR THEN
        RETURN
    END

    Y.STOP.PROCESSING = 0

* Truncate Current Table
    Y.EB.API.ID = "REDO.COL.DB.TRUNCATE"
    Y.REQUEST  = Y.TABLE.ID
    GOSUB CALL.JAVA
    IF Y.ERROR THEN
        RETURN
    END

* setAutoCommit = FALSE
    Y.EB.API.ID = "REDO.COL.DB.AUTO.COMMIT"
    Y.REQUEST  = ''
    GOSUB CALL.JAVA
    IF Y.ERROR THEN
        RETURN
    END

RETURN

*-----------------------------------------------------------------------
PROCESS.RECORD:
*-----------------------------------------------------------------------
* AMMEND FOR FIX THE ISSUE: PACS00296264
*    CHANGE VM TO '@vm' IN Y.REQUEST
*    CHANGE FM TO '@fm' IN Y.REQUEST
    Y.REQUEST = CHANGE(Y.REQUEST,@VM,'@vm')
    Y.REQUEST = CHANGE(Y.REQUEST,@FM,'@fm')
*    CALL OCOMO('Y.REQUEST ':Y.REQUEST )

*CALL REDO.COL.R.CALL.JAVA.API("REDO.COL.DB.INSERT", Y.REQUEST, Y.RESPONSE) ;*R22 MANUAL CODE CONVERSION
    APAP.REDORETAIL.redoColRCallJavaApi("REDO.COL.DB.INSERT", Y.REQUEST, Y.RESPONSE) ;*R22 MANUAL CODE CONVERSION
* If an error occured, then keep the message and Copy to the Queue.Error
    IF Y.RESPONSE NE '' THEN
* Keep the message
        GOSUB COPY.ERROR.QUEUE
* Rollback
        Y.EB.API.ID = "REDO.COL.DB.ROLLBACK"
        Y.RESPONSE1    = ''
        Y.REQUEST     = ''
*CALL REDO.COL.R.CALL.JAVA.API(Y.EB.API.ID, Y.REQUEST, Y.RESPONSE1);*R22 MANUAL CODE CONVERSION
        APAP.REDORETAIL.redoColRCallJavaApi(Y.EB.API.ID, Y.REQUEST, Y.RESPONSE1) ;*R22 MANUAL CODE CONVERSION
        IF Y.RESPONSE1 NE '' THEN
            CALL OCOMO("ROLLBACK WAS NOT SUCCESSFULLY DONE ... PLEASE CHECK DB " : Y.RESPONSE1)
        END
* Trace Original Error, but the service must continue with the next ID
        TEXT = Y.RESPONSE
        GOSUB TRACE.ERROR
    END ELSE

        Y.TOTAL.REC = DCOUNT(Y.DETAILS.REC<1>,@VM)

        FOR X1 = 1 TO  Y.TOTAL.REC
*AQUI C.22 CORRECTO

            C.MON.TP='01'
            C.DESC = 'PROCESO REDO.COL.DELIVERY'
            C.ID.PROC = REDO.INTERFACE.PARAM.ID
*CALL REDO.INTERFACE.REC.ACT(C.INT.CODE,C.INT.TYPE,Y.CONTADOR,Y.NUM.TO.PROCESS,C.INFO.OR,C.INFO.DE,C.ID.PROC,C.MON.TP,C.DESC,C.REC.CON,C.EX.USER,C.EX.PC)

*INVOCACION A REDO.R.COL.PROCESS.TRACE con status = 10
*CALL REDO.R.COL.PROCESS.TRACE('DELIVERY', 10, Y.CONTADOR + X1, Y.TABLE.ID, Y.DETAILS.REC<2,X1>, '') ;*R22 MANUAL CODE CONVERSION
            APAP.TAM.redoRColProcessTrace('DELIVERY', 10, Y.CONTADOR + X1, Y.TABLE.ID, Y.DETAILS.REC<2,X1>, '') ;*R22 MANUAL CODE CONVERSION
        NEXT X1
    END

    C.MON.TP='07'
    C.DESC = 'FIN PROCESO REDO.COL.DELIVERY'
    C.ID.PROC = REDO.INTERFACE.PARAM.ID
*CALL REDO.INTERFACE.REC.ACT(C.INT.CODE,C.INT.TYPE,Y.CONTADOR,Y.NUM.TO.PROCESS,C.INFO.OR,C.INFO.DE,C.ID.PROC,C.MON.TP,C.DESC,C.REC.CON,C.EX.USER,C.EX.PC)
RETURN

*-----------------------------------------------------------------------
CALL.JAVA:
*-----------------------------------------------------------------------
    Y.RESPONSE    = ''
*CALL REDO.COL.R.CALL.JAVA.API(Y.EB.API.ID, Y.REQUEST, Y.RESPONSE) ;*R22 MANUAL CODE CONVERSION
    APAP.REDORETAIL.redoColRCallJavaApi(Y.EB.API.ID, Y.REQUEST, Y.RESPONSE) ;*R22 MANUAL CODE CONVERSION
    IF Y.RESPONSE NE '' THEN
        TEXT = Y.RESPONSE
        GOSUB TRACE.ERROR
    END
RETURN

*-----------------------------------------------------------------------
COPY.ERROR.QUEUE:
*-----------------------------------------------------------------------

    R.REDO.COL.QUEUE = ''
    YERR = ''
* In the second position we recived the QUEUE.ID from java application
    REDO.COL.QUEUE.ID = CHANGE(Y.RESPONSE,'|',@FM )<2>
    CALL F.READ(FN.REDO.COL.QUEUE,REDO.COL.QUEUE.ID,R.REDO.COL.QUEUE,F.REDO.COL.QUEUE,YERR)
* Keep the error message on the QUEUE.ERROR
    R.REDO.COL.QUEUE<3> = Y.RESPONSE
    WRITE R.REDO.COL.QUEUE TO F.REDO.COL.QUEUE.ERROR, REDO.COL.QUEUE.ID SETTING Y.ERR ON ERROR

        CALL OCOMO(Y.ERR)
    END
    CALL OCOMO("ERROR TRYING TO MAKE INSERT QUEUE.ID " : REDO.COL.QUEUE.ID)
    CALL OCOMO("JAVA RESPONSE" : Y.RESPONSE)
RETURN

*-----------------------------------------------------------------------
* Remove the TABLE from the list to process
DELETE.ENTRY:
*-----------------------------------------------------------------------
    IF Y.MUST.DELETE THEN
*CALL REDO.COL.R.DEL.UPD.LOCKING("DELETE",Y.TABLE.ID) ;*R22 MANUAL CODE CONVERSION
        APAP.REDORETAIL.redoColRDelUpdLoking("DELETE",Y.TABLE.ID) ;*R22 MANUAL CODE CONVERSION
        CALL OCOMO("DONE " : Y.TABLE.ID)
    END

RETURN

*-----------------------------------------------------------------------
* Call Trace Api's
TRACE.ERROR:
*-----------------------------------------------------------------------

* C.22 ERROR
    C.DESC = TEXT
    CALL TXT(C.DESC)
    C.MON.TP='08'
*       C.DESC = TEXT
    C.ID.PROC = REDO.INTERFACE.PARAM.ID
*CALL REDO.INTERFACE.REC.ACT(C.INT.CODE,C.INT.TYPE,C.BAT.NO,C.BAT.TOT,C.INFO.OR,C.INFO.DE,C.ID.PROC,C.MON.TP,C.DESC,C.REC.CON,C.EX.USER,C.EX.PC)
    Y.DETAIL = ""
    Y.VM.POS = 0
    LOCATE REDO.COL.QUEUE.ID IN Y.DETAILS.REC<1,1> SETTING Y.VM.POS THEN
        Y.DETAIL = Y.DETAILS.REC<2,Y.VM.POS>
    END ELSE
        Y.VM.POS = 1
    END
*INVOCACION A REDO.R.COL.PROCESS.TRACE con status = 20
*CALL REDO.R.COL.PROCESS.TRACE('DELIVERY', 20, Y.CONTADOR + Y.VM.POS, Y.TABLE.ID, Y.DETAIL, C.DESC) ;*R22 MANUAL CODE CONVERSION
    APAP.TAM.redoRColProcessTrace('DELIVERY', 20, Y.CONTADOR + Y.VM.POS, Y.TABLE.ID, Y.DETAIL, C.DESC) ;*R22 MANUAL CODE CONVERSION
*CALL REDO.R.COL.EXTRACT.ERROR(C.DESC, C.ID.PROC,Y.TABLE.ID) ;*R22 MANUAL CODE CONVERSION
    APAP.TAM.redoRColExtractError(C.DESC, C.ID.PROC,Y.TABLE.ID) ;*R22 MANUAL CODE CONVERSION
    SOURCE.INFO = "REDO.COL.DELIVERY"
    SOURCE.INFO<7> = "YES"      ;* get out of this thread and get the next table
    CALL OCOMO(TEXT)
    CALL FATAL.ERROR(SOURCE.INFO)
    Y.ERROR = 1
    Y.MUST.DELETE = 0 ;* Please  don't remove the entry for F.LOCKING

RETURN
*-----------------------------------------------------------------------
END
