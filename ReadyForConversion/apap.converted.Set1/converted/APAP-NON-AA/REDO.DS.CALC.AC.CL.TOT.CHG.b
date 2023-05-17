SUBROUTINE REDO.DS.CALC.AC.CL.TOT.CHG(RES)
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
    $INSERT I_F.ACCOUNT.CLOSURE

    GOSUB INIT
RETURN
*-----*
INIT:
*-----*
    RES=R.NEW(AC.ACL.TOTAL.CHARGES) + R.NEW(AC.ACL.CLO.CHARGE.AMT)
    Y.TEMP.AMOUNT    =RES
    Y.LEN.CUR        ='2'
    Y.LEN.CUR        ="L%":Y.LEN.CUR
    Y.TEMP.AMOUNT.FIR=FIELD(Y.TEMP.AMOUNT,'.',1)
    Y.TEMP.AMOUNT.DEC=FIELD(Y.TEMP.AMOUNT,'.',2)
    Y.TEMP.AMOUNT.DEC=FMT(Y.TEMP.AMOUNT.DEC,Y.LEN.CUR)
    RES              =Y.TEMP.AMOUNT.FIR:'.':Y.TEMP.AMOUNT.DEC
RETURN
END
