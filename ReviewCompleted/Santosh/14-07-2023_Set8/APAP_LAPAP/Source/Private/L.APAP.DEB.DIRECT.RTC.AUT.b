* @ValidationCode : MjoxNDc2MzQ2NjM5OkNwMTI1MjoxNjg5MjQyMzIxMTQyOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:28:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.DEB.DIRECT.RTC.AUT(Y.ARRAY.IDS)
*-----------------------------------------------------------------------------
* Bank name: APAP
* Decription: Rutina para generar archivo INFILES y procesar en la etapa de cobro automatico ruedala tu cuota
* Developed By: APAP
* Date:  09/02/2021
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       FM TO @FM, VM to @VM, SM to @SM, BP Removed in INSERTFILE
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_L.APAP.DEB.DIRECT.RTC.AUT.COMMON

    GOSUB MAIN.PROCESS
RETURN

MAIN.PROCESS:
*************
    Y.ARR.ID = ''; Y.CUENTA.DEBITO = ''; Y.MONTO.ABONO = 0; Y.TASA = 0;
    OFS.RECORD = ''; Y.ARREGLO.RECORD = '';
    Y.ARREGLO.RECORD = Y.ARRAY.IDS;
    Y.REGISTROS = CHANGE(Y.ARREGLO.RECORD,"|",@FM)
    Y.ARR.ID = Y.REGISTROS<1>
    Y.CUENTA.DEBITO = Y.REGISTROS<2>
    Y.MONTO.ABONO = Y.REGISTROS<3>
    GOSUB READ.AA.ARRANGEMENT
    GOSUB VERIFICAR.CUENTAS.BALANCE

RETURN

READ.AA.ARRANGEMENT:
*******************
    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARR.ID,R.ARR.ARRANGEMENT,F.AA.ARRANGEMENT,ERROR.ARRANGEMENT)
    Y.CUSTOMER.ID = R.ARR.ARRANGEMENT<AA.ARR.CUSTOMER>
    Y.NUMERO.PRESTAMO = R.ARR.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    Y.NUMERO.PRESTAMO = CHANGE(Y.NUMERO.PRESTAMO,@VM,@FM)
    Y.NUMERO.PRESTAMO = CHANGE(Y.NUMERO.PRESTAMO,@SM,@FM)
    Y.NUMERO.PRESTAMO = Y.NUMERO.PRESTAMO<1>
RETURN


VERIFICAR.CUENTAS.BALANCE:
    Y.MANCOMUNADA = "501"; Y.TUTOR = "510"; Y.PROCESAR.OFS = "NO";
    Y.CODIGO.TRANSACION = "ACPR"; Y.MONEDA = "DOP"; Y.ORDERING.BANK = "RUEDALA";
    R.ACCOUNT = ''; Y.ERROR.ACCOUNT = '' ; Y.MONTO.DISPONIBLE.ACC = 0; R.FT = "";
    CALL F.READ(FN.ACCOUNT, Y.CUENTA.DEBITO, R.ACCOUNT, F.ACCOUNT, Y.ERROR.ACCOUNT)
    Y.MONTO.DISPONIBLE.ACC = R.ACCOUNT<AC.LOCAL.REF,L.AC.AV.BAL.POS>
    Y.RELATION.CODE = R.ACCOUNT<AC.RELATION.CODE>

    IF Y.MONTO.DISPONIBLE.ACC GT Y.MONTO.ABONO AND Y.RELATION.CODE NE Y.MANCOMUNADA AND Y.RELATION.CODE NE Y.TUTOR  THEN
        R.FT<FT.DEBIT.ACCT.NO> = Y.CUENTA.DEBITO
        R.FT<FT.CREDIT.ACCT.NO> = Y.NUMERO.PRESTAMO
        R.FT<FT.DEBIT.AMOUNT> = Y.MONTO.ABONO
        R.FT<FT.TRANSACTION.TYPE> = Y.CODIGO.TRANSACION
        R.FT<FT.DEBIT.CURRENCY> = Y.MONEDA
        R.FT<FT.ORDERING.BANK> = Y.ORDERING.BANK
        GOSUB OFS.PROCESS.FT
        IF Y.ESTADO.OFS EQ "FAILURE" THEN
            GOSUB PROCESS.EN.OTRAS.ACC
        END ELSE
            GOSUB SET.TABLA.CONCAT
        END
    END ELSE
        GOSUB PROCESS.EN.OTRAS.ACC

        RETURN


