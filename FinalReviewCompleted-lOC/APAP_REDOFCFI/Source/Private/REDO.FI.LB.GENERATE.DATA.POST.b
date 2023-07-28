* @ValidationCode : MjoxNDE5OTU2ODczOlVURi04OjE2ODM2MTYwOTcxMzQ6SVRTUzotMTotMToxNDg2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 May 2023 12:38:17
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1486
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.LB.GENERATE.DATA.POST
*-----------------------------------------------------------------------------
* Subroutine Type : Subroutine
* Attached to     : BATCH record REDO.FI.PLANILLA
* Attached as     : Subroutine
* Primary Purpose : Id Pay Method is external save file .txt with loans to pay and save file .ans to indicate the process end
*
* Incoming:
* ---------
* Outgoing:
* ---------
*
* Error Variables:
* ----------------
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Ana Noriega - TAM Latin America
* Date            : Nov 23, 2010
*
*-----------------------------------------------------------------------------------
* Modified by     : Adriana Velasco - TAM Latin America
* Date            : Oct. 21, 2011
* Details         : Change select conditions to use L.AA.FORM or L.AA.PAY.METHD depending of
*                   some validations
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*=====================================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
*
    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
*
    $INSERT I_F.REDO.FI.LB.BPROC
    $INSERT I_F.REDO.FI.LB.BPROC.DET
    $USING APAP.REDOCHNLS
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN

* ======
PROCESS:
* ======


    LOOP
        REMOVE FI.GROUP.ID FROM PLANILLA.GROUP.LIST SETTING Y.GROUP.POS.FILE
    WHILE FI.GROUP.ID:Y.POS.FILE
        LOCATE FI.GROUP.ID IN PLANILLA.GROUP.LIST SETTING GROUP.SEQ.POS THEN
            Y.ID.SEQ = PLANILLA.SEQ.LIST<GROUP.SEQ.POS>
        END
        CALL F.READ(FN.REDO.INTERFACE.PARAM, FI.GROUP.ID, R.REDO.GRP.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM, Y.ERR)

        PLANILLA.LIST = R.REDO.GRP.INTERFACE.PARAM<REDO.INT.PARAM.AFF.COMPANY>
        IF FI.GROUP.ID EQ 'APAP-EMPLEADOS' THEN
            PLANILLA.LIST = 'APAP-EMPLEADOS'
        END
        IF FI.GROUP.ID EQ 'APAP-EXEC-EMPLEADOS' THEN
            PLANILLA.LIST = 'APAP-EXEC-EMPLEADOS'
        END

        LOOP

            REMOVE Y.ID.PLANILLA FROM  PLANILLA.LIST SETTING Y.POS.FILE
        WHILE Y.ID.PLANILLA:Y.POS.FILE
            Y.ID.PROCESS = Y.ID.PLANILLA:'.':Y.ID.SEQ
            GOSUB GET.PAY.METH
            GOSUB SUB.PROCESS
        REPEAT
    REPEAT
RETURN
* ======
SUB.PROCESS:
* ======
*
*  Principal Process
*
    LOOP.CNT  = 2
    MAX.LOOPS = 3
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 2
* Writte File
                GOSUB READ.LB.BPROC.DET
* Close File
                IF Y.RECORD THEN
                    GOSUB CLOSE.PATH
                END

            CASE LOOP.CNT EQ 3
* Update Redo.Fi.Lb.Bproc
                IF Y.RECORD THEN
                    GOSUB SAVE.HEAD.LB.BPROC
* Save Answer File in PROC.QUEUE path

                    GOSUB SAVE.ANSWER
                END

        END CASE

* Control message error
        GOSUB CONTROL.MSG.ERROR
* Increase option
        LOOP.CNT +=1
    REPEAT
