* @ValidationCode : MjotNjU4MDY2NzQ3OkNwMTI1MjoxNjgxMjc2NTU1OTQ1OklUU1M6LTE6LTE6Mjg0OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 284
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.ACC.REASON.UPDATE
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine is attached as Auth Routine in Deposit Closure Version.
* It is used to update the cancel reason from deposit account
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH R
* PROGRAM NAME : REDO.ACC.REASON.UPDATE
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO               REFERENCE         DESCRIPTION
* 26-JUN-12        GANESH R          PACS00203772      Initial
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 VM TO @VM , FM TO @FM
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
*-------------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.REF.APP = 'ACCOUNT':@FM:'AZ.ACCOUNT'
    LOC.REF.FIELD = 'L.AC.CAN.REASON':@VM:'L.AC.OTH.REASON':@FM:'L.AC.CAN.REASON':@VM:'L.AC.OTH.REASON'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)
    POS.AC.CAN.REASON.CLOSE = LOC.REF.POS<1,1>
    POS.AC.OTH.REASON.CLOSE = LOC.REF.POS<1,2>
    POS.AC.CAN.REASON.AZ    = LOC.REF.POS<2,1>
    POS.AC.OTH.REASON.AZ    = LOC.REF.POS<2,2>
RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
* This is the main para used to check the category and update the charge related fields
    VAR.ACC.ID = ID.NEW
    CALL F.READ(FN.ACCOUNT,VAR.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    R.ACCOUNT<AC.LOCAL.REF,POS.AC.CAN.REASON.CLOSE> = R.NEW(AZ.LOCAL.REF)<1,POS.AC.CAN.REASON.AZ>
    R.ACCOUNT<AC.LOCAL.REF,POS.AC.OTH.REASON.CLOSE> = R.NEW(AZ.LOCAL.REF)<1,POS.AC.OTH.REASON.AZ>
    CALL F.WRITE(FN.ACCOUNT,VAR.ACC.ID,R.ACCOUNT)

RETURN
*---------------------------------------------------------------------------------------------------------------
END
