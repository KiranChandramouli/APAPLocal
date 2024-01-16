* @ValidationCode : MjoxMzIxMDgzOTA4OkNwMTI1MjoxNjg2Njc0MjUwMjE4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:07:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>351</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ENQ.PORTAL.AHO.TODAS(Y.FINAL)

*--------------------------------------------------------------------------------------------------
* Description           : This routine returns a consolidated saving customer product of a customer
* Developed On          : 02/10/2020
* Developed By          : Estalin Valerio
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* --------               Estalin Valerio                    02/10/2020            Creation

* 08-JUNE-2023     Santosh               R22 Manual Conversion - Changed VM,FM to @VM,@FM and Corrcted NEXT statement
*--------------------------------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_ENQUIRY.COMMON
    $INSERT  I_F.CUSTOMER
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.RELATION
    $INSERT  I_F.CATEGORY
    $INSERT  I_F.REDO.CUST.PRD.LIST
   $USING EB.LocalReferences

**----------------------------------------
**ABRIR LA TABLA FBNK.REDO.CUST.PRD.LIST
**----------------------------------------
    FN.CUS.PRD = "F.REDO.CUST.PRD.LIST"
    FV.CUS.PRD = ""
    R.CUS.PRD = ""
    CUS.PRD.ERR = ""


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
**TABLA FBNK.JOINT.CONTRACTS.XREF
**---------------------------------------
    FN.JOINT.CONTRACTS.XREF='F.JOINT.CONTRACTS.XREF';
    FV.JOINT.CONTRACTS.XREF=''
    R.JOINT.CONTRACTS.XREF = ""
    JOINT.CONTRACTS.XREF.ERR = ""
    CALL OPF(FN.JOINT.CONTRACTS.XREF,FV.JOINT.CONTRACTS.XREF)

**-------------------------------------------------------------

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
    NEXT A ;*R22 Manual Conversion

**---------------------------------------------------------------

**---------------------------------------------------------------------------------------

    Y.CAN.CUS.PRD = DCOUNT(Y.CUS.PRD,@VM)

    FOR P = 1 TO Y.CAN.CUS.PRD STEP 1

        T.CONTINUE.FLAG  = "NO"
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
        Y.ALT.ACCT.ID       = R.ACC<AC.ALT.ACCT.ID>

*        CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",PS)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.AV.BAL",PS);* R22 UTILITY AUTO CONVERSION
        Y.AV.BAL = R.ACC<AC.LOCAL.REF,PS>

*        CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.REINVESTED",ACC.POS);* R22 UTILITY AUTO CONVERSION
        Y.L.AC.REINVESTED  = R.ACC<AC.LOCAL.REF,ACC.POS>


        IF F.ID NE Y.CUSTOMER AND F.ID NE Y.JOINT.PRIMERO AND F.ID NE Y.JOINT.SEGUNDO   THEN
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


        IF Y.CUSTOMER EQ '' THEN
            GOSUB GET_HIST
        END

        GOSUB SET_FINAL
        GOSUB ADD_ALL_ACCT
    NEXT P

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


RETURN

ADD_ALL_ACCT:
    IF Y.ALL.ACCOUNTS EQ "" THEN
        Y.ALL.ACCOUNTS = Y.CTA.ACTUAL
    END
    IF Y.ALL.ACCOUNTS NE "" THEN
        Y.ALL.ACCOUNTS = Y.ALL.ACCOUNTS : @VM : Y.CTA.ACTUAL
    END
RETURN

SET_FINAL:
*--------
    IF (Y.CATEGORY GE 6000 AND Y.CATEGORY LE 6599 AND Y.L.AC.REINVESTED EQ "") THEN
        IF T.CONTINUE.FLAG NE "SI" THEN
            Y.FINAL<-1>   = Y.ACCOUNT.NUMBER : "*" : Y.AV.BAL : "*" : Y.OPENING.DATE : "*" :  Y.L.AC.STATUS1 : "*" : Y.L.AC.STATUS2 : "*" : Y.ALT.ACCT.ID : "*":Y.ACC.NOTIFY
        END
    END
RETURN

END
