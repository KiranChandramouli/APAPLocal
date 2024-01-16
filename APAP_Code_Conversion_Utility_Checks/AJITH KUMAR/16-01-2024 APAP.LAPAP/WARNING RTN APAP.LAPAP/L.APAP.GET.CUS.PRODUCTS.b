* @ValidationCode : MjotMTk2Mjg4NzQ0NjpDcDEyNTI6MTcwNDc5NjE1NjEyMTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 15:59:16
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

*-----------------------------------------------------------------------------
* <Rating>958</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.CUS.PRODUCTS (Y.FINAL)

*--------------------------------------------------------------------------------------------------
* Description           : This routine returns a consolidated product of a customer
* Developed On          : 26/12/2018
* Developed By          : Anthony Martinez
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* --------               Anthony Martinez               26/12/2018            Creation
* --------               Anthony Martinez               20/05/2019            Validation if account is shared (ACCOUNT TYPE Y)
* --------               Arcadio Ruiz                   20/09/2019            Validation if the co signer is true in the account
* --------               Arcadio Ruiz                   26/09/2019            Add co-signer loan and joint holder saving account
* MDP-742                Melvy Martinez                 11/11/2019            Corrigiendo fecha de desembolso para prestamos
* MPD-920                Oliver Fermin                  13/02/2020            Correción para los contratos que no devuelve el LOAN.STATUS.1 de la tabla OVERDUE
* MDR-1668               Jose Hilario                   22/03/2022            Agregar el status de las tarjeta debito

* 08-JUNE-2023     Santosh             R22 Manual Conversion - Changed VM,FM to @VM,@FM and NEXT statement modified, Changed CALL method
* 21/11/2023         Suresh             R22 Manual Conversion                 Latest Routine Changes Merged
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RELATION
    $INSERT I_F.CATEGORY
    $INSERT I_F.AA.PRODUCT
   * $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    *$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.CARD.STATUS
    $INSERT I_F.LATAM.CARD.ORDER
   $USING EB.LocalReferences
   $USING AA.Framework

    $USING APAP.LAPAP

    GOSUB CARGAR.TABLAS ;* Latest Routine- Changes GOSUB Added
    GOSUB PROCESO.PRINCIPAL
RETURN

CARGAR.TABLAS: ;* Latest Routine- Changes

**----------------------------------------
**ABRIR LA TABLA FBNK.REDO.CUST.PRD.LIST
**----------------------------------------
    FN.CUS.PRD = "F.REDO.CUST.PRD.LIST"
    FV.CUS.PRD = ""
    R.CUS.PRD = ""
    CUS.PRD.ERR = ""

**----------------------------------------
**ABRIR LA TABLA F.AA.OVERDUE
**----------------------------------------
    FN.AA.ARR.OVERDUE          = 'F.AA.ARR.OVERDUE'
    F.AA.ARR.OVERDUE           = ''
    R.AA.ARR.OVERDUE = ""
    AA.ARR.OVERDUE.ERR = ""
    CALL OPF(FN.AA.ARR.OVERDUE,F.AA.ARR.OVERDUE)

    FN.AA.ARRANGEMENT.DATED.XREF  = 'F.AA.ARRANGEMENT.DATED.XREF'
    F.AA.ARRANGEMENT.DATED.XREF = ''
    CALL OPF(FN.AA.ARRANGEMENT.DATED.XREF,F.AA.ARRANGEMENT.DATED.XREF)

**---------------------------------------
**ABRIR LA TABLA CUSTOMER
**---------------------------------------
    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    R.CUS = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,FV.CUS)

**---------------------------------------
**ABRIR LA TABLA RELATION
**---------------------------------------
    FN.REL = "F.RELATION"
    FV.REL = ""
    R.REL = ""
    REL.ERR = ""
    CALL OPF(FN.REL,FV.REL)

**---------------------------------------
**ABRIR LA TABLA F.ACCOUNT Y F.ACCOUNT.CLOSED
**---------------------------------------
    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""
    R.ACC = ""
    ACC.ERR = ""

    FN.ACC.C = "F.ACCOUNT.CLOSED"
    FV.ACC.C = ""
    R.ACC.C = ""
    ACC.ERR.C = ""
    CALL OPF(FN.ACC.C,FV.ACC.C)

**---------------------------------------
**ABRIR LA TABLA CATEGORY
**---------------------------------------
    FN.CAT = "F.CATEGORY"
    FV.CAT = ""
    R.CAT = ""
    CAT.ERR = ""
    CALL OPF(FN.CAT,FV.CAT)

**---------------------------------------
**ABRIR LA TABLA AA.PRODUCT
**---------------------------------------
    FN.AA.PROD = "F.AA.PRODUCT"
    FV.AA.PROD = ""
    R.AA.PROD = ""
    AA.PROD.ERR = ""
    CALL OPF(FN.AA.PROD,FV.AA.PROD)

