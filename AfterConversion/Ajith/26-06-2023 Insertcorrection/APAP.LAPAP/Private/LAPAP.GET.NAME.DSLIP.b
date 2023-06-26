$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*26-06-2023       Conversion Tool           R22 Auto Code conversion          No Changes
*26-06-2023       S.AJITHKUMAR               R22 Manual Code Conversion       T24.BP IS REMOVED,Command this Insert file I_F.T24.FUND.SERVICES
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.GET.NAME.DSLIP(Y.DEPOSITANTE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Melvy Martinez
*Program   Name    :LAPAP.GET.NAME.DSLIP
*Modify            :
*---------------------------------------------------------------------------------
*DESCRIPTION       : Utilizada para obtener el nombre del depositante en caja.
* --------------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.TELLER ;*R22 manual code cnversion
*$INSERT  I_F.T24.FUND.SERVICES ;*R22 manual code cnversion

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
