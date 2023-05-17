SUBROUTINE REDO.APAP.GET.ACCT.OFF
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.GET.ACCT.OFF
*---------------------------------------------------------------------------------------------------------
*Description   : REDO.APAP.GET.ACCT.OFF  is a conversion routine attached to the ENQUIRY>
*                REDO.APAP.INVST.RATE , the routine fetches the value of account officer
*                from O.DATA
*Linked With   :
*In Parameter  : N/A
*Out Parameter : N/A
*----------------------------------------------------------------------------------------------------------
*Modification Details:
*---------------------
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 20 OCT 2010              Dhamu S             ODR-2010-03-0098            Initial Creation
*
***********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
*-------------------------------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    ACCT.ID = O.DATA
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    O.DATA = R.ACCOUNT<AC.ACCOUNT.OFFICER>
RETURN
END
*-----------------------------------------------------------------------------------------------------------