**---------------------------------------
**ABRIR LA TABLA AA.ARRANGEMENT
**---------------------------------------
    FN.AA.ARR = "F.AA.ARRANGEMENT"
    FV.AA.ARR = ""
    R.AA.ARR = ""
    AA.ARR.ERR = ""
    CALL OPF(FN.AA.ARR, FV.AA.ARR)

**---------------------------------------
**ABRIR LA TABLA AA.ARRANGEMENT.ACTIVITY - MDP-742
**---------------------------------------
    FN.AA.ARRANGEMENT.ACTIVITY = "F.AA.ARRANGEMENT.ACTIVITY"; FV.AA.ARRANGEMENT.ACTIVITY = ""
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY, FV.AA.ARRANGEMENT.ACTIVITY)

**---------------------------------------
**ABRIR LA TABLA AZ.ACCOUNT
**---------------------------------------
    FN.AZ.ACC = "F.AZ.ACCOUNT"
    FV.AZ.ACC = ""
    R.AZ.ACC = ""
    AZ.ACC.ERR = ""
    CALL OPF(FN.AZ.ACC,FV.AZ.ACC)

**---------------------------------------
**TABLA FBNK.JOINT.CONTRACTS.XREF
**---------------------------------------
    FN.JOINT.CONTRACTS.XREF='F.JOINT.CONTRACTS.XREF';
    FV.JOINT.CONTRACTS.XREF=''
    R.JOINT.CONTRACTS.XREF = ""
    JOINT.CONTRACTS.XREF.ERR = ""
    CALL OPF(FN.JOINT.CONTRACTS.XREF,FV.JOINT.CONTRACTS.XREF)

**----------------------------------------
**TABLA PRESTAMOS TODOS
**---------------------------------------

    FN.REDO.CUSTOMER.ARRANGEMENT='F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUSTOMER.ARRANGEMENT=''
    CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT)

**-------------------------------------------------------------


**------------------------------------------------------
**TABLAS DE TARJETA DE DEBITOS
**--------------------------------------------------------

    FN.CARD.STATUS = 'F.CARD.STATUS'
    FV.CARD.STATUS = ''
    CALL OPF (FN.CARD.STATUS,FV.CARD.STATUS)

    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    FV.LATAM.CARD.ORDER = ''
    CALL OPF (FN.LATAM.CARD.ORDER,FV.LATAM.CARD.ORDER)

RETURN ;* Latest Routine- Changes
PROCESO.PRINCIPAL: ;* Latest Routine- Changes
**--------------------------------------------------------


**---------------------------------------------------------------------------------------------
**SENTENCIA LOCATE
**---------------------------------------------------------------------------------------------
    LOCATE "CUSTOMER.NUMBER" IN D.FIELDS<1> SETTING CUS.POS THEN
        F.ID = D.RANGE.AND.VALUE<CUS.POS>
    END
**------------------------------------------------------------------------------------------------------------------------------------
    Y.ALL.ACCOUNTS = ""
**------------------------------------------------------------------------------------------------------------------------------------
**------------------------------------------------------------------------------------------------------------------------------------
**PRIMERO PARA DICHO CLIENTE OBTENGO TODAS SUS CUENTAS, Y A SU VEZ PARA CADA CUENTA OBTENGO
**LOS REGISTROS CORRESPONDIENTE A CADA CUENTA DESDE LA TABLA ACCOUNT
**------------------------------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.CUS.PRD,F.ID,R.CUS.PRD, FV.CUS.PRD, CUS.PRD.ERR)
    Y.CUS.PRD = R.CUS.PRD<PRD.PRODUCT.ID>

**---------------------------------------------------------------
**BUSCAR CUENTAS COTITULARES QUE NO ESTEN EN LA TABLA INTERMEDIA

    Y.CUS.PRD.XREF = CHANGE(Y.CUS.PRD,@VM,@FM)

    CALL F.READ(FN.JOINT.CONTRACTS.XREF,F.ID,R.JOINT.CONTRACTS.XREF,FV.JOINT.CONTRACTS.XREF,EF.ERR)

    NO.OF.JOINT.ACCOUNT = DCOUNT(R.JOINT.CONTRACTS.XREF,@FM)

    FOR A = 1 TO NO.OF.JOINT.ACCOUNT STEP 1

        Y.ACC.NO = R.JOINT.CONTRACTS.XREF<A>

        LOCATE Y.ACC.NO IN Y.CUS.PRD.XREF SETTING POS.XREF ELSE
            Y.CUS.PRD = Y.CUS.PRD : @VM : Y.ACC.NO
        END

*    NEXT P
    NEXT A ;* R22 Manual Conversion
**---------------------------------------------------------------

