SUBROUTINE REDO.V.INP.CHECK.FT.BENEFICARY

*---------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Riyas
* PROGRAM NAME: REDO.V.INP.CHECK.FT.BENEFICARY
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is to make mandatory Beneficary field

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT

*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE        WHO                REFERENCE           DESCRIPTION
* 26.02.2013  Riyas              ODR-2009-12-0285    INITIAL CREATION
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER


    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
******

    LREF.APP   = 'FUNDS.TRANSFER'
    LREF.FIELD = 'BENEFIC.NAME'
    LREF.POS   = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    BENEFICIARY.POS = LREF.POS

RETURN

PROCESS:
*********

    Y.BENE = R.NEW(FT.LOCAL.REF)<1,BENEFICIARY.POS>
    CHANGE @SM TO @FM IN Y.BENE

    IF NOT(Y.BENE<1>) THEN
        AF = FT.LOCAL.REF
        AV = BENEFICIARY.POS
        AS = 1
        ETEXT = "AC-MAND.FLD"
        CALL STORE.END.ERROR
    END

RETURN
*----------------------------------------------------------------------------------------------------------------------
END
