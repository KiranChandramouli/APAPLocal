SUBROUTINE LAPAP.ACC.CANAL.APERTURA

**************************************************************
*-------------------------------------------------------------
* Descripcion: Esta rutina captura los nuemeros de cuentas que
* se encuentran en las trasacciones de caja para buscar el
* Canal de apertura y agregarlo en la transaccion.
* Autor: Juan Garcia
* Fecha: 13/01/2022
* Ticket: https://apap-software.atlassian.net/browse/DIP-139
*-------------------------------------------------------------
**************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT JBC.h
    $INSERT I_F.CUSTOMER
    $INSERT I_F.VERSION
    $INSERT I_F.T24.FUND.SERVICES


    IF APPLICATION EQ 'TELLER' THEN
        CALL REDO.APAP.ACCOUNT.CHECK.EXTENDED
    END

    IF APPLICATION EQ 'T24.FUND.SERVICES' THEN
        CALL REDO.V.VAL.PRIMARY.ACC.EXTENDED
    END

    Y.VAR           = 'APAPPMovil'

    GOSUB INIT

RETURN

*=====
INIT:
*=====

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    Y.ACCOUNT                = COMI
    POS.L.PRESENCIAL         = '';

    IF APPLICATION EQ 'TELLER' THEN
        CALL GET.LOC.REF("TELLER","L.PRESENCIAL",POS.L.PRESENCIAL)
        GOSUB TELLER.PROCCESS
    END

    IF APPLICATION EQ 'T24.FUND.SERVICES' THEN
        CALL GET.LOC.REF("T24.FUND.SERVICES","L.PRESENCIAL",POS.L.PRESENCIAL)
        GOSUB FUNDS.PROCCESS
    END

RETURN

*===============
TELLER.PROCCESS:
*===============

    R.ACCOUNT = ''; ACCOUNT.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

    Y.PRESENCIAL.POS = '';
    CALL GET.LOC.REF("ACCOUNT","L.PRESENCIAL",Y.PRESENCIAL.POS)
    Y.PRESENCIAL             = R.ACCOUNT<AC.LOCAL.REF,Y.PRESENCIAL.POS>

    IF Y.PRESENCIAL EQ Y.VAR THEN
        R.NEW(TT.TE.LOCAL.REF)<1,POS.L.PRESENCIAL>      =  Y.PRESENCIAL
        T.LOCREF<POS.L.PRESENCIAL,7>                    = 'NOINPUT'
    END
    IF Y.PRESENCIAL NE Y.VAR THEN
        Y.PRESENCIAL                                    = 'Fisico Sucursal'
        R.NEW(TT.TE.LOCAL.REF)<1,POS.L.PRESENCIAL>      =  Y.PRESENCIAL
        T.LOCREF<POS.L.PRESENCIAL,7>                    = 'NOINPUT'
    END
RETURN
*==============
FUNDS.PROCCESS:
*==============

    R.ACCOUNT = ''; ACCOUNT.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

    Y.PRESENCIAL.POS = '';
    CALL GET.LOC.REF("ACCOUNT","L.PRESENCIAL",Y.PRESENCIAL.POS)
    Y.PRESENCIAL             = R.ACCOUNT<AC.LOCAL.REF,Y.PRESENCIAL.POS>

    IF Y.PRESENCIAL EQ Y.VAR THEN
        R.NEW(TFS.LOCAL.REF)<1,POS.L.PRESENCIAL>        =  Y.PRESENCIAL
        T.LOCREF<POS.L.PRESENCIAL,7>                    = 'NOINPUT'
    END
    IF Y.PRESENCIAL NE Y.VAR THEN
        Y.PRESENCIAL                                    = 'Fisico Sucursal'
        R.NEW(TFS.LOCAL.REF)<1,POS.L.PRESENCIAL>        =  Y.PRESENCIAL
        T.LOCREF<POS.L.PRESENCIAL,7>                    = 'NOINPUT'
    END
RETURN
END