**----------------------------------------------------------------------
**BUSCA PRESTAMOS FALTANTES

    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,F.ID,R.CUS.ARR,F.REDO.CUSTOMER.ARRANGEMENT,CUS.ARR.ERR)

    Y.OWNER = R.CUS.ARR<CUS.ARR.OTHER.PARTY>
    Y.CUS.ARR = CHANGE(Y.CUS.PRD,@VM,@FM)
    Y.OWNER.CNT = DCOUNT(Y.OWNER,@VM)

    FOR B = 1 TO Y.OWNER.CNT STEP 1

        Y.ACC.PR = Y.OWNER<1,B>

        CALL F.READ(FN.AA.ARR,Y.ACC.PR,R.AA.ARR,FV.AA.ARR,AA.ARR.ERR)
        *Y.ACCOUNT.PR = R.AA.ARR<AA.ARR.LINKED.APPL.ID>
        Y.ACCOUNT.PR = R.AA.ARR<AA.Framework.Arrangement.ArrLinkedApplId>

        LOCATE Y.ACCOUNT.PR IN Y.CUS.ARR SETTING POS.XREF ELSE
            Y.CUS.PRD = Y.CUS.PRD : @VM : Y.ACCOUNT.PR
        END

    NEXT B

**---------------------------------------------------------------------------------------

    Y.CAN.CUS.PRD = DCOUNT(Y.CUS.PRD,@VM)

    FOR P = 1 TO Y.CAN.CUS.PRD STEP 1

        T.CONTINUE.FLAG  = "NO"
*Y.CTA.ACTUAL   = R.CUS.PRD<PRD.PRODUCT.ID,P>
        Y.CTA.ACTUAL  = Y.CUS.PRD<1,P>
        Y.CTA.ACTUAL.EST  = R.CUS.PRD<PRD.PRD.STATUS,P>

        IF Y.CTA.ACTUAL.EST EQ "CLOSED" THEN
            CONTINUE
        END

        CALL F.READ(FN.ACC,Y.CTA.ACTUAL,R.ACC, FV.ACC, ACC.ERR)

        Y.RECORD.STATUS  = R.ACC<AC.RECORD.STATUS>

        IF Y.RECORD.STATUS EQ "CLOSED" THEN
            CONTINUE
        END

*--SE OBTIENE EL ALIAS PARA CADA CUENTA
        FN.ACC.ALIAS = "F.AI.REDO.ARCIB.ALIAS.TABLE"; FV.ACC.ALIAS = ""; R.ACC.ALIAS = ""; ERR.ACC.ALIAS = ""
        CALL OPF(FN.ACC.ALIAS, FV.ACC.ALIAS)
        CALL F.READ(FN.ACC.ALIAS, Y.CTA.ACTUAL, R.ACC.ALIAS, FV.ACC.ALIAS, ERR.ACC.ALIAS)

        Y.ACCOUNT.NUMBER    = Y.CTA.ACTUAL
        Y.CUSTOMER          = R.ACC<AC.CUSTOMER>
        Y.ONLINE.ACTUAL.BAL = R.ACC<AC.ONLINE.ACTUAL.BAL>
        Y.DATE.LAST.CR.CUST = R.ACC<AC.DATE.LAST.CR.CUST>
        Y.DATE.LAST.DR.CUST = R.ACC<AC.DATE.LAST.DR.CUST>
        Y.AMNT.LAST.CR.CUST = R.ACC<AC.AMNT.LAST.CR.CUST>
        Y.AMNT.LAST.DR.CUST = R.ACC<AC.AMNT.LAST.DR.CUST>
        Y.RELATION.CODE     = R.ACC<AC.RELATION.CODE>
        Y.CATEGORY          = R.ACC<AC.CATEGORY>
        Y.JOINT.HOLDER      = R.ACC<AC.JOINT.HOLDER>
        Y.ACC.ALIAS         = R.ACC.ALIAS<1>
        Y.OPENING.DATE      = R.ACC<AC.OPENING.DATE>
        Y.AZ.RATE           = 0
        Y.LOCKED.AMOUNT     = 0
        Y.RELATION          = ""
        Y.LOAN.COND         = ""
        Y.ACC.NOTIFY        = ""
        Y.POSTING.RESTRIC   = R.ACC<AC.POSTING.RESTRICT>
        Y.EXPIRATION.DATE   = ""
        Y.AZ.INT.UNPAID     = 0
        Y.JOINT.PRIMERO     = R.ACC<AC.JOINT.HOLDER,1>
        Y.JOINT.SEGUNDO     = R.ACC<AC.JOINT.HOLDER,2>
        Y.ARRANGEMENT.ID    = R.ACC<AC.ARRANGEMENT.ID>

        PROP.CLASS     = 'CUSTOMER'
        PROP.NAME      = ''
        RET.ERR        = ''
        R.AA = ''

