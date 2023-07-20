* @ValidationCode : Mjo2OTcwNjIzMzk6Q3AxMjUyOjE2ODk4MzUyNTEwNzE6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Jul 2023 12:10:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
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
* 14-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 14-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

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
