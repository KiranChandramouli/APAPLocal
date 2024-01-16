* @ValidationCode : MjoxMTU5NDc2MDIwOkNwMTI1MjoxNjkwMTk0ODE5NTg2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 16:03:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
* <Rating>-42</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.FUND.SEND.MONITOR(REC.LIST)
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.FUND.SEND.MONITOR
* Date           : 2018-05-04
* Item ID        : CN004475
*========================================================================
* Brief description :
* -------------------
* This a multi-threading program for inject data in monitor interface
* without use any version.
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-05-04     Richard HC                Initial Development
*========================================================================
* Content summary :
* =================
* Table name     :
* Auto Increment :
* Views/versions :
* EB record      :
* Routine        :
*========================================================================

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts and Removed "\" and done in one Line

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_LAPAP.FUND.SEND.MONITOR
   $USING EB.LocalReferences
   $USING EB.TransactionControl

    GOSUB INIT
    GOSUB PROCESS
    GOSUB BUILDING
    GOSUB SENDING



*===
INIT:
*===
    FN.MON = "F.REDO.MON.SEND.QUEUE"
    F.MON = ""

    FN.CUR = "F.CURRENCY"
    F.CUR = ""

    FN.TXN = "F.FT.TXN.TYPE.CONDITION"
    F.TXN = ""

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""

    CALL OPF(FN.MON,F.MON)
    CALL OPF(FN.CUR,F.CUR)
    CALL OPF(FN.TXN,F.TXN)
    CALL OPF(FN.CUS,F.CUS)

    IDD = REC.LIST



*======
PROCESS:
*======
    CALL F.READ(FN.FUND,IDD,R.FUND,F.FUND,E.FUND)
    mon.cliente = R.FUND<FT.DEBIT.CUSTOMER>
    beneficiario = R.FUND<FT.CREDIT.CUSTOMER>
    no.cuenta.beneficiario = R.FUND<FT.CREDIT.ACCT.NO>
    mon.cuenta = R.FUND<FT.DEBIT.ACCT.NO>
    tipo.moneda = R.FUND<FT.CREDIT.CURRENCY>
    mon.num.tran = IDD
    mon.fecha = R.FUND<FT.PROCESSING.DATE>
    mon.hora = R.FUND<FT.DATE.TIME>
    mon.monto.original = R.FUND<FT.LOC.AMT.DEBITED>
    mon.valor.tran = R.FUND<FT.LOC.AMT.DEBITED>
    mon.usu.autoriza = R.FUND<FT.INPUTTER>
    mon.valor.efectivo = R.FUND<FT.LOC.AMT.CREDITED>
    mon.oficina.apertura = 1
    mon.producto = R.FUND<FT.TRANSACTION.TYPE>
    secuencia.lectura = 00000000000000000


*-Passing parameters to this routine for get some values
*CALL LAPAP.CUSTOMER.IDENT(mon.cliente,IDENT,IDENTYPE,NAME,LASTN,DEFV)
    APAP.LAPAP.lapapCustomerIdent(mon.cliente,IDENT,IDENTYPE,NAME,LASTN,DEFV);* R22 Manual conversion - CALL method format changed
    IF DEFV EQ "YES" THEN
        mon.cedula = IDENT
        mon.tipo = IDENTYPE
        mon.nombre = NAME
        mon.apellido = LASTN
    END


    CALL F.READ(FN.ACC,mon.cuenta,R.ACC,F.ACC,E.RR)
    mon.fecha.apertura = R.ACC<AC.OPENING.DATE>
*    CALL GET.LOC.REF("ACCOUNT","L.AC.STATUS1",POSs)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.STATUS1",POSs);* R22 UTILITY AUTO CONVERSION
    mon.estatus.anterior = R.ACC<AC.LOCAL.REF,POSs>


    CALL F.READ(FN.TXN,mon.producto,R.TXN,F.TXN,E.TXN)
    mon.codigo.tran = R.TXN<FT6.TXN.CODE.CR>


    CALL F.READ(FN.CUR,tipo.moneda,R.CUR,F.CUR,E.CUR)
    mon.moneda = R.CUR<EB.CUR.NUMERIC.CCY.CODE>


    CALL F.READ(FN.CUS,mon.cliente,R.CUS,F.CUS,E.CUS)
