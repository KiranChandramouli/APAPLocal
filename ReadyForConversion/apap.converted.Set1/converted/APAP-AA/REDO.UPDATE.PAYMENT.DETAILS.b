SUBROUTINE REDO.UPDATE.PAYMENT.DETAILS
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Temenos Application Management
*Program   Name    :REDO.UPDATE.PAYMENT.DETAILS
*Reference         :ODR-2010-03-0138
*Date              :31 AUG 2010
*---------------------------------------------------------------------------------
*
*DESCRIPTION       :This program is used to update the local CONCAT file
*                   REDO.AA.PAYMENT.DETAILS with the arrangement ID which is to be processed in online report
*
*LINKED WITH       :Attached to ACTIVITY.API, for the activity LENDING-SETTLE-PAYMNET.RULES,LENDING-APPLYPAYMNET-PAYMNET.RULES and LENDING-CREDIT-ARRANGEMENT
*                   triggered during PAYMENT update Action
*
*--------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.AA.PAYMENT.DETAILS

    VAR.STATUS = c_aalocActivityStatus
    IF VAR.STATUS EQ 'AUTH' THEN
        GOSUB OPEN.FILES
        GOSUB WRITE.VALUE
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
OPEN.FILES:
*----------

    FN.REDO.AA.PAYMENT.DETAILS = 'F.REDO.AA.PAYMENT.DETAILS'
    F.REDO.AA.PAYMENT.DETAILS = ''
    CALL OPF(FN.REDO.AA.PAYMENT.DETAILS,F.REDO.AA.PAYMENT.DETAILS)
    R.REDO.AA.PAYMENT.DETAILS = ''

RETURN
*-------------------------------------------------------------------------------------------------------------------
* Update the Arrangement ID in the CONCAT file REDO.AA.PAYMENT.DETAILS
*
WRITE.VALUE:
*-----------

    CONCAT.ID = c_aalocArrActivityId
    R.REDO.AA.PAYMENT.DETAILS<REDO.PAYMENT.DET.ARR.ID> = c_aalocArrId
    R.REDO.AA.PAYMENT.DETAILS<REDO.PAYMENT.DET.EFFECTIVE.DATE> = c_aalocActivityEffDate
    R.REDO.AA.PAYMENT.DETAILS<REDO.PAYMENT.DET.ACTIVITY.CLASS> = c_aalocArrActivityRec<AA.ARR.ACT.ACTIVITY.CLASS>
    CALL F.WRITE(FN.REDO.AA.PAYMENT.DETAILS,CONCAT.ID,R.REDO.AA.PAYMENT.DETAILS)  ;* For Payment Update the CONCAT file with the Arrangement ID

RETURN
*-----------------------------------------------------------------------------------------------------------------------------
END