*
RETURN
* ----------------
READ.LB.BPROC.DET:
* ----------------
*
*  GET PARAM FOR ESPECIFIC PARAM PLANILLA
*

    Y.TOTAL.RECORDS            = 0
    Y.TOTAL.AMOUNT             = 0
    Y.RECORD = ''
    Y.SEL.CMD = "SELECT ":FN.REDO.FI.LB.BPROC.DET:" WITH ID.PROCESO.BATCH EQ ": Y.ID.PROCESS
    CALL EB.READLIST(Y.SEL.CMD,Y.BPROC.DET.LIST,'',Y.NO.OF.REG,Y.RET.CODE)
    LOOP
        REMOVE Y.BPROC.DET.LIST.ID FROM Y.BPROC.DET.LIST SETTING Y.POS
    WHILE Y.BPROC.DET.LIST.ID:Y.POS
        CALL F.READ(FN.REDO.FI.LB.BPROC.DET, Y.BPROC.DET.LIST.ID, R.REDO.FI.LB.BPROC.DET, F.REDO.FI.LB.BPROC.DET, Y.ERR)
        IF Y.ERR EQ "" THEN
* Set record to save
            GOSUB SET.RECORD.FILE
* Save record in the file and the directory
            IF Y.RECORD THEN
                GOSUB SAVE.FILE.TO.SEND
            END
        END

    REPEAT


    IF NOT(Y.BPROC.DET.LIST) THEN

        LOCATE FI.GROUP.ID IN PLANILLA.GROUP.LIST SETTING COMP.GRP.POS THEN
            R.REDO.PLANILLA.INTERFACE.PARAM<REDO.INT.PARAM.SEQ.STATUS,COMP.GRP.POS> = 'AVAILABLE'
            CALL F.WRITE(FN.REDO.INTERFACE.PARAM,PLANILLA.ID,R.REDO.PLANILLA.INTERFACE.PARAM)
            R.REDO.AFF.INTERFACE.PARAM<REDO.INT.PARAM.SEQ.STATUS> = 'AVAILABLE'
            R.REDO.AFF.INTERFACE.PARAM<REDO.INT.PARAM.SERVICE.CONTROL> = 'INACTIVE'
            CALL F.WRITE(FN.REDO.INTERFACE.PARAM,Y.ID.PLANILLA,R.REDO.AFF.INTERFACE.PARAM)
        END
    END


RETURN
*
* --------------
SET.RECORD.FILE:
* --------------
*
*  SET RECORD TO SAVE IN THE FILE. The fields are fixed length
*
*  Data

    Y.EMPLOYED        = R.REDO.FI.LB.BPROC.DET<Y.DET.EMPLEADO.ID>
    Y.EMPLOYED        = FMT(Y.EMPLOYED,"R#15")
    Y.LOAN.TYPE       = R.REDO.FI.LB.BPROC.DET<REDO.FI.LB.BPROC.DET.TIPO.PRESTAMO>
    Y.LOAN.TYPE       = FMT(Y.LOAN.TYPE,"T#15")
*
    Y.MONTH           = '01':".":Y.TODAY[5,2]:".":Y.TODAY[1,4]
    Y.MONTH           = FMT(Y.MONTH,"L15#15")
*
    Y.DATE            = Y.LAST.DATE[7,2]:'.':Y.LAST.DATE[5,2]:'.':Y.LAST.DATE[1,4]
    Y.DATE            = FMT(Y.DATE,"L15#15")
*
    Y.BALANCE         = R.REDO.FI.LB.BPROC.DET<Y.DET.BALANCE>
*
*  Totals
    Y.TOTAL.RECORDS  += 1
    Y.TOTAL.AMOUNT   += Y.BALANCE

    Y.BALANCE =   FMT(Y.BALANCE,'19R,2')
    CHANGE ',' TO '' IN Y.BALANCE
    Y.BALANCE =FMT(ABS(Y.BALANCE),"R#15")


*
*  Record
    IF Y.PAY.METHOD NE "External Payroll" THEN
        Y.RECORD          = Y.EMPLOYED:Y.LOAN.TYPE:Y.MONTH:Y.DATE:Y.BALANCE
    END ELSE
        Y.ARR.ID          = R.REDO.FI.LB.BPROC.DET<REDO.FI.LB.BPROC.DET.ID.PRESTAMO>
        Y.ARR.ID = FMT(Y.ARR.ID,"T#15")
        Y.RECORD          = Y.ARR.ID:Y.LOAN.TYPE:Y.MONTH:Y.DATE:Y.BALANCE
    END
