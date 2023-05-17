SUBROUTINE REDO.S.FETCH.CARD.NO.TD(RES)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.FETCH.CUST.IDEN
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to check the customer record Field and get
*                   identification field and display in the deal slip
*[IDENTITY ID  >> "EEEE" = LEGAL.ID or L.CU.CIDENT or L.CU.NOUNICO or L.CU.ACTANAC
*    Just one of these values will be populated on CUSTOMER (so pick up the one being populated from above))
*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE
    GOSUB INIT
RETURN
*-----*
INIT:
*-----*
    Y.CARD.ID=RES
    RES  =FIELD(Y.CARD.ID,'.',2)
    Y.LEN=LEN(RES)
    Y.LEN -= 12
    RES=RES[1,6]:'XXXXXX':RES[13,Y.LEN]
RETURN
END
