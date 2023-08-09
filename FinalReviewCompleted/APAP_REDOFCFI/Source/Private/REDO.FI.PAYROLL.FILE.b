<<<<<<< Updated upstream
* @ValidationCode : MjoxNzYxMDk0MDU2OkNwMTI1MjoxNjkwMTc0Mzk3MzI5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 10:23:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
* @ValidationCode : MjoxMDc3MzA5MDI4OkNwMTI1MjoxNjg1MTA2MDg2MTMzOklUU1M6LTE6LTE6LTc1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 May 2023 18:31:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -75
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.PAYROLL.FILE(IN.TXT.MSG,OUT.ERR.MSG)
*******************************************************************************************************
*
*    Routine processing TXT PayRoll file from the External Associated Companies
*    Parameters:
*        IN.TXT.MSG:   Input parameter to recive the TXT message from the principal routine
*        OUT.ERR.MSG:  Output parameter to send the ERROR message get in the process
*
*=====================================================================================================
*
*    First Release : Ana Noriega
*    Developed for : APAP
*    Developed by  : Ana Noriega
*    Date          : 2010/Nov/08
*=====================================================================================================
* Modifications:
* 27/01/2012 - avelasco@temenos.com
*              APAP C18 :
*              Modifications
* 20/04/2012 - cherrera@temenos.com
*              APAP C18 Issues:
*                                BUG-C18-NOMINAS-20120201-1359, BUG-C18-NOMINAS-20120229-1942,
*                                BUG-C18-NOMINAS-20120302-1619, BUG-C18-NOMINAS-20120307-0938
*                                BUG-C18-NOMINAS-20120603-1627, BUG-C18-NOMINAS-20120603-1914,
*                                MANTIS0002302, MANTIS0002303
*              Modifications:
*               - @ID for REDO.FI.CONTROL record is calculated in REDO.FI.PAYROLL.VALIDATE
*               - Control for duplicate files
*               - Change corporate debit account using REDO.INTERFACE.PARAM which the same Company ID
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1 , I = I.VAR
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION           CALL RTN METHOD ADDED
*=====================================================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_REDO.FI.VARIABLES.COMMON
    $INSERT I_F.REDO.FI.CONTROL
    $INSERT I_F.REDO.INTERFACE.PARAM
    $USING APAP.REDOCHNLS
    $USING APAP.TAM
*
*******************************************************************************************************
*
    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
*   Principal Process
*
*   Validate File

    APAP.REDOFCFI.redoFiPayrollValidate(IN.TXT.MSG,Y.VAR.WORK,Y.NEW.TXT.MSG,Y.ERR.MSG) ;*MANUAL R22 CODE CONVERSION
*   Message Error
* DEBUG
    GOSUB CONTROL.MSG.ERROR
* DEBUG
    FI.CTA.DESTINO = Y.VAR.WORK<2>

    GOSUB RECORD.FI.CONTROL
