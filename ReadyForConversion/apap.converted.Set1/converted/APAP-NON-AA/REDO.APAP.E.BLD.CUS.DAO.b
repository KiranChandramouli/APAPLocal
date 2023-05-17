SUBROUTINE REDO.APAP.E.BLD.CUS.DAO(Y.ENQ.DTLS)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep M
* Program Name  : REDO.APAP.E.BLD.CUS.DAO
*-------------------------------------------------------------------------
* Description: This is the Biuld routime for the application CUSTOMER
*-------------------------------------------------------------------------
* Linked with   : ENQUIRY>REDO.CUST.DAO
* In parameter  : Y.ENQ.DTLS
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
*   DATE              ODR / HD REF                  DESCRIPTION
* 16-10-11            ODR-2011-08-0055
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.USER
    $INSERT I_ENQUIRY.COMMON

    GOSUB OPEN.FILES

    GOSUB PROCESS

RETURN

OPEN.FILES:
*----------


    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''

    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.USER='F.USER'
    F.USER=''

    CALL OPF(FN.USER,F.USER)

RETURN

PROCESS:
*-------

    CALL CACHE.READ(FN.USER, OPERATOR, R.USER, ERR.USER)
    Y.DPT.OFFCR=R.USER<EB.USE.DEPARTMENT.CODE>

    SEL.LIST=''
    NO.OF.REC=''
    ERR.SLIST=''

    SEL.CMD="SELECT ":FN.CUSTOMER: " WITH ACCOUNT.OFFICER EQ ":Y.DPT.OFFCR
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.SLIST)

    CHANGE @FM TO @SM IN SEL.LIST

    Y.ENQ.DTLS<2> = '@ID'
    Y.ENQ.DTLS<3> = 'EQ'
    Y.ENQ.DTLS<4> = SEL.LIST

RETURN

END
