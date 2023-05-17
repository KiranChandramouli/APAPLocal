SUBROUTINE REDO.V.INP.CHK.CARD.ACCT.STATUS
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.INP.CHK.CARD.ACCT.STATUS
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it in R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2009-10-0536    Initial Creation
* 03-DEC-2010        Prabhu.N       ODR-2010-11-0211    Modified based on Sunnel
* 22-JUN-2011        Prabhu         ODR-2010-11-0211    Error message moved to validation
* 25-AUG-2011        Riyas          PACS00103353        call routine to update REDO.SUNNEL.CARD.DETAILS Table
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.SUNNEL.PARAMETER
    FN.REDO.SUNNEL.PARAMETER='F.REDO.SUNNEL.PARAMETER'
    F.REDO.SUNNEL.PARAMETER=''
    CALL OPF(FN.REDO.SUNNEL.PARAMETER,F.REDO.SUNNEL.PARAMETER)

    LREF.APP = 'TELLER'
    LREF.FIELDS ='L.TT.AC.STATUS'
    LREF.POS=''

    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    Y.CARD.ACCT.ST=R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS>
    CALL CACHE.READ(FN.REDO.SUNNEL.PARAMETER,'SYSTEM',R.REDO.SUNNEL.PARAMETER,ERR)
    Y.STATUS<1>=R.REDO.SUNNEL.PARAMETER<SP.LEGAL.STATUS>

    IF Y.CARD.ACCT.ST EQ Y.STATUS<1> THEN
        CURR.NO=DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM) + 1
        TEXT='REDO.LEGAL.STATUS'
        CALL STORE.OVERRIDE(CURR.NO)
    END
*PACS00103353-S
    CALL REDO.V.INP.SUNNEL.UPDATE
*PACS00103353-E
RETURN
END
