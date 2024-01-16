* @ValidationCode : MjotODg4NjU4MTQwOkNwMTI1MjoxNjgyMzMxNTY0OTgzOklUU1M6LTE6LTE6ODM1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 835
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* @(#) REDO.AUT.UPDATES.STATUS.CS Ported to jBASE 16:17:01  28 NOV 2017
*-----------------------------------------------------------------------------
SUBROUTINE REDO.AUT.UPDATES.STATUS.CS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is attached with VERSION.CONTROL of AZ.ACCOUNT and ACCOUNT as
*authorization routine.This routine is used to update CUSTOMER.STATUS in CUSTOMER
*application and STATUS field in REDO.CUST.PRD.LIST
* Revision History:
*------------------
*   Date               who           Reference            Description
*   2019-07-11         ClientesCapt  MDP-443              Fix clientes que se resucitan.
*  21.04.2023       Conversion Tool    R22                Auto Conversion     - FM TO @FM, VM TO @VM, SM TO @SM, $INCLUDE T24.BP TO $INSERT
*  21.04.2023       Shanmugapriya M    R22                Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------
    $INSERT I_EQUATE                      ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_COMMON                      ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_F.CUSTOMER                  ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_F.ACCOUNT                   ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_F.AZ.ACCOUNT                ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_F.AZ.OVERDUES               ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_F.REDO.CUST.PRD.LIST        ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT

    GOSUB INIT
    GOSUB PROCESS
RETURN

*----
INIT:
*----
    LREF.APP='ACCOUNT'
    LREF.FIELDS='L.AC.STATUS1': @VM : 'L.AC.STATUS2'
    LREF.POS=''; YDECEAS.FLG = 0

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.CUST.PRD.LIST='F.REDO.CUST.PRD.LIST'
    F.CUST.PRD.LIST=''
    CALL OPF(FN.CUST.PRD.LIST,F.CUST.PRD.LIST)

    FN.AZ.OVERDUES='F.AZ.OVERDUES'
    F.AZ.OVERDUES=''
    CALL OPF(FN.AZ.OVERDUES,F.AZ.OVERDUES)

    CUST.JOIN='CUSTOMER'
RETURN

*-------
PROCESS:
*-------
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    IF APPLICATION EQ 'ACCOUNT' THEN
        Y.CUSTOMER.ID=R.NEW(AC.CUSTOMER)
        Y.AC.STATUS1=R.NEW(AC.LOCAL.REF)<1,LREF.POS<1,1>>
        Y.AC.STATUS2=R.NEW(AC.LOCAL.REF)<1,LREF.POS<1,2>>
        CALL F.READ(FN.AZ.ACCOUNT,ID.NEW,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
        IF R.AZ.ACCOUNT NE '' THEN
            Y.AC.STATUS1='ACTIVE'
        END
        GOSUB UPDATE
        GOSUB LOC.PRD.LIST
        GOSUB UPD.PRD.LIST
        GOSUB PRD.UPD.JOIN
    END
    ELSE
        IF APPLICATION EQ 'AZ.ACCOUNT' THEN
            Y.CUSTOMER.ID=R.NEW(AZ.CUSTOMER)
            GOSUB LOC.PRD.LIST
            R.CUST.PRD.LIST<PRD.PRD.STATUS,PRD.POS> ='ACTIVE'
            CALL F.READ(FN.AZ.OVERDUES,ID.NEW,R.AZ.OVERDUES,F.AZ.OVERDUES,AZ.ERR)
            IF R.AZ.OVERDUES<AZ.OVE.TOTAL.OD.AMT> NE '' THEN
                Y.AC.STATUS='OVERDUE'
            END
            GOSUB UPD.PRD.LIST
        END
    END
RETURN

*------
UPDATE:
*------
    CHANGE @SM TO @FM IN Y.AC.STATUS2
    LOCATE 'DECEASED' IN Y.AC.STATUS2 SETTING ACT.ST.POS THEN
        YDECEAS.FLG = 1
    END

    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
*2019-08-07; Se agrega esta condicion extra porque se estan reviviendo clientes muertos al cancelar un AA.
*La intencion es que si un customer esta fallecido (3) se quede asi...
    Y.ESTATUS.CLIENTE = R.CUSTOMER<EB.CUS.CUSTOMER.STATUS>
    IF Y.ESTATUS.CLIENTE EQ 3 THEN
        YDECEAS.FLG = 1
    END
    IF R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> NE '1' AND Y.AC.STATUS1 EQ 'ACTIVE' THEN
        IF YDECEAS.FLG NE 1 THEN
            R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> = '1'
            GOSUB OFS.GEN
        END
    END
RETURN

*------------
LOC.PRD.LIST:
*------------
    GOSUB READ.CUSTOMER
RETURN

*-----------
UPD.PRD.STATUS:
*-----------
    IF Y.AC.STATUS1 EQ 'ACTIVE' THEN
        R.CUST.PRD.LIST<PRD.PRD.STATUS,PRD.POS> ='ACTIVE'
    END
    IF Y.AC.STATUS1 EQ "6MINACTIVE" OR Y.AC.STATUS1 EQ "3YINACTIVE" OR Y.AC.STATUS1 EQ "ABANDONED" OR Y.AC.STATUS1 EQ "OVERDUE" OR Y.AC.STATUS2 EQ "GUARANTEE.STATUS" THEN
        R.CUST.PRD.LIST<PRD.PRD.STATUS,PRD.POS> ='INACTIVE'
    END
    IF YDECEAS.FLG EQ 1 THEN
        R.CUST.PRD.LIST<PRD.PRD.STATUS,PRD.POS> ='DECEASED'
    END
RETURN

*------------
UPD.PRD.LIST:
*------------
    Y.PRD.LIST=R.CUST.PRD.LIST<PRD.PRODUCT.ID>
    CHANGE @VM TO @FM IN Y.PRD.LIST
    LOCATE ID.NEW IN Y.PRD.LIST SETTING PRD.POS ELSE
        GOSUB UPD.PRD.STATUS
        R.CUST.PRD.LIST<PRD.TYPE.OF.CUST,PRD.POS>=CUST.JOIN
        R.CUST.PRD.LIST<PRD.PRODUCT.ID,PRD.POS> = ID.NEW
        R.CUST.PRD.LIST<PRD.DATE,PRD.POS>=TODAY
        R.CUST.PRD.LIST<PRD.PROCESS.DATE> = TODAY
        CALL F.WRITE(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST)
    END
RETURN

*------------
PRD.UPD.JOIN:
*------------
    IF R.NEW(AC.JOINT.HOLDER) NE '' THEN
        Y.CUSTOMER.ID=R.NEW(AC.JOINT.HOLDER)
        CUST.JOIN='JOINT.HOLDER'
        GOSUB READ.CUSTOMER
        GOSUB UPD.PRD.LIST
    END
RETURN

*--------
OFS.GEN:
*--------
    OFS.SOURCE.ID = 'REDO.OFS.CUS.UPDATE'
    APPLICATION.NAME = 'CUSTOMER'
    TRANS.FUNC.VAL = 'I'
    TRANS.OPER.VAL = 'PROCESS'
    APPLICATION.NAME.VERSION = 'CUSTOMER,REDO.CUS.STATUS'
    NO.AUT = ''
    OFS.MSG.ID = ''
    APPLICATION.ID =Y.CUSTOMER.ID
    OFS.POST.MSG = ''

    CALL OFS.BUILD.RECORD(APPLICATION.NAME,TRANS.FUNC.VAL,TRANS.OPER.VAL,APPLICATION.NAME.VERSION,"",NO.AUT,APPLICATION.ID,R.CUSTOMER,OFS.REQ.MSG)
    CALL OFS.POST.MESSAGE(OFS.REQ.MSG,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
RETURN

**************
READ.CUSTOMER:
**************
*    CALL F.READ(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST,F.CUST.PRD.LIST,CUS.ERR)
    CALL F.READU(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST,F.CUST.PRD.LIST,CUS.ERR,'');* R22 UTILITY AUTO CONVERSION
RETURN

END