*   SaveFileToProcess
    IF Y.ERR.MSG EQ ''  THEN

        GOSUB SAVE.FILE.IN.DIR
        Y.ERR.MSG = ''
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.OK>    = W.REC.FT.OK
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.OK>    = W.TOT.FT.OK
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.PROC>   = W.REC.FT.OK + W.REC.FT.ERR
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC>       = W.TOT.FT.OK + W.TOT.FT.ERR
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.FAIL>  = W.REC.FT.ERR
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.FAIL>  = W.TOT.FT.ERR
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STATUS>       = Y.STT.REC
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>       = Y.ERR.MSG   ;* Need to refresh the actual Error Message
        APAP.REDOFCFI.redoFiRecordControl(Y.ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    END
*
RETURN
*
* ----------------
RECORD.FI.CONTROL:
* ----------------
*
*   Total Records
    Y.COUNT.NEW.TXT = DCOUNT(Y.NEW.TXT.MSG,@FM)
* TAM - EC: cherrera
* The correct ID was generated in REDO.FI.PAYROLL.VALIDATE routine
    FI.W.REDO.FI.CONTROL.ID  = Y.VAR.WORK<1>

*   Redo.Fi.Control
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.FILE.NAME>        = FI.FILE.ID
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.FILE.DIR>         = FI.WORK.DIR
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROCESS.CONFIRM>  = FI.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.AUT.AVAIL.FUNDS>
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.DATE>        = TODAY
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.TIME>        = FIELD(TIMEDATE()," ",1)
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.FILE>  = FI.DATO.NUM.REG
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.AMOUNT.FILE>  = FI.DATO.MONTO.TOTAL
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.CALC>  = FI.CALC.NUM.REG
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.AMOUNT.CALC>  = FI.CALC.MONTO.TOTAL
    FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STATUS>      = "CARGA NO FALLIDA"
*   If there is a Msg Error set the status and description of the cause
    IF Y.ERR.MSG THEN
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STATUS>      = "CARGA FALLIDA"
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>      = Y.ERR.MSG
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.OK>   = 0
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.OK>   = 0
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.PROC>  = 0
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC>      = 0
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.FAIL> = 0
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.FAIL> = 0
    END
*   Save in Redo.Fi.Control
    APAP.REDOFCFI.redoFiRecordControl(Y.ERR.MSG) ;*MANUAL R22 CODE CONVERSION

RETURN
*
* ---------------
SAVE.FILE.IN.DIR:
* ---------------
*
*   Open OutPut Directory
*

    W.REC.FT.ERR  = 0
    W.REC.FT.OK   = 0
    W.TOT.FT.OK   = 0
    W.TOT.FT.ERR  = 0
    CONTADO.EXTRA = Y.COUNT.NEW.TXT + 1
* Credit for customer account
    FOR I.VAR = 1 TO Y.COUNT.NEW.TXT
        OUT.RESP = ''
        OUT.RESP<1> = ''

        GOSUB APPEND.ADDITIONAL.INFO
        GOSUB MESSAGE.FORMAT
        GOSUB REPORT.FORMAT
    NEXT

* Debit to enterprise account
    R.PARAM<1>  = "NULL"
    R.PARAM<2>  = "N"
    R.PARAM<3>  = W.TOT.FT.OK
    R.PARAM<4>  = FI.FILE.ID
    R.PARAM<5>  = FI.INTERFACE
    R.PARAM<6>  = FI.CTA.DESTINO
    R.PARAM<7>  = W.TOT.FT.OK
    R.PARAM<8>  = "DOP"
    R.PARAM<9>  = FI.W.REDO.FI.CONTROL.ID
    R.PARAM<10> = "S"
    R.PARAM<11> = FI.CTA.INTERMEDIA
    R.PARAM<12> = "NOMINAC"
    R.PARAM<13> = "ACZZ"

    WRECORD.NUMBER        = CONTADO.EXTRA
    W.ADDITIONAL.INFO     = ""
    W.ADDITIONAL.INFO<1>  = FI.BATCH.ID : "." : WRECORD.NUMBER          ;* THEIR.REFERENCE
    W.ADDITIONAL.INFO<2>  = FI.BATCH.ID : "." : WRECORD.NUMBER          ;* OUR.REFERENCE
    W.ADDITIONAL.INFO<3>  = FI.INTERFACE : "." : FI.BATCH.ID  ;* NARRATIVE
    W.ADDITIONAL.INFO<4>  = FI.W.REDO.FI.CONTROL.ID ;* TRANS.REFERENCE
    W.ADDITIONAL.INFO<5>  = WRECORD.NUMBER          ;* BATCH.ID
    W.ADDITIONAL.INFO     = CHANGE(W.ADDITIONAL.INFO,@FM,",")

    Y.STT.REC        = ""
    Y.IN.MSG         = FI.CTA.DESTINO:",":FI.DATO.MONTO.TOTAL:",DOP,-"
    Y.NEW.TXT.MSG<CONTADO.EXTRA> = Y.IN.MSG:",":W.ADDITIONAL.INFO
    APAP.REDOFCFI.redoFiMsgFormat(FI.INTERFACE,Y.NEW.TXT.MSG<CONTADO.EXTRA>,DATO.OUT) ;*MANUAL R22 CODE CONVERSION

    IF W.TOT.FT.OK GT 0 THEN
        GOSUB FT.PROCESS

        IF OUT.ERR<2> NE "" THEN
            E =OUT.ERR
            IF OUT.ERR<4> NE '' THEN
                E =OUT.ERR<4>

            END
* "EB-ERROR.FAILED.FT"
            Y.ERR.MSG = E
            Y.STT.REC = "FALLIDO"
            FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>  = Y.ERR.MSG
            GOSUB CONTROL.MSG.ERROR
        END ELSE
            Y.STT.REC = "PROCESADO"
        END

    END ELSE
        E = "EB-ERROR.NONE.FT.APPLIED"
        Y.ERR.MSG = E
        Y.STT.REC = "FALLIDO"
        FI.W.REDO.FI.CONTROL<REDO.FI.CON.PROC.STAT.D>  = Y.ERR.MSG
        W.TOT.FT.ERR = 0
        W.TOT.FT.ERR += FI.DATO.MONTO.TOTAL
        GOSUB CONTROL.MSG.ERROR
    END

    I.VAR = CONTADO.EXTRA
    GOSUB REPORT.FORMAT


RETURN

* ---------------------
APPEND.ADDITIONAL.INFO:
* ---------------------
*
* Paragraph that add data to send to the FT
*

    WRECORD.NUMBER        = I.VAR
    W.ADDITIONAL.INFO     = ""
    W.ADDITIONAL.INFO<1>  = FI.BATCH.ID : "." : WRECORD.NUMBER          ;* THEIR.REFERENCE
    W.ADDITIONAL.INFO<2>  = FI.BATCH.ID : "." : WRECORD.NUMBER          ;* OUR.REFERENCE
    W.ADDITIONAL.INFO<3>  = FI.INTERFACE : "." : FI.BATCH.ID  ;* NARRATIVE
    W.ADDITIONAL.INFO<4>  = FI.W.REDO.FI.CONTROL.ID ;* TRANS.REFERENCE
    W.ADDITIONAL.INFO<5>  = WRECORD.NUMBER          ;* BATCH.ID
    W.ADDITIONAL.INFO     = CHANGE(W.ADDITIONAL.INFO,@FM,",")
*
RETURN
*
* =============
MESSAGE.FORMAT:
* =============
*
*   Paragraph to set message format to AC.ENTRY.PARAM
*

    Y.STT.REC        = ""
    Y.IN.MSG         = Y.NEW.TXT.MSG<I.VAR>
    Y.NEW.TXT.MSG<I.VAR> = Y.NEW.TXT.MSG<I.VAR>:",":W.ADDITIONAL.INFO
    APAP.REDOFCFI.redoFiMsgFormat(FI.INTERFACE,Y.NEW.TXT.MSG<I.VAR>,DATO.OUT) ;*MANUAL R22 CODE CONVERSION
    R.PARAM<1>  = "NULL"
    R.PARAM<2>  = "N"
    R.PARAM<3>  = FIELD(DATO.OUT,"|",3)
    R.PARAM<4>  = FI.FILE.ID
    R.PARAM<5>  = FI.INTERFACE
    R.PARAM<6>  = FI.CTA.INTERMEDIA
    R.PARAM<7>  = FIELD(DATO.OUT,"|",3)
    R.PARAM<8>  = FIELD(DATO.OUT,"|",4)
    R.PARAM<9>  = FI.W.REDO.FI.CONTROL.ID
    R.PARAM<10> = "N"
    R.PARAM<11> = FIELD(DATO.OUT,"|",2)
    R.PARAM<12> = "NOMINA"
    R.PARAM<13> = "ACNO"

    GOSUB FT.PROCESS

*
RETURN
*
* ============
REPORT.FORMAT:
* ============
*
*   Paragraph to set report message to REDO.FI.E.REPORT
*   and save log in REDO.INTERFACE.REC.ACT
*
*   DEBUG
    IF Y.ERR.MSG NE "" THEN
        W.STATUS = "04"
        W.ERROR.MSG = Y.ERR.MSG
    END ELSE
        W.STATUS = "01"
        W.ERROR.MSG = "OK"
        W.TOTAL.TRANSACC += R.PARAM<3>
    END

    Y.ID.RCL  = FI.INTERFACE:".R"         ;*The id is NOMINA.R
    Y.TOT.REC = Y.COUNT - 1
    Y.IN.MSG  = WRECORD.NUMBER:",":Y.IN.MSG:",":W.STATUS:",":Y.ERR.MSG
*
*  Call RCL to set data to send report
    APAP.REDOFCFI.redoFiMsgFormat(Y.ID.RCL,Y.IN.MSG,Y.OUT.MSG) ;*MANUAL R22 CODE CONVERSION
*  Save record in log tabla REDO.INTERFACE.REC.ACT
    FI.INTERFACES = FI.INTERFACE:".INT"
* DEBUG

* Y.OUT.MSG = Y.OUT.MSG :"@":W.STATUS:"@":W.ERROR.MSG:"@":OUT.RESP<1>
    Y.OUT.MSG = Y.OUT.MSG :"@":W.ERROR.MSG:"@":OUT.RESP<1>

    IF Y.ERR.MSG NE "" THEN
*APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(FI.INTERFACES,"BATCH",WRECORD.NUMBER,Y.TOT.REC,FI.W.REDO.FI.CONTROL.ID,FI.FILE.ID,"","04",Y.ERR.MSG,Y.OUT.MSG,"","")
        APAP.REDOCHNLS.redoInterfaceRecAct(FI.INTERFACES,"BATCH",WRECORD.NUMBER,Y.TOT.REC,FI.W.REDO.FI.CONTROL.ID,FI.FILE.ID,"","04",Y.ERR.MSG,Y.OUT.MSG,"","") ;*MANUAL R22 CODE CONVERSION
        IF R.PARAM<10> EQ "N" THEN
            W.REC.FT.ERR += 1
            W.TOT.FT.ERR +=R.PARAM<7>
        END
    END ELSE
*APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(FI.INTERFACES,"BATCH",WRECORD.NUMBER,Y.TOT.REC,FI.W.REDO.FI.CONTROL.ID,FI.FILE.ID,WRECORD.NUMBER,"01","OK",Y.OUT.MSG,"","")
        APAP.REDOCHNLS.redoInterfaceRecAct(FI.INTERFACES,"BATCH",WRECORD.NUMBER,Y.TOT.REC,FI.W.REDO.FI.CONTROL.ID,FI.FILE.ID,WRECORD.NUMBER,"01","OK",Y.OUT.MSG,"","");*MANUAL R22 CODE CONVERSION
        IF R.PARAM<10> EQ "N" THEN
            W.REC.FT.OK += 1
            W.TOT.FT.OK += R.PARAM<7>
            FI.DATO.MONTO.TOTAL = W.TOT.FT.OK
        END
    END
*
RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph that record the error message and move the file to the rejected directory renaming the file
*
    IF Y.ERR.MSG THEN
        ETEXT            = Y.ERR.MSG
        OUT.ERR.MSG      = Y.ERR.MSG
        Y.NAME.DIR       = FI.PATH.REJ
    END
*
    IF ETEXT THEN
        PROCESS.GOAHEAD = 0
        OUT.ERR.MSG     = ""
        CALL STORE.END.ERROR
        OUT.ERR.MSG     = ETEXT
        ETEXT           = ""
    END
*

    IF OUT.ERR.MSG NE "" THEN
        Y.FILE.ID = CHANGE(FI.FILE.ID,".txt",".rej")
        OPENSEQ FI.PATH.REJ, Y.FILE.ID TO Y.SEQ.FILE.POINTER ELSE
            CREATE Y.SEQ.FILE.POINTER ELSE
                OUT.ERR.MSG = "Error.Opening.Output.File"
            END
        END

        OPENSEQ FI.PATH.REJ, Y.FILE.ID TO Y.SEQ.FILE.POINTER ELSE
            CREATE Y.SEQ.FILE.POINTER ELSE
                OUT.ERR.MSG = "Error.Opening.Output.File"
            END
        END

        WRITESEQ IN.TXT.MSG TO Y.SEQ.FILE.POINTER ELSE
            OUT.ERR.MSG = "Error.Writing.To.Output.File"
        END
        WEOFSEQ   Y.SEQ.FILE.POINTER        ;* Writes an EOF
        CLOSESEQ  Y.SEQ.FILE.POINTER
    END
*
RETURN
*
* ----------------
FT.PROCESS:
* ----------------
*
* Paragraph that record the error message and move the file to the rejected directory renaming the file
*
<<<<<<< Updated upstream
*   CALL REDO.FI.DEBIT.PROCES(R.PARAM, OUT.RESP, OUT.ERR)
    APAP.TAM.redoFiDebitProces(R.PARAM, OUT.RESP, OUT.ERR) ;*MANUAL R22 CODE CONVERSION
=======
    CALL REDO.FI.DEBIT.PROCES(R.PARAM, OUT.RESP, OUT.ERR)
*APAP.TAM.redoFiDebitProces(R.PARAM, OUT.RESP, OUT.ERR) ;*MANUAL R22 CODE CONVERSION
>>>>>>> Stashed changes

    IF OUT.ERR<2> NE "" THEN
        E =OUT.ERR
*"EB-ERROR.FAILED.FT"
        Y.ERR.MSG = E
        Y.STT.REC = "FALLIDO"
    END
    IF OUT.ERR<2> NE "" AND OUT.ERR<4> NE "" THEN

        E =OUT.ERR<4>
*"EB-ERROR.FAILED.FT"
        Y.ERR.MSG = E
        Y.STT.REC = "FALLIDO"
    END
*
RETURN
*

* ---------
INITIALISE:
* ---------
*   General Variables

    PROCESS.GOAHEAD      = 1
    LOOP.CNT             = 1
    MAX.LOOPS            = 1
*   MessageTXT
    Y.SEPARATOR.REC      = CHARX(13):CHARX(10)        ;*CHAR(13) is CR, CHAR(13) is LF ;* AUTO R22 CODE CONVERSION
    IN.TXT.MSG           = CHANGE(IN.TXT.MSG,Y.SEPARATOR.REC,@FM)
    Y.COUNT              = COUNT(IN.TXT.MSG,@FM)
    Y.COUNT.NEW.TXT      = 0
*   Parameters to send
    Y.VAR.WORK           = ""
    Y.NEW.TXT.MSG        = ""
*   Save.File.In.Dir
    Y.ERR.MSG            = ""
    Y.FILE.ID            = ""
    Y.SEQ.FILE.POINTER   = ""
    DATO.OUT             = ""
    R.PARAM              = ""
*
    Y.IN.MSG             = ""
    Y.OUT.MSG            = ""
    Y.STT.REC            = "PROCESADO"
    W.STATUS             = "01"
*
    FI.INTERFACES        = ""
    OUT.ERR.MSG          = ""
*
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM = ""

    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, FI.INTERFACE, R.REDO.INTERFACE.PARAM, Y.ERR)
    IF Y.ERR THEN
        PROCESS.GOAHEAD = 0
        E = "EB-PARAMETER.MISSING"
        CALL ERR
    END
    RIP.PARAM = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    RIP.VALUE = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

    CTA.INTERMEDIA = "CTA.INTERMEDIA"
*    CTA.DESTINO = "CTA.DESTINO"
* The bussiness account for debits is token from the concern record in REDO.INTERFACE.PARAM wich use the same ID as the company
    WPARAM.POS = 1
    LOCATE CTA.INTERMEDIA IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.CTA.INTERMEDIA = RIP.VALUE<1,PARAM.POS>
        WPARAM.POS   = PARAM.POS + 1
    END ELSE
        WERROR.MSG = "&.Intermediate.Account.not.defined.in.&":@FM:CTA.INTERMEDIA
    END

RETURN
*

*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1        ;*    Validate TXT file exists
                IF IN.TXT.MSG EQ "" THEN
                    Y.ERR.MSG =  "File.Is.Empty"
                END
        END CASE
*Message Error
        GOSUB CONTROL.MSG.ERROR
*Increase
        LOOP.CNT +=1
    REPEAT
*
RETURN

END
