SUBROUTINE REDO.V.VAL.CIUU.CATEGORY
*----------------------------------------------------------------------------

*Company Name: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program Name: REDO.V.VAL.CIUU.CATEGORY

*--------------------------------------------------------------------------------------------------------------------------------------------
*Description:This routine will default the CIUU CATEGORY id which is also present in the field category in the local table Destination of Loan
*----------------------------------------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE           DESCRIPTION
* 6-06-2010      PREETHI MD   ODR-2009-10-0326 N.3  INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.REDO.CIUU.LOAN.DESTINATION

    GOSUB INIT
    GOSUB PROCESS
RETURN

*------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------

    FN.LOAN.DES="F.REDO.CIUU.LOAN.DESTINATION"
    F.LOAN.DES=""

    APPL.ARRAY='AA.PRD.DES.ACCOUNT'
    FLD.ARRAY='L.AA.LOAN.DSN':@VM:'L.AA.CATEG'
    FLD.POS=''

    Y.INITIAL = 1

RETURN

*------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------


    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    Y.LOAN.POS=FLD.POS<1,1>
    Y.CAT.POS=FLD.POS<1,2>

    CALL OPF(FN.LOAN.DES,F.LOAN.DES)
    Y.LOAN.DESN.ID=R.NEW(AA.AC.LOCAL.REF)<1,Y.LOAN.POS>
    R.LOAN.DES=''
    CALL F.READ(FN.LOAN.DES,Y.LOAN.DESN.ID,R.LOAN.DES,F.LOAN.DES,Y.ERR)

    CATEG.CIUU        = R.LOAN.DES<CIU.LN.CATEG.CIUU>
    Y.CATEG.COUNT   = DCOUNT(CATEG.CIUU,@VM)

    LOOP
    WHILE Y.INITIAL LE Y.CATEG.COUNT
        R.NEW(AA.AC.LOCAL.REF)<1,Y.CAT.POS,Y.INITIAL> = R.LOAN.DES<CIU.LN.CATEG.CIUU,Y.INITIAL>
        Y.INITIAL +=1
    REPEAT

RETURN
END