*
RETURN
*
* ----------------
SAVE.FILE.TO.SEND:
* ----------------
*
*  GET DATA FROM REDO.FI.LB.BPROC.DET TO WRITE FILE TO SEND
*
*-----------------------------------------------------------------------------

    GOSUB VERF.PATH
    OPENSEQ Y.PATH.SEND, Y.NAME.FILE TO Y.SEND.FILE.POINTER ELSE
        CREATE Y.SEND.FILE.POINTER ELSE
            Y.ERR = "ERROR.OPENING.SEND.FILE"
        END
    END

*-----------------------------------------------------------------------------

    IF Y.TOTAL.RECORDS EQ 1 THEN

        IF Y.ID.PLANILLA EQ 'APAP-EMPLEADOS' OR Y.ID.PLANILLA EQ 'APAP-EXEC-EMPLEADOS' THEN
            Y.HEADER.TITLE = "PERNR          SUBTY          BEGDA          ENDDA          BETRG"
        END ELSE
            Y.HEADER.TITLE = "CONTRACT       SUBTY          BEGDA          ENDDA          AMOUNT"
        END
        WRITESEQ Y.HEADER.TITLE APPEND TO Y.SEND.FILE.POINTER ELSE
            Y.ERR ="EB-ERROR.WRITE.SEND.FILE"
        END
    END

    WRITESEQ Y.RECORD APPEND TO Y.SEND.FILE.POINTER ELSE
        Y.ERR ="EB-ERROR.WRITE.SEND.FILE"
    END
*

*
RETURN
*
* ---------
CLOSE.PATH:
* ---------
*  Close File to save SendFile
*
    IF Y.SEND.FILE.POINTER THEN
        WEOFSEQ   Y.SEND.FILE.POINTER       ;* Writes an EOF
        CLOSESEQ  Y.SEND.FILE.POINTER
    END
*

RETURN
*
* ----------------
SAVE.HEAD.LB.BPROC:
* ----------------