*        CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARRANGEMENT.ID,PROP.CLASS,PROP.NAME,'','',R.AA,RET.ERR)
AA.Framework.GetArrangementConditions(Y.ARRANGEMENT.ID,PROP.CLASS,PROP.NAME,'','',R.AA,RET.ERR);* R22 UTILITY AUTO CONVERSION
        R.AA = RAISE(R.AA)

        Y.AA.CUSTOMER = R.AA<AA.CUS.OTHER.PARTY>
        Y.AA.JOINT = Y.AA.CUSTOMER<1,1>

        IF F.ID NE Y.CUSTOMER AND F.ID NE Y.JOINT.PRIMERO AND F.ID NE Y.JOINT.SEGUNDO AND F.ID NE Y.AA.JOINT   THEN
            CONTINUE
        END

*        CALL GET.LOC.REF("ACCOUNT", "L.AC.STATUS1", L.AC.STATUS1.POS)
EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.STATUS1", L.AC.STATUS1.POS);* R22 UTILITY AUTO CONVERSION
        Y.L.AC.STATUS1  = R.ACC<AC.LOCAL.REF,L.AC.STATUS1.POS>

*        CALL GET.LOC.REF("ACCOUNT", "L.AC.STATUS2", L.AC.STATUS2.POS)
EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.STATUS2", L.AC.STATUS2.POS);* R22 UTILITY AUTO CONVERSION
        Y.L.AC.STATUS2  = R.ACC<AC.LOCAL.REF,L.AC.STATUS2.POS>

*-- IDENTIFICAMOS SI LA CUENTA ES COMPARTIDA (TIPO Y)
        Y.SIZE = DCOUNT(R.ACC<AC.RELATION.CODE>, @VM)

        FOR I = 1 TO Y.SIZE STEP 1
            CALL F.READ(FN.REL, R.ACC<AC.RELATION.CODE, I>, R.REL, FV.REL, REL.ERR)
            Y.RELATION = Y.RELATION : "|" :R.REL<EB.REL.DESCRIPTION>
*        NEXT P
        NEXT I ;* R22 Manual Conversion
*-- IDENTIFICAMOS LAS NOTIFICACIONES DE UNA CUENTA
*        CALL GET.LOC.REF("ACCOUNT", "L.AC.NOTIFY.1", L.AC.NOTIFY.POS)
EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.NOTIFY.1", L.AC.NOTIFY.POS);* R22 UTILITY AUTO CONVERSION
        Y.ACC.NOTIFY = R.ACC<AC.LOCAL.REF, L.AC.NOTIFY.POS>

        IF (Y.CATEGORY GE 6000 AND Y.CATEGORY LE 6599) THEN
*            CALL GET.LOC.REF("ACCOUNT", "L.AC.AV.BAL", L.AC.AV.BAL.POS)
EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.AV.BAL", L.AC.AV.BAL.POS);* R22 UTILITY AUTO CONVERSION
            Y.L.AC.AV.BAL       = R.ACC<AC.LOCAL.REF, L.AC.AV.BAL.POS>
            Y.ONLINE.ACTUAL.BAL = R.ACC<AC.WORKING.BALANCE>
            Y.LOCKED.AMOUNT     = Y.ONLINE.ACTUAL.BAL - Y.L.AC.AV.BAL
        END

*---------------------------------------------------------------------------------------------------------------------------
*Omitir cuentas de prestamos cancelados.
*Excluir las cuentas entre las categorias 3000 a 3999 que en el registro de ACCOUNT tengan el ONLINE.ACTUA.BAL con valor 0
*---------------------------------------------------------------------------------------------------------------------------

        IF (Y.CATEGORY GE 3000 AND Y.CATEGORY LE 3999) AND Y.ONLINE.ACTUAL.BAL EQ 0 THEN
            CONTINUE
        END

        IF (Y.CATEGORY GE 3000 AND Y.CATEGORY LE 3999) AND Y.ONLINE.ACTUAL.BAL NE 0 THEN
            OUTSTANDING.BALANCE = 0
*            CALL L.APAP.GET.OUTSTANDING.BALANCE (Y.ACCOUNT.NUMBER, OUTSTANDING.BALANCE)
            APAP.LAPAP.lApapGetOutstandingBalance(Y.ACCOUNT.NUMBER, OUTSTANDING.BALANCE) ;*R22 Manual Conversion
            Y.ONLINE.ACTUAL.BAL = ABS(OUTSTANDING.BALANCE)
        END

        GOSUB GET_CATEGORY_D
        GOSUB GET_JOINT_JOLDER_D
        GOSUB GET_INFO_CERTIFICADO

        Y.ARRANGEMENT.ID = R.ACC<AC.ARRANGEMENT.ID>
        Y.ALT.ACCT.ID  = R.ACC<AC.ALT.ACCT.ID>
* Latest Routine- Changes START
***------------------------------------------------------------------
        Y.ALT.ACCT.TYPE = ''
        Y.ALT.ACCT.TYPE = R.ACC<AC.ALT.ACCT.TYPE>
        Y.ALT.ACCT.TYPE = CHANGE(Y.ALT.ACCT.TYPE,@VM,@FM)
        Y.ALT.ACCT.TYPE = CHANGE(Y.ALT.ACCT.TYPE,@SM,@FM)
