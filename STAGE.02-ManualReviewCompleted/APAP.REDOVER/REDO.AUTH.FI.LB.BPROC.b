* @ValidationCode : MjotMTgxMTczMTczNDpDcDEyNTI6MTY4MDY4MTgwNzMwOTpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:33:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.FI.LB.BPROC

*-------------------------------------------------------------------L-------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.AUTH.FI.LB.BPROC
*--------------------------------------------------------------------------------
* Description: This Authorization routine routine for REDO.FI.LB.BPROC.DET Table
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO                    REFERENCE             DESCRIPTION
*05-04-2023  Conversion Tool         R22 Auto Code conversion      FM TO @FM
*05-04-2023  Samaran T                Manual R22 Code Conversion    No Changes
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.PARAMETER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.FI.LB.BPROC
    $INSERT I_F.REDO.FI.LB.BPROC.DET
    $INSERT I_F.REDO.INTERFACE.PARAM
    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN

*---------------------------------------------------------------------------------
OPEN.FILE:
*---------------------------------------------------------------------------------

    FN.REDO.FI.LB.BPROC = 'F.REDO.FI.LB.BPROC'
    F.REDO.FI.LB.BPROC  = ''
    CALL OPF(FN.REDO.FI.LB.BPROC,F.REDO.FI.LB.BPROC)

    FN.REDO.INTERFACE.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INTERFACE.PARAM  = ''
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    FI.FILE.ANS.ID = ID.NEW:".ans"
    PLANILLA.ID = 'PLANILLA'
    CALL F.READ(FN.REDO.INTERFACE.PARAM,PLANILLA.ID,R.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM,RIP.ERR)
    RIP.PLANILLA.PARAM     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    RIP.PLANILLA.VALUE     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

    FI.QUEUE.PATH = ''
    QUEUE.PATH.ID   = "PROC.QUEUE"        ;* Directory path to store the process key
    WPARAM.POS = 1
    LOCATE QUEUE.PATH.ID IN RIP.PLANILLA.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.QUEUE.PATH  = RIP.PLANILLA.VALUE<1,PARAM.POS>
    END


    Y.FILE.TOTAL  = R.NEW(REDO.FI.LB.BPROC.MONTO.TOTAL)
    Y.TOTAL.PROC  = R.NEW(REDO.FI.LB.BPROC.MONTO.TOTAL.PROC)
    Y.FILE.STATUS = R.NEW(REDO.FI.LB.BPROC.ESTADO)
    Y.OLD.STATUS  = R.OLD(REDO.FI.LB.BPROC.ESTADO)
    Y.TXN.REF     = R.NEW(REDO.FI.LB.BPROC.TRANSACTION.ID)


    AFF.COMP.ID = FIELD(ID.NEW,'.',1)
    CALL F.READ(FN.REDO.INTERFACE.PARAM,AFF.COMP.ID,R.REDO.INTERFACE.PARAM.AFF,F.REDO.INTERFACE.PARAM,RIP.AFF.ERR)
    RIP.AFF.COMPANY  = R.REDO.INTERFACE.PARAM.AFF<REDO.INT.PARAM.AFF.COMPANY>
    IF RIP.AFF.COMPANY EQ 'APAP-EXTERNOS-NOTAX' THEN
        IF NOT(Y.TXN.REF) AND Y.FILE.STATUS EQ 'APROBADO' THEN
            AF = REDO.FI.LB.BPROC.PLANILLA.ID
            ETEXT = 'EB-REDO.PLANILLA.NO.TXN.REF'
            CALL STORE.END.ERROR
        END
    END



    IF NOT(Y.FILE.TOTAL) AND Y.FILE.STATUS EQ 'APROBADO' THEN
        AF = REDO.FI.LB.BPROC.PLANILLA.ID
        ETEXT = 'EB-REDO.PLANILLA.NO.LOANS'
        CALL STORE.END.ERROR
    END

    IF Y.TOTAL.PROC EQ ABS(Y.FILE.TOTAL) THEN
        IF Y.FILE.STATUS EQ 'COMPLETADO' ELSE
            AF = REDO.FI.LB.BPROC.PLANILLA.ID
            ETEXT = 'EB-REDO.PLANILLA.COMPLETED'
            CALL STORE.END.ERROR
        END
    END

    IF Y.FILE.STATUS EQ 'NO.APLICADO' OR Y.FILE.STATUS EQ 'APLICADO' THEN
        AF = REDO.FI.LB.BPROC.ESTADO
        ETEXT = 'EB-REDO.PLANILLA.CHANGE.STATUS':@FM:Y.FILE.STATUS ;*R22 AUTO CODE CONVERSION
        CALL STORE.END.ERROR
    END

    IF Y.FILE.STATUS EQ 'APROBADO' THEN
        OPENSEQ FI.QUEUE.PATH, FI.FILE.ANS.ID TO Y.PROC.QUEUE.POINTER ELSE
            CREATE Y.PROC.QUEUE.POINTER ELSE
                Y.ERR = "ERROR.OPENING.SEND.FILE"
            END
        END
        Y.RECORD = "Process ": ID.NEW: " completed at ": TODAY
        WRITESEQ Y.RECORD APPEND TO Y.PROC.QUEUE.POINTER ELSE
            Y.ERR ="EB-ERROR.WRITE.PROC.QUEUE"
        END
        WEOFSEQ   Y.PROC.QUEUE.POINTER
        CLOSESEQ  Y.PROC.QUEUE.POINTER
    END ELSE
        X.CMD = "DELETE ":FI.QUEUE.PATH:" ":FI.FILE.ANS.ID
        EXECUTE X.CMD
    END

    Y.PLANILLA.ID = FIELD(ID.NEW,'.',1)
    IF Y.FILE.STATUS NE Y.OLD.STATUS AND NOT(ETEXT) THEN
        NEW.TASK = "QUERY REDO.FI.LB.BPROC.GENERADAS PLANILLA.ID EQ ":Y.PLANILLA.ID
        CALL EB.SET.NEW.TASK(NEW.TASK)
    END

RETURN
*----------------------
END
