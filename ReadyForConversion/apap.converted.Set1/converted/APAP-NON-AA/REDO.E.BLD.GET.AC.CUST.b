SUBROUTINE REDO.E.BLD.GET.AC.CUST(ENQ.DATA)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Prabhu N
* Program Name  : REDO.E.BLD.AC.CUST
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to all enquiries
* which have customer no as selection field to restrict unauthorised access
*----------------------------------------------------------
* Linked with: All enquiries with Customer no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 08-04-2011         PACS000332630000522        Created as build routine for the enquiry
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*---------
OPENFILES:
*---------
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
PROCESS:

    LOCATE '@ID' IN ENQ.DATA<2,1> SETTING POS1 THEN
        LOCATE 'MB.CUSTOMER.ID' IN ENQ.DATA<2,1> SETTING POS2 ELSE
            Y.ACCT=ENQ.DATA<4,POS1>
            CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACCOUNT,F.ACCOUNT,ERR)
            Y.CUST=R.ACCOUNT<AC.CUSTOMER>
            ENQ.DATA<2,-1>='MB.CUSTOMER.ID'
            ENQ.DATA<3,-1>='EQ'
            ENQ.DATA<4,-1>=Y.CUST
        END
    END
RETURN
END
