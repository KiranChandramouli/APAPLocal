* @ValidationCode : MjotMTc2NzI5NDg0OTpDcDEyNTI6MTcwMzgyMzQ2MjAwOTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 29 Dec 2023 09:47:42
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
$PACKAGE APAP.REDOVER
*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.AUT.TILL.CHECK.ACC
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :PRABHU.N
*Program Name :REDO.V.AUT.TILL.CHECK.ACC
*---------------------------------------------------------------------------------

*DESCRIPTION :Routine changes L.AC.STATUS1 to ACTIVE when teller transaction
* involves account which is not active and transaction is authorized
*LINKED WITH :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*02/17/2009 -
*Development for setting local field L.AC.STATUS1 to ACTIVE
*-----------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*10-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*10-04-2023       Samaran T               R22 Manual Code Conversion       ASSIGN IS CORE COMMON VARIBLE SO CHANGED SPELLING
*29-12-2023       AJITH KUMAR            R22 MANUAL CODE CONVERSION
*--------------------------------------------------------------------------------------------
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CUST.PRD.LIST
    $USING EB.LocalReferences
    GOSUB INIT
    GOSUB PROCESS
    GOSUB ASSIGNE   ;*R22 MANUAL CODE CONVERSION
RETURN
*----
INIT:
*----
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    LREF.APP='ACCOUNT'
    LREF.FIELD='L.AC.STATUS1'
    FN.CUST.PRD.LIST='F.REDO.CUST.PRD.LIST'
    F.CUST.PRD.LIST=''
RETURN
*-------
PROCESS:
*-------
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
* CALL GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    EB.LocalReferences.GetLocRef(LREF.APP,LREF.FIELD,LREF.POS)

RETURN
*------
ASSIGNE:    ;*R22 MANUAL CODE CONVERSION
*------
    Y.CR.DEB.ID=R.NEW(TT.TE.ACCOUNT.1)
    GOSUB ACTIVATE
    Y.CR.DEB.ID=R.NEW(TT.TE.ACCOUNT.2)
    GOSUB ACTIVATE
RETURN
*--------
ACTIVATE:
*--------
* CALL F.READ(FN.ACCOUNT,Y.CR.DEB.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    CALL F.READU(FN.ACCOUNT,Y.CR.DEB.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR,'');*R22 MANUAL CODE CONVERSION
    IF R.ACCOUNT <AC.LOCAL.REF,LREF.POS> NE 'ACTIVE' AND R.ACCOUNT <AC.CUSTOMER> NE '' THEN
        R.ACCOUNT <AC.LOCAL.REF,LREF.POS> = 'ACTIVE'
        Y.CUSTOMER.ID=R.ACCOUNT<AC.CUSTOMER>
        CALL F.WRITE(FN.ACCOUNT,Y.CR.DEB.ID,R.ACCOUNT)
        CUST.JOIN='CUSTOMER'
        GOSUB UPD.PRD.LIST
        GOSUB PRD.UPD.JOIN
    END
RETURN
UPD.PRD.LIST:
* CALL F.READ(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST,F.CUST.PRD.LIST,CUS.ERR)
    CALL F.READU(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST,F.CUST.PRD.LIST,CUS.ERR,'');*R22 MANUAL CODE CONVERSION
    Y.PRD.LIST=R.CUST.PRD.LIST<PRD.PRODUCT.ID>
    CONVERT @VM TO @FM IN Y.PRD.LIST ;*R22 MANUAL CODE CONVERSION
    LOCATE Y.CR.DEB.ID IN Y.PRD.LIST SETTING PRD.POS ELSE
    END
    R.CUST.PRD.LIST<PRD.PRD.STATUS,PRD.POS> ='ACTIVE'
    R.CUST.PRD.LIST<PRD.TYPE.OF.CUST,PRD.POS>=CUST.JOIN
    R.CUST.PRD.LIST<PRD.DATE,PRD.POS>=TODAY
    R.CUST.PRD.LIST<PRD.PROCESS.DATE> = TODAY
    CALL F.WRITE(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST)
RETURN
PRD.UPD.JOIN:
    IF R.ACCOUNT<AC.JOINT.HOLDER> NE '' THEN
        Y.CUSTOMER.ID=R.ACCOUNT<AC.JOINT.HOLDER>
        CUST.JOIN='JOINT.HOLDER'
        GOSUB UPD.PRD.LIST
    END
RETURN
RETURN
END
