* @ValidationCode : Mjo3MTYzNTY5NTY6Q3AxMjUyOjE2ODA2MTA2NTc1MTE6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 17:47:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUT.UPDATES.STATUS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is attached with VERSION.CONTROL of AZ.ACCOUNT and ACCOUNT as
*authorization routine.This routine is used to update CUSTOMER.STATUS in CUATOMER
*application and STATUS field in REDO.CUST.PRD.LIST
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 27-DEC-2009        Prabhu.N       ODR-2009-10-0535     Initial Creation
* 28-MAR-2011      SUDHARSANAN S     PACS00033264       Change the l.ac.status1 value based on EB.LOOKUP ID
*------------------------------------------------------------------------------------------
*Modification History
*   Date                   who                           Reference               Description
*04-04-2023           Conversion Tool          R22 Auto Code conversion      FM TO @FM,VM TO @VM
*04-04-2023            Samaran T                Manual R22 Code Conversion    No Changes
*----------------------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.OVERDUES
    $INSERT I_F.REDO.CUST.PRD.LIST

    GOSUB INIT
    GOSUB PROCESS
RETURN

*----
INIT:
*----
    LREF.APP='ACCOUNT'
    LREF.FIELDS='L.AC.STATUS1': @VM : 'L.AC.STATUS2'
    LREF.POS=''

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
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> NE '1' AND Y.AC.STATUS1 EQ 'ACTIVE' THEN
        R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> = '1'
        GOSUB OFS.GEN
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
    IF Y.AC.STATUS2 EQ "DECEASED" THEN
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
*************

    CALL F.READ(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST,F.CUST.PRD.LIST,CUS.ERR)

RETURN

END
