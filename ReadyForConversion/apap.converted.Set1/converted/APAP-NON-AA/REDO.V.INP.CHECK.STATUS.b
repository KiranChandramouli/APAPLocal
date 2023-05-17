SUBROUTINE REDO.V.INP.CHECK.STATUS
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :PRABHU.N
*Program Name :REDO.V.INP.CHECK.STATUS
*---------------------------------------------------------------------------------

*DESCRIPTION :It is attached as authorization routine in all the version used
* in the development N.83.If Credit card status is Back log then it will
* show an override message
*LINKED WITH :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
* Date who Reference Description
* 16-APR-2010 Prabhu.N ODR-2009-10-0526 Initial Creation
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.INTERFACE.PARAMETER


    LREF.POS=''
    CALL GET.LOC.REF('TELLER','L.TT.CR.CRD.STS',LREF.POS)


    FN.REDO.INTERFACE.PARAMETER='F.REDO.INTERFACE.PARAMETER'
    F.REDO.INTERFACE.PARAMETER=''
    CALL OPF(FN.REDO.INTERFACE.PARAMETER,F.REDO.INTERFACE.PARAMETER)

    CALL F.READ(FN.REDO.INTERFACE.PARAMETER,'SUNNEL',R.INTERFACE.PARAM,F.REDO.INTERFACE.PARAMETER,ERR)
    VAR.STATUS=R.INTERFACE.PARAM<IN.CREDIT.STATUS>

    IF R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS> EQ VAR.STATUS THEN
        VAR.CURR.NO=R.NEW(TT.TE.CURR.NO)
        TEXT="REDO.CREDIT.STATUS"
        CALL STORE.OVERRIDE(VAR.CURR.NO)
    END
RETURN
