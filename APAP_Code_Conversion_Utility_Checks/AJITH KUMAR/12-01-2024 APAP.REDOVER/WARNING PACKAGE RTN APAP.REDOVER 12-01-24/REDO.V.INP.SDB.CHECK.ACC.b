* @ValidationCode : MjoxMDk1ODM3MTA0OkNwMTI1MjoxNzA0MzY4NTc2MzgyOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jan 2024 17:12:56
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
* <Rating>-42</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.SDB.CHECK.ACC
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :TPS
*Program Name :REDO.V.INP.SDB.CHECK.ACC
*---------------------------------------------------------------------------------

*DESCRIPTION :Input routine generates override when SDB (Safe Deposit Box)involves Account which
* is not active
*LINKED WITH :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
* DATE 		WHO 		   REFERENCE 			         DESCRIPTION
* 27-FEB-13 TPS PACS000249340    Override with account number for inactive status.
*24/05/2023     VIGNESHWARI      MANUAL R22 CODE CONVERSION          ASSIGN TO ASSINED
*24/05/2023     CONVERSION TOOL  AUTO R22 CODE CONVERSION            VM TO @VM, FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.MB.SDB.POST
    $INSERT I_F.ACCOUNT
    $USING EB.LocalReferences


    GOSUB INIT
    GOSUB PROCESS
    GOSUB ASSINED
RETURN
*----
INIT:
*----
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    LREF.APP='ACCOUNT'
    LREF.FIELD='L.AC.STATUS1'
RETURN
*-------
PROCESS:
*-------
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*CALL GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    EB.LocalReferences.GetLocRef(LREF.APP,LREF.FIELD,LREF.POS);* R22 AUTO CONVERSION
RETURN
*------
ASSINED:
*------

    Y.CR.DEB.ID=R.NEW(SDB.POST.CUSTOMER.ACCT)
    GOSUB OVERRIDE.GEN
RETURN
*-----------
OVERRIDE.GEN:
*-----------
    CALL F.READ(FN.ACCOUNT,Y.CR.DEB.ID,R.ACCOUNT,F.ACCOUNT,DEB.ERR)
    Y.STATUS=R.ACCOUNT<AC.LOCAL.REF,LREF.POS>
    VIRTUAL.TAB.ID='L.AC.STATUS1'
    IF Y.STATUS NE 'ACTIVE' AND Y.STATUS NE '' AND R.ACCOUNT<AC.CUSTOMER> NE '' THEN
        CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
        Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
        Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
        CHANGE '_' TO @FM IN Y.LOOKUP.LIST
        CHANGE '_' TO @FM IN Y.LOOKUP.DESC
        LOCATE Y.STATUS IN Y.LOOKUP.LIST SETTING POS1 THEN
            IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN ;* This is for english user
                Y.MESSAGE=Y.LOOKUP.DESC<POS1,1>
            END
            IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
                Y.MESSAGE=Y.LOOKUP.DESC<POS1,2> ;* This is for spanish user
            END ELSE
                Y.MESSAGE=Y.LOOKUP.DESC<POS1,1>
            END
        END
        TEXT="REDO.AC.CHECK.ACTIVE":@FM:Y.CR.DEB.ID:@VM:Y.MESSAGE
        OVERRIDE.FIELD.VALUE = R.NEW(SDB.POST.OVERRIDE)
        CURR.NO = DCOUNT(OVERRIDE.FIELD.VALUE,@VM) + 1
        CALL STORE.OVERRIDE(CURR.NO)
    END

RETURN
END