***------------------------------------------------------------------------------
* Latest Routine- END
        GOSUB GET_DISBURSEMENT_DATE

*        CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.REINVESTED",ACC.POS);* R22 UTILITY AUTO CONVERSION
        Y.L.AC.REINVESTED  = R.ACC<AC.LOCAL.REF,ACC.POS>

        IF Y.CUSTOMER EQ '' THEN
            GOSUB GET_HIST
        END

        GOSUB GET.CARD.STATUS
        GOSUB SET_FINAL
        GOSUB ADD_ALL_ACCT
    NEXT P
RETURN  ;* Latest Routine- Changes

GET_HIST:
    T.CONTINUE.FLAG  = "NO"
    Y.RECORD.STATUS  = ''
    HIS.REC    = ''
    YERROR     = ''
    FN.AC.HIS    = 'F.ACCOUNT$HIS' ; F.AC.HIS = ''

    CALL OPF(FN.AC.HIS,F.AC.HIS)
    CALL EB.READ.HISTORY.REC(F.AC.HIS,Y.CTA.ACTUAL,HIST.REC,YERROR)

    Y.RECORD.STATUS  = HIST.REC<AC.RECORD.STATUS>

    IF Y.RECORD.STATUS EQ "CLOSED" THEN
        T.CONTINUE.FLAG  = "SI"
    END

    Y.ACCOUNT.NUMBER  = Y.CTA.ACTUAL
    Y.CUSTOMER    = HIST.REC<AC.CUSTOMER>
    Y.DATE.LAST.CR.CUST = HIST.REC<AC.DATE.LAST.CR.CUST>
    Y.DATE.LAST.DR.CUST = HIST.REC<AC.DATE.LAST.DR.CUST>
    Y.AMNT.LAST.CR.CUST = HIST.REC<AC.AMNT.LAST.CR.CUST>
    Y.AMNT.LAST.DR.CUST = HIST.REC<AC.AMNT.LAST.DR.CUST>
    Y.RELATION.CODE  = HIST.REC<AC.RELATION.CODE>
    Y.CATEGORY   = HIST.REC<AC.CATEGORY>
    Y.JOINT.HOLDER  = HIST.REC<AC.JOINT.HOLDER>

    GOSUB GET_CATEGORY_D
    GOSUB GET_JOINT_JOLDER_D
    GOSUB GET_INFO_CERTIFICADO

    Y.ARRANGEMENT.ID = HIST.REC<AC.ARRANGEMENT.ID>
    Y.ALT.ACCT.ID  = HIST.REC<AC.ALT.ACCT.ID>

* Latest Routine- Changes START
***------------------------------------------------------------------
    Y.ALT.ACCT.TYPE = '';
    Y.ALT.ACCT.TYPE = HIST.REC<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.TYPE = CHANGE(Y.ALT.ACCT.TYPE,@VM,@FM)
    Y.ALT.ACCT.TYPE = CHANGE(Y.ALT.ACCT.TYPE,@SM,@FM)
***------------------------------------------------------------------------------
* Latest Routine- Changes END
    GOSUB GET_DISBURSEMENT_DATE

*    CALL L.APAP.RETURN.BANLACE.CANCELACION(Y.ARRANGEMENT.ID, Y.OUT.ARR)
    APAP.LAPAP.lApapReturnBanlaceCancelacion(Y.ARRANGEMENT.ID, Y.OUT.ARR) ;*R22 Manual Conversion
    Y.ONLINE.ACTUAL.BAL = Y.OUT.ARR<2>

*    CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.REINVESTED",ACC.POS);* R22 UTILITY AUTO CONVERSION
    Y.L.AC.REINVESTED  = HIST.REC<AC.LOCAL.REF,ACC.POS>

RETURN

GET_CATEGORY_D:
    Y.CATEGORY.DESC = ""
    CALL F.READ(FN.CAT,Y.CATEGORY,R.CAT, FV.CAT, CAT.ERR)
    Y.CATEGORY.DESC  = R.CAT<EB.CAT.DESCRIPTION>

    IF R.ACC<AC.ARRANGEMENT.ID> NE '' THEN
        CALL F.READ(FN.AA.ARR, R.ACC<AC.ARRANGEMENT.ID>, R.AA.ARR, FV.AA.ARR, AA.ARR.ERR)
        *CALL F.READ(FN.AA.PROD, R.AA.ARR<AA.ARR.PRODUCT>, R.AA.PROD, FV.AA.PROD, AA.PROD.ERR)
        CALL F.READ(FN.AA.PROD, R.AA.ARR<AA.Framework.Arrangement.ArrProduct>, R.AA.PROD, FV.AA.PROD, AA.PROD.ERR)
        Y.CATEGORY.DESC  = R.AA.PROD<AA.PDT.DESCRIPTION,2>
    END

