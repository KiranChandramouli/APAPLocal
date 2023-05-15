$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.LOAD.ACH.BEN.INFO
*--------------------------------------------------------------------------------------------------
* Description           : Esta rutina carga a la version la informacion de un beneficiario
* Developed On          : ---
* Developed By          : Anthony Martinez
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* --------               Anthony Martinez               04/01/2019            Creation
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - F.READ to CACHE.READ and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes   
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CUSTOMER

    Y.BEN.ID = R.NEW(FT.BENEFICIARY.ID)
    OUT.ARR = ""

*-- GET BENEFICIARY DATA
    FN.BEN = "F.BENEFICIARY"; FV.BEN = ""; R.BEN = ""; ERR.BEN = ""
    CALL OPF(FN.BEN, FV.BEN)
    CALL CACHE.READ(FN.BEN, Y.BEN.ID, R.BEN, ERR.BEN)	;*R22 Auto Conversion  - F.READ to CACHE.READ

    CALL GET.LOC.REF("FUNDS.TRANSFER", "L.FTST.ACH.PART", L.FTST.ACH.PART.POS)
    CALL GET.LOC.REF("FUNDS.TRANSFER", "L.FT.ACH.B.ACC", L.FT.ACH.B.ACC.POS)
    CALL GET.LOC.REF("FUNDS.TRANSFER", "L.FT.CR.CARD.NO", L.FT.CR.CARD.NO.POS)
    CALL GET.LOC.REF("FUNDS.TRANSFER", "L.FT.ACH.B.NAM", L.FT.ACH.B.NAM.POS)
    CALL GET.LOC.REF("FUNDS.TRANSFER", "L.ACH.PART.ID", L.ACH.PART.ID.POS)

    CALL GET.LOC.REF("BENEFICIARY", "L.BEN.PROD.TYPE", L.BEN.PROD.TYPE.POS)
    CALL GET.LOC.REF("BENEFICIARY", "L.BEN.ACCOUNT", L.BEN.ACCOUNT.POS)
    CALL GET.LOC.REF("BENEFICIARY", "L.BEN.BANK", L.BEN.BANK.POS)
    CALL GET.LOC.REF("BENEFICIARY", "L.BEN.CUST.NAME", L.BEN.CUST.NAME.POS)
    CALL GET.LOC.REF("BENEFICIARY", "L.BEN.CEDULA", L.BEN.CEDULA.POS)

    Y.BANK.CODE = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.BANK.POS, 1>
    Y.BEN.ACCOUNT = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.ACCOUNT.POS, 1>
    Y.PROD.TYPE = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.PROD.TYPE.POS, 1>

    CUSTOMER = R.BEN<ARC.BEN.OWNING.CUSTOMER>

    CALL LAPAP.CUSTOMER.IDENT(CUSTOMER, IDENT, IDENTYPE, NAME, LASTN, DEFV)

    R.NEW(FT.LOCAL.REF)<1, L.FTST.ACH.PART.POS> = Y.BANK.CODE
    R.NEW(FT.LOCAL.REF)<1, L.FT.ACH.B.ACC.POS> = Y.BEN.ACCOUNT
    R.NEW(FT.LOCAL.REF)<1, L.FT.ACH.B.NAM.POS> = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.CUST.NAME.POS, 1>
    R.NEW(FT.LOCAL.REF)<1, L.ACH.PART.ID.POS> = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.CEDULA.POS, 1>

    IF Y.PROD.TYPE EQ 'CARDS' THEN
        R.NEW(FT.LOCAL.REF)<1, L.FT.CR.CARD.NO.POS> = SUBSTRINGS(Y.BEN.ACCOUNT,0,4) : "-xxxx-xxxx-" : SUBSTRINGS(Y.BEN.ACCOUNT,13,4)
    END

RETURN

END
