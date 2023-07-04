$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.REINV.CUSTOMER.NO
*-----------------------------------------------------------------------------

*Description: This routine is hot validation routine for CUSTOMER field in order
* to default the category in ACCOUNT.OFFICER ACCOUNT.NAME SHORT.NAME

*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 24-02-2011      H GANESH      PACS00033293       Initial Draft
** 18-04-2023 R22 Auto Conversion no changes
** 18-04-2023 Skanda R22 Manual Conversion - No changes
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.H.AZ.REINV.DEPOSIT


    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    CALL F.READ(FN.CUSTOMER,COMI,R.CUS,F.CUSTOMER,CUS.ERR)
    R.NEW(REDO.AZ.REINV.ACCOUNT.OFFICER)=R.CUS<EB.CUS.ACCOUNT.OFFICER>
    R.NEW(REDO.AZ.REINV.ACCOUNT.NAME) = R.CUS<EB.CUS.NAME.1>
    R.NEW(REDO.AZ.REINV.SHORT.NAME) = R.CUS<EB.CUS.SHORT.NAME>

RETURN
END
