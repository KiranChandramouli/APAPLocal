* @ValidationCode : MjotMTgzODQ0MzY4NDpDcDEyNTI6MTY4OTg0Mjk0OTI5MzpJVFNTMTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Jul 2023 14:19:09
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
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 14-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 14-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

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
*       CALL REDO.APAP.ACCOUNT.CHECK.EXTENDED
        APAP.LAPAP.redoApapAccountCheckExtended() ;* R22 Manual Conversion
    END

    IF APPLICATION EQ 'T24.FUND.SERVICES' THEN
*       CALL REDO.V.VAL.PRIMARY.ACC.EXTENDED
        APAP.LAPAP.redoVValPrimaryAccExtended() ;* R22 Manual Conversion
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