PROCESS.EN.OTRAS.ACC:
        Y.PROCESAR.OFS = "NO";
        SEL.CMD = "SELECT ": FN.ACCOUNT: " WITH CUSTOMER EQ ":"'":Y.CUSTOMER.ID:"'"
        CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)
        LOOP
            REMOVE Y.ID.ACCOUNT FROM SEL.LIST SETTING ACC.POS

        WHILE Y.ID.ACCOUNT DO
            R.ACCOUNT = ''; Y.ERROR.ACCOUNT = '' ; Y.MONTO.DISPONIBLE.ACC = 0; R.FT = "";

            IF Y.ID.ACCOUNT EQ Y.CUENTA.DEBITO THEN
                CONTINUE
            END
            IF Y.PROCESAR.OFS EQ "YES" THEN
                CONTINUE
            END
            CALL F.READ(FN.ACCOUNT, Y.ID.ACCOUNT, R.ACCOUNT, F.ACCOUNT, Y.ERROR.ACCOUNT)
            Y.RELATION.CODE = ''; Y.MONTO.DISPONIBLE.ACC = 0; R.FT = '';
            Y.MONTO.DISPONIBLE.ACC = R.ACCOUNT<AC.LOCAL.REF,L.AC.AV.BAL.POS>
            IF  R.ACCOUNT<AC.ARRANGEMENT.ID> EQ Y.ARR.ID THEN
                CONTINUE
            END
            Y.RELATION.CODE = R.ACCOUNT<AC.RELATION.CODE>
            IF Y.MONTO.DISPONIBLE.ACC GT Y.MONTO.ABONO AND Y.RELATION.CODE NE Y.MANCOMUNADA AND Y.RELATION.CODE NE Y.TUTOR  THEN
                R.FT<FT.DEBIT.ACCT.NO> =  Y.ID.ACCOUNT
                R.FT<FT.CREDIT.ACCT.NO> = Y.NUMERO.PRESTAMO
                R.FT<FT.DEBIT.AMOUNT> = Y.MONTO.ABONO
                R.FT<FT.TRANSACTION.TYPE> = Y.CODIGO.TRANSACION
                R.FT<FT.DEBIT.CURRENCY> = Y.MONEDA
                R.FT<FT.ORDERING.BANK> = Y.ORDERING.BANK
                Y.PROCESAR.OFS = "YES"
                GOSUB OFS.PROCESS.FT
                CONTINUE
            END

        REPEAT
        IF Y.ESTADO.OFS EQ "FAILURE" AND Y.PROCESAR.OFS EQ 'NO'  THEN
            GOSUB SET.TABLA.CONCAT
            RETURN
        END
        IF Y.PROCESAR.OFS EQ 'NO' THEN
            Y.ESTADO.OFS = "FAILURE"
            Y.DETALLE.ERROR.OFS = "CUENTAS DEL CLIENTE CON BALANCE INSUFICIENTE"
            GOSUB SET.TABLA.CONCAT
            RETURN
        END
        IF Y.PROCESAR.OFS EQ 'YES' THEN
            GOSUB SET.TABLA.CONCAT
            RETURN
        END

        RETURN

OFS.PROCESS.FT:
        options = ''; APP.NAME = ''; OFSFUNCTION = ''; GTS.MODE = '';
        NO.OF.AUTH = ''; OFS.VERSION = ''; TRANSACTION.ID = ''; OFS.RECORD = '';
        PROCESS = ''; Y.txnCommitted = ''
        options = 'DM.OFS.SRC.VAL'
        APP.NAME = 'FUNDS.TRANSFER'
        OFSFUNCTION = 'I';
        GTS.MODE = '' ;
        NO.OF.AUTH = '0'
        OFS.VERSION = APP.NAME:",REDO.STANDBY.UTIL"
        TRANSACTION.ID = ""
        OFS.RECORD = ''
        PROCESS = 'PROCESS'
        Y.txnCommitted = ''
        CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCTION,PROCESS,OFS.VERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.FT,OFS.RECORD)
        CALL OFS.CALL.BULK.MANAGER(options,OFS.RECORD,RESP, Y.txnCommitted)
        IF INDEX(RESP,'//-1/',1) THEN
            Y.RESP.ARRAY1 = FIELD(RESP,'//-1/',2)
            Y.DETALLE.ERROR.OFS = FIELD(Y.RESP.ARRAY1,'</request><request>',1)
            Y.ESTADO.OFS = 'FAILURE'
        END ELSE
            M.VALIDA = FIELD(RESP,"//",1)
            CHANGE "<requests><request>" TO "" IN M.VALIDA
            IF M.VALIDA[1,2] EQ 'FT' THEN
                Y.DETALLE.ERROR.OFS = M.VALIDA
                Y.ESTADO.OFS = 'SUCCESS'
            END
        END

        RETURN

SET.TABLA.CONCAT:
        R.LAPAP.CONCATE.DEB.DIR = Y.ESTADO.OFS:"*":Y.DETALLE.ERROR.OFS
        CALL  F.WRITE(FN.LAPAP.CONCATE.DEB.DIR,Y.ARR.ID,R.LAPAP.CONCATE.DEB.DIR)
        RETURN

    END