*    CALL GET.LOC.REF("CUSTOMER","L.CU.TIPO.CL",POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.TIPO.CL",POS);* R22 UTILITY AUTO CONVERSION
    tipo.de.persona = R.CUS<EB.CUS.LOCAL.REF,POS>
    sexo = R.CUS<EB.CUS.GENDER>
    IF sexo EQ "FEMALE" THEN
        sexo = "F"
    END ELSE
        sexo = "M"
    END


*-Passing parameters to this routine for get some values
    APAP.LAPAP.lapapCustomerIdent(beneficiario,IDENT,IDENTYPE,NAME,LASTN,DEFV);* R22 Manual conversion - CALL method format changed
*CALL LAPAP.CUSTOMER.IDENT(beneficiario,IDENT,IDENTYPE,NAME,LASTN,DEFV)
    IF DEFV EQ "YES" THEN
        cedula.beneficiario = IDENT
        nombre.beneficiario = NAME:" ":LASTN
    END



*========
BUILDING:
*========

* ARR<1,1> = "mon_cliente":"@vm":"mon_cedula":"@vm":"mon_tipo":"@vm":"mon_apellido":"@vm":\
*            "mon_nombre":"@vm":"mon_cuenta":"@vm":"mon_fecha_apertura":"@vm":"mon_num_tran":"@vm":\
*            "mon_fecha":"@vm":"mon_hora":"@vm":"mon_codigo_tran":"@vm":"mon_moneda":"@vm":\
*            "mon_monto_original":"@vm":"mon_valor_tran":"@vm":"mon_usu_autoriza":"@vm":\
*            "mon_valor_efectivo":"@vm":"mon_oficina_apertura":"@vm":"mon_producto":"@vm":\
*            "mon_estatus_anterior":"@vm":"sexo":"@vm":"tipo_de_persona":"@vm":"cedula_beneficiario":"@vm":\
*            "nombre_beneficiario":"@vm":"no_cuenta_beneficiario":"@vm":"secuencia_lectura":"@vm"
*
*  ARR<2,1> = "N":"@vm":"C":"@vm":"C":"@vm":"C":"@vm":"C":"@vm":"N":"@vm":"N":"@vm":"C":"@vm":\
*             "N":"@vm":"N":"@vm":"N":"@vm":"C":"@vm":"N":"@vm":"N":"@vm":"C":"@vm":"N":"@vm":"N":"@vm":\
*             "C":"@vm":"C":"@vm":"C":"@vm":"C":"@vm":"C":"@vm":"C":"@vm":"N":"@vm":"C":"@vm"
*
*  ARR<3,1> = mon.cliente:"@vm":mon.cedula:"@vm":mon.tipo:"@vm":mon.apellido:"@vm":mon.nombre:"@vm":\
*             mon.cuenta:"@vm":mon.fecha.apertura:"@vm":mon.num.tran:"@vm":mon.fecha:"@vm":mon.hora:"@vm":\
*             mon.codigo.tran:"@vm":mon.moneda:"@vm":mon.monto.original:"@vm":mon.valor.tran:"@vm":mon.usu.autoriza:"@vm":\
*             mon.valor.efectivo:"@vm":mon.oficina.apertura:"@vm":mon.producto:"@vm":mon.estatus.anterior:"@vm":sexo:"@vm":\
*             tipo.de.persona:"@vm":cedula.beneficiario:"@vm":nombre.beneficiario:"@vm":no.cuenta.beneficiario:"@vm":\
*             secuencia.lectura:"@vm"

    ARR<1,1> = "mon_cliente":"@vm":"mon_cedula":"@vm":"mon_tipo":"@vm":"mon_apellido":"@vm":"mon_nombre":"@vm":"mon_cuenta":"@vm":"mon_fecha_apertura":"@vm":"mon_num_tran":"@vm":"mon_fecha":"@vm":"mon_hora":"@vm":"mon_codigo_tran":"@vm":"mon_moneda":"@vm":"mon_monto_original":"@vm":"mon_valor_tran":"@vm":"mon_usu_autoriza":"@vm":"mon_valor_efectivo":"@vm":"mon_oficina_apertura":"@vm":"mon_producto":"@vm":"mon_estatus_anterior":"@vm":"sexo":"@vm":"tipo_de_persona":"@vm":"cedula_beneficiario":"@vm":"nombre_beneficiario":"@vm":"no_cuenta_beneficiario":"@vm":"secuencia_lectura":"@vm"      ;*R22 Manual Conversion - Removed "\" and done in one Line

    ARR<2,1> = "N":"@vm":"C":"@vm":"C":"@vm":"C":"@vm":"C":"@vm":"N":"@vm":"N":"@vm":"C":"@vm":"N":"@vm":"N":"@vm":"N":"@vm":"C":"@vm":"N":"@vm":"N":"@vm":"C":"@vm":"N":"@vm":"N":"@vm":"C":"@vm":"C":"@vm":"C":"@vm":"C":"@vm":"C":"@vm":"C":"@vm":"N":"@vm":"C":"@vm"        ;*R22 Manual Conversion - Removed "\" and done in one Line

    ARR<3,1> = mon.cliente:"@vm":mon.cedula:"@vm":mon.tipo:"@vm":mon.apellido:"@vm":mon.nombre:"@vm":mon.cuenta:"@vm":mon.fecha.apertura:"@vm":mon.num.tran:"@vm":mon.fecha:"@vm":mon.hora:"@vm":mon.codigo.tran:"@vm":mon.moneda:"@vm":mon.monto.original:"@vm":mon.valor.tran:"@vm":mon.usu.autoriza:"@vm":mon.valor.efectivo:"@vm":mon.oficina.apertura:"@vm":mon.producto:"@vm":mon.estatus.anterior:"@vm":sexo:"@vm":tipo.de.persona:"@vm":cedula.beneficiario:"@vm":nombre.beneficiario:"@vm":no.cuenta.beneficiario:"@vm":secuencia.lectura:"@vm"        ;*R22 Manual Conversion - Removed "\" and done in one Line

    ARR<4,1> = "MONITOR_CAJA"



*======
SENDING:
*======
    CALL F.WRITE(FN.MON,IDD,ARR)
*    CALL JOURNAL.UPDATE('')
EB.TransactionControl.JournalUpdate('');* R22 UTILITY AUTO CONVERSION


END