RETURN

ADD_ALL_ACCT:
    IF Y.ALL.ACCOUNTS EQ "" THEN
        Y.ALL.ACCOUNTS = Y.CTA.ACTUAL
    END
    IF Y.ALL.ACCOUNTS NE "" THEN
        Y.ALL.ACCOUNTS = Y.ALL.ACCOUNTS : @VM : Y.CTA.ACTUAL
    END
RETURN

GET_JOINT_JOLDER_D:
    Y.JOINT.HOLDER.DESC = ""
    CALL F.READ(FN.CUS,Y.JOINT.HOLDER,R.CUS, FV.CUS, CUS.ERR)
    Y.JOINT.HOLDER.DESC = R.CUS<EB.CUS.NAME.1>
RETURN

GET_INFO_CERTIFICADO:
**----------------------------------------------------------------------------------------------------------------------
**Las categorias que identifican los certificados estan en los siguientes rangos: entre 6600 y 6618 y entre 6630 y 6699.
**----------------------------------------------------------------------------------------------------------------------
    Y.OFICINA.CERT = ""
    Y.APERTURA.CERT = ""

    IF (Y.CATEGORY GT 6599 AND Y.CATEGORY LT 6619) OR (Y.CATEGORY GT 6629 AND Y.CATEGORY LT 6700) THEN

        CALL F.READ(FN.AZ.ACC, Y.CTA.ACTUAL, R.AZ.ACC, FV.AZ.ACC, AZ.ACC.ERR)

        Y.OFICINA.CERT     = R.AZ.ACC<AZ.CO.CODE>
        Y.APERTURA.CERT    = R.AZ.ACC<AZ.VALUE.DATE>
        Y.AZ.RATE          = R.AZ.ACC<AZ.INTEREST.RATE>
        Y.ALT.ACCT.ID      = R.AZ.ACC<AZ.INTEREST.LIQU.ACCT>
        Y.EXPIRATION.DATE  = R.AZ.ACC<AZ.MATURITY.DATE>

*        CALL GET.LOC.REF("AZ.ACCOUNT", "L.TYPE.INT.PAY", L.TYPE.INT.PAY.POS)
EB.LocalReferences.GetLocRef("AZ.ACCOUNT", "L.TYPE.INT.PAY", L.TYPE.INT.PAY.POS);* R22 UTILITY AUTO CONVERSION
*        CALL GET.LOC.REF("AZ.ACCOUNT", "L.AZ.REIVSD.INT", L.AZ.REIVSD.INT.POS)
EB.LocalReferences.GetLocRef("AZ.ACCOUNT", "L.AZ.REIVSD.INT", L.AZ.REIVSD.INT.POS);* R22 UTILITY AUTO CONVERSION

        Y.ONLINE.ACTUAL.BAL  = Y.ONLINE.ACTUAL.BAL + R.AZ.ACC<AZ.LOCAL.REF, L.AZ.REIVSD.INT.POS>

*--GET ACCOUNT DATA
        FN.ACC.INT = "F.ACCOUNT"; FV.ACC.INT = ""; R.ACC.INT = ""; ERR.ACC.INT = ""
        CALL OPF(FN.ACC.INT, FV.ACC.INT)
        CALL F.READ(FN.ACC.INT, Y.ALT.ACCT.ID, R.ACC.INT, FV.ACC.INT, ERR.ACC.INT)

        IF R.AZ.ACC<AZ.LOCAL.REF, L.TYPE.INT.PAY.POS> EQ "Reinvested" THEN
            Y.AZ.INT.UNPAID = R.ACC.INT<AC.ACCR.CR.AMOUNT> + R.ACC<AC.ACCR.CR.AMOUNT>
        END ELSE
            Y.AZ.INT.UNPAID = R.ACC<AC.ACCR.CR.AMOUNT>
        END

    END

RETURN

GET.LOAN.STATUS:
*--------------*

    IF Y.ARRANGEMENT.ID THEN
        ArrangementID = Y.ARRANGEMENT.ID
        idPropertyClass = 'OVERDUE'; Y.LOAN.STATUS = ''
        idProperty = ''; returnIds = ''; returnConditions = ''; returnError = ''; effectiveDate = ''
*        CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 UTILITY AUTO CONVERSION
        R.AA.OVERDUE  = RAISE(returnConditions)

