$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.GET.NAME.DSLIP(Y.DEPOSITANTE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Melvy Martinez
*Program   Name    :LAPAP.GET.NAME.DSLIP
*Modify            :
*---------------------------------------------------------------------------------
*DESCRIPTION       : Utilizada para obtener el nombre del depositante en caja.
* --------------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.T24.FUND.SERVICES

    LOC.REF.FIELDS      = 'L.TT.CLIENT.NME'

    CALL MULTI.GET.LOC.REF(APPLICATION,LOC.REF.FIELDS,LREF.POS)
    POS.L.TT.CLIENT.NME = LREF.POS<1,1>

    IF APPLICATION EQ 'T24.FUND.SERVICES' THEN
        Y.NOMBRE.DEP = R.NEW(TFS.LOCAL.REF)<1,POS.L.TT.CLIENT.NME>
    END ELSE
        Y.NOMBRE.DEP = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.CLIENT.NME>
    END

    Y.DEPOSITANTE = FMT(Y.NOMBRE.DEP,'R#34')

RETURN

END
