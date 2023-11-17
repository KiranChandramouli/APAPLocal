* @ValidationCode : MjoxNzc3NjQ0MTM2OkNwMTI1MjoxNjgyMzM1OTQ1Mzk5OklUU1M6LTE6LTE6MjY2OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 266
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED , VM TO @VM
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
* Subrutina: L.APAP.VAL.STATU.NOTI
*  Creación: 03/08/2020
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.STATU.NOTI
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER ;* AUTO R22 CODE CONVERSION END

    GOSUB INIT
    GOSUB PROCESS

RETURN

*----
INIT:
*----

*--Declaro y Cargo Tabla de Cuentas
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LREF.APP = 'ACCOUNT'
    LREF.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.AC.NOTIFY.1'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    L.AC.STATUS1.POS=LREF.POS<1,1>
    L.AC.STATUS2.POS=LREF.POS<1,2>
    L.AC.NOTIFY.POS=LREF.POS<1,3>

RETURN

*-------
PROCESS:
*-------
*--Leo el Registro de la Cuenta Débito
    Y.VAR.DEBIT.ACCT.ID = R.NEW(FT.DEBIT.ACCT.NO)
    R.DEBITO = ''
    ERR = ''
    CALL F.READ(FN.ACCOUNT, Y.VAR.DEBIT.ACCT.ID, R.DEBITO, F.ACCOUNT, ERR)


*--Leo el Registro de la Cuenta Crédito
    Y.VAR.CREDIT.ACCT.ID =R.NEW(FT.CREDIT.ACCT.NO)
    R.CREDITO = ''
    ERR = ''
    CALL F.READ(FN.ACCOUNT, Y.VAR.CREDIT.ACCT.ID, R.CREDITO, F.ACCOUNT, ERR)

    GOSUB CHECK.DATOSCUENTAS

RETURN

*------------------
CHECK.DATOSCUENTAS:
*------------------
    Y.ACC.NOTIF.CR = R.CREDITO<AC.LOCAL.REF><1,L.AC.NOTIFY.POS>
    Y.ACC.NOTIF.DB = R.DEBITO<AC.LOCAL.REF><1,L.AC.NOTIFY.POS>

*--Valida que el campo LAC.NOTIFIY.1 de los registros Crédito y Débito No contengan el Valor 'REDO.MONEY.LAUNDER'
*--IF Y.ACC.NOTIF.CR EQ 'REDO.MONEY.LAUNDER'  OR Y.ACC.NOTIF.DB EQ 'REDO.MONEY.LAUNDER' THEN
*--IF Y.ACC.NOTIF.CR EQ 'NOTIFY.MGMT.MONEY.LAUNDRY.PREV'  OR Y.ACC.NOTIF.DB EQ 'NOTIFY.MGMT.MONEY.LAUNDRY.PREV' THEN
    LOCATE 'NOTIFY.MGMT.MONEY.LAUNDRY.PREV' IN Y.ACC.NOTIF.DB<1,1,1> SETTING VERSION.POS  THEN
        ETEXT = 'EB-REDO.IVR.PR.BLOCK'
        CALL STORE.END.ERROR
        RETURN
    END

    LOCATE 'NOTIFY.MGMT.MONEY.LAUNDRY.PREV' IN Y.ACC.NOTIF.CR<1,1,1> SETTING VERSION.POS  THEN
        ETEXT = 'EB-REDO.IVR.PR.BLOCK'
        CALL STORE.END.ERROR
        RETURN
    END

*--Valida que el campo LAC.NOTIFIY.1 de los registros Crédito y Débito No contengan el Valor 'REDO.VALIDAR.ID'
*--IF Y.ACC.NOTIF.CR EQ 'VALIDAR.ID.URGENTE'  OR  Y.ACC.NOTIF.DB EQ 'VALIDAR.ID.URGENTE' THEN
    LOCATE 'VALIDAR.ID.URGENTE' IN Y.ACC.NOTIF.DB<1,1,1> SETTING VERSION.POS  THEN
        ETEXT = 'EB-REDO.IVR.PR.BLOCK'
        CALL STORE.END.ERROR
        RETURN
    END

    LOCATE 'VALIDAR.ID.URGENTE' IN Y.ACC.NOTIF.CR<1,1,1> SETTING VERSION.POS  THEN
        ETEXT = 'EB-REDO.IVR.PR.BLOCK'
        CALL STORE.END.ERROR
        RETURN
    END

*--Valida que el campo LAC.NOTIFIY.1 del registro Débito contengan el Valor 'REDO.SEGURIDAD.PRODUCTOS'
*--IF Y.ACC.NOTIF.DB EQ 'SEGURIDAD.DE.PRODUCTOS' OR Y.ACC.NOTIF.CR EQ 'NO.CR.XPREVELAC' THEN
*--IF Y.ACC.NOTIF.DB EQ 'SEGURIDAD.DE.PRODUCTOS' THEN
    LOCATE 'SEGURIDAD.DE.PRODUCTOS' IN Y.ACC.NOTIF.DB<1,1,1> SETTING VERSION.POS  THEN
        ETEXT = 'EB-REDO.IVR.PR.BLOCK'
        CALL STORE.END.ERROR
        RETURN
    END

    LOCATE 'NO.CR.XPREVELAC' IN Y.ACC.NOTIF.CR<1,1,1> SETTING VERSION.POS  THEN
        ETEXT = 'EB-REDO.IVR.PR.BLOCK'
        CALL STORE.END.ERROR
        RETURN
    END

    Y.ACC.STATUS2.CR = R.CREDITO<AC.LOCAL.REF><1,L.AC.STATUS2.POS>
    Y.ACC.STATUS2.DB = R.DEBITO<AC.LOCAL.REF><1,L.AC.STATUS2.POS>
*--Valida que el campo LAC.STATUS2 de los registros Crédito y Débito No contengan el Valor 'DECEASED'
    IF Y.ACC.STATUS2.CR EQ 'DECEASED'  OR  Y.ACC.STATUS2.DB EQ 'DECEASED' THEN
        ETEXT = 'EB-INACT.ACCOUNT'
        CALL STORE.END.ERROR
        RETURN
    END

    Y.ACC.STATUS1.CR = R.CREDITO<AC.LOCAL.REF><1,L.AC.STATUS1.POS>
    Y.ACC.STATUS1.DB = R.DEBITO<AC.LOCAL.REF><1,L.AC.STATUS1.POS>
*--Valida que el campo LAC.STATUS2 de los registros Crédito y Débito No contengan el Valor 'ABANDONED'
    IF Y.ACC.STATUS1.CR EQ 'ABANDONED'  OR  Y.ACC.STATUS1.DB EQ 'ABANDONED' THEN
        ETEXT = 'EB-INACT.ACCOUNT'
        CALL STORE.END.ERROR
        RETURN
    END

RETURN