*        CALL GET.LOC.REF("AA.ARR.OVERDUE", "L.LOAN.STATUS.1", L.LOAN.STATUS.1.POS)
EB.LocalReferences.GetLocRef("AA.ARR.OVERDUE", "L.LOAN.STATUS.1", L.LOAN.STATUS.1.POS);* R22 UTILITY AUTO CONVERSION
*        CALL GET.LOC.REF("AA.ARR.OVERDUE", "L.LOAN.COND", L.LOAN.COND.POS)
EB.LocalReferences.GetLocRef("AA.ARR.OVERDUE", "L.LOAN.COND", L.LOAN.COND.POS);* R22 UTILITY AUTO CONVERSION

        Y.L.AC.STATUS1 = R.AA.OVERDUE<AA.OD.LOCAL.REF, L.LOAN.STATUS.1.POS>
        Y.LOAN.COND    = R.AA.OVERDUE<AA.OD.LOCAL.REF, L.LOAN.COND.POS>

*--MPD-920 - Oliver Fermin
        IF Y.L.AC.STATUS1 EQ "" THEN
            GOSUB GET.STATUS.MANUAL
        END

    END

RETURN


GET.STATUS.MANUAL:
*----------------

    ARR.ID = Y.ARRANGEMENT.ID
    APPL =  'AA.PRD.DES.OVERDUE' ; FIELDNAME =  'L.LOAN.STATUS.1'; FIELDNAME.2 =  'L.LOAN.COND'; LN.STS.POS = ''; LN.STS.POS.2 = ''
*    CALL GET.LOC.REF (APPL,FIELDNAME,LN.STS.POS)
EB.LocalReferences.GetLocRef (APPL,FIELDNAME,LN.STS.POS);* R22 UTILITY AUTO CONVERSION
*    CALL GET.LOC.REF (APPL,FIELDNAME.2,LN.STS.POS.2)
EB.LocalReferences.GetLocRef (APPL,FIELDNAME.2,LN.STS.POS.2);* R22 UTILITY AUTO CONVERSION

    READ R.AA.ARR.XREF FROM F.AA.ARRANGEMENT.DATED.XREF,ARR.ID ELSE NULL
    OD.POS = ''
    LOCATE 'APAP.OVERDUE' IN R.AA.ARR.XREF<1,1> SETTING OD.POS THEN
        AA.ARR.OD.ID = ARR.ID:'-APAP.OVERDUE-':R.AA.ARR.XREF<2,OD.POS,1>
        R.AA.ARR.OVERDUE = ''
        READ R.AA.ARR.OVERDUE FROM F.AA.ARR.OVERDUE,AA.ARR.OD.ID ELSE NULL
        Y.L.AC.STATUS1 = R.AA.ARR.OVERDUE<AA.OD.LOCAL.REF,LN.STS.POS>
        Y.LOAN.COND    = R.AA.ARR.OVERDUE<AA.OD.LOCAL.REF,LN.STS.POS.2>
    END

RETURN

SET_FINAL:
*--------
    IF T.CONTINUE.FLAG NE "SI" THEN
        GOSUB GET.LOAN.STATUS
        Y.FINAL<-1>   = Y.ACCOUNT.NUMBER : "*" : F.ID : "*" : Y.ONLINE.ACTUAL.BAL : "*" : Y.DATE.LAST.CR.CUST : "*" : Y.DATE.LAST.DR.CUST : "*" : Y.AMNT.LAST.CR.CUST : "*" : Y.AMNT.LAST.DR.CUST : "*" : Y.RELATION.CODE : "*" : Y.CATEGORY : "*" : Y.CATEGORY.DESC : "*" : Y.ARRANGEMENT.ID : "*" : Y.ALT.ACCT.ID : "*" : Y.L.AC.REINVESTED : "*" : Y.JOINT.HOLDER : "*" : Y.OFICINA.CERT : "*" : Y.APERTURA.CERT : "*" : Y.ACC.ALIAS : "*" : Y.OPENING.DATE : "*" : Y.LOCKED.AMOUNT : "*" : Y.AZ.RATE : "*" : Y.L.AC.STATUS1 : "*" : Y.L.AC.STATUS2 : "*" : Y.RELATION : "*" : Y.LOAN.COND : "*" : Y.ACC.NOTIFY : "*" : Y.POSTING.RESTRIC : "*" : Y.EXPIRATION.DATE : "*" : Y.AZ.INT.UNPAID : "*" :Y.DESCRIPCION.STATUS
    END

RETURN

*----------------------
GET_DISBURSEMENT_DATE:
*----------------------

    IF Y.ARRANGEMENT.ID THEN

        CALL F.READ(FN.AA.ARR,Y.ARRANGEMENT.ID,R.AA.ARR,FV.AA.ARR,AA.ARR.ERR)

        IF R.AA.ARR THEN
            *Y.PR.START.DATE = R.AA.ARR<AA.ARR.START.DATE>
             Y.PR.START.DATE = R.AA.ARR<AA.Framework.Arrangement.ArrStartDate>
            * Y.PR.START.DATE = R.AA.ARR<AA.ARR.START.DATE>
           * Y.PR.ORIG.CONTRACT.DATE = R.AA.ARR<AA.ARR.ORIG.CONTRACT.DATE>
             Y.PR.ORIG.CONTRACT.DATE = R.AA.ARR<AA.Framework.Arrangement.ArrOrigContractDate>
            Y.ACTIVITY.DATE = ""

            IF Y.PR.ORIG.CONTRACT.DATE THEN
                Y.OPENING.DATE = Y.PR.ORIG.CONTRACT.DATE
                RETURN
            END

            GOSUB GET_ACTIVITY_DATE

            IF Y.ACTIVITY.DATE THEN
                Y.OPENING.DATE = Y.ACTIVITY.DATE
                RETURN
            END

            IF Y.PR.START.DATE THEN
                Y.OPENING.DATE = Y.PR.START.DATE
                RETURN
            END

        END

    END