*
*  UPDATE TOTAL FIELDS IN REDO.FI.LB.BPROC
*   `
*  Record

    R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.PLANILLA.ID>     = Y.ID.PLANILLA
    R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.FECHA.CREADO>    = Y.DATE.PROCESS
    R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.TOTAL.REGISTROS> = Y.TOTAL.RECORDS
    R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.MONTO.TOTAL>     = Y.TOTAL.AMOUNT
    R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.ESTADO>          = "NO.APLICADO"
    R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.TOTAL.PROC>      = 0
*    R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.TRANSACTION.ID>  = ""
    R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.TRAN.AMOUNT>     = 0
*  Save data

    CALL F.WRITE(FN.REDO.FI.LB.BPROC,Y.ID.PROCESS,R.REDO.FI.LB.BPROC)
    CALL F.WRITE(FN.REDO.INTERFACE.PARAM,Y.ID.PLANILLA,R.REDO.AFF.INTERFACE.PARAM)
    LOCATE FI.GROUP.ID IN PLANILLA.GROUP.LIST SETTING COMP.GRP.POS THEN
        R.REDO.PLANILLA.INTERFACE.PARAM<REDO.INT.PARAM.SEQ.STATUS,COMP.GRP.POS> = 'AVAILABLE'
        CALL F.WRITE(FN.REDO.INTERFACE.PARAM,PLANILLA.ID,R.REDO.PLANILLA.INTERFACE.PARAM)
        R.REDO.AFF.INTERFACE.PARAM<REDO.INT.PARAM.SEQ.STATUS> = 'AVAILABLE'
        R.REDO.AFF.INTERFACE.PARAM<REDO.INT.PARAM.SERVICE.CONTROL> = 'INACTIVE'
        CALL F.WRITE(FN.REDO.INTERFACE.PARAM,Y.ID.PLANILLA,R.REDO.AFF.INTERFACE.PARAM)
    END

*

RETURN
*
* ----------
SAVE.ANSWER:
* ----------
*
*  SAVE ANSWER
*
    OPENSEQ Y.PROC.QUEUE, FI.FILE.ANS.ID TO Y.PROC.QUEUE.POINTER ELSE
        CREATE Y.PROC.QUEUE.POINTER ELSE
            Y.ERR = "ERROR.OPENING.SEND.FILE"
        END
    END
    Y.RECORD = "Process ": Y.ID.PROCESS: " completed at ": Y.DATE.PROCESS
    WRITESEQ Y.RECORD APPEND TO Y.PROC.QUEUE.POINTER ELSE
        Y.ERR ="EB-ERROR.WRITE.PROC.QUEUE"
    END
*
    WEOFSEQ   Y.PROC.QUEUE.POINTER        ;* Writes an EOF
    CLOSESEQ  Y.PROC.QUEUE.POINTER
*
RETURN
*

* -------
GET.PAY.METH:
* -------
*

*   Get Path Send
*
    Y.PATH.SEND   = FI.PATH.SEND:"/":Y.ID.PLANILLA
*
*   Set name file to send
    Y.NAME.FILE   = Y.ID.PROCESS:".txt"
*
*   Set path queue
    Y.PROC.QUEUE   = FI.QUEUE.PATH
*
*   Set file name to request
    Y.REQ.FILE   = Y.ID.PROCESS:".req"
*
*   Set name file to send to path queue
    FI.FILE.ANS.ID = Y.ID.PROCESS:".ans"

*
*   Get Pay Method

    CALL F.READ(FN.REDO.INTERFACE.PARAM,Y.ID.PLANILLA, R.REDO.AFF.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM, Y.ERR)
    RIP.PARAM     = R.REDO.AFF.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    RIP.VALUE     = R.REDO.AFF.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

    METODO.PAGO = "METODO.PAGO"
    LOCATE METODO.PAGO IN RIP.PARAM<1,1> SETTING PARAM.POS THEN
        Y.PAY.METHOD = RIP.VALUE<1,PARAM.POS>
    END


RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph that control the error in the subroutine
*
    IF Y.ERR NE "" THEN

        PROCESS.GOAHEAD = 0
        CALL TXT(Y.ERR)

        FI.INT.ACT.ID = "PLA001"
        INT.TYPE = 'BATCH'
        BAT.NO = '1'
        BAT.TOT = '1'
        INFO.OR = 'T24'
        INFO.DE = 'T24'
        ID.PROC = PLANILLA.ID
        MON.TP = '04'
        ID.DESC = PLANILLA.ID
        REC.CON = Y.ERR
        EX.USER = OPERATOR ;
        EX.PC = ''
*  CALL APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(FI.INT.ACT.ID,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,ID.DESC,REC.CON,EX.USER,EX.PC)
        CALL APAP.REDOCHNLS.redoInterfaceRecAct(FI.INT.ACT.ID,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,ID.DESC,REC.CON,EX.USER,EX.PC);*MANUAL R22 CODE CONVERSION

    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
*  Inicialise Variables
*
    PROCESS.GOAHEAD            = 1
    LOOP.CNT                   = 1
    MAX.LOOPS                  = 1
*
    Y.ERR                      = ""
*
*  Get current Id Process, take from de common variable
*   Y.ID.PROCESS               = COMMON.ID.PROCESO.BATCH    ;*The first possition is the Id Planilla
*
*  Get Id Planilla
*   Y.ID.PLANILLA              = FIELD(Y.ID.PROCESS,'.',1)
    Y.TODAY = TODAY
    COMI = Y.TODAY
    CALL LAST.DAY.OF.THIS.MONTH
    Y.LAST.DATE = COMI

*
*  Work Variables
    FN.REDO.FI.LB.BPROC        = "F.REDO.FI.LB.BPROC"
    F.REDO.FI.LB.BPROC         = ""
    R.REDO.FI.LB.BPROC         = ""
*
    FN.REDO.FI.LB.BPROC.DET    = "F.REDO.FI.LB.BPROC.DET"
    F.REDO.FI.LB.BPROC.DET     = ""
    R.REDO.FI.LB.BPROC.DET     = ""

    FN.REDO.INTERFACE.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INTERFACE.PARAM  = ''
    R.REDO.INTERFACE.PARAM  = ''
*
    Y.PAY.METHOD              = ""
    Y.PATH.SEND                = ""
    Y.NAME.FILE                = ""
    Y.PROC.QUEUE               = ""
*
    Y.DET.EMPLEADO.ID          = REDO.FI.LB.BPROC.DET.EMPLEADO.ID
    Y.DET.BALANCE              = REDO.FI.LB.BPROC.DET.BALANCE
    Y.DET.MNT.APLICAR          = REDO.FI.LB.BPROC.DET.MNT.APLICAR
    Y.DATE.PROCESS             = TODAY
    Y.RECORD                   = ""
*
*

RETURN
*
* =========
OPEN.FILES:
* =========
*
*  OPEN FILES
*

*  Open Redo.Fi.Lb.Bproc
    CALL OPF(FN.REDO.FI.LB.BPROC,F.REDO.FI.LB.BPROC)
*

    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)

*  Open Redo.Fi.Lb.Bproc.Det
    CALL OPF(FN.REDO.FI.LB.BPROC.DET,F.REDO.FI.LB.BPROC.DET)
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*

    PLANILLA.ID = 'PLANILLA'
    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, PLANILLA.ID, R.REDO.PLANILLA.INTERFACE.PARAM, Y.ERR)
    PLANILLA.GROUP.LIST = R.REDO.PLANILLA.INTERFACE.PARAM<REDO.INT.PARAM.AFF.COMPANY>
    PLANILLA.SEQ.LIST   = R.REDO.PLANILLA.INTERFACE.PARAM<REDO.INT.PARAM.PROCES.SEQ>
    RIP.PLANILLA.PARAM     = R.REDO.PLANILLA.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    RIP.PLANILLA.VALUE     = R.REDO.PLANILLA.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

    FI.QUEUE.PATH = ''
    QUEUE.PATH.ID   = "PROC.QUEUE"        ;* Directory path to store the process key

    WPARAM.POS = 1
    LOCATE QUEUE.PATH.ID IN RIP.PLANILLA.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.QUEUE.PATH  = RIP.PLANILLA.VALUE<1,PARAM.POS>
        OPEN FI.QUEUE.PATH ELSE
            PROCESS.GOAHEAD = 0
            WERROR.MSG =  'Queue path Directory Missing ' : FI.QUEUE.PATH
        END
    END ELSE
        WERROR.MSG = "&.Directory.not.defined.in.&":@FM:QUEUE.PATH.ID:@VM:PLANILLA.ID
    END

    Y.PATH.SEND.ID = "PATH.SEND"
    FI.PATH.SEND   = ""



    LOCATE Y.PATH.SEND.ID IN RIP.PLANILLA.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.PATH.SEND   = RIP.PLANILLA.VALUE<1,PARAM.POS>

        OPEN FI.PATH.SEND ELSE
            PROCESS.GOAHEAD = 0
            WERROR.MSG =  'Queue path Directory Missing ' : FI.PATH.SEND
        END

    END ELSE
        WERROR.MSG = "&.Directory.not.defined.in.&":@FM:Y.PATH.SEND.ID:@VM:PLANILLA.ID
    END

    CHANGE @VM TO @FM IN PLANILLA.GROUP.LIST
    CHANGE @VM TO @FM IN PLANILLA.SEQ.LIST

    IF Y.ERR THEN
        Y.ERR = "Planilla.Process.Id.Not.Exists"
    END

    GOSUB CONTROL.MSG.ERROR

RETURN
*
* --------
VERF.PATH:
* --------
    OPEN Y.PATH.SEND ELSE

        X.CMD = "CREATE.FILE ":Y.PATH.SEND:" TYPE=UD"
        GOSUB EXECUTE.COMAND

    END
RETURN
*============
EXECUTE.COMAND:
*============

    EXECUTE X.CMD


RETURN
END
