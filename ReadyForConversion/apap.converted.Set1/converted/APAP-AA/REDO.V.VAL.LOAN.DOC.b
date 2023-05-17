SUBROUTINE REDO.V.VAL.LOAN.DOC
*-----------------------------------------------------------------------------------------------------------------
*Company Name:ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program Name:REDO.V.VAL.LOAN.DOC
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*Description:
*         This validation routine should generate an override
*a. when the field mandatory docs is "yes"  and the field document received is "blank" then it should throw an override " Mandatory document not received"
*b. when the field mandatory docs is "no"  and the field document received is "blank" then it should throw an override " Optional document is not yet received for product"

*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 2-06-2010      PREETHI MD   ODR-2009-10-0326 N.3  INITIAL CREATION
*
*----------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_AA.LOCAL.COMMON

    GOSUB INIT
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------------------
INIT:
*--------------------------------------------------------------------------------------
    LOCAL.APPLICATION="AA.PRD.DES.ACCOUNT"
    LOCAL.FIELDS="L.AA.LOAN.DOC":@VM:"L.AA.MAND.DOCS":@VM:"L.AA.DOC.RECVD":@VM:"L.AA.REMARKS"
    LOCAL.POS=''

RETURN
*-------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------

    CALL MULTI.GET.LOC.REF(LOCAL.APPLICATION,LOCAL.FIELDS,LOCAL.POS)

    Y.LNDOC.POS=LOCAL.POS<1,1>
    Y.MAND.POS=LOCAL.POS<1,2>
    Y.RECVD.POS=LOCAL.POS<1,3>
    Y.REM.POS=LOCAL.POS<1,4>

    Y.LOANDOC=R.NEW(AA.AC.LOCAL.REF)<1,Y.LNDOC.POS>
    Y.LNDOC.COUNT=DCOUNT(Y.LOANDOC,@SM)
    IF V$FUNCTION EQ 'I' THEN
        FOR Y.INITIAL=1 TO Y.LNDOC.COUNT

            Y.MAND.DOCS=R.NEW(AA.AC.LOCAL.REF)<1,Y.MAND.POS,Y.INITIAL>
            Y.DOC.RECVD=R.NEW(AA.AC.LOCAL.REF)<1,Y.RECVD.POS,Y.INITIAL>


            BEGIN CASE

                CASE Y.MAND.DOCS EQ "YES"
                    IF Y.DOC.RECVD EQ "" THEN
                        TEXT = "AA.LOAN.DOCS.REC1"
                        CURR.NO = DCOUNT(R.NEW(AA.AC.OVERRIDE),@VM)
                        CALL STORE.OVERRIDE(CURR.NO+1)
                    END

                CASE Y.MAND.DOCS EQ "NO"
                    IF Y.DOC.RECVD EQ "" THEN
                        TEXT = "AA.LOAN.DOCS.REC2"
                        CURR.NO = DCOUNT(R.NEW(AA.AC.OVERRIDE),@VM)
                        CALL STORE.OVERRIDE(CURR.NO+1)
                    END

            END CASE
        NEXT Y.INITIAL
    END
RETURN
END
