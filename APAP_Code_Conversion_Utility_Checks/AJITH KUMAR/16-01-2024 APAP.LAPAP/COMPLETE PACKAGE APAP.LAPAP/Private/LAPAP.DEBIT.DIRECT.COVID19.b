* @ValidationCode : Mjo5MDE1Mzk4MjY6Q3AxMjUyOjE3MDQ4NjE0ODU3MjI6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Jan 2024 10:08:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Limpieza de DEBIT.DIRECT - 2da Fase - Proyecto COVID19
* Fecha: 31/03/2020
* Autor: Oliver Fermin
*----------------------------------------

SUBROUTINE LAPAP.DEBIT.DIRECT.COVID19(Y.ARRANGEMENT.ID)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-JULY-2023      Harsha                R22 Auto Conversion  - FM to @FM
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    *$INSERT I_F.AA.ARRANGEMENT
    $INSERT I_LAPAP.DEBIT.DIRECT.COVID19.COMO
    $USING APAP.TAM
   $USING AA.Framework
    GOSUB MAIN.PROCESS

RETURN

*-----------------------------------------------------------------------------

MAIN.PROCESS:
************
    AA.ARR.ID = Y.ARRANGEMENT.ID
    AA.ARR.ID = CHANGE(AA.ARR.ID,',',@FM)
    AA.ARR.ID = AA.ARR.ID<1>

    GOSUB GET.ARRANGEMENT

RETURN

GET.ARRANGEMENT:
***************

    R.ARRANGEMENT = ''; ERR.ARRAGEMENT = ''; CLIENTE.ID = ''
*    CALL AA.GET.ARRANGEMENT(AA.ARR.ID,R.ARRANGEMENT,ERR.ARRAGEMENT)
AA.Framework.GetArrangement(AA.ARR.ID,R.ARRANGEMENT,ERR.ARRAGEMENT);* R22 UTILITY AUTO CONVERSION
   * Y.COMPANY =  R.ARRANGEMENT<AA.ARR.CO.CODE>
    *Y.PRODUCT.GROUP = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    *Y.LINKED.APP.ID = R.ARRANGEMENT<AA.ARR.LINKED.APPL.ID,1>
    Y.COMPANY =  R.ARRANGEMENT< AA.Framework.ArrangementSim.ArrCoCode>
    Y.PRODUCT.GROUP = R.ARRANGEMENT< AA.Framework.ArrangementSim.ArrProductGroup>
    Y.LINKED.APP.ID = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedApplId,1>

    GOSUB GET.FIELDS.PAYMENT.SCHEDULE

RETURN

GET.FIELDS.PAYMENT.SCHEDULE:
****************************

    PROP.CLASS = 'PAYMENT.SCHEDULE'; PROPERTY = ''; EFF.DATE = ''; R.CONDITION = ''
    ERR.MSG = ''; R.AA.PAYMENT.SCHEDULE = ''
*   CALL REDO.CRR.GET.CONDITIONS(AA.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    APAP.TAM.redoCrrGetConditions(AA.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG) ;*R22 Manual Code Conversion
    R.AA.PAYMENT.SCHEDULE = R.CONDITION

    IF R.AA.PAYMENT.SCHEDULE THEN
        Y.L.AA.PAY.METHD = R.AA.PAYMENT.SCHEDULE<AA.PS.LOCAL.REF, L.AA.PAY.METHD.POS>
        Y.L.AA.DEBT.AC = R.AA.PAYMENT.SCHEDULE<AA.PS.LOCAL.REF, L.AA.DEBT.AC.POS>
    END

*Archivo de validacion para ver los valores que poseen actualmente los contratos
    R.LAPAP.DEBIT.DIRECT.COVID19 = AA.ARR.ID:"|":Y.LINKED.APP.ID:"|":Y.PRODUCT.GROUP:"|":Y.L.AA.PAY.METHD:"|":Y.L.AA.DEBT.AC;
    REGISTRO.ID =  AA.ARR.ID:'*':'VALIDATION.FILE'
    GOSUB CHECK.ARCHIVO.FILES

*Archivo que se utilizara para la DMT.
    R.LAPAP.DEBIT.DIRECT.COVID19 = "||":AA.ARR.ID:"||LENDING-CHANGE-REPAYMENT.SCHEDULE||":Y.COMPANY:"||REPAYMENT.SCHEDULE||L.AA.PAY.METHD::L.AA.DEBT.AC||":Y.PARM.PAY.METHOD:"::":Y.PARAM.DEBT.AC:"||";
    REGISTRO.ID  = AA.ARR.ID:'*':'DMT.FILE'
    GOSUB CHECK.ARCHIVO.FILES

RETURN

CHECK.ARCHIVO.FILES:
    CALL F.WRITE(FN.LAPAP.DEBIT.DIRECT.COVID19,REGISTRO.ID,R.LAPAP.DEBIT.DIRECT.COVID19)
RETURN

END