RETURN

*------------------
GET_ACTIVITY_DATE:
*------------------

    Y.ACTIVITY.DATE = ""
    SEL.CMD = "SELECT ":FN.AA.ARRANGEMENT.ACTIVITY : " WITH ARRANGEMENT EQ " : Y.ARRANGEMENT.ID : "AND ACTIVITY EQ 'LENDING-DISBURSE-COMMITMENT' BY EFFECTIVE.DATE"
    SEL.LIST = ""; NO.OF.REC = ""; SEL.ERR = ""

    CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)

    LOOP
        REMOVE Y.AA.ACTIVITY.ID FROM SEL.LIST SETTING ACTIVITY.POS

    WHILE Y.AA.ACTIVITY.ID DO
        *CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.AA.ACTIVITY.ID,R.AA.ARRANGEMENT.ACTIVITY, FV.AA.ARRANGEMENT.ACTIVITY, AA.ARRANGEMENT.ACTIVITY.ERR)
       * Y.ACTIVITY.DATE = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.EFFECTIVE.DATE>
R.AA.ARRANGEMENT.ACTIVITY=AA.Framework.ArrangementActivity.Read(Y.AA.ACTIVITY.ID, AA.ARRANGEMENT.ACTIVITY.ERR)
Y.ACTIVITY.DATE = R.AA.ARRANGEMENT.ACTIVITY<AA.Framework.ArrangementActivity.ArrActEffectiveDate>
        IF Y.ACTIVITY.DATE THEN
            RETURN
        END

    REPEAT

RETURN

GET.CARD.STATUS:
    Y.ALT.MULTI.AC.ID = Y.ALT.ACCT.ID
    Y.ALT.MULTI.AC.ID = CHANGE(Y.ALT.MULTI.AC.ID,@SM,@FM)
    Y.ALT.MULTI.AC.ID = CHANGE(Y.ALT.MULTI.AC.ID,@VM,@FM)
    Y.CNT = DCOUNT (Y.ALT.MULTI.AC.ID,@FM)
    Y.CONTADOR = 0
    FOR I = 1 TO Y.CNT
        IF Y.ALT.MULTI.AC.ID<I> EQ '' THEN
            CONTINUE
        END
        IF Y.ALT.ACCT.TYPE<I> NE 'T.DEBITO.1' AND Y.ALT.ACCT.TYPE<I> NE 'T.DEBITO.2'  THEN ;* Latest Routine- Changes
            CONTINUE;
        END
*** ESTATUS DE LA TARJETA------------------------------------------------------------------------------------
        SEL.CMD.IN = "SELECT ":FN.LATAM.CARD.ORDER : " WITH @ID LIKE ..." : Y.ALT.MULTI.AC.ID<I>
        SEL.LIST.IN = ""; NO.OF.REC.IN = ""; SEL.ERR.IN = ""
        CALL EB.READLIST(SEL.CMD.IN, SEL.LIST.IN,"", NO.OF.REC.IN, SEL.ERR)
        LOOP
            REMOVE Y.TARJETA.ID FROM SEL.LIST.IN SETTING TARJETA.POS

        WHILE Y.TARJETA.ID DO
            Y.CONTADOR +=1
            CALL F.READ (FN.LATAM.CARD.ORDER,Y.TARJETA.ID,R.LATAM.CARD.ORDER,FV.LATAM.CARD.ORDER,ERROR.LATAM.CARD.ORDER)
            CALL F.READ (FN.CARD.STATUS,R.LATAM.CARD.ORDER<CARD.IS.CARD.STATUS>,R.CARD.STATUS, FV.CARD.STATUS,ERROR.CARD.STATUS)
            Y.DESCRIPCION.STATUS.MULTI = R.CARD.STATUS<CARD.STS.CRD.STS.DES>
            IF Y.CONTADOR GT 1 THEN

                Y.DESCRIPCION.STATUS =  Y.DESCRIPCION.STATUS:"|": Y.DESCRIPCION.STATUS.MULTI<1,2>
            END  ELSE

                Y.DESCRIPCION.STATUS = Y.DESCRIPCION.STATUS.MULTI<1,2>
            END
***--------------------------------------------------------------------------------------

        REPEAT

    NEXT I
RETURN

END
